<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!--====================================사용자 정보 수정하기================================-->
<%
    Integer memberIdx = (Integer) session.getAttribute("memberIdx");
    String currName = "";
    String currAff  = "";
    String currEmail= "";
    if (memberIdx != null) {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            try (
                Connection con = DriverManager.getConnection(
                    "jdbc:mariadb://localhost:3306/memodb","admin","1234");
                PreparedStatement ps = con.prepareStatement(
                    "SELECT userNickname, affiliation, email FROM member WHERE idx = ?")
            ) {
                ps.setInt(1, memberIdx);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        currName  = rs.getString("userNickname");
                        currAff   = rs.getString("affiliation") != null
                                    ? rs.getString("affiliation") : "";
                        currEmail = rs.getString("email");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>계정 설정</title>
    <style>
        body { font-family: sans-serif; margin: 40px; background-color: #f7f7f7; } 
        h1 { font-size: 22px; margin-bottom: 8px;} 
        hr { border: none; border-top: 1px solid #cccccc; margin-bottom: 20px; }
        form { background-color: #ffffff; padding: 20px; margin-bottom: 30px; border: 1px solid #dddddd; border-radius: 6px; }
        label { display: block; margin-top: 10px; font-weight: bold; }
        input[type="text"], input[type="email"], input[type="password"], input[type="file"] { display: block; width: 100%; max-width: 300px; margin-top: 5px; margin-bottom: 15px; padding: 8px; box-sizing: border-box; border: 1px solid #cccccc; border-radius: 3px; font-size: 14px; }
        .profile-img { display: inline-block; width: 50px; height: 50px; background-color: #ccc; border-radius: 50%; margin-right: 10px; }
        button, input[type="submit"] { cursor: pointer; background-color: #007bff; color: #ffffff; padding: 10px 20px; font-size: 15px; border: none; border-radius: 3px; }
        button:hover, input[type="submit"]:hover { background-color: #0056b3; }
        .desc1 { font-size: 12px; color: #666666; margin: -5px 0 10px 0; }
        .desc2 { font-size: 12px; color: #666666; margin: -5px 0 10px 0; }
        .desc3 { font-size: 12px; color: #666666; margin: -5px 0 10px 0; }
        .backToMemo{ cursor: pointer; background-color: #007bff; color: #ffffff; padding: 10px 20px; font-size: 15px; border: none; border-radius: 3px; }
    </style>
</head>
<body>
    <h1>계정 정보</h1>
    <hr>
    <form action="#" method="post" class="account_info">
        <!--사용자 이름-->
        <label for="userName">사용자 이름</label>
        <input type="text" name="userName" id="userName" placeholder="사용자 이름을 입력하세요">
        <p class="desc1">현재: <%=currName%></p>
        <!--소속-->
        <label for="affiliation">학교/회사 또는 소속</label>
        <input type="text" name="affiliation" id="affiliation" placeholder="학교/회사 또는 소속">
        <p class="desc2">현재: <%=currAff%></p>
        <input type="submit" value="정보 변경하기">
    </form>
    <h1>계정 보안</h1>
    <hr>
    <form action="db_updatePassword.jsp" method="post" class="account-security">
        <!--이메일-->
        <label for="email">이메일</label>
        <input type="email" name="email" id="email"
            title="xxx@xxx.xxx" placeholder="새 이메일 주소를 입력하세요">
        <!--비밀번호-->
        <p class="desc3">현재: <%=currEmail%></p>    
        <label for="currentPassword">현재 비밀번호</label>
        <input type="password" name="currentPassword" id="currentPassword"
        placeholder="현재 비밀번호를 입력하세요">
        <label for="newPassword">새 비밀번호</label>
        <input type="password" name="newPassword" id="newPassword" 
        placeholder="새 비밀번호를 입력하세요">
        <input type="submit" value="이메일 및 비밀번호 변경하기">
    </form>
    <button class="backToMemo"type="button" onclick="location.href='login_success.jsp'">메모페이지로 돌아가기</button>
</body>
</html>