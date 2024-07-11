<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>

	$(function(){
		
		timediifPostDate();  // 함수 호출
		
		// 클래스가 modalCloseBtn인 태그를 클릭하면 실행되는 함수
		$('.modalCloseBtn').click(function(){
			$("#myModal").hide(); // 태그를 화면에서 감춤
		});

	});  // 웹 문서가 로딩 완료되면 현재의 함수를 실행하도록 한다


	// 게시글의 글작성일을 얻어와 2시간 이내에 작성한 글이라면 new.png 이미지를 제목 앞에 붙여 출력한다.
	function timediifPostDate() {
		$(".postDate").each(function(i, e) {
			// console.log(i + '번째 태그 : ' + $(e).html());
			let postDate = new Date($(e).html());  // 글 작성일 저장 (Date객체로 변환후)
			let curDate = new Date();  // 현재 날짜 현재 시간 객체 생성

			console.log(postDate, curDate);
			// 아래의 시간차이는 timestamp(1970년 1월1일0시0분0초 부터 지금까지 흘러온 시간을 정수로 표현한값)
			// 단위는 ms이므로 시간 차이로 바꾸면
			let diff = (curDate - postDate) / 1000 / 60 / 60; // 시간 차이

			console.log(diff);
			
			let title = $(e).prev().prev().html();
			console.log(title);
			if (diff < 2) {  // 2시간 이내에 작성한 글 이라면...
				// 글 제목 앞에 new이미지 태그를 넣어 출력
				let output = "<span><img src='/resources/images/new.png' width='20px' /></span>";
				$(e).prev().prev().html(output + title);
			}

		});
	}

</script>
</head>
<body>
	<div class="container">
		<c:import url="./../header.jsp" />

		<div class="content">
			<h1>계층형 게시판 전체 리스트 페이지</h1>
			<c:choose>
				<c:when test="${boardList != null }">
					<table class="table table-hover">
						<thead>
							<tr>
								<th>#</th>
								<th>title</th>
								<th>writer</th>
								<th>postDate</th>
								<th>readCount</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="board" items="${boardList }">
								<tr>
									<td>${board.boardNo }</td>
									<td>${board.title }</td>
									<td>${board.writer }</td>
									<td class="postDate">${board.postDate }</td>
									<td>${board.readCount }</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:when>
				<c:when test="${boardList == null and exception == 'error' }">

					<!-- The Modal -->
					<div class="modal" id="myModal" style="display: block;">
						<div class="modal-dialog">
							<div class="modal-content">

								<!-- Modal Header -->
								<div class="modal-header">
									<h4 class="modal-title">MiniProject</h4>
									<button type="button" class="btn-close modalCloseBtn" data-bs-dismiss="modal"></button>
								</div>

								<!-- Modal body -->
								<div class="modal-body">문제가 발생하여 데이터를 가져오지 못했습니다!</div>

								<!-- Modal footer -->
								<div class="modal-footer">
									<button type="button" class="btn btn-danger modalCloseBtn"
										data-bs-dismiss="modal">Close</button>
								</div>

							</div>
						</div>
					</div>
				</c:when>

			</c:choose>



		</div>

		<div>
			<button type="button" class="btn btn-primary"
				onclick="location.href='/hboard/saveBoard';">글 저장</button>
		</div>

		<c:import url="./../footer.jsp" />
	</div>
</body>
</html>