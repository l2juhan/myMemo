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