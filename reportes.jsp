<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="conexion.jsp" %>
<html>
<head>
    <title>Reporte de Stock Bajo</title>
    <style>
        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: #ffe0e0;
        }
    </style>
</head>
<body>
<h2 style="text-align:center;">Productos con Stock Bajo</h2>
<table>
    <tr>
        <th>ID</th>
        <th>Instrumento</th>
        <th>Categoría</th>
        <th>Stock</th>
        <th>Stock Mínimo</th>
    </tr>
    <%
        try {
            String sql = "SELECT * FROM vista_instrumentos_completa WHERE nivel_stock = 'Bajo'";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("nombre") %></td>
        <td><%= rs.getString("categoria") %></td>
        <td><%= rs.getInt("stock") %></td>
        <td><%= rs.getInt("stock_minimo") %></td>
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
