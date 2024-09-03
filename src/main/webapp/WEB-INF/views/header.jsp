<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<style>
.userArea {
	display: flex;
	align-items: center;
	color: rgba(255, 255, 255, 0.55);
}

.userProfile {
	width: 40px;
	border-radius: 20px;
	border: 2px solid #595959;
	padding: 4px;
}
</style>
</head>
<body>
	<nav class="navbar navbar-expand-sm navbar-dark bg-dark">
		<div class="container-fluid">
			<a class="navbar-brand" href="javascript:void(0)">MiniProject</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#mynavbar">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="mynavbar">
				<ul class="navbar-nav me-auto">
					<li class="nav-item"><a class="nav-link"
						href="/hboard/listAll">계층형게시판</a></li>
					<li class="nav-item"><a class="nav-link"
						href="/rboard/listAll">댓글형게시판</a></li>

					<li class="nav-item"><a class="nav-link" href="/chartEx1">chart
							연습</a></li>

		<div class="dropdown">
  <button type="button" class="btn btn-primary dropdown-toggle" data-bs-toggle="dropdown">
    지도연습
  </button>
  <ul class="dropdown-menu">
    <li><a class="dropdown-item" href="/mapEx1">연습 1</a></li>
    <li><a class="dropdown-item" href="#">연습 2</a></li>
  </ul>
</div>
		
		


					<li class="nav-item"><a class="nav-link"
						href="/member/register">회원가입</a></li>

					<c:choose>
						<c:when test="${sessionScope.loginMember != null}">
							<li class="nav-item userArea">
								<!-- <div class="dropdown" class="dropdown-toggle"
									data-bs-toggle="dropdown">  --> <a href="/member/myPage"> <img
									src="/resources/userImg/${sessionScope.loginMember.userImg}"
									class="userProfile" /> <span class="userName">
										${sessionScope.loginMember.userName} </span> <c:if
										test="${sessionScope.unReadMsgCnt != null}">
										<button type="button" class="btn btn-primary">
											Messages <span class="badge bg-danger">${sessionScope.unReadMsgCnt }</span>
										</button>
									</c:if>
							</a> <!-- <ul class="dropdown-menu">
										<li><a class="dropdown-item" href="#">Link 1</a></li>
										<li><a class="dropdown-item" href="#">Link 2</a></li>
										<li><a class="dropdown-item" href="#">Link 3</a></li>
									</ul>

								</div> --> <a class="nav-link" href="/member/logout"
								style="margin-left: 4px;">로그아웃</a>
							</li>
						</c:when>
						<c:otherwise>
							<li class="nav-item"><a class="nav-link"
								href="/member/login">로그인</a></li>
						</c:otherwise>
					</c:choose>


					<!--<li class="nav-item"><a class="nav-link"
						href="/weather">오늘의 날씨(연습)</a></li>
						
					<li class="nav-item"><a class="nav-link"
						href="/movie">영화 api(연습)</a></li>
						
					<li class="nav-item"><a class="nav-link"
						href="/news">뉴스 api(연습, xml)</a></li> -->
				</ul>
				<form class="d-flex">
					<input class="form-control me-2" type="text" placeholder="Search">
					<button class="btn btn-primary" type="button">Search</button>
				</form>
			</div>
		</div>
	</nav>
</body>
</html>