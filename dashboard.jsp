<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="conexion.jsp" %>
<html>
<head>
    <title>Dashboard</title>
    <style>
        .card {
            width: 200px;
            padding: 20px;
            margin: 20px;
            background: #f2f2f2;
            border-radius: 10px;
            box-shadow: 2px 2px 10px #aaa;
            text-align: center;
            display: inline-block;
        }
    </style>
</head>
<body>
<h2 style="text-align:center;">Dashboard</h2>
<div style="text-align:center;">
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        conn = getConnection();
        stmt = conn.createStatement();

        // Instrumentos
        rs = stmt.executeQuery("SELECT COUNT(*) FROM instrumentos");
        rs.next();
        int totalInstrumentos = rs.getInt(1);
        rs.close();

        // Ventas
        rs = stmt.executeQuery("SELECT COUNT(*) FROM ventas");
        rs.next();
        int totalVentas = rs.getInt(1);
        rs.close();

        // Usuarios
        rs = stmt.executeQuery("SELECT COUNT(*) FROM usuarios");
        rs.next();
        int totalUsuarios = rs.getInt(1);
        rs.close();
%>

    <div class="card">
        <h3>🎵 Instrumentos</h3>
        <p><%= totalInstrumentos %></p>
    </div>
    <div class="card">
        <h3>🧾 Ventas</h3>
        <p><%= totalVentas %></p>
    </div>
    <div class="card">
        <h3>👥 Usuarios</h3>
        <p><%= totalUsuarios %></p>
    </div>

<%
    } catch(Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        closeAll(conn, stmt, rs);
    }
%>
</div>
</body>
</html>
