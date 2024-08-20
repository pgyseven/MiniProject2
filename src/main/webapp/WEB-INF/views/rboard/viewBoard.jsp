<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
<meta charset="UTF-8">
<title>상세보기</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script>

   let pageNo = 1;
   
   $(function() {
      //모달창 닫기 버튼을 클릭하면...
      getAllReplies(pageNo);
      
      $('.modalCloseBtn').click(function() {
         $('#myModal').hide();
      });     
   });
   
   
   // 댓글을 저장하는 함수
   function saveReply() {
	   let boardNo = $('#boardNo').val();
	   let content = $('#replyContent').val();
	   let replyer = 'jisoo';
	   
	   const newReply = {// 자바스크립트에서 객체를 {}로 표현한다. newReply 객체에 boardNo, content를 담은 것이다.
			   'boardNo' : boardNo,
			   'content' : content,
			   'replyer' : replyer
	   } ;
	   
	   console.log(JSON.stringify(newReply)); // JSON.stringify() : 객체를 json 문자열로만 표현한다.(객체를 문자열로 바꾼 것이다.)
	   
	   if (content.length < 1) {
		   alert('내용이 입력되지 않았습니다.');
		   return;
	   } else {
		   $.ajax({
		         url : '/reply/' + boardNo,
		         type : 'post',
		         data : JSON.stringify(newReply), // 보낼 데이터
		         headers : {
		        	 "Content-Type" : "application/json"
		         }, // 보낼 데이터가 겉보기에는 문자열이지만 json이라고 백엔드단에 알려주는 것
		         dataType : 'json', // 수신받을 데이터 타입
		         async : false,
		         success : function(data) {
		            console.log(data);	
		            if (data.resultCode == 200 || data.resultMessage == "SUCCESS"){ // 댓글 저장에 성공했으면 getAllReplies() 호출해서 댓글을 가져와서 다시 출력해줘야 한다.
		            	$('#replyContent').val(''); // 댓글이 저장되면 댓글 입력창을 비워준다.
		                outputReplies(1); // 최신댓글은 1페이지에 나오니까 1페이지를 불러와서 다시 출력해준다.
		             }
		         },
		         error : function(data) {
		            console.log(data);
		            alert("댓글을 저장하지 못했습니다");
		         }
		      });
	   }
   }

   function showRemoveModal() {
      let boardNo = $('#boardNo').val();
      $('.modal-body').html(boardNo + '글을 삭제 할까요?')
      $('#myModal').show(500); /* 밀리세컨드 단위고 0.5초 속도로 천천히 보여줌 */
   }
   
   function getAllReplies(pageNo) {
      $.ajax({
         url : '/reply/all/${param.boardNo}/' + pageNo,
         type : 'get',
         dataType : 'json',
         async : false,
         success : function(data) {
            console.log(data);
            if (data.resultCode == 200 || data.resultMessage == "SUCCESS"){
               outputReplies(data);
            }
            
         },
         error : function(data) {
            console.log(data);
            alert("댓글을 불러오지 못했습니다")
         }
      });
   }
   
   function outputReplies(replies) {
      let output = `<div class="list-group">`;
      
      if(replies.data.replyList.length == 0) {
         output += `<div class="empty">`;
         output += `<img src ='/resources/images/empty.png'>`;
         output += `<div>댓글이 없습니다.</div>`;
         output += `</div>`;
         
      }else {
         $.each(replies.data.replyList, function(i, reply) {
                output += `<a href="#" class="list-group-item list-group-item-action reply">`;      
                output += `<div class='replyBody'>`;
                
                output += `<div class='replyerProfile'>`;
                output += `<img src='/resources/userImg/\${reply.userImg}'/>`;
                output += `</div>`;
                
                output += `<div class='replyBodyArea'>`;
                output += `<div class='replyContent'>\${reply.content}</div>`;
                
                output += `<div class='replyInfo'>`;
                let betweenTime = processPostDate(reply.regDate);
                output += `<div class='regDate'>\${betweenTime}</div>`;
                
                output += `<div class='replyer' onmouseover='showReplyInfo(this);' onmouseout='hideReplyInfo(this);'>`;
                output += `\${reply.replyer}</div>`;
                output += `<div class='replyerInfo'>\${reply.userName}(\${reply.email})</div>`;
                
                output += `</div>`;
                
                output += `</div>`;
                output += `</div>`;
                output += `</a>`;
             });
         outputPagination(replies);
      }
      
     
      output += ``;
        
      output += `</div>`;
      
      $(".replyList").html(output);
      
   }
   
   // 댓글 페이징
   function outputPagination(replies) {
         let output = `<ul class="pagination justify-content-center" style="margin:20px 0">`;
         
         let pagingInfo = replies.data.pagingInfo;
         if(pageNo > 1){
            output += `<li class="page-item"><a class="page-link" onclick="getAllReplies(--pageNo);">◀</a></li>`;
         }
         
         
         for (let i  = pagingInfo.startPageNoCurBlock ; i <= pagingInfo.endPageNoCurBlock ; i++) {
            
            if(pageNo == i) {
               output += `<li class="page-item active"><a class="page-link" onclick="pageNo = \${i}; getAllReplies(\${i});">\${i}</a></li>`;
            } else {
               output += `<li class="page-item"><a class="page-link" onclick="pageNo = \${i}; getAllReplies(\${i});">\${i}</a></li>`;
            }
         }
         if (pageNo < pagingInfo.totalPageCnt){
            output += `<li class="page-item"><a class="page-link" onclick="getAllReplies(++pageNo);">▶</a></li>`;
         }
         
         output += `</ul>`;
         
         $('.replyPagination').html(output);

      }
   
   
   // 댓글 작성일시 : 방금 전, 몇분 전, 몇시간 전 의 형식으로 출력
   function processPostDate(writtenDate) {
      
      const postDate = new Date(writtenDate); // 댓글 작성 시간
      // 객체는 주소값이 바뀌는 것이 아니라서 const로 선언해도 된다.
      
      const now = new Date(); // 현재 시간
      
      let diff = (now - postDate) / 1000; // 시간 차이를 초 단위로 구하기 위해서 1000으로 나눠준다.
      
      const times = [
       {name : "일", time : 60 * 60 * 24},
       {name : "시간", time : 60 * 60},
       {name : "분", time : 60}
      ];
      
      for(let val of times) {
         let betweenTime = Math.floor(diff / val.time); // {name : "일", time : 60 * 60 * 24} 의 time으로 나눠준다.
         console.log(writtenDate, diff, betweenTime);
         
         if(betweenTime > 0 && val.name != "일") {
            return betweenTime + val.name + "전";
         } else if(betweenTime > 0 && val.name == "일") {
            return postDate.toLocaleString();
         }
      }
      
      return "방금전";
   }
   
   function showReplyInfo(obj) {
      $(obj).next().show();
   }
   
   function hideReplyInfo(obj){
      $(obj).next().hide();
   }
</script>
<style type="text/css">
.replyList {
	margin-top: 15px;
	padding: 10px;
}

.replyBody {
	display: flex;
	justify-content: space-between;
	flex-direction: row;
	align-items: center;
	font-size: 0.9rem;
	color: rgba(0, 0, 0, 0.8);
}

.replyBodyArea {
	flex: 1;
	margin-left: 15px;
}

.replyerProfile img {
	width: 50px;
	border-radius: 25px;
	border: 1px solid lightgray;
}

.replyInfo {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	font-size: 0.6rem;
	color: rgba(0, 0, 0, 0.6);
}

.replyerInfo {
	display: none;
	color: white;
	background-color: #333;
	padding: 5px;
	width: 80;
	border-radius: 4px;
}

.replyInputArea {
	margin-top : 10px;
	padding : 10px;
	display : flex;
	flex-direction : row;
	align-items: center;
	border : 2px;
}

.replyInputArea input {
	flex : 1;
	width : 80%;
}

.replyInputArea img {
	margin-left : 5px;
	border : 2px solid rgba(0,0,255, 0.4);
	border-radius: 25px;
}
</style>
</head>
<body>

	<div class="container">
		<c:import url="../header.jsp"></c:import>

		<div class="content">
			<h1>게시글 상세 페이지</h1>




			<c:if test="${board.isDelete == 'Y'}">
				<c:redirect url="/hboard/listAll?status=wrongAccess" />
			</c:if>


			<div class="boardInfo">
				<div class="mb-3">
					<label for="boardNo" class="form-label">글 번호</label> <input
						type="text" class="form-control" id="boardNo"
						value="${board.boardNo}" readonly>
				</div>
				<div class="mb-3">
					<label for="title" class="form-label">글 제목</label> <input
						type="text" class="form-control" id="title" value="${board.title}"
						readonly>
				</div>
				<div class="mb-3">
					<label for="writer" class="form-label">작성자</label> <input
						type="text" class="form-control" id="writer"
						value="${board.writer}(${board.email})" readonly>
				</div>

				<div class="mb-3">
					<label for="writer" class="form-label">작성일</label> <input
						type="text" class="form-control" id="postDate"
						value="${board.postDate}" readonly>
				</div>

				<div class="mb-3">
					<label for="writer" class="form-label">조회수</label> <input
						type="text" class="form-control" id="readCount"
						value="${board.readCount}" readonly>
				</div>
				<!-- readonly는 수정 불가 -->


				<div class="mb-3">
					<label for="content" class="form-label">내용</label>
					<div class="form-control" id="content" rows="5" readonly>
						${board.content}</div>
				</div>
			</div>

			<!-- 댓글 섹션 추가 
         <div class="comments-section">
            <h3>댓글</h3>-->

			<!-- 댓글 목록 
            <c:forEach items="${comments}" var="comment">
               <div class="comment">
                  <p>
                     <strong>${comment.writer}</strong> - <span>${comment.commentDate}</span>
                  </p>
                  <p>${comment.content}</p>
               </div>
            </c:forEach>-->

			<%-- <div class="pagination justify-content-center"
               style="margin: 20px 0">
               <ul class="pagination">
                  <c:if test="${pagingInfo.pageNo > 1}">
                     <li class="page-item"><a class="page-link"
                        href="/rboard/listAll?pageNo=${pagingInfo.pageNo - 1}&pagingSize=${param.pagingSize}">◀</a>
                     </li>
                  </c:if>

                  <c:forEach begin="${pagingInfo.startPageNo}"
                     end="${pagingInfo.endPageNo}" var="i">
                     <li class="page-item ${pagingInfo.pageNo == i ? 'active' : ''}">
                        <a class="page-link"
                        href="/rboard/listAll?pageNo=${i}&pagingSize=${param.pagingSize}">${i}</a>
                     </li>
                  </c:forEach>

                  <c:if test="${pagingInfo.pageNo < pagingInfo.totalPageCnt}">
                     <li class="page-item"><a class="page-link"
                        href="/rboard/listAll?pageNo=${pagingInfo.pageNo + 1}&pagingSize=${param.pagingSize}">▶</a>
                     </li>
                  </c:if>
               </ul>
            </div> --%>

			<!-- 댓글 작성 폼 
            <form action="/rboard/addComment" method="post">
               <input type="hidden" name="boardNo" value="${board.boardNo}">
               <div class="form-group">
                  <label for="commentContent">새 댓글:</label>
                  <textarea class="form-control" id="commentContent" name="content"
                     rows="3" required></textarea>
               </div>
               <button type="submit" class="btn btn-primary">댓글 작성</button>
            </form>
         </div>-->

			<div calss="btns">
				<button type="button" class="btn btn-primary"
					onclick="location.href='/rboard/modifyBoard?boardNo=${board.boardNo}';">글수정</button>
				<button type="button" class="btn btn-info"
					onclick="location.href='/rboard/listAll';">리스트페이지로 돌아가기</button>
			</div>
		</div>

		<!-- form 태그가 아니라서 name속성이 필요가 없다. -->
		<div class="replyInputArea">
			
			<input type="text" class="form-control" id="replyContent" placeholder="댓글을 입력하세요."/>
			
			<img src="/resources/images/saveReply.png" onclick="saveReply();" />
			
		</div>

		<div class="replyList"></div>

		<div class="replyPagination"></div>

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
						<button type="button" class="btn btn-info"
							onclick="location.href='/hboard/removeBoard?boardNo=${param.boardNo}';">삭제</button>
						<button type="button" class="btn btn-danger modalCloseBtn"
							data-bs-dismiss="modal">취소</button>
					</div>

				</div>
			</div>
		</div>

		<c:import url="../footer.jsp"></c:import>
	</div>
</body>
</html>
