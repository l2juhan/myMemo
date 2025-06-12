<%@ page language="java" contentType="application/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page trimDirectiveWhitespaces="true" %><%
    String categoryId_str = request.getParameter("categoryId");
    
    // 방어 코드
    if (categoryId_str == null || categoryId_str.trim().isEmpty() || categoryId_str.equals("null")) {
        out.println("<?xml version='1.0' encoding='UTF-8'?><memos></memos>");
        return;
    }

    int categoryId = Integer.parseInt(categoryId_str);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    String driver = "org.mariadb.jdbc.Driver";
    String url = "jdbc:mariadb://localhost:3306/memodb";
    String dbUser = "admin";
    String dbPass = "1234";

    out.println("<?xml version='1.0' encoding='UTF-8'?>");
    out.println("<memos>");

    try {
        Class.forName(driver);
        try (Connection con = DriverManager.getConnection(url, dbUser, dbPass);
             PreparedStatement pstmt = con.prepareStatement("SELECT idx, title, is_important, created_at FROM memo WHERE list_idx = ? ORDER BY created_at DESC")) {
            
            pstmt.setInt(1, categoryId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while(rs.next()) {
                    out.println("<memo>");
                    out.println("  <id>" + rs.getInt("idx") + "</id>");
                    out.println("  <title>" + rs.getString("title") + "</title>");
                    out.println("  <is_important>" + rs.getString("is_important") + "</is_important>");
                    out.println("  <created_at>" + sdf.format(rs.getTimestamp("created_at")) + "</created_at>");
                    out.println("</memo>");
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    out.println("</memos>");
%>