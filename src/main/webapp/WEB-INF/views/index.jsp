<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
<meta charset="UTF-8">
<title>INDEX</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	$(function() { // 웹 문서가 로딩되면..
		$('#myModal').show();
	
		// 클래스가 modalCloseBtn인 태그를 클릭하면 실행되는 함수
	      $('.modalCloseBtn').click(function(){
	         $("#myModal").hide(); // 태그를 화면에서 감춤
	      });
	}); 
</script>
</head>
<body>
	<div class="container">
		<c:import url="./header.jsp" />

		<div class="content">
			<h1>index.jsp</h1>
		</div>

		<!-- The Modal -->
		<div class="modal" id="myModal" style="display: none;">
			<div class="modal-dialog">
				<div class="modal-content">

					<!-- Modal Header -->
					<div class="modal-header">
						<h4 class="modal-title">MiniProject</h4>
						<button type="button" class="btn-close modalCloseBtn"
							data-bs-dismiss="modal"></button>
					</div>

					<!-- Modal body -->
					<div class="modal-body"></div>
						<div>사이트가 개편중입니다. 빠른 시일 안에 개편을 완료하도록 하겠습니다~~</div>
						<div>얄루</div>
					<!-- Modal footer -->
					<div class="modal-footer">
						<span><input class="form-check-input" type="checkbox" id="ch_agree" />하루동안 열지 않기</span>
						<button type="button" class="btn btn-danger modalCloseBtn"
							data-bs-dismiss="modal">Close</button>
					</div>

				</div>
			</div>
		</div>

		<c:import url="./footer.jsp" />
	</div>
</body>
</html>
