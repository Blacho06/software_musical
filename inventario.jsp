<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="conexion.jsp" %>
<html>
<head>
    <title>Inventario</title>
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
            background-color: #f0f0f0;
        }
        .stock-Bajo {
            background-color: #f8d7da;
            color: #721c24;
        }
        .stock-Medio {
            background-color: #fff3cd;
            color: #856404;
        }
        .stock-Alto {
            background-color: #d4edda;
            color: #155724;
        }
    </style>
</head>
<body>
<h2 style="text-align:center;">Inventario de Instrumentos</h2>
<table>
    <tr>
        <th>ID</th>
        <th>Nombre</th>
        <th>Categoría</th>
        <th>Marca</th>
        <th>Modelo</th>
        <th>Precio</th>
        <th>Stock</th>
        <th>Nivel</th>
    </tr>
    <%
        try {
            String query = "SELECT * FROM vista_instrumentos_completa";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while(rs.next()) {
                String nivel = rs.getString("nivel_stock");
    %>
    <tr class="stock-<%= nivel %>">
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("nombre") %></td>
        <td><%= rs.getString("categoria") %></td>
        <td><%= rs.getString("marca") %></td>
        <td><%= rs.getString("modelo") %></td>
        <td>$<%= rs.getDouble("precio") %></td>
        <td><%= rs.getInt("stock") %></td>
        <td><%= nivel %></td>
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
