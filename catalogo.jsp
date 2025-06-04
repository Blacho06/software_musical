<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%!
    // Clase para representar un Instrumento
    public class Instrumento {
        private int id;
        private String nombre;
        private String descripcion;
        private String categoria;
        private String marca;
        private String modelo;
        private double precio;
        private int stock;
        private int stockMinimo;
        private String imagen;
        private String nivelStock;
        
        public Instrumento(int id, String nombre, String descripcion, String categoria, 
                          String marca, String modelo, double precio, int stock, 
                          int stockMinimo, String imagen) {
            this.id = id;
            this.nombre = nombre;
            this.descripcion = descripcion;
            this.categoria = categoria;
            this.marca = marca;
            this.modelo = modelo;
            this.precio = precio;
            this.stock = stock;
            this.stockMinimo = stockMinimo;
            this.imagen = imagen;
            this.nivelStock = calcularNivelStock();
        }
        
        private String calcularNivelStock() {
            if (stock <= stockMinimo) return "Bajo";
            if (stock <= stockMinimo * 2) return "Medio";
            return "Alto";
        }
        
        // Getters
        public int getId() { return id; }
        public String getNombre() { return nombre; }
        public String getDescripcion() { return descripcion; }
        public String getCategoria() { return categoria; }
        public String getMarca() { return marca; }
        public String getModelo() { return modelo; }
        public double getPrecio() { return precio; }
        public int getStock() { return stock; }
        public int getStockMinimo() { return stockMinimo; }
        public String getImagen() { return imagen; }
        public String getNivelStock() { return nivelStock; }
    }
    
    // Clase para representar una Categoría
    public class Categoria {
        private int id;
        private String nombre;
        private String descripcion;
        
        public Categoria(int id, String nombre, String descripcion) {
            this.id = id;
            this.nombre = nombre;
            this.descripcion = descripcion;
        }
        
        public int getId() { return id; }
        public String getNombre() { return nombre; }
        public String getDescripcion() { return descripcion; }
    }
%>

<%
    // Verificar sesión
    if (session.getAttribute("usuarioActual") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Inicializar datos de categorías (simulando base de datos)
    List<Categoria> categorias = new ArrayList<>();
    categorias.add(new Categoria(1, "Guitarras", "Guitarras acústicas y eléctricas"));
    categorias.add(new Categoria(2, "Pianos", "Pianos acústicos y digitales"));
    categorias.add(new Categoria(3, "Percusión", "Baterías y instrumentos de percusión"));
    categorias.add(new Categoria(4, "Vientos", "Instrumentos de viento madera y metal"));
    categorias.add(new Categoria(5, "Cuerdas", "Violines, violas, cellos y contrabajos"));
    categorias.add(new Categoria(6, "Accesorios", "Cables, púas, soportes y otros accesorios"));
    
    // Inicializar datos de instrumentos (simulando base de datos)
    List<Instrumento> instrumentos = new ArrayList<>();
    instrumentos.add(new Instrumento(1, "Guitarra Acústica Yamaha", "Guitarra acústica de calidad con sonido cálido y equilibrado", "Guitarras", "Yamaha", "FG800", 299.99, 15, 5, "🎸"));
    instrumentos.add(new Instrumento(2, "Piano Digital Casio", "Piano digital con 88 teclas pesadas y sonidos realistas", "Pianos", "Casio", "CDP-S110", 599.99, 8, 5, "🎹"));
    instrumentos.add(new Instrumento(3, "Batería Completa Pearl", "Set completo de batería profesional de 5 piezas", "Percusión", "Pearl", "Export EXX", 799.99, 3, 5, "🥁"));
    instrumentos.add(new Instrumento(4, "Violín 4/4 Stentor", "Violín tamaño completo ideal para estudiantes", "Cuerdas", "Stentor", "Student I", 199.99, 12, 5, "🎻"));
    instrumentos.add(new Instrumento(5, "Saxofón Alto Yamaha", "Saxofón alto profesional en Mi bemol", "Vientos", "Yamaha", "YAS-280", 899.99, 5, 5, "🎷"));
    instrumentos.add(new Instrumento(6, "Guitarra Eléctrica Fender", "Guitarra eléctrica Stratocaster clásica", "Guitarras", "Fender", "Player Stratocaster", 449.99, 7, 5, "🎸"));
    instrumentos.add(new Instrumento(7, "Bajo Eléctrico Ibanez", "Bajo eléctrico de 4 cuerdas con sonido versátil", "Guitarras", "Ibanez", "GSR200", 349.99, 6, 5, "🎸"));
    instrumentos.add(new Instrumento(8, "Flauta Traversa Gemeinhardt", "Flauta traversa plateada para principiantes", "Vientos", "Gemeinhardt", "2SP", 299.99, 10, 5, "🎶"));
    instrumentos.add(new Instrumento(9, "Teclado Yamaha", "Teclado de 61 teclas con ritmos y sonidos", "Pianos", "Yamaha", "PSR-E373", 179.99, 20, 5, "🎹"));
    instrumentos.add(new Instrumento(10, "Trompeta Bach", "Trompeta profesional en Si bemol", "Vientos", "Bach", "TR300H2", 399.99, 4, 5, "🎺"));
    
    // Filtros
    String busqueda = request.getParameter("busqueda");
    String categoriaFiltro = request.getParameter("categoria");
    String ordenPor = request.getParameter("orden");
    
    // Aplicar filtros
    List<Instrumento> instrumentosFiltrados = new ArrayList<>();
    for (Instrumento inst : instrumentos) {
        boolean incluir = true;
        
        // Filtro de búsqueda
        if (busqueda != null && !busqueda.trim().isEmpty()) {
            String busquedaLower = busqueda.toLowerCase();
            if (!inst.getNombre().toLowerCase().contains(busquedaLower) &&
                !inst.getMarca().toLowerCase().contains(busquedaLower) &&
                !inst.getModelo().toLowerCase().contains(busquedaLower)) {
                incluir = false;
            }
        }
        
        // Filtro de categoría
        if (categoriaFiltro != null && !categoriaFiltro.trim().isEmpty() && !categoriaFiltro.equals("todas")) {
            if (!inst.getCategoria().equals(categoriaFiltro)) {
                incluir = false;
            }
        }
        
        if (incluir) {
            instrumentosFiltrados.add(inst);
        }
    }
    
    // Ordenar
    if (ordenPor != null) {
        switch (ordenPor) {
            case "precio_asc":
                instrumentosFiltrados.sort((a, b) -> Double.compare(a.getPrecio(), b.getPrecio()));
                break;
            case "precio_desc":
                instrumentosFiltrados.sort((a, b) -> Double.compare(b.getPrecio(), a.getPrecio()));
                break;
            case "nombre":
                instrumentosFiltrados.sort((a, b) -> a.getNombre().compareTo(b.getNombre()));
                break;
            case "stock":
                instrumentosFiltrados.sort((a, b) -> Integer.compare(b.getStock(), a.getStock()));
                break;
        }
    }
    
    DecimalFormat df = new DecimalFormat("#,##0.00");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo - Inventario Musical</title>
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
        
        .header a {
            color: white;
            text-decoration: none;
            background: rgba(255,255,255,0.2);
            padding: 8px 16px;
            border-radius: 5px;
            transition: background 0.3s;
        }
        
        .header a:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .filters {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .filters h3 {
            margin-bottom: 1rem;
            color: #333;
        }
        
        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .filter-group {
            display: flex;
            flex-direction: column;
        }
        
        .filter-group label {
            margin-bottom: 0.5rem;
            font-weight: bold;
            color: #555;
        }
        
        .filter-group input,
        .filter-group select {
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .filter-group input:focus,
        .filter-group select:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-weight: bold;
            text-align: center;
            transition: transform 0.2s;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #36d1dc 0%, #5b86e5 100%);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
        }
        
        .results-info {
            background: white;
            padding: 1rem 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .catalog-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
        }
        
        .product-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
        }
        
        .product-image {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: white;
        }
        
        .product-info {
            padding: 1.5rem;
        }
        
        .product-title {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
            color: #333;
        }
        
        .product-category {
            color: #667eea;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }
        
        .product-brand {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        
        .product-description {
            color: #666;
            font-size: 0.9rem;
            line-height: 1.4;
            margin-bottom: 1rem;
        }
        
        .product-price {
            font-size: 1.5rem;
            font-weight: bold;
            color: #e74c3c;
            margin-bottom: 1rem;
        }
        
        .product-stock {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }
        
        .stock-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 8px;
        }
        
        .stock-alto { background: #4CAF50; }
        .stock-medio { background: #FFC107; }
        .stock-bajo { background: #f44336; }
        
        .product-actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .btn-small {
            padding: 8px 16px;
            font-size: 0.9rem;
            flex: 1;
        }
        
        .no-results {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .no-results h3 {
            color: #666;
            margin-bottom: 1rem;
        }
        
        .breadcrumb {
            background: white;
            padding: 1rem 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
        }
        
        .breadcrumb a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <header class="header">
        <h1>🎵 Catálogo de Instrumentos</h1>
        <a href="index.jsp">🏠 Volver al Dashboard</a>
    </header>
    
    <div class="container">
        <!-- Breadcrumb -->
        <nav class="breadcrumb">
            <a href="index.jsp">Dashboard</a> / <strong>Catálogo</strong>
        </nav>
        
        <!-- Filtros -->
        <div class="filters">
            <h3>🔍 Filtros de Búsqueda</h3>
            <form method="get" action="catalogo.jsp">
                <div class="filter-row">
                    <div class="filter-group">
                        <label for="busqueda">Buscar por nombre, marca o modelo:</label>
                        <input type="text" id="busqueda" name="busqueda" 
                               value="<%= busqueda != null ? busqueda : "" %>" 
                               placeholder="Ej: Yamaha, Guitarra, FG800">
                    </div>
                    
                    <div class="filter-group">
                        <label for="categoria">Categoría:</label>
                        <select id="categoria" name="categoria">
                            <option value="todas">Todas las categorías</option>
                            <% for (Categoria cat : categorias) { %>
                                <option value="<%= cat.getNombre() %>" 
                                        <%= (categoriaFiltro != null && categoriaFiltro.equals(cat.getNombre())) ? "selected" : "" %>>
                                    <%= cat.getNombre() %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="orden">Ordenar por:</label>
                        <select id="orden" name="orden">
                            <option value="">Orden por defecto</option>
                            <option value="nombre" <%= "nombre".equals(ordenPor) ? "selected" : "" %>>Nombre A-Z</option>
                            <option value="precio_asc" <%= "precio_asc".equals(ordenPor) ? "selected" : "" %>>Precio menor a mayor</option>
                            <option value="precio_desc" <%= "precio_desc".equals(ordenPor) ? "selected" : "" %>>Precio mayor a menor</option>
                            <option value="stock" <%= "stock".equals(ordenPor) ? "selected" : "" %>>Mayor stock</option>
                        </select>
                    </div>
                </div>
                
                <div style="display: flex; gap: 1rem; margin-top: 1rem;">
                    <button type="submit" class="btn">🔍 Buscar</button>
                    <a href="catalogo.jsp" class="btn btn-secondary">🔄 Limpiar Filtros</a>
                </div>
            </form>
        </div>
        
        <!-- Información de Resultados -->
        <div class="results-info">
            <div>
                <strong>📊 Resultados encontrados: <%= instrumentosFiltrados.size() %></strong>
                <% if (busqueda != null && !busqueda.trim().isEmpty()) { %>
                    <span style="color: #666;"> - Búsqueda: "<%= busqueda %>"</span>
                <% } %>
                <% if (categoriaFiltro != null && !categoriaFiltro.equals("todas")) { %>
                    <span style="color: #666;"> - Categoría: <%= categoriaFiltro %></span>
                <% } %>
            </div>
            <a href="carrito.jsp" class="btn btn-success">🛒 Ver Carrito</a>
        </div>
        
        <!-- Grid de Productos -->
        <% if (instrumentosFiltrados.isEmpty()) { %>
            <div class="no-results">
                <h3>😔 No se encontraron instrumentos</h3>
                <p>Intenta modificar los filtros de búsqueda o <a href="catalogo.jsp">ver todos los productos</a></p>
                <br>
                <a href="catalogo.jsp" class="btn">🔄 Ver Todos los Productos</a>
            </div>
        <% } else { %>
            <div class="catalog-grid">
                <% for (Instrumento inst : instrumentosFiltrados) { %>
                    <div class="product-card">
                        <div class="product-image">
                            <%= inst.getImagen() %>
                        </div>
                        <div class="product-info">
                            <div class="product-title"><%= inst.getNombre() %></div>
                            <div class="product-category">🏷️ <%= inst.getCategoria() %></div>
                            <div class="product-brand">
                                <strong>Marca:</strong> <%= inst.getMarca() %> | 
                                <strong>Modelo:</strong> <%= inst.getModelo() %>
                            </div>
                            <div class="product-description">
                                <%= inst.getDescripcion() %>
                            </div>
                            <div class="product-price">
                                $<%= df.format(inst.getPrecio()) %>
                            </div>
                            <div class="product-stock">
                                <div class="stock-indicator stock-<%= inst.getNivelStock().toLowerCase() %>"></div>
                                Stock: <%= inst.getStock() %> unidades 
                                (<%= inst.getNivelStock() %>)
                            </div>
                            <div class="product-actions">
                                <% if (inst.getStock() > 0) { %>
                                    <a href="carrito.jsp?action=agregar&id=<%= inst.getId() %>" 
                                       class="btn btn-success btn-small">🛒 Agregar</a>
                                <% } else { %>
                                    <button class="btn btn-small" style="background: #ccc; cursor: not-allowed;" disabled>
                                        ❌ Sin Stock
                                    </button>
                                <% } %>
                                <a href="catalogo.jsp?detalle=<%= inst.getId() %>" 
                                   class="btn btn-secondary btn-small">👁️ Detalles</a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
        
        <!-- Detalle del Producto (Modal) -->
        <%
            String detalleParam = request.getParameter("detalle");
            if (detalleParam != null) {
                int detalleId = Integer.parseInt(detalleParam);
                Instrumento detalleInst = null;
                for (Instrumento inst : instrumentos) {
                    if (inst.getId() == detalleId) {
                        detalleInst = inst;
                        break;
                    }
                }
                
                if (detalleInst != null) {
        %>
            <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; display: flex; align-items: center; justify-content: center;">
                <div style="background: white; padding: 2rem; border-radius: 15px; max-width: 600px; width: 90%; max-height: 80vh; overflow-y: auto;">
                    <h2>📋 Detalles del Producto</h2>
                    <hr style="margin: 1rem 0;">
                    
                    <div style="text-align: center; margin-bottom: 2rem;">
                        <div style="font-size: 6rem; margin-bottom: 1rem;"><%= detalleInst.getImagen() %></div>
                        <h3><%= detalleInst.getNombre() %></h3>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 2rem;">
                        <div><strong>Categoría:</strong> <%= detalleInst.getCategoria() %></div>
                        <div><strong>Marca:</strong> <%= detalleInst.getMarca() %></div>
                        <div><strong>Modelo:</strong> <%= detalleInst.getModelo() %></div>
                        <div><strong>Precio:</strong> $<%= df.format(detalleInst.getPrecio()) %></div>
                        <div><strong>Stock:</strong> <%= detalleInst.getStock() %> unidades</div>
                        <div><strong>Nivel de Stock:</strong> <%= detalleInst.getNivelStock() %></div>
                    </div>
                    
                    <div style="margin-bottom: 2rem;">
                        <strong>Descripción:</strong><br>
                        <%= detalleInst.getDescripcion() %>
                    </div>
                    
                    <div style="display: flex; gap: 1rem; justify-content: center;">
                        <% if (detalleInst.getStock() > 0) { %>
                            <a href="carrito.jsp?action=agregar&id=<%= detalleInst.getId() %>" 
                               class="btn btn-success">🛒 Agregar al Carrito</a>
                        <% } %>
                        <a href="catalogo.jsp" class="btn btn-secondary">❌ Cerrar</a>
                    </div>
                </div>
            </div>
        <%
                }
            }
        %>
    </div>
</body>
</html>