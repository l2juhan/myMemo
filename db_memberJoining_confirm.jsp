<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!--===============================회원가입 확인 절차====================================-->
<%
    request.setCharacterEncoding("UTF-8");
    String userId=request.getParameter("userId");
    String nickname = request.getParameter("userNickname");
    String password = request.getParameter("password");
    String passwordConfirm=request.getParameter("passwordConfirm");
    String affiliation = request.getParameter("affiliation");
    String email = request.getParameter("email");

    if(!password.equals(passwordConfirm)){
%>
<script>
    alert("비밀번호가 일치하지 않습니다ㅡㅡ");
    window.location.href="index.jsp";
</script>
<%
    return;    
    }
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String dbUrl = "jdbc:mariadb://localhost:3306/memodb?useSSL=false";
    String dbUser = "admin";
    String dbPass = "1234";

    try {
        out.println("드라이버 로드 시도");
        Class.forName("org.mariadb.jdbc.Driver");
        out.println("드라이버 로드 성공");
        con = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // 중복 검사: 닉네임 또는 이메일
        String checkSql = "SELECT * FROM member WHERE userNickname = ? OR email = ?";
        pstmt = con.prepareStatement(checkSql);
        pstmt.setString(1, userId);
        pstmt.setString(2, email);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String existingId = rs.getString("userId");
            String existingEmail = rs.getString("email");
            if (existingId.equals(userId)) {
%>
<script>
    alert("같은 아이디가 존재합니다ㅡ3ㅡ");
    window.location.href = "index.jsp";
</script>
<%
            } else if (existingEmail.equals(email)) {
%>
<script>
    alert("같은 이메일이 존재합니다ㅡ3ㅡ");
    window.location.href = "index.jsp";
</script>
<%
            }
        } else {
            // 중복 아님: INSERT
            String insertSql = "INSERT INTO member (userId, userNickname, password, affiliation, email) VALUES (?, ?, ?, ?, ?)";
            pstmt = con.prepareStatement(insertSql);
            pstmt.setString(1, userId);
            pstmt.setString(2, nickname);
            pstmt.setString(3, password);
            pstmt.setString(4, affiliation);
            pstmt.setString(5, email);
            
            int result = pstmt.executeUpdate();
            if (result > 0) {
                session.setAttribute("userId", userId);
                session.setAttribute("nickname", nickname);
                session.setAttribute("affiliation", affiliation);
                session.setAttribute("email", email);
                session.setAttribute("password",password);
%>
<script>
    alert("회원가입이 완료되었습니다.");
    window.location.href = "login_success.jsp";
</script>
<%
            } else {
%>
<script>
    alert("헉!!!회원가입 실패... 다시 시도해주세요.");
    window.location.href = "index.jsp";
</script>
<%
            }
        }
    } catch (Exception e) {
%>
<script>
    alert("헉!!!에러 발생.: <%= e.getMessage() %>");
    window.location.href = "index.jsp";
</script>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>
