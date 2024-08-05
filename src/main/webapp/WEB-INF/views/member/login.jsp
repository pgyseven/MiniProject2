<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
	<div class="container">
		<c:import url="../header.jsp" />

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
						class="form-check-input" type="checkbox" name="remember">
						Remember me
					</label>
				</div>
				<button type="submit" class="btn btn-primary">로그인</button>
			</form>
		</div>



		<c:import url="../footer.jsp" />
	</div>
</body>
</html>