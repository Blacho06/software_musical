<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%!
    // Clase para representar un Usuario
    public class Usuario {
        private String nombre;
        private String password;
        private String rol;
        private int idRol;
        
        public Usuario(String nombre, String password, String rol, int idRol) {
            this.nombre = nombre;
            this.password = password;
            this.rol = rol;
            this.idRol = idRol;
        }
        
        // Getters
        public String getNombre() { return nombre; }
        public String getPassword() { return password; }
        public String getRol() { return rol; }
        public int getIdRol() { return idRol; }
    }
    
    // Clase para representar estadísticas
    public class Estadisticas {
        private int totalInstrumentos;
        private int ventasHoy;
        private int stockBajo;
        private double totalVentas;
        
        public Estadisticas() {
            // Generar datos aleatorios para demostración
            Random rand = new Random();
            this.totalInstrumentos = rand.nextInt(200) + 100;
            this.ventasHoy = rand.nextInt(15) + 5;
            this.stockBajo = rand.nextInt(20) + 5;
            this.totalVentas = rand.nextInt(5000) + 1000;
        }
        
        // Getters
        public int getTotalInstrumentos() { return totalInstrumentos; }
        public int getVentasHoy() { return ventasHoy; }
        public int getStockBajo() { return stockBajo; }
        public double getTotalVentas() { return totalVentas; }
    }
%>

<%
    // Inicializar usuarios del sistema
    Map<String, Usuario> usuarios = new HashMap<>();
    usuarios.put("admin", new Usuario("Administrador", "admin123", "Administrador", 1));
    usuarios.put("dueno", new Usuario("Propietario", "dueno123", "Dueño", 2));
    usuarios.put("vendedor", new Usuario("Vendedor", "vendedor123", "Vendedor", 3));
    
    // Variables para el estado de la aplicación
    String action = request.getParameter("action");
    String usuario = request.getParameter("usuario");
    String password = request.getParameter("password");
    String mensaje = "";
    String tipoMensaje = "";
    boolean isLoggedIn = false;
    Usuario usuarioActual = null;
    
    // Verificar si ya hay una sesión activa
    if (session.getAttribute("usuarioActual") != null) {
        usuarioActual = (Usuario) session.getAttribute("usuarioActual");
        isLoggedIn = true;
    }
    
    // Procesar acciones
    if ("login".equals(action) && usuario != null && password != null) {
        if (usuarios.containsKey(usuario)) {
            Usuario user = usuarios.get(usuario);
            if (user.getPassword().equals(password)) {
                usuarioActual = user;
                session.setAttribute("usuarioActual", usuarioActual);
                isLoggedIn = true;
                mensaje = "¡Bienvenido " + usuarioActual.getNombre() + "!";
                tipoMensaje = "success";
            } else {
                mensaje = "Contraseña incorrecta";
                tipoMensaje = "error";
            }
        } else {
            mensaje = "Usuario no encontrado";
            tipoMensaje = "error";
        }
    } else if ("logout".equals(action)) {
        session.removeAttribute("usuarioActual");
        usuarioActual = null;
        isLoggedIn = false;
        mensaje = "Sesión cerrada correctamente";
        tipoMensaje = "success";
    }
    
    // Generar estadísticas si el usuario está logueado
    Estadisticas stats = null;
    if (isLoggedIn) {
        stats = new Estadisticas();
    }
    
    // Fecha actual
    SimpleDateFormat sdf = new SimpleDateFormat("dd 'de' MMMM 'de' yyyy", new Locale("es", "ES"));
    String fechaActual = sdf.format(new Date());
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventario Musical</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }
        
        /* Estilos del Login */
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
            margin: 50px auto;
        }
        
        .logo {
            margin-bottom: 30px;
        }
        
        .logo h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .logo p {
            color: #666;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: bold;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
        }
        
        .message {
            padding: 12px;
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
        
        .demo-info {
            margin-top: 30px;
            padding: 20px;
            background: #f5f5f5;
            border-radius: 8px;
            font-size: 14px;
            color: #666;
        }
        
        .demo-info h3 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .demo-credentials {
            text-align: left;
            margin-top: 10px;
        }
        
        .demo-credentials p {
            margin: 5px 0;
            font-family: monospace;
            background: white;
            padding: 5px;
            border-radius: 4px;
        }
        
        /* Estilos del Dashboard */
        .dashboard {
            background: #f5f7fa;
            min-height: 100vh;
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
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-info span {
            background: rgba(255,255,255,0.2);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
        }
        
        .btn-logout {
            background: #e74c3c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            transition: background 0.3s;
        }
        
        .btn-logout:hover {
            background: #c0392b;
        }
        
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }
        
        .card {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .card h3 {
            color: #333;
            margin-bottom: 1rem;
            font-size: 20px;
        }
        
        .card p {
            color: #666;
            margin-bottom: 1.5rem;
            line-height: 1.6;
        }
        
        .btn {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: transform 0.2s;
            border: none;
            cursor: pointer;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #36d1dc 0%, #5b86e5 100%);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            color: #333;
        }
        
        .btn-warning {
            background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
            color: #333;
        }
        
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        
        .quick-actions {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .quick-actions h3 {
            margin-bottom: 1rem;
            color: #333;
        }
        
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }
        
        .navigation {
            background: white;
            padding: 1rem 2rem;
            margin-bottom: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .nav-links {
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
        }
        
        .nav-links a {
            color: #667eea;
            text-decoration: none;
            font-weight: bold;
            padding: 0.5rem 1rem;
            border-radius: 5px;
            transition: background 0.3s;
        }
        
        .nav-links a:hover {
            background: #f0f4ff;
        }
        
        .role-restrictions {
            margin-top: 1rem;
            padding: 1rem;
            background: #e8f4fd;
            border-radius: 8px;
            border-left: 4px solid #2196F3;
        }
        
        .date-info {
            background: white;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .refresh-btn {
            background: #4CAF50;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 12px;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <% if (!isLoggedIn) { %>
        <!-- Pantalla de Login -->
        <div class="login-container">
            <div class="logo">
                <h1>🎵 Inventario Musical</h1>
                <p>Sistema de Gestión de Instrumentos</p>
            </div>
            
            <% if (!mensaje.isEmpty()) { %>
                <div class="message <%= tipoMensaje.equals("error") ? "error-message" : "success-message" %>">
                    <%= mensaje %>
                </div>
            <% } %>
            
            <form method="post">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label for="usuario">Usuario:</label>
                    <input type="text" id="usuario" name="usuario" required 
                           value="<%= request.getParameter("usuario") != null ? request.getParameter("usuario") : "" %>">
                </div>
                
                <div class="form-group">
                    <label for="password">Contraseña:</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <button type="submit" class="btn-login">Iniciar Sesión</button>
            </form>
            
            <div class="demo-info">
                <h3>Credenciales de Prueba:</h3>
                <div class="demo-credentials">
                    <p><strong>Administrador:</strong> admin / admin123</p>
                    <p><strong>Dueño:</strong> dueno / dueno123</p>
                    <p><strong>Vendedor:</strong> vendedor / vendedor123</p>
                </div>
                <p><em>Nota: Este es un sistema de demostración con JSP y Java</em></p>
            </div>
        </div>
    <% } else { %>
        <!-- Dashboard -->
        <div class="dashboard">
            <header class="header">
                <h1>🎵 Inventario Musical</h1>
                <div class="user-info">
                    <span>👤 <%= usuarioActual.getNombre() %></span>
                    <span>🏷️ <%= usuarioActual.getRol() %></span>
                    <a href="?action=logout" class="btn-logout">Cerrar Sesión</a>
                </div>
            </header>
            
            <div class="container">
                <!-- Información de Fecha y Estadísticas -->
                <div class="date-info">
                    <strong>📅 Fecha actual: <%= fechaActual %></strong>
                    <a href="?" class="refresh-btn">🔄 Actualizar</a>
                </div>
                
                <!-- Mensaje de bienvenida -->
                <% if (!mensaje.isEmpty() && tipoMensaje.equals("success")) { %>
                    <div class="message success-message">
                        <%= mensaje %>
                    </div>
                <% } %>
                
                <!-- Navegación -->
                <nav class="navigation">
                    <div class="nav-links">
                        <a href="?">🏠 Dashboard</a>
                        <a href="?section=catalogo">📋 Catálogo</a>
                        <a href="?section=carrito">🛒 Carrito</a>
                        <% if (usuarioActual.getIdRol() <= 2) { // Administrador y Dueño %>
                            <a href="?section=inventario">📦 Inventario</a>
                            <a href="?section=ventas">💰 Ventas</a>
                            <a href="?section=reportes">📊 Reportes</a>
                        <% } %>
                        <% if (usuarioActual.getIdRol() == 1) { // Solo Administrador %>
                            <a href="?section=usuarios">👥 Usuarios</a>
                        <% } %>
                    </div>
                </nav>
                
                <!-- Estadísticas Rápidas -->
                <div class="stats-row">
                    <div class="stat-card">
                        <div class="stat-number"><%= stats.getTotalInstrumentos() %></div>
                        <div class="stat-label">Instrumentos</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= stats.getVentasHoy() %></div>
                        <div class="stat-label">Ventas Hoy</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= stats.getStockBajo() %></div>
                        <div class="stat-label">Stock Bajo</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">$<%= String.format("%,.0f", stats.getTotalVentas()) %></div>
                        <div class="stat-label">Total del Día</div>
                    </div>
                </div>
                
                <!-- Grid de Tarjetas Principales -->
                <div class="dashboard-grid">
                    <div class="card">
                        <h3>📋 Catálogo de Instrumentos</h3>
                        <p>Explora nuestro catálogo completo de instrumentos musicales. Puedes buscar, filtrar y agregar productos al carrito.</p>
                        <a href="?section=catalogo" class="btn">Ver Catálogo</a>
                    </div>
                    
                    <div class="card">
                        <h3>🛒 Mi Carrito</h3>
                        <p>Revisa los productos que has agregado al carrito y procede con la compra cuando estés listo.</p>
                        <a href="?section=carrito" class="btn btn-secondary">Ver Carrito (<%= (int)(Math.random() * 5) + 1 %> items)</a>
                    </div>
                    
                    <% if (usuarioActual.getIdRol() <= 2) { // Administrador y Dueño %>
                    <div class="card">
                        <h3>📦 Gestión de Inventario</h3>
                        <p>Administra el stock de instrumentos, agrega nuevos productos y actualiza información existente.</p>
                        <a href="?section=inventario" class="btn btn-success">Gestionar Inventario</a>
                    </div>
                    
                    <div class="card">
                        <h3>💰 Ventas y Facturación</h3>
                        <p>Procesa ventas, genera facturas y lleva un control detallado de todas las transacciones.</p>
                        <a href="?section=ventas" class="btn btn-warning">Ver Ventas</a>
                    </div>
                    <% } %>
                </div>
                
                <!-- Acciones Rápidas -->
                <div class="quick-actions">
                    <h3>⚡ Acciones Rápidas</h3>
                    <div class="actions-grid">
                        <a href="?section=catalogo" class="btn">🔍 Buscar Instrumento</a>
                        <% if (usuarioActual.getIdRol() <= 2) { %>
                            <a href="?section=inventario&action=nuevo" class="btn btn-secondary">➕ Agregar Producto</a>
                            <a href="?section=reportes" class="btn btn-success">📊 Ver Reportes</a>
                        <% } %>
                        <% if (usuarioActual.getIdRol() == 1) { %>
                            <a href="?section=usuarios&action=nuevo" class="btn btn-warning">👤 Nuevo Usuario</a>
                        <% } %>
                    </div>
                    
                    <% if (usuarioActual.getIdRol() == 3) { // Solo Vendedor %>
                    <div class="role-restrictions">
                        <strong>ℹ️ Información para Vendedores:</strong><br>
                        Como vendedor, puedes ver el catálogo, agregar productos al carrito y procesar ventas. 
                        Para funciones administrativas, contacta a tu supervisor.
                        <br><strong>Tu ID de rol:</strong> <%= usuarioActual.getIdRol() %>
                    </div>
                    <% } %>
                </div>
                
                <!-- Información del Sistema -->
                <div class="quick-actions">
                    <h3>📋 Información del Sistema</h3>
                    <p><strong>Usuario actual:</strong> <%= usuarioActual.getNombre() %> (<%= usuarioActual.getRol() %>)</p>
                    <p><strong>Nivel de acceso:</strong> <%= usuarioActual.getIdRol() %></p>
                    <p><strong>Sesión iniciada:</strong> ✅ Activa</p>
                    <p><strong>Permisos:</strong> 
                        <% if (usuarioActual.getIdRol() == 1) { %>
                            Administrador completo - Acceso total al sistema
                        <% } else if (usuarioActual.getIdRol() == 2) { %>
                            Dueño - Gestión de inventario y ventas
                        <% } else { %>
                            Vendedor - Catálogo y carrito únicamente
                        <% } %>
                    </p>
                </div>
            </div>
        </div>
    <% } %>
</body>
</html>