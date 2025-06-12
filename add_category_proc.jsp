<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String categoryName = request.getParameter("categoryName");
    String memberIdx_str = request.getParameter("memberIdx"); 

    if (memberIdx_str == null || memberIdx_str.trim().isEmpty() || memberIdx_str.equals("null")) {
        // 간단한 오류 처리 후 이전 페이지로 돌아가기
        out.println("<script>alert('사용자 정보가 없어 카테고리를 추가할 수 없습니다. 다시 로그인해주세요.'); history.back();</script>");
        return; 
    }

    int memberIdx = Integer.parseInt(memberIdx_str);

    String driver = "org.mariadb.jdbc.Driver";
    String url = "jdbc:mariadb://localhost:3306/memodb";
    String dbUser = "admin";
    String dbPass = "1234";
    
    try {
        Class.forName(driver);
        try (Connection con = DriverManager.getConnection(url, dbUser, dbPass);
             PreparedStatement pstmt = con.prepareStatement("INSERT INTO list (listName, member_idx) VALUES (?, ?)")) {
            
            pstmt.setString(1, categoryName);
            pstmt.setInt(2, memberIdx);

            pstmt.executeUpdate();
        }
    } catch (Exception e) {
        e.printStackTrace();
        // 실제 서비스에서는 에러 페이지로 보내는 것이 더 좋습니다.
        out.println("<script>alert('DB 오류로 카테고리 추가에 실패했습니다: " + e.getMessage() + "'); history.back();</script>");
        return;
    }
    
    // 작업 완료 후, 메인 페이지로 다시 이동시킴
    response.sendRedirect("login_success.jsp");
%>