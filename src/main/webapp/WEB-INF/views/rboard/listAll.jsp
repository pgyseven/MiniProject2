<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>

   $(function(){

	  // 현재 페이지 번호를 가져와 해당 페이지번호 pagination li 태그에 active라는 클래스를 부여 
	  /* let pageNo = '${param.pageNo}';
	  if(pageNo == '') {
		  pageNo = 1;
	  } else {
		  pageNo = parseInt('${param.pageNo}');
	  }
	  
	  $(`#\${pageNo}`).addClass('active'); */
	   
	   
      showModalAccordingToStatus();

      timediifPostDate();  // 함수 호출
      
      let pagingSize = '${param.pagingSize}'
      if(pagingSize == '') {
   	  	pagingSize=10;
   	  } else {
   		pagingSize = parseInt(pagingSize);
   	  }
      $('#pagingSize').val(pagingSize);
      
      // 클래스가 modalCloseBtn인 태그를 클릭하면 실행되는 함수
      $('.modalCloseBtn').click(function(){
         $("#myModal").hide(); // 태그를 화면에서 감춤
      });
      
      
   // 유저가 페이징 사이즈를 선택하면
      $('.pagingSize').change(function(){
   	   console.log($(this).val());
   	   
   	   let pageNo = '${param.pageNo}';
   		  if(pageNo == '') {
   			  pageNo = 1;
   		  } else {
   			  pageNo = parseInt('${param.pageNo}');
   		  }
   	   
   	   location.href='/hboard/listAll?pagingSize=' + $(this).val() + '&pageNo=' + pageNo + '&searchType=${param.searchType}&searchWord=${param.searchWord}';
      });

   });  // 웹 문서가 로딩 완료되면 현재의 함수를 실행하도록 한다
   
   
   


   // 데이터 로딩 상태에 따라 모달창을 띄우는 함수
   function showModalAccordingToStatus() {
      let status = '${param.status}';  // url주소창에서 status쿼리스트링의 값을 가져와 변수에 저장
      console.log(status);

      if (status == 'success') {
         // 글 저장 성공 모달창을 띄움
         $('.modal-body').html('<h5>글 저장에 성공하였습니다</h5>');
         $('#myModal').show();

      } else if (status == 'fail') {
         // 글 저장 실패 모달창을 띄움
         $('.modal-body').html('<h5>글 저장에 실패하였습니다</h5>');
         $('#myModal').show();
      } 

      // 게시글을 불러올때 예외가 발생했거나 데이터가 없을때
      let except = '${exception}';
      if (except == 'error') {
         $('.modal-body').html('<h5>게시글이 없거나, 문제가 발생해 데이터를 불러오지 못했습니다.</h5>');
         $('#myModal').show();
      }
   }

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
   
   // 검색 버튼을 눌렀을 때 searchType == -1 이거나, searchWord에 빈 문자열이라면 검색어가 제대로 입력되지 않았으므로
   // 백엔드 단으로 데이터를 넘기면 안된다.
   function isValid() {
	   let result = false;
	   	
	   if($('#searchType').val() == -1 || $('#searchWord').val() == '') {
		   alert('검색조건과 검색어를 지정해주세요');
		   $('#searchType').focus();
		   return result;
	   } else {
		   result = true;
	   }
	   
	   return result;
   }

</script>
</head>
<body>
	<div class="container">
		<c:import url="./../header.jsp" />

		<div class="content">
			<h1>계층형 게시판 전체 리스트 페이지</h1>

			<div class="boardControl">
				<select class="form-select pagingSize" id="pagingSize">
					<option value="10">10개씩 보기</option>
					<option value="20">20개씩 보기</option>
					<option value="40">40개씩 보기</option>
					<option value="80">80개씩 보기</option>
				</select>
			</div>

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
								<th>isDelete</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="board" items="${boardList}">
								<c:choose>
									<c:when test="${board.isDelete == 'N'}">
										<tr
											onclick="location.href='/rboard/viewBoard?boardNo=${board.boardNo}';">
											<td>${board.boardNo }</td>
											<td><c:forEach var="i" begin="1" end="${board.step}">
													<img src="/resources/images/reply.png" />
												</c:forEach> ${board.title }</td>
											<td>${board.writer }</td>
											<td class="postDate">${board.postDate }</td>
											<td>${board.readCount }</td>
											<td>${board.isDelete }</td>
										</tr>
									</c:when>

								</c:choose>

							</c:forEach>
						</tbody>
					</table>
				</c:when>
			</c:choose>



		</div>

		<div style="float : right; margin-right:5px;">
			<button type="button" class="btn btn-secondary"
				onclick = "location.href='/rboard/showSaveBoardForm';">글 쓰기</button>
		</div>

		<form class="searchBar" style="clear:right; display:flex; flex-direction: row; align-items:center; justify-content:center;"
			action="/rboard/listAll" method="post">
			
				<div class="input-group mt-3 mb-3" style="width:40%;">
					<select class="form-select" name="searchType" id="searchType">
						<option value="-1">--검색조건--</option>
						<option value="title">제목</option>
						<option value="writer">작성자</option>
						<option value="content">내용</option>
					</select>
					<input type="text" class="form-control" name="searchWord" id="searchWord" placeholder="검색어를 입력하세요">
					<input type="hidden" name="pageNo" value="${param.pageNo}" />
					<input type="hidden" name="pagingSize" value="${param.pagingSize}" />
				</div>
			<div>
				<button type="submit" class="btn btn-primary" onclick="return isValid();">검색</button>
 		    </div>

		</form>

		<div class="pagination justify-content-center" style="margin: 20px 0">
			<ul class="pagination">
				<c:if test="${param.pageNo > 1}">
					<li class="page-item"><a class="page-link"
						href="/hboard/listAll?pageNo=${param.pageNo - 1}&pagingSize=${param.pagingSize}&searchType=${search.searchType}&searchWord=${search.searchWord}">◀</a></li>

				</c:if>

				<c:forEach var="i" begin="${PagingInfo.startPageNoCurBlock}"
					end="${PagingInfo.endPageNoCurBlock}">
					<c:choose>
						<c:when test="${param.pageNo == i}">
							<li class="page-item active" id="${i}"><a class="page-link"
								href="/hboard/listAll?pageNo=${i}&pagingSize=${param.pagingSize}&searchType=${search.searchType}&searchWord=${search.searchWord}">${i}</a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item" id="${i}"><a class="page-link"
								href="/hboard/listAll?pageNo=${i}&pagingSize=${param.pagingSize}&searchType=${search.searchType}&searchWord=${search.searchWord}">${i}</a></li>
						</c:otherwise>
					</c:choose>

				</c:forEach>

				<c:if test="${param.pageNo < PagingInfo.totalPageCnt}">
					<li class="page-item"><a class="page-link"
						href="/hboard/listAll?pageNo=${param.pageNo + 1}&pagingSize=${param.pagingSize}&searchType=${search.searchType}&searchWord=${search.searchWord}">▶</a></li>
				</c:if>
			</ul>
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

					<!-- Modal footer -->
					<div class="modal-footer">
						<button type="button" class="btn btn-danger modalCloseBtn"
							data-bs-dismiss="modal">Close</button>
					</div>

				</div>
			</div>
		</div>

		<c:import url="./../footer.jsp" />
	</div>
</body>
</html>