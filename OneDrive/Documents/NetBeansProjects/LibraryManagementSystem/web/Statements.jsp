<%@ page import="java.sql.*" %>
<%@ include file="dConfig.jsp" %>

<%
    Connection conn=getConnection();
    PreparedStatement pstmt = null;
    ResultSet rs = null;

//    String url = "jdbc:mysql://localhost:3306/library";
//    String user = "root";
//    String password = "Preethi1002@";

    // Get parameters from request
    String year = request.getParameter("year");
    String semester = request.getParameter("semester");
    String supplierName = request.getParameter("supplier");

     try {
        Class.forName("com.mysql.cj.jdbc.Driver");
//        conn = DriverManager.getConnection(url, user, password);
         
        // Main Summary Query
        String query = "SELECT category, " +
                       "COALESCE(SUM(no_of_books), 0) AS total_books, " +
                       "COALESCE(SUM(no_of_books_donated), 0) AS total_specimens, " +
                       "COALESCE(SUM(no_of_books_purchased), 0) AS total_purchased, " +
                       "COALESCE(SUM(net_amount), 0) AS total_amount " +
                       "FROM ( " +
                       "   SELECT 'ENGG' AS category UNION ALL " +
                       "   SELECT 'MBA' AS category " +
                       ") categories " +
                       "LEFT JOIN 2023_2024_data ON categories.category = 2023_2024_data.engg_mba " +
                       "AND year = ? AND semester = ? " +
                       "GROUP BY category";

        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, year);
        pstmt.setString(2, semester);
        rs = pstmt.executeQuery();
%>

<!-- Main Summary Report Table -->
<h3>Main Summary Report</h3>
<table class="table table-bordered">
    <thead class="table-dark">
        <tr>
            <th>Category</th>
            <th>No. of Books</th>
            <th>Specimens</th>
            <th>Purchased</th>
            <th>Total Books</th>
            <th>Total Amount</th>
        </tr>
    </thead>
    <tbody>
        <%
            int grandTotalBooks = 0, grandTotalSpecimens = 0, grandTotalPurchased = 0;
            double grandTotalAmount = 0;

            while (rs.next()) {
                String category = rs.getString("category");
                int totalBooks = rs.getInt("total_books");
                int totalSpecimens = rs.getInt("total_specimens");
                int totalPurchased = rs.getInt("total_purchased");
                double totalAmount = rs.getDouble("total_amount");

                grandTotalBooks += totalBooks;
                grandTotalSpecimens += totalSpecimens;
                grandTotalPurchased += totalPurchased;
                grandTotalAmount += totalAmount;
        %>
        <tr>
            <td><%= category %></td>
            <td><%= totalBooks %></td>
            <td><%= totalSpecimens %></td>
            <td><%= totalPurchased %></td>
            <td><%= (totalPurchased + totalSpecimens) %></td>
            <td>Rs.<%= String.format("%.2f", totalAmount) %></td>
        </tr>
        <% } %>

        <!-- Total Row -->
        <tr class="table-secondary">
            <td><strong>Total</strong></td>
            <td><strong><%= grandTotalBooks %></strong></td>
            <td><strong><%= grandTotalSpecimens %></strong></td>
            <td><strong><%= grandTotalPurchased %></strong></td>
            <td><strong><%= (grandTotalPurchased + grandTotalSpecimens) %></strong></td>
            <td><strong>Rs.<%= String.format("%.2f", grandTotalAmount) %></strong></td>
        </tr>
    </tbody>
</table>

<%
    // Close previous statement and result set
    rs.close();
    pstmt.close();

    // Query to get books summary by time period
    String timePeriodQuery = "SELECT " +
            "CASE " +
            "WHEN month BETWEEN 6 AND 12 AND year = 2023 THEN 'June to Dec 2023' " +
            "WHEN month BETWEEN 1 AND 5 AND year = 2024 THEN 'Jan to May 2024' " +
            "END AS category, " +
            "SUM(no_of_books) AS no_of_books, " +
            "SUM(no_of_books_donated) AS specimens, " +
            "SUM(no_of_books_purchased) AS purchased, " +
            "SUM(no_of_books_purchased + no_of_books_donated) AS total_books, " +
            "SUM(net_amount) AS total_amount " +
            "FROM 2023_2024_data " +
            "WHERE year IN (2023, 2024) " +
            "GROUP BY category " +
            "UNION ALL " +
            "SELECT 'Total' AS category, " +
            "SUM(no_of_books), SUM(no_of_books_donated), SUM(no_of_books_purchased), " +
            "SUM(no_of_books_purchased + no_of_books_donated), SUM(net_amount) " +
            "FROM 2023_2024_data WHERE year IN (2023, 2024);";

    pstmt = conn.prepareStatement(timePeriodQuery);
    rs = pstmt.executeQuery();
%>

<!-- ? Summarized Report Table -->
<h3>Summarized Report</h3>
<table class="table table-bordered">
    <thead class="table-dark">
        <tr>
            <th>Category</th>
            <th>No. of Books</th>
            <th>Specimens</th>
            <th>Purchased</th>
            <th>Total Books</th>
            <th>Total Amount</th>
        </tr>
    </thead>
    <tbody>
        <%
            while (rs.next()) {
                String category = rs.getString("category");
                int noOfBooks = rs.getInt("no_of_books");
                int specimens = rs.getInt("specimens");
                int purchased = rs.getInt("purchased");
                int totalBooks = rs.getInt("total_books");
                double totalAmount = rs.getDouble("total_amount");
        %>
        <tr>
            <td><%= category %></td>
            <td><%= noOfBooks %></td>
            <td><%= specimens %></td>
            <td><%= purchased %></td>
            <td><%= totalBooks %></td>
            <td>Rs.<%= String.format("%.2f", totalAmount) %></td>
        </tr>
        <% } %>
    </tbody>
</table>

<%
    // Close previous statement and result set
    rs.close();
    pstmt.close();

    // Fetch Supplier Summary Data
    String supplierQuery = "SELECT name_of_the_book_supplier, " +
            "SUM(no_of_books) AS total_books, " +
            "SUM(no_of_books_donated) AS total_specimens, " +
            "SUM(no_of_books_purchased) AS total_purchased, " +
            "SUM(net_amount) AS total_amount " +
            "FROM 2023_2024_data " +
            "WHERE name_of_the_book_supplier = ? " +
            "GROUP BY name_of_the_book_supplier";

    pstmt = conn.prepareStatement(supplierQuery);
    pstmt.setString(1, supplierName);
    rs = pstmt.executeQuery();
%>

<!-- Supplier-wise Book Summary -->
<h3>Supplier-wise Book Summary for <%= supplierName %></h3>
<table class="table table-bordered">
    <thead class="table-dark">
        <tr>
            <th>Supplier Name</th>
            <th>No. of Books</th>
            <th>Specimens</th>
            <th>Purchased</th>
            <th>Total Books</th>
            <th>Total Amount</th>
        </tr>
    </thead>
    <tbody>
        <%
            if (rs.next()) {
        %>
        <tr>
            <td><%= supplierName %></td>
            <td><%= rs.getInt("total_books") %></td>
            <td><%= rs.getInt("total_specimens") %></td>
            <td><%= rs.getInt("total_purchased") %></td>
            <td><%= rs.getInt("total_books") %></td>
            <td>Rs.<%= String.format("%.2f", rs.getDouble("total_amount")) %></td>
        </tr>
        <% } else { %>
        <tr><td colspan="6">No data found for this supplier.</td></tr>
        <% } %>
    </tbody>
</table>

<%
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

