<%@ page import="java.sql.*, java.text.SimpleDateFormat,java.util.ArrayList, java.util.List, java.util.stream.Collectors" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // 1. 기본 정보 및 파라미터 가져오기
    if (session.getAttribute("userId") == null) { //혹시 모를 버그대비
        response.sendRedirect("login.jsp");
        return;
    }
    String nickname = (String) session.getAttribute("nickname");
    Integer memberIdx = (Integer) session.getAttribute("memberIdx");
    String selectedCategoryId_str = request.getParameter("categoryId");
    String selectedMemoId_str = request.getParameter("memoId");
    
    //카테고리 정보 가져오기
List<String[]> categoryList = new ArrayList<>();
int categoryCount=0;

String sql =
    "SELECT l.idx, l.listName, COUNT(m.idx) AS memo_count " +
    "FROM list AS l " +
    "LEFT JOIN memo AS m ON l.idx = m.list_idx " +
    "WHERE l.member_idx = ? " +
    "GROUP BY l.idx, l.listName " +
    "ORDER BY l.listName";

try (
    Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/memodb","admin","1234");
    PreparedStatement pstmt = con.prepareStatement(sql)
) {
    Class.forName("org.mariadb.jdbc.Driver");
    pstmt.setInt(1, memberIdx);
    try (ResultSet rs = pstmt.executeQuery()) {
        while(rs.next()){
            categoryList.add(new String[]{
                rs.getString("idx"),
                rs.getString("listName"),
                rs.getString("memo_count")
            });
        }
    }
    categoryCount = categoryList.size();
} catch (Exception e) {
    e.printStackTrace();
}

String existingNamesJs = categoryList.stream()
        .map(cat -> "\"" + cat[1].replace("\"","\\\"") + "\"")
        .collect(Collectors.joining(","));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>메모 프로그램</title>
    <style>
        * { box-sizing: border-box; font-family: "Arial", sans-serif; }
        .memo_titles { margin-left: 20px; margin-bottom: 6px; }
        .memo_title_item { padding: 4px 8px; cursor: pointer; }
        .memo_title_item:hover { background-color: #f0f0f0; }
        header { display: flex; justify-content: space-between; align-items: center; height: 40px; }
        header h1 { margin: 0; font-size: 30px; }
        header h1 a { text-decoration: none; color: #f44336; }
        .layout { display: flex; height: 100vh; }
        .left { width: 15%; background-color: #fff; border-right: 2px solid #bbb; padding: 5px; }
        .user_info { margin-bottom: 20px; border: 1px solid #ccc; border-radius: 8px; text-align: center; padding: 10px; text-decoration: none;}
        .category_header { display: flex; align-items: center; justify-content: center; margin-bottom: 10px; font-weight: bold; }
        .category_list { max-height: calc(100vh - 200px); overflow-y: auto; max-height:calc(100vh-200px); overflow-y:auto; text-decoration: none;}
        .icon { margin-right: 5px; font-size: 18px; }
        .category_item { display: flex; align-items: center; width: 100%; padding: 8px 10px; margin-bottom: 6px; background-color: #eee; border-radius: 6px; cursor: pointer; }
        .category_item:hover, .category_item.selected { background-color: #ddd; }
        .memo_list_container { padding-left: 20px; max-height:calc(100vh-300px); overflow-y:auto; padding-left:0;}
        .memo_item { padding: 4px 8px; cursor: pointer; border-radius: 4px; margin-top: 4px; margin-bottom:4px; display: block; width:100%; padding:6px 10px; background-color: #f9f9f9;
                    border-radius:6px; text-decoration:none; color:#333;}
        .memo_item:hover { background-color: #eee }
        .memo_date { font-size: 0.8em; color: #777; margin-left: 8px; }
        .center { width: 70%; background-color: #fff8dc; display: flex; flex-direction: column; padding: 20px; }
        .note_header { display: flex; align-items: center; justify-content: space-between; background-color: #ffff88; padding: 10px; border-radius: 8px 8px 0 0; }
        .title_input { flex: 1; margin-right: 10px; padding: 5px; border: 1px solid #ccc; border-radius: 4px; background-color: #fff8dc; }
        .note_body { flex: 1; padding: 20px; overflow-y: auto; border-right: 1px solid #ddd; border-left: 1px solid #ddd; }
        .note_body textarea { width: 100%; height: 100%; resize: none; border: none; outline: none; background-color: transparent; }
        .note_footer { position: relative; padding: 10px; background-color: #ffff88; border-radius: 0 0 8px 8px; display: flex; justify-content: center; align-items: center; }
        .memo_time{position:absolute; left:10px; top:50%; transform: translateY(-50%); margin:0; font-size:0.85em; color:#777;}
        .file_attachment { position: absolute; right: 10px; }
        .right { width: 15%; background-color: #fff; border-left: 2px solid #bbb; padding: 5px; display: flex; flex-direction: column; gap: 8px; }
        .right button { width: 100%; margin-top: 10px; margin-bottom: 10px; padding: 12px; border: none; border-radius: 8px; cursor: pointer; text-align: center; height: 48px; }
        .home_btn { background-color: #4CAF50; color: #fff; }
        .memo_add_btn { background-color: #888; color: #fff; }
        .delete_btn { background-color: #f44336; color: #fff; }
        .quicknote { width: 100%; height: 300px; background-color: #ffff88; border-radius: 8px; padding: 10px; }
        .quicknote_header { font-weight: bold; margin-bottom: 5px; }
        .quicknote_input { width: 100%; height: 250px; resize: none; border: none; outline: none; background-color: transparent; }
    </style>
</head>
<body>
    <header>
        <h1><a href="login_success.jsp">myMemo</a></h1>
        <div class="search_box">
            <input type="text" placeholder="검색어를 입력하세요...">
            <button>검색</button>
        </div>
    </header>
    <hr style="margin:0">
    <div class="layout" id="mainLayout">
        <div class="left">
            <div class="user_info">
                <h3><a href="auth.jsp" style="text-decoration: none;">👤사용자 정보</a></h3>
                <div class="user_nickname"><%= nickname %>님, 환영합니다!</div>
            </div>
            <div class="left_panel_content">
                <div class="category">
                    <div class="category_header">
                        <span>🗂️카테고리</span>
                        <form name="categoryForm" action="add_category_proc.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="categoryName" id="categoryNameInput">
                            <input type="hidden" name="memberIdx" value="<%= memberIdx %>">
                            <button type="button" id="addCategoryBtn" class="add_list_btn">➕</button>
                        </form>
                    </div>
                    <div class="category_list">
                        <div id="categoryMenu" style="
                            display:none; position:absolute;
                            border:1px solid #ccc; background:#fff;
                            z-index:1000;">
                            <div id="editCategory" style="padding:4px;cursor:pointer;">✏️ 수정</div>
                            <div id="deleteCategory" style="padding:4px;cursor:pointer;">🗑️ 삭제</div>
                        </div>

        <% for (String[] category : categoryList) {
            String listIdx  = category[0];
            String listName = category[1];
            String memoCount= category[2];
            String selClass = (listIdx.equals(selectedCategoryId_str))?"selected":"";
        %>
            <a href="login_success.jsp?categoryId=<%=listIdx%>"
            class="category_item <%=selClass%>"
            data-id="<%=listIdx%>"
            data-name="<%=listName%>"
            style="text-decoration:none;">
            📂 <%=listName%> (<%=memoCount%>)
            </a>
        <% } %>
                </div>
                    

                    <%-- ### 3. 메모 목록 DB에서 불러와 표시 ### --%>
                    <%
                    if (selectedCategoryId_str != null) {
                    %>
                    <div class="memo_list_container">
                        <h4>메모 목록</h4>
                    <%
                    try {
                        Class.forName("org.mariadb.jdbc.Driver");
                        try (
                            Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/memodb", "admin", "1234");
                            PreparedStatement pstmt = con.prepareStatement("SELECT idx, title, is_important, created_at FROM memo WHERE list_idx = ? ORDER BY idx DESC")
                            ) {
                                pstmt.setInt(1, Integer.parseInt(selectedCategoryId_str));               
                                try (ResultSet rs = pstmt.executeQuery()) {
                                    if (!rs.isBeforeFirst()) { // 결과가 없는 경우
                                    out.println("<div style='color: #888; padding: 5px 10px;'>메모가 없습니다.</div>");
                                } else {
                                    while (rs.next()) {
                                        int memoId = rs.getInt("idx");
                                        String importantMark = "Y".equals(rs.getString("is_important")) ? "⭐" : "";
                                        String selectedMemoClass = (selectedMemoId_str != null && memoId == Integer.parseInt(selectedMemoId_str)) ? "selected" : "";
                                        String title = rs.getString("title");
                                        String createdAt = rs.getString("created_at");
                    %>
                    <!--카테고리 출력-->
                    <a href="login_success.jsp?categoryId=<%=selectedCategoryId_str%>&memoId=<%=memoId%>" class="memo_item <%= selectedMemoClass %>">
                    [#<%=memoId%>]<%= importantMark %> <%= rs.getString("title") %><br><%=createdAt%>
                    </a>
                    <%
                        
                                    }
                                }
                            }
                        }    
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<div style='color:red; padding-left:10px;'>메모 목록을 불러오는 중 오류가 발생했습니다.</div>");
                    }
                    %>
                </div>
                <%
                }
                %>
                </div>
            </div>
        </div>
        <%-- ### 4. 메모 내용 표시 ### --%>
        <%
    String memoTitle = "";
    String memoContent = "";
    String memoIsImportant = "N";
    String memoBackgroundColor = "default";
    String memoFileName = "";
    String memoCreatedAt = null;

    if (selectedMemoId_str != null) {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            try (
                Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/memodb", "admin", "1234");
                PreparedStatement pstmt = con.prepareStatement("SELECT * FROM memo WHERE idx = ?")
            ) {
                pstmt.setInt(1, Integer.parseInt(selectedMemoId_str));
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        memoTitle = rs.getString("title");
                        memoContent = rs.getString("memo");
                        memoIsImportant = rs.getString("is_important");
                        memoBackgroundColor = rs.getString("backgroundColor");
                        // DB의 fileName이 null일 경우를 대비한 코드
                        String tempFileName = rs.getString("fileName");
                        memoFileName = (tempFileName == null) ? "" : tempFileName;
                        memoCreatedAt=rs.getString("created_at");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // out.println("메모 상세 정보를 불러오는 중 오류");
        }
    }
%>
<%
    boolean isEdit = (selectedMemoId_str != null && !selectedMemoId_str.isEmpty());
%>
        <form name="memoForm" id="memoForm" class="center" action="add_memo_proc.jsp" method="POST" enctype="multipart/form-data">
            <% if(isEdit){ %>
                <input type="hidden" name="list_idx" value="<%= selectedCategoryId_str %>">
            <% } %>
            <input type="hidden" name="memoIdx" id="memoIdx" value="<%= selectedMemoId_str != null ? selectedMemoId_str : "" %>">
            <div class="note_header">
                <input type="text" name="title" class="title_input" placeholder="제목을 입력하세요" value="<%= memoTitle %>">
                <label>중요:
                    <select name="is_important" id="isImportantSelect">
                        <option value="N" <%= "N".equals(memoIsImportant) ? "selected" : "" %>>N</option>
                        <option value="Y" <%= "Y".equals(memoIsImportant) ? "selected" : "" %>>Y</option>
                    </select>
                </label>
                <label>배경색:
                    <select name="backgroundColor" id="memoColorSelect">
                        <option value="default" <%= "default".equals(memoBackgroundColor) ? "selected" : "" %>>기본</option>
                        <option value="skyBlue" <%= "skyBlue".equals(memoBackgroundColor) ? "selected" : "" %>>하늘색</option>
                        <option value="Yellow"  <%= "Yellow".equals(memoBackgroundColor) ? "selected" : "" %>>흰색</option>
                    </select>
                </label>
                <label>카테고리:
            <select
                <%= isEdit ? "disabled" : "" %>
                name="<%= isEdit ? "" : "list_idx" %>"
                id="categorySelect"
            >
                <% for(String[] cat: categoryList){ 
                    String idx=cat[0], name=cat[1], cnt=cat[2];
                    String sel = idx.equals(selectedCategoryId_str)?"selected":"";
                %>
                    <option value="<%=idx%>" <%=sel%>>
                    <%=name%> (<%=cnt%>)
                    </option>
                <% } %>
            </select>
        </label>
            </div>
            <div class="note_body" 
                style="background-color: 
                <%="skyBlue".equals(memoBackgroundColor) ? "#add8e6"
                : "Yellow".equals(memoBackgroundColor) ? "#ffffff"
                : "#fff8dc"%>;">
                <textarea name="memo" placeholder="메모 내용을 입력하세요..."><%= memoContent %></textarea>
            </div>
            <div class="note_footer">
                <span class="memo_time">
                    메모 저장시간: <%= memoCreatedAt != null ? memoCreatedAt : "null" %>
                </span>
                <div class="file_attachment">
                    <label for="fileInput">&nbsp;&nbsp;첨부 그림:</label>
                    <input type="file" name="fileName" id="fileInput">
                    <% if (memoFileName != null && !memoFileName.isEmpty()) { %>
                    <span id="currentFileName">(현재 파일: <%= memoFileName %>)</span>
                        <% } %>
                    </div>
                </div>
        </form>
        <div class="right">
            <button class="home_btn" onclick="location.href='login_success.jsp'">🏠 홈</button>
            <button id="addMemoBtn" type="button" class="memo_add_btn">➕ 새 메모 저장</button>
            <button id="updateMemoBtn" type="button" class="memo_add_btn" style="display:none;">✏️ 메모 수정</button>
            <button id="deleteMemoBtn" class="delete_btn">🗑️ 삭제하기</button>
            <div class="quicknote">
                <div class="quicknote_header">📌 간편 메모장</div>
                <textarea class="quicknote_input" placeholder="내용 입력..."></textarea>
            </div>
        </div>
    </div>
    <!--<div id="categorySelectOverlay" class="category-select-overlay">저장할 카테고리를 선택하세요</div>-->
<script>
document.addEventListener('DOMContentLoaded', function() {
  // 1) 카테고리 추가
document.getElementById('addCategoryBtn')
    .addEventListener('click', function() {
        const name = prompt("추가할 새 카테고리의 이름을 입력하세요:");
        if (name && name.trim()) {
            document.getElementById('categoryNameInput').value = name;
            document.categoryForm.submit();
        } else if (name !== null) {
            alert("카테고리 이름이 입력되지 않았습니다.");
        }
    });

  // 2) 새 메모 저장
document.getElementById('addMemoBtn')
    .addEventListener('click', function() {
        const form    = document.getElementById('memoForm');
        const title   = form.title.value.trim();
        const content = form.memo.value.trim();
        const cat     = form.elements['list_idx'].value;

        if (!cat) {
            alert("카테고리를 선택하세요.");
            return;
        }
        if (!title || !content) {
            alert("제목과 내용을 모두 입력해주세요.");
            return;
        }
        form.submit();
    });
});

document.addEventListener('DOMContentLoaded', function(){
    const addBtn  = document.getElementById('addMemoBtn');
    const updBtn  = document.getElementById('updateMemoBtn');
    upBtn.addEventListener('click',submitForm);
    const memoIdx=document.getElementById("memoIdx").value;
    if (memoIdx) {
        addBtn.style.display = 'none';
        updBtn.style.display = 'block';
    }else{
        addBtn.style.display = 'block';
        updBtn.style.display = 'none';
    }
  // 저장·수정 공통 검증
function submitForm(){
    const form = document.getElementById("memoForm");
    const title = form.title.value.trim();
    const content = form.memo.value.trim();
    const cat = form.elements['list_idx'].value;
    if (!cat){ alert("카테고리를 선택하세요."); return; }
    if (!title||!content){ alert("제목과 내용을 모두 입력해주세요."); return; }
    form.submit();
    }
    addBtn.addEventListener('click', submitForm);
    updBtn.addEventListener('click', submitForm);
});
//카테고리 수정 및 삭제하기
const existingCategoryNames = [ <%= existingNamesJs %> ];

      document.addEventListener('DOMContentLoaded', function(){
        const menu = document.getElementById('categoryMenu');
        let selId, selName;

        document.querySelectorAll('.category_item').forEach(item => {
          item.oncontextmenu = function(e){
            e.preventDefault();
            selId   = this.getAttribute('data-id');
            selName = this.getAttribute('data-name');
            menu.style.left    = e.pageX + 'px';
            menu.style.top     = e.pageY + 'px';
            menu.style.display = 'block';
            return false;
          };
        });

        document.body.onclick = () => { menu.style.display = 'none'; };

        document.getElementById('editCategory').onclick = function(){
          let newName = prompt("카테고리 이름을 입력하세요", selName);
          if (newName === null) return;
          newName = newName.trim();
          if (!newName) {
            alert("카테고리 이름을 입력해주세요.");
            return window.location.href = "login_success.jsp";
          }
          if (existingCategoryNames.includes(newName)) {
            alert("이미 존재하는 카테고리명입니다.");
            return window.location.href = "login_success.jsp";
          }
          window.location.href =
            "updateCategoryName.jsp?listIdx=" + selId
            + "&newName=" + encodeURIComponent(newName);
        };

        document.getElementById('deleteCategory').onclick = function(){
          if (!confirm("정말 삭제하시겠습니까?")) return;
          window.location.href = "deleteCategory.jsp?listIdx=" + selId;
        };
      });
</script>
</body>
</html>