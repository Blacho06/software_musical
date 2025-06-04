<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="conexion.jsp" %>
<html>
<head>
    <title>Ventas</title>
    <style>
        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background-color: #dceaff;
        }
    </style>
</head>
<body>
<h2 style="text-align:center;">Historial de Ventas</h2>
<table>
    <tr>
        <th>ID Venta</th>
        <th>Fecha</th>
        <th>Cliente</th>
        <th>Vendedor</th>
        <th>Total Items</th>
        <th>Total ($)</th>
    </tr>
    <%
        try {
            String sql = "SELECT * FROM vista_ventas_resumen ORDER BY fecha_venta DESC";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("fecha_venta") %></td>
        <td><%= rs.getString("cliente") %></td>
        <td><%= rs.getString("vendedor") %></td>
        <td><%= rs.getInt("total_items") %></td>
        <td><%= rs.getDouble("total") %></td>
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
