<%@ page import="java.sql.*, java.util.regex.Pattern" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    String userId    = (String)session.getAttribute("userId");
    String newEmail  = request.getParameter("email");
    String currPw    = request.getParameter("currentPassword");
    String newPw     = request.getParameter("newPassword");

    // 1) 이메일 형식 체크
    String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
    if (newEmail==null || !Pattern.matches(emailRegex, newEmail)) {
        out.println("<script>alert('이메일을 올바르게 입력하시오.'); location.href='auth.jsp';</script>");
        return;
    }

    Class.forName("org.mariadb.jdbc.Driver");
    try (Connection con = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/memodb","admin","1234");
        PreparedStatement ps = con.prepareStatement(
            "SELECT password, email FROM member WHERE userId=?")
    ) {
        ps.setString(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) {
                out.println("<script>alert('세션이 유효하지 않습니다.'); location.href='login.jsp';</script>");
                return;
            }
            String realPw    = rs.getString("password");
            String realEmail = rs.getString("email");

            // 2) 현재 PW 확인
            if (!realPw.equals(currPw)) {
                if(newEmail.equals("")){
                    out.println("<script>alert('현재 비밀번호가 일치하지 않습니다.'); location.href='auth.jsp';</script>");
                    return;
                }
            }

            // 3) 변경 사항 체크
            boolean emailChanged = !newEmail.equals(realEmail);
            boolean pwChanged    = (newPw!=null && !newPw.isEmpty() && !newPw.equals(realPw));
            if (!emailChanged && !pwChanged) {
                out.println("<script>alert('변경할 이메일 또는 비밀번호를 입력하세요.'); location.href='auth.jsp';</script>");
                return;
            }

            // 4) UPDATE 문 동적 생성
            StringBuilder sql = new StringBuilder("UPDATE member SET ");
            if (emailChanged) sql.append("email=?");
            if (pwChanged) {
                if (emailChanged) sql.append(", ");
                sql.append("password=?");
            }
            sql.append(" WHERE userId=?");

            try (PreparedStatement up = con.prepareStatement(sql.toString())) {
                int idx=1;
                if (emailChanged) up.setString(idx++, newEmail);
                if (pwChanged)    up.setString(idx++, newPw);
                up.setString(idx, userId);

                int cnt = up.executeUpdate();
                if (cnt>0) {
                    out.println("<script>alert('정보가 변경되었습니다.'); location.href='auth.jsp';</script>");
                } else {
                    out.println("<script>alert('변경에 실패했습니다.'); history.back();</script>");
                }
            }
        }
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류: "+e.getMessage().replace("'", "\\'")+"'); history.back();</script>");
    }
%>