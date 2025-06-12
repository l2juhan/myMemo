<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>계정 설정</title>
    <style>
    
        body {
            font-family: sans-serif;
            margin: 40px;
            background-color: #f7f7f7;
        }
        h1 {
            font-size: 22px;
            margin-bottom: 8px;
        } 
        hr {
            border: none;
            border-top: 1px solid #cccccc;
            margin-bottom: 20px;
        }
        form {
            background-color: #ffffff;
            padding: 20px;
            margin-bottom: 30px;
            border: 1px solid #dddddd;
            border-radius: 6px;
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="file"] {
            display: block;
            width: 100%;
            max-width: 300px;
            margin-top: 5px;
            margin-bottom: 15px;
            padding: 8px;
            box-sizing: border-box;
            border: 1px solid #cccccc;
            border-radius: 3px;
            font-size: 14px;
        }

        .profile-img {
            display: inline-block;
            width: 50px;
            height: 50px;
            background-color: #ccc;
            border-radius: 50%;
            margin-right: 10px;
        }

        button,
        input[type="submit"] {
            cursor: pointer;
            background-color: #007bff;
            color: #ffffff;
            padding: 10px 20px;
            font-size: 15px;
            border: none;
            border-radius: 3px;
        }

        button:hover,
        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .desc {
            font-size: 12px;
            color: #666666;
            margin: -5px 0 10px 0;
        }
    </style>
    <script>
        function saveAndRediret(e){
            e.preventDefault();
            const name = document.getElementById('userName').value;
            sessionStorage.setItem('userName',name);
            window.location.href='login_success.html';
        }
    </script>
</head>
<body>

    <h1>계정 정보</h1>
    <hr>
    <form action="#" method="post" class="account_info" onsubmit="saveAndRedirect(event)">
        <label for="userName">사용자 이름</label>
        <input type="text" name="userName" id="userName" placeholder="사용자 이름을 입력하세요">
        <p class="desc">간단한 이름을 사용하세요.</p>
    </form>

    <h1>계정 보안</h1>
    <hr>
    <form action="db_updatePassword.jsp" method="post" class="account-security">
        <label for="email">이메일</label>
        <input type="email" name="email" id="email"
            title="xxx@xxx.xxx" placeholder="이메일 주소를 입력하세요">
    
        
        <label for="currentPassword">현재 비밀번호</label>
        <input type="password" name="currentPassword" id="currentPassword"
        placeholder="현재 비밀번호를 입력하세요">

        <label for="newPassword">새 비밀번호</label>
        input type="password" name="newPassword" id="newPassword" 
        placeholder="새 비밀번호를 입력하세요">

        <input type="submit" value="비밀번호 변경">
    </form>

</body>
</html>