<%@ page import="java.io.*, java.sql.*, java.util.Date, java.text.SimpleDateFormat, jakarta.servlet.ServletOutputStream, com.itextpdf.text.*, com.itextpdf.text.pdf.*" %>
<%@ include file="dConfig.jsp" %>

<%
    // Set response content type to PDF
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "attachment; filename=report.pdf");

    try (Connection conn = getConnection()) {
        // Fetching request parameters
        String semester = request.getParameter("semester");
        String year = request.getParameter("year");
        String purchaseType = request.getParameter("purchaseType");
        String department = request.getParameter("department");
        String supplier = request.getParameter("supplier");

        // Construct SQL Query with filters
        StringBuilder query = new StringBuilder("SELECT id, semester, purchase_type, department_subject, name_of_the_book_supplier, date_of_invoice FROM 2023_2024_data WHERE 1=1");
        if (semester != null && !semester.isEmpty()) query.append(" AND semester = ?");
        if (year != null && !year.isEmpty()) query.append(" AND year = ?");
        if (purchaseType != null && !purchaseType.isEmpty()) query.append(" AND purchase_type = ?");
        if (department != null && !department.isEmpty()) query.append(" AND department_subject = ?");
        if (supplier != null && !supplier.isEmpty()) query.append(" AND name_of_the_book_supplier = ?");

        try (PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
            int index = 1;
            if (semester != null && !semester.isEmpty()) pstmt.setString(index++, semester);
            if (year != null && !year.isEmpty()) pstmt.setString(index++, year);
            if (purchaseType != null && !purchaseType.isEmpty()) pstmt.setString(index++, purchaseType);
            if (department != null && !department.isEmpty()) pstmt.setString(index++, department);
            if (supplier != null && !supplier.isEmpty()) pstmt.setString(index++, supplier);

            // Initialize PDF Document
            Document document = new Document();
            ServletOutputStream outStream = response.getOutputStream();
            PdfWriter.getInstance(document, outStream);
            document.open();

            // PDF Title
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
            Paragraph title = new Paragraph("Purchase Report", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);

            // Fetch Invoice Date Separately
            String invoiceDate = "Not Available";
            try (PreparedStatement dateStmt = conn.prepareStatement(query.toString());
                 ResultSet rsDate = dateStmt.executeQuery()) {
                if (rsDate.next()) { 
                    Date date = rsDate.getDate("date_of_invoice");  // Fetch date
                    if (date != null) {
                        invoiceDate = new SimpleDateFormat("dd-MM-yyyy").format(date); // Format it
                    }
                }
            }

            // Add Invoice Date Below Title
            Font dateFont = new Font(Font.FontFamily.HELVETICA, 12, Font.ITALIC);
            Paragraph datePara = new Paragraph("Date of Invoice: " + invoiceDate, dateFont);
            datePara.setAlignment(Element.ALIGN_CENTER);
            document.add(datePara);
            document.add(new Paragraph("\n"));

            // Create Table with 6 Columns
            PdfPTable table = new PdfPTable(6);
            table.setWidthPercentage(100);
            table.addCell("ID");
            table.addCell("Semester");
            table.addCell("Purchase Type");
            table.addCell("Department");
            table.addCell("Supplier");
            table.addCell("Invoice Date");

            // Execute Query and Populate Table
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    table.addCell(String.valueOf(rs.getInt("id")));
                    table.addCell(rs.getString("semester"));
                    table.addCell(rs.getString("purchase_type"));
                    table.addCell(rs.getString("department_subject"));
                    table.addCell(rs.getString("name_of_the_book_supplier"));

                    Date date = rs.getDate("date_of_invoice");
                    table.addCell(date != null ? new SimpleDateFormat("dd-MM-yyyy").format(date) : "N/A");
                }
            }

            // Add Table to PDF and Close Document
            document.add(table);
            document.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
