<%@ page import="java.sql.*, java.io.*" %>
<%@ include file="dConfig.jsp" %>
<%
    try (Connection connection = getConnection()) {

        // Fetch the last inserted ID from the database
        int id = 1; // Default ID if table is empty
        String getLastIdQuery = "SELECT MAX(id) FROM `2023_2024_data`";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(getLastIdQuery)) {
            if (rs.next() && rs.getInt(1) > 0) {
                id = rs.getInt(1) + 1; // Increment last ID
            }
        }

        // Retrieve form data
        String semester = request.getParameter("semester");
        String engg_mba = request.getParameter("engg_mba");
        int year = Integer.parseInt(request.getParameter("year"));
        int month = Integer.parseInt(request.getParameter("month"));
        String date_of_invoice = request.getParameter("date_of_invoice");
        String purchase_type = request.getParameter("purchase_type");
        String invoice_no = request.getParameter("invoice_no");
        String name_of_the_book_supplier = request.getParameter("name_of_the_book_supplier");
        String department_subject = request.getParameter("department_subject");
        int book_accn_no_from = Integer.parseInt(request.getParameter("book_accn_no_from"));
        int book_accn_no_to = Integer.parseInt(request.getParameter("book_accn_no_to"));
        int no_of_books = Integer.parseInt(request.getParameter("no_of_books"));
        int no_of_books_purchased = Integer.parseInt(request.getParameter("no_of_books_purchased"));
        int no_of_books_donated = Integer.parseInt(request.getParameter("no_of_books_donated"));
        int acc_reg_no = Integer.parseInt(request.getParameter("acc_reg_no"));
        int accn_register_page_no_from = Integer.parseInt(request.getParameter("accn_register_page_no_from"));
        int accn_register_page_no_to = Integer.parseInt(request.getParameter("accn_register_page_no_to"));
        double discount_percentage = Double.parseDouble(request.getParameter("discount_percentage"));
        int gross_invoice_amount = Integer.parseInt(request.getParameter("gross_invoice_amount"));
        double discount_amount = Double.parseDouble(request.getParameter("discount_amount"));
        int net_amount = Integer.parseInt(request.getParameter("net_amount"));

        // Insert data into MySQL
        String insertQuery = "INSERT INTO `2023_2024_data` (id, semester, engg_mba, year, month, date_of_invoice, purchase_type, " +
                "invoice_no, name_of_the_book_supplier, department_subject, book_accn_no_from, book_accn_no_to, no_of_books, " +
                "no_of_books_purchased, no_of_books_donated, acc_reg_no, accn_register_page_no_from, accn_register_page_no_to, " +
                "discount_percentage, gross_invoice_amount, discount_amount, net_amount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement statement = connection.prepareStatement(insertQuery)) {
            statement.setInt(1, id);
            statement.setString(2, semester);
            statement.setString(3, engg_mba);
            statement.setInt(4, year);
            statement.setInt(5, month);
            statement.setString(6, date_of_invoice);
            statement.setString(7, purchase_type);
            statement.setString(8, invoice_no);
            statement.setString(9, name_of_the_book_supplier);
            statement.setString(10, department_subject);
            statement.setInt(11, book_accn_no_from);
            statement.setInt(12, book_accn_no_to);
            statement.setInt(13, no_of_books);
            statement.setInt(14, no_of_books_purchased);
            statement.setInt(15, no_of_books_donated);
            statement.setInt(16, acc_reg_no);
            statement.setInt(17, accn_register_page_no_from);
            statement.setInt(18, accn_register_page_no_to);
            statement.setDouble(19, discount_percentage);
            statement.setInt(20, gross_invoice_amount);
            statement.setDouble(21, discount_amount);
            statement.setInt(22, net_amount);

            statement.executeUpdate();
        }

        // Redirect to index.html after successful submission
%>
        <script>
            alert('Record added successfully!');
            window.location.href = 'index.html';
        </script>
<%
    } catch (Exception e) {
%>
        <script>
            alert('Error saving record: <%= e.getMessage() %>');
            window.history.back();
        </script>
<%
        e.printStackTrace();
    }
%>
