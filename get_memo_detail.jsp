<%@ page language="java" contentType="application/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
	String memoId_str = request.getParameter("memoId");

	if (memoId_str == null || memoId_str.trim().isEmpty() || memoId_str.equals("null")) {
        out.println("<?xml version='1.0' encoding='UTF-8'?><memo></memo>");
        return;
    	}
    // ▲▲▲ 방어 코드 끝 ▲▲▲

    int memoId = Integer.parseInt(memoId_str);
    
    String driver = "org.mariadb.jdbc.Driver";
    String url = "jdbc:mariadb://localhost:3306/memodb";
    String dbUser = "admin";
    String dbPass = "1234";

    out.println("<?xml version='1.0' encoding='UTF-8'?>");
    out.println("<memo>");

    try {
        Class.forName(driver);
        try (Connection con = DriverManager.getConnection(url, dbUser, dbPass);
             PreparedStatement pstmt = con.prepareStatement("SELECT title, memo, is_important, backgroundColor, fileName FROM memo WHERE idx = ?")) {
            
            pstmt.setInt(1, memoId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    out.println("<title>" + rs.getString("title") + "</title>");
                    out.println("<content>" + rs.getString("memo") + "</content>");
                    out.println("<is_important>" + rs.getString("is_important") + "</is_important>");
                    out.println("<backgroundColor>" + rs.getString("backgroundColor") + "</backgroundColor>");
                    out.println("<fileName>" + (rs.getString("fileName") != null ? rs.getString("fileName") : "") + "</fileName>");
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    out.println("</memo>");
%>