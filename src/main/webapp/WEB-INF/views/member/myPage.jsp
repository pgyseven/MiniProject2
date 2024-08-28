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
	$(function() {

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
		
		
		getRecieveUsers();
		
		
	}
	
	function getRecieveUsers() {
		
		$.ajax({
	         url : '/message/getFriends/' + '${sessionScope.loginMember.userId}',  
	         type : 'get', 
	         dataType : 'json', // 수신받을 데이터 타입
	         async : false,      
	         success : function (data) {
	            console.log(data);
	           makeReceiveUserList(data);
	            
	         }, error : function (data) {
	        	console.log(data);
	        	
	         }
	      });
		
	}
	
	function makeReceiveUserList(data) { // 동적 바인딩 
		let output = "";
		$.each(data.data, function(i, friend){
			output += `<option value = '\${friend.friendId}'>\${friend.friendName}</option>`
			
			
		});
	
		$('#receiveUser').html(output);
	
	}
	
</script>
<style>
/* ul.nav li {
	border: 1px solid #333;
} */
.msgInputArea {
	margin-top: 10px;
	padding: 10px;
	display: flex;
	flex-direction: row;
	align-items: center;
	border: 1px solid #dee2e6;
	border-radius: 0.375rem;
}

.msgInputArea input {
	flex: 1;
	width: 80%;
}

.msgInputArea img {
	margin-left: 5px;
	border: 2px solid rgba(0, 0, 255, 0.4);
	border-radius: 5px;
}
</style>
</head>
<body>
	<div class="container">
		<jsp:include page="../header.jsp"></jsp:include>

		<div class="content">
			<h1>회원 정보 페이지</h1>

			<ul class="nav nav-tabs">
				<li class="nav-item "><a href="#" class="nav-link"
					onclick="showBasicInfo();">회원 기본 정보</a>
					
					<div class="basicInfo">
					<h4>회원 기본 정보</h4>
					<div>${memberInfo}</div>
					</div>
					</li>
				<li class="nav-item "><a href="#" class="nav-link"
					onclick="showPointInfo();">포인트 내역</a>
					<div class="pointInfo">포인트 내역</div></li>
				<li class="nav-item "><a href="#" class="nav-link"
					onclick="showMyBoard();">내가 쓴 글</a>
					<div class="myBoard">내가 쓴 글</div></li>
				<li class="nav-item "><a href="#" class="nav-link"
					onclick="showMessage();">쪽지</a>
					<div class="message">
						<div class="msgInputArea">
							<select id="receiveUser">
								
							</select>
						
							<input type="text" class="form-control" id="msgContent"
								placeholder="메세지 내용 입력" /> <img
								src="/resources/images/saveReply.png" onclick="saveReply();" />

						</div>

					</div></li>
			</ul>
		</div>



		<jsp:include page="../footer.jsp"></jsp:include>
	</div>
</body>
</html>