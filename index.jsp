<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!--============================첫 페이지==============================-->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주한이의 메모 프로그램 - 메인 페이지</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: "Arial", sans-serif; }
        body { background-color: #f2f2f2; min-height: 100vh; display: flex; flex-direction: column; }
        header { background-color: #ffffff; border-bottom: 1px solid #cccccc; padding: 10px 20px; }
        nav { display: flex; align-items: center; justify-content: space-between; }
        .nav-left { font-weight: bold; font-size: 20px; color: #d11; display: flex; align-items: center; }
        .nav-left a { font-weight: normal; font-size: 16px; color: #333333; text-decoration: none; margin-left: 15px;  }
        .nav-left a:hover { text-decoration: underline; }
        .nav-right a { text-decoration: none; color: #333333; margin-left: 20px; font-size: 16px; }
        .nav-right a:hover { text-decoration: underline; }
        main { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; padding: 20px; }
        main h1 { font-size: 28px; margin-bottom: 20px; }
        main p { font-size: 18px; line-height: 1.5; margin-bottom: 30px; }
        .note { width: 150px; height: 200px; background-color: #ffffcc; border: 2px solid #cccccc; border-radius: 4px; display: inline-block; position: relative; background-image: repeating-linear-gradient(to bottom, transparent, transparent 19px, #999 20px); }
    </style>
</head>
<body>
    <header>
        <nav>
            <div class="nav-left">
                myMemo
                <a href="introdudce.jsp">소개 및 사용법</a>
            </div>
            <div class="nav-right">
                <a href="login.jsp">로그인</a>
                <a href="memberJoining.jsp">회원가입</a>
            </div>
        </nav>
    </header>
    <main>
        <h1>주한이가 만든 메모 프로그램!</h1>
        <p>은근 쓸만합니다<br>열심히 했습니다.</p>
        <div class="note"></div>
    </main>
</body>
</html>