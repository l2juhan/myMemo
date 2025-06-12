<%@ page import="java.sql.*, java.text.SimpleDateFormat,java.util.ArrayList, java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // --- 1. 기본 정보 및 파라미터 가져오기 ---
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String nickname = (String) session.getAttribute("nickname");
    Integer memberIdx = (Integer) session.getAttribute("memberIdx");
    String selectedCategoryId_str = request.getParameter("categoryId");
    String selectedMemoId_str = request.getParameter("memoId");
    //카테고리 목록 
    List<String[]> categoryList=new ArrayList<>();
    
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Class.forName("org.mariadb.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/memodb", "admin", "1234");
    try {
    	String sql = "SELECT l.idx, l.listName, COUNT(m.idx) as memo_count " +
                "FROM list AS l LEFT JOIN memo AS m ON l.idx = m.list_idx " +
                "WHERE l.member_idx = ? " +
                "GROUP BY l.idx, l.listName ORDER BY l.listName";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, memberIdx);
        rs = pstmt.executeQuery();
        while(rs.next()) {
        	categoryList.add(new String[]{ 
                    rs.getString("idx"), 
                    rs.getString("listName"), 
                    rs.getString("memo_count") 
                });
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    }
    
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>메모 프로그램</title>
    <style>
        .memo_titles { margin-left: 20px; margin-bottom: 6px; }
        .memo_title_item { padding: 4px 8px; cursor: pointer; }
        .memo_title_item:hover { background-color: #f0f0f0; }
        * { box-sizing: border-box; font-family: "Arial", sans-serif; }
        header { display: flex; justify-content: space-between; align-items: center; height: 40px; }
        header h1 { margin: 0; font-size: 30px; }
        header h1 a { text-decoration: none; color: #f44336; }
        .layout { display: flex; height: 100vh; }
        .left { width: 15%; background-color: #fff; border-right: 2px solid #bbb; padding: 5px; }
        .user_info { margin-bottom: 20px; border: 1px solid #ccc; border-radius: 8px; text-align: center; padding: 10px; }
        .category_header { display: flex; align-items: center; justify-content: center; margin-bottom: 10px; font-weight: bold; }
        .category_list { max-height: calc(100vh - 200px); overflow-y: auto; }
        .icon { margin-right: 5px; font-size: 18px; }
        .category_item { display: flex; align-items: center; width: 100%; padding: 8px 10px; margin-bottom: 6px; background-color: #eee; border-radius: 6px; cursor: pointer; }
        .category_item:hover, .category_item.selected { background-color: #ddd; }
        .memo_list_container { padding-left: 20px; }
        .memo_item { padding: 4px 8px; cursor: pointer; border-radius: 4px; margin-top: 4px; }
        .memo_item:hover { background-color: #f0f0f0; }
        .memo_date { font-size: 0.8em; color: #777; margin-left: 8px; }
        .center { width: 70%; background-color: #fff8dc; display: flex; flex-direction: column; padding: 20px; }
        .note_header { display: flex; align-items: center; justify-content: space-between; background-color: #ffff88; padding: 10px; border-radius: 8px 8px 0 0; }
        .title_input { flex: 1; margin-right: 10px; padding: 5px; border: 1px solid #ccc; border-radius: 4px; background-color: #fff8dc; }
        .note_body { flex: 1; padding: 20px; overflow-y: auto; border-right: 1px solid #ddd; border-left: 1px solid #ddd; }
        .note_body textarea { width: 100%; height: 100%; resize: none; border: none; outline: none; background-color: transparent; }
        .note_footer { position: relative; padding: 10px; background-color: #ffff88; border-radius: 0 0 8px 8px; display: flex; justify-content: center; align-items: center; }
        .arrow_group { position: absolute; left: 10px; }
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
                <h3><a href="#">👤사용자 정보</a></h3>
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
                        <%-- ### 2. 카테고리 목록 DB에서 불러와 표시 ### --%>
                        <%
                            for (String[] category : categoryList) {
                                String listIdx = category[0];
                                String listName = category[1];
                                String memoCount = category[2]; // 메모 개수 변수
                                String selectedClass = (selectedCategoryId_str != null && listIdx.equals(selectedCategoryId_str)) ? "selected" : "";
                        %>
                                <a href="login_success.jsp?categoryId=<%= listIdx %>" class="category_item <%= selectedClass %>">
                                    <span class="category_name">
                                        <span class="icon">📂</span>
                                        <span><%= listName %></span>
                                    </span>
                                    <span class="memo_count">(<%= memoCount %>)</span>
                                </a>
                        <%
                            }
                        %>
                    </div>

                    <%-- ### 3. 메모 목록 DB에서 불러와 표시 ### --%>
                    <%
                        if (selectedCategoryId_str != null) {
                    %>
                        <div class="memo_list_container">
                            <h4>메모 목록</h4>
                    <%
                     		try {
                                String memoSql = "SELECT idx, title, is_important FROM memo WHERE list_idx = ? ORDER BY created_at DESC";
                                pstmt = con.prepareStatement(memoSql);
                                pstmt.setInt(1, Integer.parseInt(selectedCategoryId_str));
                                rs = pstmt.executeQuery();
                                while (rs.next()) {
                                    String importantMark = "Y".equals(rs.getString("is_important")) ? "⭐" : "";
                                    int memoId = rs.getInt("idx");
                                    String selectedMemoClass = (selectedMemoId_str != null && memoId == Integer.parseInt(selectedMemoId_str)) ? "selected" : "";
                    %>
                                    <div class="memo_item <%= selectedMemoClass %>" onclick="location.href='login_success.jsp?categoryId=<%=selectedCategoryId_str%>&memoId=<%=memoId%>'">
                                        <%= importantMark %> <%= rs.getString("title") %>
                                    </div>
                    <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                out.println("메모 목록을 불러오는 중 오류.");
                            } finally {
                                if (rs != null) try { rs.close(); } catch (Exception e) {}
                                if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}                              
                            }
                    %>
                        </div>
                    <%}%>
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
            
            if (selectedMemoId_str != null) {
                try {
                    String sql = "SELECT * FROM memo WHERE idx = ?";
                    pstmt = con.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(selectedMemoId_str));
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        memoTitle = rs.getString("title");
                        memoContent = rs.getString("memo");
                        memoIsImportant = rs.getString("is_important");
                        memoBackgroundColor = rs.getString("backgroundColor");
                        memoFileName = rs.getString("fileName");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception e) {}
                    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                    if (con != null) try { con.close(); } catch (Exception e) {}
                }
            }
        %>
        
        <form name="memoForm" id="memoForm" class="center" action="add_memo_proc.jsp" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="list_idx" id="selectedListIdx">
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
                        <option value="Yellow"  <%= "Yellow".equals(memoBackgroundColor) ? "selected" : "" %>>노란색</option>
                    </select>
                </label>
                <label>카테고리:
                 <select name="list_idx" id="categorySelect">
                     <%
                         if (categoryList.isEmpty()) {
                     %>
                             <option value="">카테고리를 만들어주세요</option>
                     <%
                         } else {
                             for (String[] category : categoryList) {
                     %>
                                 <option value="<%= category[0] %>"><%= category[1] %> (<%= category[2] %>)</option>
                     <%
                             }
                         }
                     %>
                 </select>
             </label>
            </div>
            <div class="note_body">
                <textarea name="memo" placeholder="메모 내용을 입력하세요..."><%= memoContent %></textarea>
            </div>
            <div class="note_footer">
                <div class="arrow_group">
                    <button type="button">⬅️</button><span>1/1</span><button type="button">➡️</button>
                </div>
                <div class="file_attachment">
                    <label for="fileInput">첨부 그림:</label>
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
            <button id="updateMemoBtn" class="memo_add_btn" style="display:none;">✏️ 메모 수정</button>
            <button id="deleteMemoBtn" class="delete_btn">🗑️ 삭제하기</button>
            <div class="quicknote">
                <div class="quicknote_header">📌 간편 메모장</div>
                <textarea class="quicknote_input" placeholder="내용 입력..."></textarea>
            </div>
        </div>
    </div>
    <div id="categorySelectOverlay" class="category-select-overlay">저장할 카테고리를 선택하세요</div>

<script>
    // 전역 변수로 현재 상태를 관리

    // 카테고리 추가 버튼 이벤트
    document.addEventListener('DOMContentLoaded', function() {
        const addBtn = document.getElementById('addCategoryBtn');
        addBtn.addEventListener('click', function() {
            const name = prompt("추가할 새 카테고리의 이름을 입력하세요:");
            if (name && name.trim() !== "") {
                document.getElementById('categoryNameInput').value = name;
                document.categoryForm.submit();
            } else if (name !== null) {
                alert("카테고리 이름이 입력되지 않았습니다.");
            }
        });
    });

    // 메모 추가 버튼 이벤트
    // login_success.jsp의 <script> 태그 안
// ...

// 메모 추가 로직
document.getElementById('addMemoBtn').addEventListener('click', function() {
    // 1. memoForm을 가져옵니다.
    const form = document.forms.memoForm;
    const title = form.title.value.trim();
    const content = form.memo.value.trim();
    const categorySelect = form.list_idx;

    // 2. 유효성 검사 (카테고리 선택 여부, 제목/내용 입력 여부)
    if (categorySelect.value === "") {
        alert("저장할 카테고리가 없습니다. 카테고리를 먼저 만들어주세요.");
        return;
    }
    if (title === "" || content === "") {
        alert("제목과 내용을 먼저 입력해주세요.");
        return;
    }

    // 3. 모든 조건이 만족하면 form을 action에 지정된 "add_memo_proc.jsp"로 제출합니다.
    form.submit();
});
</script>
</body>
</html>