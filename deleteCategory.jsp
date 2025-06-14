<%@ page import="java.sql.*" language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  request.setCharacterEncoding("UTF-8");
  String listIdx = request.getParameter("listIdx");
  if (listIdx != null && !listIdx.trim().isEmpty()) {
    Class.forName("org.mariadb.jdbc.Driver");
    String url  = "jdbc:mariadb://localhost:3306/memodb";
    String user = "admin", pw = "1234";
    try (Connection con = DriverManager.getConnection(url, user, pw)) {
      con.setAutoCommit(false);
      try (
        // ① 메모부터 삭제
        PreparedStatement ps1 = con.prepareStatement(
          "DELETE FROM memo WHERE list_idx = ?"
        );
        // ② 카테고리 삭제
        PreparedStatement ps2 = con.prepareStatement(
          "DELETE FROM list WHERE idx = ?"
        );
      ) {
        int id = Integer.parseInt(listIdx);
        ps1.setInt(1, id);
        ps1.executeUpdate();
        ps2.setInt(1, id);
        ps2.executeUpdate();

        con.commit();
      } catch (Exception e) {
        con.rollback();        // 에러 나면 롤백
        throw e;
      }
    } catch (Exception e) {
      e.printStackTrace();
      // 필요하면 에러 페이지로 리다이렉트하거나 alert 처리
    }
  }
  // 삭제 후 원래 화면으로 돌아가기
  response.sendRedirect("login_success.jsp");
%>