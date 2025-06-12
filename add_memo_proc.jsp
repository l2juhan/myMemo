<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.*, java.io.File, java.util.UUID" %>
<%
    request.setCharacterEncoding("UTF-8");

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

    try {
        Class.forName(driver);
        try (Connection con = DriverManager.getConnection(url, dbUser, dbPass);
                PreparedStatement pstmt = con.prepareStatement(
                "INSERT INTO memo (title, memo, is_important, backgroundColor, fileName, list_idx, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())")) {
            
            pstmt.setString(1, title);
            pstmt.setString(2, memoContent);
            pstmt.setString(3, isImportant);
            pstmt.setString(4, backgroundColor);
            pstmt.setString(5, savedFileName);
            pstmt.setInt(6, listIdx);

            pstmt.executeUpdate();
        }
    } catch (Exception e) {
        e.printStackTrace();
        // ▼▼▼ 이 부분이 수정되었습니다 ▼▼▼
        String errorMessage = e.getMessage().replace("'", "\\'").replace("\n", "\\n").replace("\r", "");
        out.println("<script>alert('DB 오류로 메모 추가에 실패했습니다: " + errorMessage + "'); history.back();</script>");
        return;
    }
    
    response.sendRedirect("login_success.jsp?categoryId=" + listIdx);
%>