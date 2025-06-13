<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String userId    = (String)session.getAttribute("userId");
    String newNick   = request.getParameter("userName");
    String newAff    = request.getParameter("affiliation");

    // 1) 기존 값 조회
    String currNick = "", currAff = "";
    Class.forName("org.mariadb.jdbc.Driver");
    try (Connection con = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/memodb","admin","1234");
        PreparedStatement ps = con.prepareStatement(
            "SELECT userNickname, affiliation FROM member WHERE userId=?")
    ) {
        ps.setString(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                currNick = rs.getString("userNickname");
                currAff  = rs.getString("affiliation");
            }
        }

        // 2) 변경사항 없으면
        if (newNick.equals(currNick) && newAff.equals(currAff)) {
            out.println("<script>alert('변경할 내용이 없습니다.'); location.href='auth.jsp';</script>");
            return;
        }

        // 3) UPDATE
        try (PreparedStatement up = con.prepareStatement(
            "UPDATE member SET userNickname=?, affiliation=? WHERE userId=?")
        ) {
            up.setString(1, newNick);
            up.setString(2, newAff);
            up.setString(3, userId);
            int cnt = up.executeUpdate();
            if (cnt>0) {
                out.println("<script>alert('정보가 변경되었습니다.'); location.href='auth.jsp';</script>");
            } else {
                out.println("<script>alert('변경에 실패했습니다.'); history.back();</script>");
            }
        }
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류: "+e.getMessage().replace("'", "\\'")+"'); history.back();</script>");
    }
%>