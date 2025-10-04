<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%!
    // Clase para representar un item del carrito
    public class ItemCarrito {
        private int instrumentoId;
        private String nombre;
        private String marca;
        private String modelo;
        private double precio;
        private int cantidad;
        private String imagen;
        private int stockDisponible;
        

        public ItemCarrito(int instrumentoId, String nombre, String marca, String modelo, 
                          double precio, int cantidad, String imagen, int stockDisponible) {
            this.instrumentoId = instrumentoId;
            this.nombre = nombre;
            this.marca = marca;
            this.modelo = modelo;
            this.precio = precio;
            this.cantidad = cantidad;
            this.imagen = imagen;
            this.stockDisponible = stockDisponible;
        }
        
        // Getters
        public int getInstrumentoId() { return instrumentoId; }
        public String getNombre() { return nombre; }
        public String getMarca() { return marca; }
        public String getModelo() { return modelo; }
        public double getPrecio() { return precio; }
        public int getCantidad() { return cantidad; }
        public String getImagen() { return imagen; }
        public int getStockDisponible() { return stockDisponible; }
        public double getSubtotal() { return precio * cantidad; }
        
        // Setters
        public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    }
%>

<%
    // Verificar si el usuario está logueado
    if (session.getAttribute("usuarioActual") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Conexión a la base de datos
    String url = "jdbc:mysql://localhost:3306/inventario_musical";
    String dbUsername = "root";
    String dbPassword = "";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    // Variables para el carrito
    List<ItemCarrito> itemsCarrito = new ArrayList<>();
    if (session.getAttribute("carrito") == null) {
        session.setAttribute("carrito", itemsCarrito);
    } else {
        itemsCarrito = (List<ItemCarrito>) session.getAttribute("carrito");
    }
    
    String action = request.getParameter("action");
    String mensaje = "";
    String tipoMensaje = "";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);
        
        // Procesar acciones
        if ("agregar".equals(action)) {
            int instrumentoId = Integer.parseInt(request.getParameter("id"));
            int cantidad = Integer.parseInt(request.getParameter("cantidad"));
            
            // Obtener información del instrumento
            pstmt = conn.prepareStatement("SELECT nombre, marca, modelo, precio, stock, imagen FROM instrumentos WHERE id = ? AND activo = 1");
            pstmt.setInt(1, instrumentoId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String nombre = rs.getString("nombre");
                String marca = rs.getString("marca");
                String modelo = rs.getString("modelo");
                double precio = rs.getDouble("precio");
                int stock = rs.getInt("stock");
                String imagen = rs.getString("imagen");
                
                if (stock >= cantidad) {
                    // Verificar si el item ya existe en el carrito
                    boolean encontrado = false;
                    for (ItemCarrito item : itemsCarrito) {
                        if (item.getInstrumentoId() == instrumentoId) {
                            int nuevaCantidad = item.getCantidad() + cantidad;
                            if (nuevaCantidad <= stock) {
                                item.setCantidad(nuevaCantidad);
                                mensaje = "Cantidad actualizada en el carrito";
                                tipoMensaje = "success";
                            } else {
                                mensaje = "No hay suficiente stock disponible";
                                tipoMensaje = "error";
                            }
                            encontrado = true;
                            break;
                        }
                    }
                    
                    if (!encontrado) {
                        ItemCarrito nuevoItem = new ItemCarrito(instrumentoId, nombre, marca, modelo, precio, cantidad, imagen, stock);
                        itemsCarrito.add(nuevoItem);
                        mensaje = "Producto agregado al carrito";
                        tipoMensaje = "success";
                    }
                } else {
                    mensaje = "Stock insuficiente";
                    tipoMensaje = "error";
                }
            }
        } else if ("actualizar".equals(action)) {
            int instrumentoId = Integer.parseInt(request.getParameter("id"));
            int nuevaCantidad = Integer.parseInt(request.getParameter("cantidad"));
            
            for (ItemCarrito item : itemsCarrito) {
                if (item.getInstrumentoId() == instrumentoId) {
                    if (nuevaCantidad <= item.getStockDisponible() && nuevaCantidad > 0) {
                        item.setCantidad(nuevaCantidad);
                        mensaje = "Cantidad actualizada";
                        tipoMensaje = "success";
                    } else if (nuevaCantidad <= 0) {
                        itemsCarrito.remove(item);
                        mensaje = "Producto eliminado del carrito";
                        tipoMensaje = "success";
                    } else {
                        mensaje = "Cantidad solicitada excede el stock disponible";
                        tipoMensaje = "error";
                    }
                    break;
                }
            }
        } else if ("eliminar".equals(action)) {
            int instrumentoId = Integer.parseInt(request.getParameter("id"));
            itemsCarrito.removeIf(item -> item.getInstrumentoId() == instrumentoId);
            mensaje = "Producto eliminado del carrito";
            tipoMensaje = "success";
        } else if ("vaciar".equals(action)) {
            itemsCarrito.clear();
            mensaje = "Carrito vaciado";
            tipoMensaje = "success";
        }
        
        // Actualizar la sesión
        session.setAttribute("carrito", itemsCarrito);
        
    } catch (Exception e) {
        mensaje = "Error: " + e.getMessage();
        tipoMensaje = "error";
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
    
    // Calcular totales
    double subtotal = 0;
    int totalItems = 0;
    for (ItemCarrito item : itemsCarrito) {
        subtotal += item.getSubtotal();
        totalItems += item.getCantidad();
    }
    double iva = subtotal * 0.19; // 19% IVA
    double total = subtotal + iva;
    
    DecimalFormat df = new DecimalFormat("#,##0.00");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrito de Compras - Inventario Musical</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Arial', sans-serif;
            background: #f5f7fa;
            color: #333;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .header h1 {
            font-size: 24px;
        }
        
        .btn-volver {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
        }
        
        .btn-volver:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }
        
        .message {
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid;
        }
        
        .error-message {
            background: #ffebee;
            color: #c62828;
            border-color: #ffcdd2;
        }
        
        .success-message {
            background: #e8f5e8;
            color: #2e7d32;
            border-color: #c8e6c9;
        }
        
        .carrito-container {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 2rem;
            margin-top: 1rem;
        }
        
        .items-carrito {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .carrito-vacio {
            text-align: center;
            padding: 3rem;
            color: #666;
        }
        
        .carrito-vacio h3 {
            font-size: 2rem;
            margin-bottom: 1rem;
        }
        
        .item-carrito {
            display: grid;
            grid-template-columns: 80px 1fr auto auto auto;
            gap: 1rem;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #eee;
        }
        
        .item-carrito:last-child {
            border-bottom: none;
        }
        
        .item-imagen {
            font-size: 3rem;
            text-align: center;
        }
        
        .item-info h4 {
            margin-bottom: 0.5rem;
            color: #333;
        }
        
        .item-info p {
            color: #666;
            font-size: 14px;
            margin: 2px 0;
        }
        
        .item-precio {
            font-weight: bold;
            color: #667eea;
            font-size: 18px;
        }
        
        .cantidad-controls {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .cantidad-controls input {
            width: 60px;
            padding: 5px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .btn-cantidad {
            background: #667eea;
            color: white;
            border: none;
            width: 30px;
            height: 30px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        
        .btn-cantidad:hover {
            background: #5568d1;
        }
        
        .btn-eliminar {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .btn-eliminar:hover {
            background: #c0392b;
        }
        
        .resumen-carrito {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            height: fit-content;
            position: sticky;
            top: 2rem;
        }
        
        .resumen-carrito h3 {
            margin-bottom: 1rem;
            color: #333;
            border-bottom: 2px solid #667eea;
            padding-bottom: 0.5rem;
        }
        
        .resumen-linea {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            padding: 0.5rem 0;
        }
        
        .resumen-linea.total {
            border-top: 2px solid #eee;
            margin-top: 1rem;
            font-weight: bold;
            font-size: 18px;
            color: #667eea;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: transform 0.2s;
            width: 100%;
            text-align: center;
            margin-top: 1rem;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: #6c757d;
            margin-top: 0.5rem;
        }
        
        .btn-danger {
            background: #e74c3c;
            margin-top: 0.5rem;
        }
        
        .acciones-carrito {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            justify-content: space-between;
        }
        
        .stock-info {
            font-size: 12px;
            color: #28a745;
        }
        
        @media (max-width: 768px) {
            .carrito-container {
                grid-template-columns: 1fr;
            }
            
            .item-carrito {
                grid-template-columns: 1fr;
                gap: 0.5rem;
                text-align: center;
            }
            
            .item-imagen {
                grid-column: 1;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <h1>🛒 Mi Carrito de Compras</h1>
        <a href="index.jsp" class="btn-volver">← Volver al Dashboard</a>
    </header>
    
    <div class="container">
        <% if (!mensaje.isEmpty()) { %>
            <div class="message <%= tipoMensaje.equals("error") ? "error-message" : "success-message" %>">
                <%= mensaje %>
            </div>
        <% } %>
        
        <div class="carrito-container">
            <div class="items-carrito">
                <h2>Productos en tu carrito (<%= totalItems %> items)</h2>
                
                <% if (itemsCarrito.isEmpty()) { %>
                    <div class="carrito-vacio">
                        <h3>🛒</h3>
                        <h3>Tu carrito está vacío</h3>
                        <p>Explora nuestro catálogo y agrega algunos instrumentos musicales</p>
                        <a href="catalogo.jsp" class="btn" style="width: auto; margin-top: 2rem;">Ver Catálogo</a>
                    </div>
                <% } else { %>
                    <% for (ItemCarrito item : itemsCarrito) { %>
                        <div class="item-carrito">
                            <div class="item-imagen"><%= item.getImagen() %></div>
                            <div class="item-info">
                                <h4><%= item.getNombre() %></h4>
                                <p><strong>Marca:</strong> <%= item.getMarca() %></p>
                                <p><strong>Modelo:</strong> <%= item.getModelo() %></p>
                                <p class="stock-info">Stock disponible: <%= item.getStockDisponible() %></p>
                            </div>
                            <div class="item-precio">$<%= df.format(item.getPrecio()) %></div>
                            <div class="cantidad-controls">
                                <form method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="actualizar">
                                    <input type="hidden" name="id" value="<%= item.getInstrumentoId() %>">
                                    <button type="submit" name="cantidad" value="<%= item.getCantidad() - 1 %>" class="btn-cantidad">-</button>
                                </form>
                                <input type="number" value="<%= item.getCantidad() %>" min="1" max="<%= item.getStockDisponible() %>" 
                                       onchange="actualizarCantidad(<%= item.getInstrumentoId() %>, this.value)">
                                <form method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="actualizar">
                                    <input type="hidden" name="id" value="<%= item.getInstrumentoId() %>">
                                    <button type="submit" name="cantidad" value="<%= item.getCantidad() + 1 %>" class="btn-cantidad">+</button>
                                </form>
                            </div>
                            <div>
                                <form method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="eliminar">
                                    <input type="hidden" name="id" value="<%= item.getInstrumentoId() %>">
                                    <button type="submit" class="btn-eliminar" onclick="return confirm('¿Eliminar este producto del carrito?')">🗑️ Eliminar</button>
                                </form>
                            </div>
                        </div>
                    <% } %>
                    
                    <div class="acciones-carrito">
                        <a href="catalogo.jsp" class="btn btn-secondary">← Seguir Comprando</a>
                        <form method="post" style="display: inline;">
                            <input type="hidden" name="action" value="vaciar">
                            <button type="submit" class="btn btn-danger" onclick="return confirm('¿Vaciar todo el carrito?')">🗑️ Vaciar Carrito</button>
                        </form>
                    </div>
                <% } %>
            </div>
            
            <% if (!itemsCarrito.isEmpty()) { %>
                <div class="resumen-carrito">
                    <h3>📋 Resumen del Pedido</h3>
                    
                    <div class="resumen-linea">
                        <span>Subtotal (<%= totalItems %> items):</span>
                        <span>$<%= df.format(subtotal) %></span>
                    </div>
                    
                    <div class="resumen-linea">
                        <span>IVA (19%):</span>
                        <span>$<%= df.format(iva) %></span>
                    </div>
                    
                    <div class="resumen-linea total">
                        <span>Total:</span>
                        <span>$<%= df.format(total) %></span>
                    </div>
                    
                    <a href="checkout.jsp" class="btn">💳 Proceder al Pago</a>
                    <a href="catalogo.jsp" class="btn btn-secondary">← Seguir Comprando</a>
                    
                    <div style="margin-top: 2rem; padding: 1rem; background: #f8f9fa; border-radius: 8px; font-size: 14px; color: #666;">
                        <p><strong>💡 Información:</strong></p>
                        <p>• Envío gratis en compras superiores a $500.000</p>
                        <p>• Garantía de 1 año en todos los instrumentos</p>
                        <p>• Soporte técnico especializado</p>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        function actualizarCantidad(id, cantidad) {
            if (cantidad > 0) {
                window.location.href = '?action=actualizar&id=' + id + '&cantidad=' + cantidad;
            }
        }
        
        // Auto-refresh para mantener el carrito actualizado
        setTimeout(function() {
            // Opcional: refrescar la página cada 5 minutos para actualizar stock
        }, 300000);
    </script>
</body>
</html>