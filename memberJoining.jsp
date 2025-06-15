<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<!--=============================회원가입 창==============================-->
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>memberJoining</title>
	<style>
	* {        
        font-family: "Arial", sans-serif;
    }
	header { box-sizing: border-box; background-color: #ffffff; border-bottom: 1px solid #cccccc; padding: 10px 20px; }
	.nav-left a { font-weight: bold; font-size: 25px; color: #d11; display: flex; align-items: center; text-decoration: none; }
    body { background: #ffffff; margin:0; padding:0; }
    .signup-container { max-width: 400px; margin: 100px auto; background: #fff; padding: 20px; }
    .signup-container h1 { text-align: center; margin-bottom: 16px; }
    .signup-container p { font-size: 14px; color: #555; line-height: 1.4; margin-bottom: 12px; }
    .signup-container a { color: #0066cc; text-decoration: none; }
    .signup-container .form-group { margin-bottom: 12px; }
    .signup-container label { display: block; margin-bottom: 4px; font-weight: bold; font-size: 14px; }
    .signup-container input { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
    .signup-container button { width: 100%; padding: 10px; background: #007bff; color: #fff; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
    .signup-container button:hover { background: #1593ce; }
	</style>
</head>
<body>
	<header>
		<div class="nav-left"><a href="index.jsp">myMemo</a></div>
	</header>
	<div class="signup-container">
		<h1>회원가입</h1>
		<p>계정이 이미 있는 경우에는 <a href="login.jsp">로그인</a>해주세요.</p>

		<form action="db_memberJoining_confirm.jsp" method="post">
    		<div class="form-group">
    			<label for="userId">아이디</label>
    			<input type="text" id="userId" name="userId" maxlength="50" placeholder="최대 50자 입력 가능" />
    	</div>
    	<div class="form-group">
    		<label for="statusMsg">닉네임</label>
    		<input type="text" id="userNickname" name="userNickname" maxlength="50" placeholder="최대 50자 입력 가능"/>
    	</div>
    	<div class="form-group">
    		<label for="password">비밀번호</label>
    		<input type="password" id="password" name="password" maxlength="100" placeholder="최대 100자 입력 가능" required />
    	</div>
    	<div class="form-group">
    		<label for="passwordConfirm">비밀번호 (확인)</label>
    		<input type="password" id="passwordConfirm" name="passwordConfirm" maxlength="100" placeholder="최대 100자 입력 가능" required />
    	</div>
    	<div class="form-group">
    		<label for="affiliation">학교/회사 또는 소속</label>
    		<input type="text" id="affiliation" name="affiliation" maxlength="100" placeholder="최대 100자 입력 가능"/>
    	</div>
    	<div class="form-group">
    		<label for="email">이메일</label>
    		<input type="email" id="email" name="email" maxlength="100" placeholder="최대 100자 입력 가능" required />
    	</div>
    		<button type="submit">회원가입</button>
		</form>
	</div>
</body>
</html>