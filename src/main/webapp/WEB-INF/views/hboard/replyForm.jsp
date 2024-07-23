<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<c:import url="./../header.jsp" />

		<h2>${param.boardNo}번 글에 대한 답글 작성 페이지</h2>
		
		<form action="saveReply" method="post">
			<div class="mb-3">
				<label for="title" class="form-label">글제목</label> <input type="text"
					class="form-control" id="title" name="title"
					placeholder="글제목을 입력하세요">
			</div>
			<div class="mb-3">
				<label for="writer" class="form-label">작성자</label> <input
					type="text" class="form-control" id="writer" name="writer"
					placeholder="작성자를 입력하세요">
			</div>
			<div class="mb-3">
				<label for="content" class="form-label">내용</label>
				<textarea class="form-control" id="content" rows="5" name="content"
					placeholder="내용을 입력하세요"></textarea>
			</div>

			<div>
				<input type="hidden" name="ref" value="${param.ref }" />
				<input type="hidden" name="step" value="${param.step }" />
				<input type="hidden" name="refOrder" value="${param.refOrder }" />
			</div>

			<button type="submit" class="btn btn-primary">답글 저장</button>
			<button type="button" class="btn btn-warning" onclick="">취소</button>
		</form>


		<c:import url="./../footer.jsp" />
	</div>
</body>
</html>