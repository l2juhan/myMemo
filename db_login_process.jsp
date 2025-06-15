<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!--===================================로그인 정보 확인====================================-->
<%
    request.setCharacterEncoding("UTF-8");
    String userId = request.getParameter("userId");
    String password = request.getParameter("password");

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        out.println("드라이버 로드 시도");
        Class.forName("org.mariadb.jdbc.Driver");
        out.println("드라이버 로드 성공");
        con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/memodb?useSSL=false", "admin", "1234");

        String sql = "SELECT * FROM member WHERE userid = ? AND password = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userId);
        pstmt.setString(2, password);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            session.setAttribute("userId", userId);
            session.setAttribute("nickname",rs.getString("userNickname"));
            session.setAttribute("memberIdx",rs.getInt("idx"));
            response.sendRedirect("login_success.jsp");
        } else {
%>      
        <script>
            alert("헉!!!로그인이 실패하였습니다.");
            location.href = "login.jsp";
        </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
%>
        <script>
            alert("헉!!!데이터베이스에 오류가 발생했습니다.");
            location.href = "login.jsp";
        </script>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (con != null) try { con.close(); } catch (SQLException e) {}
    }
%>