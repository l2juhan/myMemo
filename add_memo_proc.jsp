
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.*, java.io.File, java.util.UUID" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    String memoIdxStr=request.getParameter("memoIdx");
    String listIdxStr = request.getParameter("list_idx");
    String title = request.getParameter("title");
    String memoContent = request.getParameter("memo");
    String isImportant = request.getParameter("is_important");
    String backgroundColor = request.getParameter("backgroundColor");

    if (listIdxStr == null || listIdxStr.isEmpty()) {
        out.println("<script>alert('저장할 카테고리를 선택하지 않았습니다.'); history.back();</script>");
        return;
    }
    int listIdx = Integer.parseInt(listIdxStr);

    Part filePart = request.getPart("fileName");
    String originalFileName = filePart.getSubmittedFileName();
    String savedFileName = "";

    if (originalFileName != null && !originalFileName.isEmpty()) {
        String uploadPath = getServletContext().getRealPath("/upload");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String fileExtension = "";
        if (originalFileName.lastIndexOf(".") > 0) {
            fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        }
        savedFileName = UUID.randomUUID().toString() + fileExtension;
        
        filePart.write(uploadPath + File.separator + savedFileName);
    }

    String driver = "org.mariadb.jdbc.Driver";
    String url = "jdbc:mariadb://localhost:3306/memodb";
    String dbUser = "admin";
    String dbPass = "1234";
    Class.forName(driver);
    try (Connection con = DriverManager.getConnection(url,dbUser,dbPass)) {

    if (memoIdxStr != null && !memoIdxStr.isEmpty()) {
      // —— 수정(update) 로직 —— 
        int memoIdx = Integer.parseInt(memoIdxStr);
        PreparedStatement up = con.prepareStatement(
        "UPDATE memo SET title=?, memo=?, is_important=?, backgroundColor=?, fileName=?, list_idx=? WHERE idx=?"
    );
    up.setString(1, title);
    up.setString(2, memoContent);
    up.setString(3, isImportant);
    up.setString(4, backgroundColor);
    up.setString(5, savedFileName);
    up.setInt(6, listIdx);
    up.setInt(7, memoIdx);
    up.executeUpdate();
    } else { // —— 생성(insert) 전 중복 체크 —— 
        PreparedStatement chk = con.prepareStatement(
        "SELECT COUNT(*) FROM memo WHERE title=? AND list_idx=?"
        );
        chk.setString(1, title);
        chk.setInt(2, listIdx);
        try (ResultSet rs = chk.executeQuery()) {
            if (rs.next() && rs.getInt(1) > 0) {
            out.println("<script>alert('같은 카테고리에 동일한 제목의 메모가 이미 있습니다.'); history.back();</script>");
            return;
        }
    }
      // —— INSERT —— 
    PreparedStatement ins = con.prepareStatement(
        "INSERT INTO memo (title, memo, is_important, backgroundColor, fileName, list_idx, created_at) "
        + "VALUES (?, ?, ?, ?, ?, ?, NOW())"
    );
    ins.setString(1, title);
    ins.setString(2, memoContent);
    ins.setString(3, isImportant);
    ins.setString(4, backgroundColor);
    ins.setString(5, savedFileName);
    ins.setInt(6, listIdx);
    ins.executeUpdate();
    }
}
response.sendRedirect("login_success.jsp?categoryId="+ listIdx
  + (memoIdxStr!=null && !memoIdxStr.isEmpty() ? "memoId" + memoIdxStr : ""));
%>