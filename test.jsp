<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    String nickname=(String)session.getAttribute("nickname");
    String email = (String)session.getAttribute("email");
    String userId = (String)session.getAttribute("userId");
    String affiliation = (String)session.getAttribute("affiliation");
    String password = (String)session.getAttribute("password");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>메모 프로그램</title>
<!--
1.(메모번호, 메모 제목, 중요여부, 메모 내용, 메모 배경색, 첨부 그림 파일명, 작성일)메모 저장과 함께 같이 저장하기
2.
-->

    <style>
    	.memo_titles {
            margin-left: 20px;
            margin-bottom: 6px;
        }
        .memo_title_item {
            padding: 4px 8px;
            cursor: pointer;
        }
        .memo_title_item:hover {
            background-color: #f0f0f0;
        }
        *{
            box-sizing:border-box; /*weight와 height에 padding 과 border 길이 포함(계산하기 편함)*/
            font-family: "Arial", sans-serif;
        }
        header{
            display:flex;
            justify-content:space-between;/*각각 컨테이너의 간격 일정*/
            align-items:center;/*세로 길이의 중앙에 배치*/
            height:40px;
        }
        header h1{
            margin:0;
            font-size: 30px;
        }
        header h1 a{
            text-decoration:none;
            color: #f44336;
        }
        .layout{
            display:flex;/*div class left,center,right를 가로로 배치*/
            height:100vh;/*viewport height*/
        }
        /* dimmed 상태에서 center와 right 영역만 흐림 처리하고 클릭 방지 */
        .layout.dimmed > .center,
        .layout.dimmed > .right {
            filter: blur(3px);
            pointer-events: none;
        }
        .left{
            width:15%;
            background-color:#fff;
            border-right:2px solid #bbb;/*오른쪽 테두리 설정*/
            padding:5px;/*테두리로부터의 거리(위,오,아,왼)*/
        }
        .user_info{
            margin-bottom:20px;/*아래 여백 만들기*/
            border:1px solid #ccc; /*박스로 만들기(일반 보류)*/
            border-radius:8px;
            text-align:center;/*가운데 정렬*/
        }
        .category_header{
            display:flex;/*가로에 배치*/
            align-items:center;
            justify-content: center;/*요소들이 가운데로 모이고, 그사이 간격 x */
            margin-bottom:10px;
            font-weight:bold;/*강조를 위해*/
        }
        .category_list{
            max-height: calc(100vh - 200px);/*clac()란?=>단위가 다른 값끼리 계산할 때 사용*/
            overflow-y: auto;/*카테고리 개수가 많아져서 화면아래로 넘어갈때*/
        }
        .icon{
            margin-right:3px;
            font-size:18px;
        }
        .category_item{
            display:flex;
            width:100%;
            padding: 8px 10px;/*(안쪽 여백)요소 안쪽에서 내용과 테두리 사이 공간*/
            margin-bottom:6px;/*(바깥 여백)다음 요소와의 간격 조절*/
            background-color: #eee;/*구별하기 위함*/
            border-radius: 6px;
            cursor:pointer;
        }
        .category_item:hover{
            background-color: #ddd;/*마우스를 올렸을때 구별하기 위함*/
        }   
        .center{
            width:70%;
            background-color: #fff8dc;
            display: flex;
            flex-direction: column;/*세로로 컨테이너 정렬하기*/
            padding:20px;
        }
        .note_header{
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: #ffff88;
            padding: 10px;
            border-radius: 8px 8px 0 0;
        }
        .title_input{
            flex:1;/*사용가능한 공간을 최대한 차치하기*/
            margin-right:10px;
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
            background-color: #fff8dc;
        }
        .note_body{
            flex:1;
            padding:20px;
            overflow-y: auto;
        }
        .note_body textarea{
            width: 100%;
            height: 100%;/*최대크기로 사용*/
            resize: none;/*사용자가 마우스로 텍스트창의 크기를 조절 x */
            border:none;/*테두리 숨김*/
            outline:none;/*텍스트 클릭 시 테두리 보임 x */
            background-color: transparent;/*배경색 투명(부모요소의 배경 사용)*/
        }
        .note_footer{
            position: relative;
            padding: 10px;
        }
        .arrow_group{
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }
        .print_btn{
            position: absolute;
            right: 10px;
        }
        .right{
            width:15%;
            background-color: #fff;
            border-left:2px solid #bbb;
            padding:5px;
            display: flex;
            flex-direction: column;
            gap: 8px;/*컨테이너에 지정,자식 요소들 사이에만 일정한 간격*/
        }
        .right button{
            width: 100%;
            margin-top: 10px;
            margin-bottom: 10px;/*개별 요소에 지정,해당 요소의 아래쪽에만 여백 추가*/
            padding:12px;
            border:none;
            border-radius:8px;
            cursor:pointer;
            text-align: center;
            height: 48px;
        }
        .home_btn{
            background-color: #4CAF50;
            color:#fff;
        }
        .memo_add_btn{
            background-color: #888;
            color: #fff;
        }
        .delete_btn{
            background-color: #f44336;
            color:#fff;
        }
        .quicknote{
            width: 100%;
            height:300px;
            background-color: #ffff88;
            border-radius: 8px;
            padding:10px;
        }
        .quicknote_header{
            font-weight:bold;
            margin-bottom: 5px;
        }
        .quicknote_input{
            width: 100%;
            height:250px;
            resize:none;
            border:none;
            outline:none;
            background-color: transparent;/*note_body_textarea와 같은 맥락*/
        }

    </style>
    <script>
        //유저의 닉네임 가져오기(jsp)
        const userNickname="<%= nickname%>";//javascript와 충돌방지를 예방한 escape

        window.onload=function(){
            displayUserNickname(userNickname);
        }

        function displayUserNickname(nickname){
            const nicknameDiv=document.querySelector('.user_nickname');
            if(nicknameDiv&&nickname){
                nicknameDiv.textContent=nickname+"님, 환영합니다!";
            }
        }
        //리스트 추가하기
        function addList(){
            const name=prompt("새 카테고리 이름을 입력하세요: ");
            if(!name) return;
            
            const list=document.querySelector(".category_list");
            const items=list.querySelectorAll(".category_item");
            //이름이 같은 리스트를 추가할려고 할때 종료하기
            for(let i=0;i<items.length;++i){
                const text=items[i].textContent.replace('📂','').trim();
                if(text===name){
                    alert("이름이 같은 리스트가 존재합니다ㅡㅡ;");
                    return;
                }
            }
            //추가할 위치 정하기(잡동사니 바로 위에)
            let referenceItem=null;
            for(let i=0;i<items.length;++i){
                if(items[i].textContent.replace('📂','').trim()==="잡동사니"){
                    referenceItem=items[i]; break;
                }
            }
            const newItem=document.createElement("div");
            newItem.className="category_item";
            const icon=document.createElement("span");
            icon.className="icon";
            icon.textContent="📂";
            newItem.appendChild(icon);
            newItem.appendChild(document.createTextNode(name));
            list.insertBefore(newItem, referenceItem);
        }
        
        //홈 버튼 클릭 시
        function backToHome(){

        }

        //메모 추가하기(카테고리 지정,default:잡동사니)
        
		window.addEventListener('DOMContentLoaded', function() {
            // 카테고리 이름 우클릭 시 이름 변경 or (카테고리 삭제)
            const categoryList = document.querySelector(".category_list");
            categoryList.addEventListener("contextmenu", function(e) {
                const item = e.target.closest(".category_item");
                if (item && item.textContent.trim() !== "잡동사니") {
                    e.preventDefault();
                    const currentName = item.textContent.replace("📂", "").trim();
                    const newName = prompt("카테고리 이름을 변경하세요:", currentName);
                    if (newName) {
                        item.childNodes[1].textContent = newName;
                    }
                }
            });
            const addBtn = document.getElementById('addMemoBtn');
            addBtn.addEventListener('click', function() {
    	// 1) 입력값 검증
    		const title = document.querySelector('.title_input').value.trim();
    		const content = document.querySelector('.note_body textarea').value.trim();
    		const color = document.getElementById('memoColorSelect').value;
    		if (!title || !content) {
                alert('제목 또는 내용을 입력하세요.');
                return;
    		}

    	// 2) 파라미터 조합 후 addMemo.jsp 로 이동
    	const params = new URLSearchParams({
            title: title,
            content: content,
            category: document.querySelector('.category_item.selected')?.textContent.replace('📂','').trim() || '잡동사니',
            color:color
   	 	});
    // addMemo.jsp 호출 (서버에서 쿠키 저장 + 리다이렉트 처리)
    	location.href = 'addMemo.jsp?' + params.toString();
        });
	});

        //메모 삭제하기
        function deleteMemo(){

        }
    </script>
</head>
<body>
    <header>
        <h1><a href="index.jsp">myMemo</a></h1>
        <div class="search_box">
            <input type="text" placeholder="검색어를 입력하세요...">
            <button onclick="searchMemo()">검색</button>
        </div>
    </header>
    <hr>
    <div class="layout">
        <div class="left">
            <div class="user_info">
                <h3><a href="auth.jsp">👤사용자 정보</a></h3>
                <div class="user_nickname"></div>
            </div>
            <div class="category">
                <div class="category_header">
                    <span>🗂️카테고리&nbsp;</span>
                    <button id="addListBtn" class="add_list_btn" onclick="addList()">➕</button>
                </div>
                <div class="category_list"><div class="category_item"><span class="icon">📂</span>인터넷프로그래밍</div>
                    <div class="category_item"><span class="icon">📂</span>자바응용프로그래밍</div>
                    <div class="category_item"><span class="icon">📂</span>자료구조</div>
                    <div class="category_item"><span class="icon">📂</span>파이썬</div>
                    <div class="category_item"><span class="icon">📂</span>잡동사니</div>
                </div>
            </div>
        </div>
        
        <form class="center" name="memoForm" method="POST" enctype="multipart/form-data">
            <div class="note_header">
                <input type="text" name="title" class="title_input" placeholder="제목을 입력하세요(최대 30글자)" maxlength="30">
                
                <label>중요:
                    <select name="is_important" id="isImportantSelect">
                        <option value="N" selected>N</option>
                        <option value="Y">Y</option>
                    </select>
                </label>
                
                <label>메모 배경색:
                    <select name="backgroundColor" id="memoColorSelect">
                        <option value="default">기본</option>
                        <option value="skyBlue">하늘색</option>
                        <option value="Yellow">노란색</option>
                    </select>
                </label>
            </div>
            <div class="note_body">
                <textarea name="memo" placeholder="메모 내용을 입력하세요..."></textarea>
            </div>
            <div class="note_footer">
                <div class="arrow_group">
                    <!--시간집어넣게 -->
                </div>
                
                <div class="file_attachment">
                    <label for="fileInput">첨부 그림:</label>
                    <input type="file" name="fileName" id="fileInput">
                </div>
            </div>
        </form>

        <div class="right">
            <div class="toolbar_top">
                <button class="home_btn" onclick="backToHome()">🏠홈</button>
                <button id="addMemoBtn" class="memo_add_btn">➕메모 추가하기</button>
                <button id="deleteMemoBtn" class="delete_btn" onclick="deleteMemo()">🗑️삭제하기</button>
                <div class="quicknote">
                    <div class="quicknote_header">📌간편 메모장</div>
                    <textarea class="quicknote_input" placeholder="내용 입력..."></textarea>
                </div>
            </div>
        </div>
    </div>
</body>
</html>