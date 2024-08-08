<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	$(function() { // = 이 페이지가 로딩이 완료되면
		$('.rememberCheck').click(function() {
			alert('자동로그인은 공공장소에서 사용하지 않을 것을 권고드립니다.');
		});
	});
</script>
</head>
<body>
	<div class="container">
		<jsp:include page="../header.jsp"></jsp:include>

		<div class="content">
			<h1>로그인</h1>

			<form action="/member/login" method="post">
				<div class="mb-3 mt-3">
					<label for="userId" class="form-label">아이디</label> <input
						type="text" class="form-control" id="userId"
						placeholder="Enter userId" name="userId">
				</div>
				<div class="mb-3">
					<label for="pwd" class="form-label">비밀번호</label> <input
						type="password" class="form-control" id="userPwd"
						placeholder="Enter password" name="userPwd">
				</div>
				<div class="form-check mb-3">
					<label class="form-check-label"> <input
						class="form-check-input rememberCheck" type="checkbox" name="remember">
						Remember me
					</label>
				</div>
				<button type="submit" class="btn btn-primary">로그인</button>
			</form>
		</div>



		<jsp:include page="../footer.jsp"></jsp:include>
	</div>
</body>
</html>