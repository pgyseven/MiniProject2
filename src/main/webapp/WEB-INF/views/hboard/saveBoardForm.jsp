<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function validBoard() {
        let result = false;
        let title = $('#title').val();
        console.log(title);

        if (title == '' || title.length < 1 || title == null) {
            // 제목을 입력 하지 않았을때
            alert("제목은 반드시 입력하셔야 합니다");
            $('#title').focus();
        } else {
            // 제목을 입력했을 때
            result = true;
        }
        

        // 유효성 검사 하는 자바스크립트에서는 마지막에 boolean 타입의 값을 반환하여
        // 데이터가 백엔드 단으로 넘어갈지 말지를 결정해줘야 한다!!!!!
        return result;
    }
</script>
</head>
<body>
<div class="container">
	<c:import url="./../header.jsp" />

    <h2>게시글 작성</h2>
    <form action="saveBoard" method="POST">
        <div class="mb-3">
            <label for="title" class="form-label">글제목</label>
            <input type="text" class="form-control" id="title" name="title" placeholder="글제목을 입력하세요" >
        </div>
        <div class="mb-3">
            <label for="writer" class="form-label">작성자</label>
            <input type="text" class="form-control" id="writer"  name="writer" placeholder="작성자를 입력하세요">
        </div>
        <div class="mb-3">
            <label for="content" class="form-label">내용</label>
            <textarea class="form-control" id="content" rows="5" name="content" placeholder="내용을 입력하세요"></textarea>
        </div>
        <button type="submit" class="btn btn-primary" onclick="return validBoard();">저장</button>
    </form>
    
    
    <c:import url="./../footer.jsp" />
</div>
</body>
</html>