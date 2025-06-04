<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="conexion.jsp" %>
<html>
<head>
    <title>Usuarios</title>
    <style>
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: 1px solid #aaa;
            text-align: center;
        }
        th {
            background-color: #e6f7ff;
        }
    </style>
</head>
<body>
<h2 style="text-align:center;">Usuarios del Sistema</h2>
<table>
    <tr>
        <th>ID</th>
        <th>Usuario</th>
        <th>Nombre</th>
        <th>Rol</th>
        <th>Activo</th>
        <th>Creado</th>
    </tr>
    <%
        try {
            String sql = "SELECT * FROM usuarios";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("username") %></td>
        <td><%= rs.getString("nombre") %></td>
        <td><%= rs.getString("rol") %></td>
        <td><%= rs.getInt("activo") == 1 ? "Sí" : "No" %></td>
        <td><%= rs.getString("fecha_creacion") %></td>
    </tr>
    <%
            }
            rs.close();
            stmt.close();
        } catch(Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
</table>
</body>
</html>
