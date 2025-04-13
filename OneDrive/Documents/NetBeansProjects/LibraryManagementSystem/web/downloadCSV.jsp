<%@ page import="java.io.*, java.sql.*, java.text.SimpleDateFormat" %>
<%@ include file="dConfig.jsp" %>

<%
    response.setContentType("text/csv");
    response.setHeader("Content-Disposition", "attachment; filename=Library_Report.csv");

    ServletOutputStream outputStream = response.getOutputStream();
    PrintWriter writer = new PrintWriter(new OutputStreamWriter(outputStream, "UTF-8"));

    // Get filter parameters
    String semester = request.getParameter("semester");
    String year = request.getParameter("year");
    String purchaseType = request.getParameter("purchaseType");
    String department = request.getParameter("department");

    try (Connection conn = getConnection()) {
        // Dynamic query building
        StringBuilder query = new StringBuilder("SELECT * FROM 2023_2024_data WHERE 1=1");
        if (semester != null && !semester.isEmpty()) query.append(" AND semester = ?");
        if (year != null && !year.isEmpty()) query.append(" AND year = ?");
        if (purchaseType != null && !purchaseType.isEmpty()) query.append(" AND purchase_type = ?");
        if (department != null && !department.isEmpty()) query.append(" AND department_subject = ?");

        try (PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
            int index = 1;
            if (semester != null && !semester.isEmpty()) pstmt.setString(index++, semester);
            if (year != null && !year.isEmpty()) pstmt.setString(index++, year);
            if (purchaseType != null && !purchaseType.isEmpty()) pstmt.setString(index++, purchaseType);
            if (department != null && !department.isEmpty()) pstmt.setString(index++, department);

            try (ResultSet rs = pstmt.executeQuery()) {
                // Writing CSV Header
                writer.println("ID,Semester,Engg/MBA,Date of Invoice,Purchase Type,Book Accn No From,Book Accn No To,Invoice No,Supplier Name,Department,No. of Books,Gross Invoice Amount,Discount Amount,Net Amount");

                // Date Formatter
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

                // Writing Data Rows
                while (rs.next()) {
                    String formattedDate = "";
                    Date dateValue = rs.getDate("date_of_invoice");
                    if (dateValue != null) {
                        formattedDate = "=\"" + sdf.format(dateValue) + "\""; // Forces Excel to treat as text
                    }

                    writer.println(
                        rs.getInt("id") + "," +
                        rs.getString("semester") + "," +
                        rs.getString("engg_mba") + "," +
                        formattedDate + "," +  // Ensure date is correctly formatted
                        rs.getString("purchase_type") + "," +
                        rs.getString("book_accn_no_from") + "," +
                        rs.getString("book_accn_no_to") + "," +
                        rs.getString("invoice_no") + "," +
                        rs.getString("name_of_the_book_supplier") + "," +
                        rs.getString("department_subject") + "," +
                        rs.getString("no_of_books") + "," +
                        rs.getString("gross_invoice_amount") + "," +
                        rs.getString("discount_amount") + "," +
                        rs.getString("net_amount")
                    );
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        writer.println("Error: Unable to generate CSV file. Please try again later.");
    } finally {
        writer.flush();
        writer.close();
    }
%>
