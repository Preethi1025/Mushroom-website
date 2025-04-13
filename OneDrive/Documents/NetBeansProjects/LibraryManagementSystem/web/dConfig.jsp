<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%!  
    public static Connection getConnection() throws Exception {
        String url = "jdbc:mysql://centerbeam.proxy.rlwy.net:10790/railway"; // Update host, port, and database name
        String user = "root";  // Try 'railway' if 'root' doesn't work
        String password = "zgFRIQqxjQkTfWprpIIurvZiEuWYrbLs"; // Use the correct Railway password

        Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure MySQL JDBC driver is loaded
        return DriverManager.getConnection(url, user, password);
    }
%>
