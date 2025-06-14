<%@ page import="java.sql.*" %>
<%
String memoIdx = request.getParameter("memoIdx");

if (memoIdx != null) {
    try {
        Class.forName("org.mariadb.jdbc.Driver");
        try (
            Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/memodb", "admin", "1234");
            PreparedStatement pstmt = con.prepareStatement("DELETE FROM memo WHERE idx = ?")
        ) {
            pstmt.setInt(1, Integer.parseInt(memoIdx));
            pstmt.executeUpdate();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}
// 삭제 후 홈으로 이동
response.sendRedirect("login_success.jsp");
%>