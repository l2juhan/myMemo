<%-- updatePassword.jsp --%>
<%@ page import="java.sql.*" %>
<%
    String userId = (String)session.getAttribute("userId");
    String currentPw = request.getParameter("currentPassword");
    String newPw = request.getParameter("newPassword");

    // DB 연결
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.mariadb.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/memodb?useSSL=false", "root", "1234");

        // 현재 비밀번호 확인
        String sql = "SELECT password FROM member WHERE userId = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();

        if (rs.next() && rs.getString("password").equals(currentPw)) {
            // 비밀번호 변경
            sql = "UPDATE member SET password = ? WHERE userId = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newPw);
            pstmt.setString(2, userId);
            int result = pstmt.executeUpdate();
            if (result > 0) {
%>
<script>alert("비밀번호가 변경되었습니다."); location.href='login_success.jsp';</script>
<%
            } else {
%>
<script>alert("변경에 실패했습니다."); history.back();</script>
<%
            }
        } else {
%>
<script>alert("현재 비밀번호가 일치하지 않습니다."); history.back();</script>
<%
        }
    } catch(Exception e) {
        out.println("오류: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>