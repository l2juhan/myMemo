<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>myMemo_login</title>
    <style>
        * {        
            font-family: "Arial", sans-serif;
        }
        header {
		    box-sizing: border-box;
            background-color: #ffffff;
            border-bottom: 1px solid #cccccc;
            padding: 10px 20px;
        }
	    .nav-left a{
            font-weight: bold;
            font-size: 23px;
            color: #d11;
            display: flex;
            align-items: center;
		    text-decoration: none;
        }
        body {
            background-color: #fff;
            margin: 0;
            padding: 0;
        }
        .login-container {
            width: 350px;
            border: 1px solid #fff;
            padding: 20px;
            margin:100px auto;
            border-radius: 0;
        }
        .login-container h1 {
            text-align: center;
            margin-bottom: 20px;
        }
        .form-input {
            margin-bottom: 15px;
        }
        .form-input input {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
        }
        .login-btn {
            width: 100%;
            background-color: #007bff;
            color: white;
            padding: 10px;
            border: none;
            cursor: pointer;
        }
        .login-btn:hover {
            background-color: #0056b3;
        }
        .info-text {
            font-size: 0.9em;
            margin-top: 15px;
            text-align: center;
            color: #555;
        }
        .info-text a {
            color: #007bff;
            text-decoration: none;
        }
        .info-text a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <header>
        <div class="nav-left"><a href="index.jsp">myMemo</a></div>
    </header>
    <div class="login-container">
        <h1>로그인</h1>
        <form action="db_login_process.jsp" method="post">
            <div class="form-input">
                <input type="text" name="userId" placeholder="아이디 / 이메일" required>
            </div>
            <div class="form-input">
                <input type="password" name="password" placeholder="비밀번호" required>
            </div>
            <button class="login-btn" type="submit">로그인</button>
        </form>
        <div class="info-text">
            회원 가입은 <a href="memberJoining.jsp">여기</a>에서 할 수 있습니다.
        </div>
    </div>
</body>
</html>