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

	function checkCookie() {
		$.ajax({
           url : '/readCookie',             
           type : 'GET',                                        
           dataType : 'json',                                 
           success : function (data) {                       
		  	console.log(data);

		  	if (data.msg == 'fail') {
		  		$('#myModal').show();
			}
          }
     	});
	}

	function getTop5Board() {
		$.ajax({
           url : '/get5Boards',             
           type : 'GET',                                        
           dataType : 'json',                                 
           success : function (data) {                       
		  	console.log(data);
			outputPopBoards(data);
          }
     	});
	}

	function outputPopBoards(data) {
		let output = '<table class="table table-hover popBoards">';
		
		$.each(data, function(i, e){
			output += "<tr>";
			output += "<td><a href='/hboard/viewBoard?boardNo=" + e.boardNo + "'>";
			output += `\${e.title}</a></td>`;
			let postDate = new Date(e.postDate).toLocaleDateString();
			output += `<td>\${postDate}</td>`;
			output += '</tr>';
		});

		output += '</table>';

		$('.top5Board').html(output);
	}

	$(function() { // 웹 문서가 로딩되면..

		checkCookie(); // 쿠키를 읽어봐서 쿠키가 없다면 모달창을 띄운다.

		getTop5Board();
	
		// 클래스가 modalCloseBtn인 태그를 클릭하면 실행되는 함수
	      $('.modalCloseBtn').click(function(){
             // 유저가 체크박스에 체크를 했는지 검사
			 if($('#ch_agree').is(':checked')) {
				// 쿠키 저장
				$.ajax({
         			url : '/saveCookie',             
         			type : 'GET',                                        
         			dataType : 'text',                                 
         			success : function (data) {                       
						console.log(data);
         			}
     			 });
                
			 } else {
				alert('쿠키 저장X');
			 }

	         $("#myModal").hide(); // 태그를 화면에서 감춤
	      });
	}); 
</script>
<style>
	.modalFooter{
		padding : 1rem;
		display : flex;
		justify-content : space-between;
		justify-items : center;
	}

	.popBoards a{
		text-decoration: none;
	}

	.popBoards a:any-link{
        color : black;
    }
</style>
</head>
<body>
	<div class="container">
		<jsp:include page="./header.jsp"></jsp:include>

		<div class="content">
			<h1>index.jsp</h1>

			<div class = "top5Board"></div>
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
					<div class="modal-body">
						<div>빠른 시일 안에 개편을 완료하도록 하겠습니다~~얄루</div>
					</div>
					<!-- Modal footer -->
					<div class="modalFooter">
						<span><input class="form-check-input" type="checkbox" id="ch_agree" />하루동안 열지 않기</span>
						<button type="button" class="btn btn-danger modalCloseBtn"
							data-bs-dismiss="modal">Close</button>
					</div>

				</div>
			</div>
		</div>

		<jsp:include page="./footer.jsp"></jsp:include>
	</div>
</body>
</html>
