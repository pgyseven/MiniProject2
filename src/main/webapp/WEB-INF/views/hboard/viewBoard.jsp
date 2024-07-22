<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="container">
		<c:import url="../header.jsp" />

		<div class="content">
			<h1>게시글 상세 페이지</h1>
			
			<div>${boardDetailInfo }</div>
		</div>

		<c:import url="../footer.jsp" />
	</div>
</body>
</html>