<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="dConfig.jsp" %>

<%
    String[] semesters = request.getParameterValues("semester");
    String[] years = request.getParameterValues("year");
    String[] purchaseTypes = request.getParameterValues("purchaseType");
    String[] departments = request.getParameterValues("department");
    String[] suppliers = request.getParameterValues("supplier");

    try (Connection conn = getConnection()) {
        StringBuilder query = new StringBuilder("SELECT * FROM 2023_2024_data WHERE 1=1");

        List<String> conditions = new ArrayList<>();
        List<String> params = new ArrayList<>();

        if (semesters != null && semesters.length > 0) {
            conditions.add("semester IN (" + String.join(",", Collections.nCopies(semesters.length, "?")) + ")");
            params.addAll(Arrays.asList(semesters));
        }
        if (years != null && years.length > 0) {
            conditions.add("year IN (" + String.join(",", Collections.nCopies(years.length, "?")) + ")");
            params.addAll(Arrays.asList(years));
        }
        if (purchaseTypes != null && purchaseTypes.length > 0) {
            conditions.add("purchase_type IN (" + String.join(",", Collections.nCopies(purchaseTypes.length, "?")) + ")");
            params.addAll(Arrays.asList(purchaseTypes));
        }
        if (departments != null && departments.length > 0) {
            conditions.add("department_subject IN (" + String.join(",", Collections.nCopies(departments.length, "?")) + ")");
            params.addAll(Arrays.asList(departments));
        }
        if (suppliers != null && suppliers.length > 0) {
            conditions.add("name_of_the_book_supplier IN (" + String.join(",", Collections.nCopies(suppliers.length, "?")) + ")");
            params.addAll(Arrays.asList(suppliers));
        }

        // Append conditions dynamically
        if (!conditions.isEmpty()) {
            query.append(" AND ").append(String.join(" AND ", conditions));
        }

        try (PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setString(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("id") + "</td>");
                    out.println("<td>" + rs.getString("semester") + "</td>");
                    out.println("<td>" + rs.getString("engg_mba") + "</td>");
                    out.println("<td>" + rs.getString("date_of_invoice") + "</td>");
                    out.println("<td>" + rs.getString("purchase_type") + "</td>");
                    out.println("<td>" + rs.getString("book_accn_no_from") + "</td>");
                    out.println("<td>" + rs.getString("book_accn_no_to") + "</td>");
                    out.println("<td>" + rs.getString("invoice_no") + "</td>");
                    out.println("<td>" + rs.getString("name_of_the_book_supplier") + "</td>");
                    out.println("<td>" + rs.getString("department_subject") + "</td>");
                    out.println("<td>" + rs.getString("no_of_books") + "</td>");
                    out.println("<td>" + rs.getString("gross_invoice_amount") + "</td>");
                    out.println("<td>" + rs.getString("discount_amount") + "</td>");
                    out.println("<td>" + rs.getString("net_amount") + "</td>");
                    out.println("</tr>");
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
