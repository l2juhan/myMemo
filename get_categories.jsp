<%@ page language="java" contentType="application/xml; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" trimDirectiveWhitespaces="true"%>
<%

    String memberIdx_str = request.getParameter("memberIdx");

    // 2. 파라미터 값 유효성 검사 (방어 코드)
    if (memberIdx_str == null || memberIdx_str.trim().isEmpty() || memberIdx_str.equals("null")) {
        out.println("<?xml version='1.0' encoding='UTF-8'?><categories></categories>");
        return;
    }

    // 3. DB 처리 준비
    int memberIdx = Integer.parseInt(memberIdx_str);

    String driver = "org.mariadb.jdbc.Driver";
    String url = "jdbc:mariadb://localhost:3306/memodb";
    String dbUser = "admin";
    String dbPass = "1234";

    // 4. XML 응답 생성 시작
    out.println("<?xml version='1.0' encoding='UTF-8'?>");
    out.println("<categories>");

    try {
        // 5. DB 로직 실행
        Class.forName(driver);
        try (Connection con = DriverManager.getConnection(url, dbUser, dbPass);
             PreparedStatement pstmt = con.prepareStatement("SELECT idx, listName FROM list WHERE member_idx = ? ORDER BY listName")) {

            pstmt.setInt(1, memberIdx);

            try (ResultSet rs = pstmt.executeQuery()) {
                // 6. 조회된 결과로 XML 태그 만들기
                while(rs.next()) {
                    out.println("<category>");
                    out.println("  <id>" + rs.getInt("idx") + "</id>");
                    out.println("  <name>" + rs.getString("listName") + "</name>");
                    out.println("</category>");
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // 7. XML 응답 마무리
    out.println("</categories>");
%>