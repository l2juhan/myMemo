<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%
  request.setCharacterEncoding("UTF-8");
  String listIdx = request.getParameter("listIdx");
  String newName = request.getParameter("newName");
  if (listIdx!=null && newName!=null && !newName.trim().isEmpty()) {
    Class.forName("org.mariadb.jdbc.Driver");
    try (Connection con = DriverManager.getConnection(
             "jdbc:mariadb://localhost:3306/memodb","admin","1234");
         PreparedStatement ps = con.prepareStatement(
             "UPDATE list SET listName=? WHERE idx=?")) {
      ps.setString(1, newName);
      ps.setInt(2, Integer.parseInt(listIdx));
      ps.executeUpdate();
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
  // 수정 후 항상 원래 화면으로 돌아가기
  response.sendRedirect("login_success.jsp?categoryId=" + listIdx);
%>