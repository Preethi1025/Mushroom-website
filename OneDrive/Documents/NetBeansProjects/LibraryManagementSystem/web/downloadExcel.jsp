<%@ page import="java.io.*, java.sql.*, org.apache.poi.ss.usermodel.*, org.apache.poi.xssf.usermodel.*" %>
<%
    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
    response.setHeader("Content-Disposition", "attachment; filename=Library_Report.xlsx");

    XSSFWorkbook workbook = new XSSFWorkbook();
    XSSFSheet sheet = workbook.createSheet("Library Data");

    Connection con = DBConnection.getConnection();
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM your_table_name");

    int rownum = 0;
    XSSFRow header = sheet.createRow(rownum++);
    header.createCell(0).setCellValue("ID");
    header.createCell(1).setCellValue("Semester");
    header.createCell(2).setCellValue("Engg/MBA");
    header.createCell(3).setCellValue("Year");
    header.createCell(4).setCellValue("Month");
    header.createCell(5).setCellValue("Date of Invoice");
    header.createCell(6).setCellValue("Purchase Type");
    header.createCell(7).setCellValue("Invoice No");
    header.createCell(8).setCellValue("Supplier Name");
    header.createCell(9).setCellValue("Department");
    header.createCell(10).setCellValue("No. of Books");

    while (rs.next()) {
        XSSFRow row = sheet.createRow(rownum++);
        row.createCell(0).setCellValue(rs.getInt("ID"));
        row.createCell(1).setCellValue(rs.getString("Semester"));
        row.createCell(2).setCellValue(rs.getString("Engg/MBA"));
        row.createCell(3).setCellValue(rs.getInt("Year"));
        row.createCell(4).setCellValue(rs.getInt("Month"));
        row.createCell(5).setCellValue(rs.getString("Date of Invoice"));
        row.createCell(6).setCellValue(rs.getString("Purchase Type"));
        row.createCell(7).setCellValue(rs.getString("Invoice No"));
        row.createCell(8).setCellValue(rs.getString("Supplier Name"));
        row.createCell(9).setCellValue(rs.getString("Department"));
        row.createCell(10).setCellValue(rs.getInt("No. of Books"));
    }

    con.close();

    OutputStream out = response.getOutputStream();
    workbook.write(out);
    out.close();
    workbook.close();
%>
