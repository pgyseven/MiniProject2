<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	
<script>

$(function(){
	
	showBasicInfo();
	
});

	function showBasicInfo() {
		$('.basicInfo').show();
		$('.pointInfo').hide();
		$('.myBoard').hide();
		$('.message').hide();
	}
	
	function showPointInfo() {
		$('.basicInfo').hide();
		$('.pointInfo').show();
		$('.myBoard').hide();
		$('.message').hide();
	}

	
	function showMyBoard() {
		$('.basicInfo').hide();
		$('.pointInfo').hide();
		$('.myBoard').show();
		$('.message').hide();
	}
	
	function showMessage() {
		$('.basicInfo').hide();
		$('.pointInfo').hide();
		$('.myBoard').hide();
		$('.message').show();
	}

</script>
<style>
/* ul.nav li {
	border: 1px solid #333;
} */
</style>
</head>
<body>
	<div class="container">
		<jsp:include page="../header.jsp"></jsp:include>

		<div class="content">
			<h1>회원 정보 페이지</h1>

			<ul class="nav nav-tabs">
				<li class="nav-item " ><a href="#" class="nav-link" onclick="showBasicInfo();">회원 기본 정보</a>
					<div class="basicInfo">회원기본정보</div>
				</li>
				<li class="nav-item " ><a href="#" class="nav-link" onclick="showPointInfo();">포인트 내역</a>
					<div class="pointInfo">포인트 내역</div>
				</li>
				<li class="nav-item "><a href="#" class="nav-link" onclick="showMyBoard();">내가 쓴 글</a>
					<div class="myBoard">내가 쓴 글</div>
				</li>
				<li class="nav-item "><a href="#" class="nav-link" onclick="showMessage();">쪽지</a>
					<div class="message">쪽지</div>
				</li>
			</ul>
		</div>



		<jsp:include page="../footer.jsp"></jsp:include>
	</div>
</body>
</html>