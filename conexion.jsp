<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>

<%!
    // Configuración de la base de datos
    private static final String DB_URL = "jdbc:mysql://localhost:3306/inventario_musical";
    private static final String DB_USER = "root"; // Cambiar según tu configuración
    private static final String DB_PASSWORD = ""; // Cambiar según tu configuración
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    
    // Método para obtener conexión a la base de datos
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName(DB_DRIVER);
        Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        return conn;
    }
    
    // Método para cerrar conexión
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // Método para cerrar statement
    public static void closeStatement(Statement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // Método para cerrar result set
    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // Método para cerrar todos los recursos
    public static void closeAll(Connection conn, Statement stmt, ResultSet rs) {
        closeResultSet(rs);
        closeStatement(stmt);
        closeConnection(conn);
    }
    
    // Método para validar conexión
    public static boolean testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            return conn != null && !conn.isClosed();
        } catch (Exception e) {
            System.err.println("Error al conectar con la base de datos: " + e.getMessage());
            return false;
        } finally {
            closeConnection(conn);
        }
    }
    
    // Método para ejecutar consultas de inserción/actualización
    public static int executeUpdate(String sql, Object... params) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            
            // Establecer parámetros
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            
            return pstmt.executeUpdate();
        } finally {
            closeStatement(pstmt);
            closeConnection(conn);
        }
    }
    
    // Método para ejecutar consultas de selección
    public static ResultSet executeQuery(String sql, Object... params) throws SQLException, ClassNotFoundException {
        Connection conn = getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        
        // Establecer parámetros
        for (int i = 0; i < params.length; i++) {
            pstmt.setObject(i + 1, params[i]);
        }
        
        return pstmt.executeQuery();
    }
%>

<%
    // Configuración de encoding para caracteres especiales
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>