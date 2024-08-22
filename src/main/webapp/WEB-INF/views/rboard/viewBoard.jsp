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




   let pageNo = 1;
   let isModifyReplyArea = false;

   $(function() { // 웹 문서가 로딩되면..
      
      getAllReplies(pageNo);
      
      // 모달창 닫기 버튼을 클릭하면...
      $('.modalCloseBtn').click(function() {
         $('#myModal').hide();
      });
      
      
      getPreInputReplyContent() 
      
      
   
      
      
   }); 
   
   function getPreInputReplyContent() {
		// 로컬(세션) 스토리지에 이전에 저장했던 댓글 내용이 있다면 댓글 내용 입력창에 붙여넣기 한다.
	 	let replyContent = localStorage.getItem("replyContent");
	 	if(replyContent != null || replyContent != '') {
	 		 $('#replyContent').val(replyContent);
	 		 
	 		// 로컬(세션) 스토리지에 저장했던 댓글을 삭제한다.
	 		localStorage.removeItem('replyContent');
	 	 }
   }
   
   // 댓글 저장, 수정, 삭제 시 로그인 인증
   function preAuth() {
      let replyer = '${sessionScope.loginMember.userId}';
      if (replyer == '') {
         // 로그인 안했다... -> 로그인 페이지로 이동 (LoginInterceptor가 작동)
         // 로컬(세션) 스토리지에 댓글 내용이 있다면 저장한다.
         
         let replyContent = $('#replyContent').val();
         if(replyContent != '') {
        	 localStorage.setItem("replyContent", replyContent);
         }
         
         
         location.href='/member/login?redirectUrl=viewBoard&boardNo=${param.boardNo}';  
      } else {
    	  return replyer;   	
    	 }    	           
      }
   
   // 댓글을 저장하는 함수
   function saveReply() {
      let boardNo = $('#boardNo').val();
      let content = $('#replyContent').val();
      let replyer = preAuth();
      const newReply = {
         'boardNo' : boardNo,
         'content' : content,
         'replyer' : replyer
      };
      
      console.log(JSON.stringify(newReply));
   
      
      if (content.length < 1) {
         alert('댓글 내용을 입력 하세요...!');
         return;
      } else if (content.length >= 1 && replyer != null){
         $.ajax({
               url : '/reply/' + boardNo,  
               type : 'post', 
               data : JSON.stringify(newReply),  // 송신할 데이터
               headers : {
                  "Content-Type" : "application/json"
               },  // 송신할 데이터가 json임을 백엔드에게 알려줌
               dataType : 'json', // 수신받을 데이터 타입
               async : false,      
               success : function (data) { 
                  console.log(data);
                  if (data.resultCode == 200 || data.resultMessage == "SUCCESS") {
                     $('#replyContent').val(''); // 댓글 입력창 비우기
                     isModifyReplyArea = false;
                     getAllReplies(1);  // 1페이지(최신 댓글)을 불러와 다시 출력
                  }   
                  
               }, error : function (data) {
                 console.log(data);
                 alert("댓글을 저장하지 못했습니다");
               }
            });
      }
      
      
      
   }
   
   

   function showRemoveModal() {
      let boardNo = $('#boardNo').val();
      $('.modal-body').html('징짜~ ' + boardNo + '번 글을 삭제 할까요?');
      $('#myModal').show(500);
   }
   
   function getAllReplies(pageNo) {
      $.ajax({
            url : '/reply/all/${param.boardNo}/' + pageNo,  
            type : 'get', 
            dataType : 'json',          
            async : false,      
            success : function (data) { 
               console.log(data);
               if (data.resultCode == 200 || data.resultMessage == "SUCCESS") {
                  outputReplies(data);   
               }   
            }, error : function (data) {
              console.log(data);
              alert("댓글을 불러오지 못했습니다");
            }
         });
      
   }
   
   function outputReplies(replies) {
      let output = `<div class="list-group">`;
      
      if (replies.data.replyList.length == 0) {
         output += `<div class="empty">`;
         output += `<img src='/resources/images/empty.png' />`;
         output += `<div>텅~(댓글이 비었습니다. 첫번째 댓글을 달아 작성자를 외롭지 않게 해주세요!)</div>`;
         output += `</div>`;
      } else {
         $.each(replies.data.replyList, function(i, reply) {
            output += `<div id="reply_\${reply.replyNo}" class="list-group-item list-group-item-action reply">`;
            output += `<div class='replyBody'>`;
            
            output += `<div class='replyerProfile'>`;
            output += `<img src='/resources/userImg/\${reply.userImg}' />`;
            output += `</div>`;
            
            output += `<div class='replyBodyArea'>`;
            
            output += `<div class='replyHeader'><div class='replyContent'>\${reply.content}</div>`;            

            
            if(reply.replyer != '${sessionScope.loginMember.userId}') { // 작성자와 유저가 같지 않을 때
              	// $('.replyBtns').empty(); // 태그 안의 자식태그를 비워줘서 빈 태그로 두는 것. hide()는 태그는 살아있고 화면에서만 보이지 않는다는 차이점이 있다.
              	output += `<div class='replyBtns'></div></div>`;
              	
            } else if(reply.replyer == '${sessionScope.loginMember.userId}') { // 작성자와 유저가 같을 때
            	output += `<div class='replyBtns'><img src="/resources/images/modifyReply.png" width="23px" onclick='modifyReply(\${reply.replyNo});'>`;
                output += `<img src="/resources/images/remove.png" width="20px" onclick='removeReply(\${reply.replyNo})'></div></div>`;
            }

            output += `<div class='replyInfo'>`;
            
            
            let betweenTime = processPostDate(reply.regDate);
            output += `<div class='regData'>\${betweenTime}</div>`;
            
            output += `<div class='replyer' onmouseover='showReplyInfo(this);' onmouseout='hideReplyInfo(this);'>`;
            output += `\${reply.replyer}</div>`;
            
            output += `<div class='replyerInfo'>\${reply.userName}(\${reply.email})</div>`; // 출력을 해야할 때만 \${}로 표현한다. 출력하지 않는다면 그렇게 표현하지 않는다.
            output += `</div>`;
            output += `</div>`;
            
            output += `</div>`;
            output += `</div>`;
         });
         
         ouptutPagination(replies);
      }
      
      output += `</div>`;
      
      $(".replyList").html(output);
      
      
   }
   
   function modifyReply(replyNo) {
	   let output = `<div class='modifyReplyArea'><input type="text" class="form-control" id="modiryReplyContent"/>`;
	   output += `<img src="/resources/images/saveReply.png" onclick="modifyReplySave(\${replyNo});" /></div>`;
	   
	   if(!isModifyReplyArea) {
		   $(output).insertBefore($(`#reply_\${replyNo}`).find('.replyInfo'));
		   $(`#reply_\${replyNo}`).find('input').focus();
	   }

	   isModifyReplyArea = true;
	    
   }
   
   function modifyReplySave(replyNo) {
       let content = $('#modiryReplyContent').val();
       let replyer = '${sessionScope.loginMember.userId}';
       console.log(replyNo);
       
       if (content == '') {
          alert('수정 될 댓글 내용을 입력하세요..');
       } else {
         const modifyReply = {
                 "replyNo" : replyNo,
                 "content" : content,
                 "replyer" : replyer
           };
         
        $.ajax({
             url : '/reply/' + replyNo,  
             type : 'put', 
             data : JSON.stringify(modifyReply),
             headers : {
                // 송신할 데이터가 Json 임을 백엔드에게 알려주는것
                "Content-Type" : "application/json",
                // PUT, DELETE, PATCH 등의 REST에서 사용되는 HTTP method가 동작하지 않는 과거의 웹 브라우저가
                // POST 방식으로 동작하도록 한다..
                "X-HTTP-Method_Override" : "POST"
             },
             dataType : 'json',          
             async : false,      
             success : function (data) { 
                console.log(data);
                
                if (data.resultCode == 200 || data.resultMessage == "SUCCESS") {
                   getAllReplies(1);  // 최신댓글 불러옴
                   
                }
             }, error : function (data) {
               console.log(data);
               alert("댓글을 수정하지 못했습니다");
             }
          });
       }
       
      
   }v
   
   function removeReply(replyNo) {
	   alert(replyNo + '번 댓글을 삭제하시겠습니까?');
	   alert  YES 면 삭제 진행 쿼리문 del
	   /* 
	   
	   부모글 삭제의 경우 댓글은 남겨두고 글작성자가 글을 삭제하는경우 댓글 남겨두고 해당글은 삭제되었습니다 뜨게 하기 
	   추가 숙제 
	   좋아요 : 다대 다 관계
	   좋아요는 테이블 하나 추가 생성
	   좋아요



	   1) 게시글 (N) - 게시글을 좋아요할 수 있는 Member(M) 이므로, 좋아요처리 하기 위한 테이블을 하나 더 만든다..

	   1-1) heedong이라는 유저가 23번글을 조회할때 (select 좋아요테이블)

	   1-2) 처음엔 heedong이라는 유저가 23번글을 좋아하지 않는다고 가정한다면..
	   heedong이라는 유저가 23번게시글을 볼때 ♡ 출력

	   2) heedong이라는 유저가 23번글을 좋아요 버튼   -> insert      (언제, 누가, 몇번글을 좋아한다)
	    -> 23번글에 좋아요 표시♥️

	   3) heedong이라는 유저가 다시 23번글을 볼때는.... 테이블을 조회하여 좋아요 조회기록이 있다면..♥️ 
	   	없다면... ♡


	   4-1) heedong이라는 유저가 23번글을 좋아한다는 기록이 있다(♥️) -> 이 버튼을 또다시 누르면 heedong이가 23번글 좋아요 
	   취소(delete)



	   5) 23번글에 대해서 좋아요한사람들을 다 조회
	   
	   마이페이지
	   
	   관리자 페이지 맴버에 컬럼 하나 더 맹글어서 로그인하고 관리자인지 아닌지 검사
	   
	   */
   }
   
   // 댓글의 페이징 작업 
   function ouptutPagination(replies) {
      let output = `<ul class="pagination justify-content-center" style="margin:20px 0">`;
      let pagingInfo = replies.data.pagingInfo;
      
      if (pageNo > 1) {
         output += `<li class="page-item"><a class="page-link" onclick="getAllReplies(--pageNo);">Previous</a></li>`;   
      }
      
      for (let i = pagingInfo.startPageNoCurBlock; i <= pagingInfo.endPageNoCurBlock; i++) {
         if (pageNo == i) {
            output += `<li class="page-item active"><a class="page-link" onclick="pageNo = \${i}; getAllReplies(\${i});">\${i}</a></li>`;   
         } else {
            output += `<li class="page-item"><a class="page-link" onclick="pageNo = \${i}; getAllReplies(\${i});">\${i}</a></li>`;   
         }   
      }
      
      if (pageNo < pagingInfo.totalPageCnt) {
         output += `<li class="page-item"><a class="page-link" onclick="getAllReplies(++pageNo);">Next</a></li>`;   
      }
      
        
      output += `</ul>`;
      
      $('.replyPagination').html(output);
      
   }
   
   
   // 댓글 작성일시 방금전, 몇분전, 몇시간전 ... 의 형식으로 출력
   function processPostDate(writtenDate) {
      const postDate = new Date(writtenDate);  // 댓글 작성시간
      const now = new Date();  // 현재 시간
      
      let diff = (now-postDate) / 1000; // 시간 차 (초단위)
      
      const times = [
         {name : "일", time : 60 * 60 * 24},
         {name : "시간", time : 60 * 60},
         {name : "분", time : 60}
      ];
      
      for (let val of times) {
         let betweenTime = Math.floor(diff / val.time);
         console.log(writtenDate, diff, betweenTime);
         
         if (betweenTime > 0 && val.name != "일") {  // 하루보다 크지 않다면..
            return betweenTime + val.name + "전";
         } else if (betweenTime > 0 && val.name == "일") { // 하루보다 큰 값이라면 그냥 작성일 출력
            return postDate.toLocaleString();
         }
      }
      
      return "방금전"; 
   }
   
   function showReplyInfo(obj) {
      $(obj).next().show();
   }
   
   function hideReplyInfo(obj) {
       $(obj).next().hide();
   }
</script>
<style>
.content {
	margin-top: 10px;
	margin-bottom: 10px;
	padding: 10px;
	border: 1px solid #dee2e6;
	border-radius: 0.375rem;
}

.replyList {
	margin-top: 15px;
	padding: 10px;
}

.replyBody {
	display: flex;
	justify-content: space-between;
	flex-direction: row;
	align-items: center;
	font-size: 0.8rem;
	color: rgba(0, 0, 0, 0.8);
}

.replyerProfile img {
	width: 50px;
	border-radius: 25px;
	border: 1px solid lightgray;
}

.replyBodyArea {
	flex: 1;
	margin-left: 20px;
}

.replyInfo {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	font-size: 0.6rem;
	color: rgba(0, 0, 0, 0.4);
}

.replyerInfo {
	display: none;
	color: white;
	background-color: #333;
	padding: 5px;
	width: 40;
	border-radius: 4px;
}

.replyInputArea {
	margin-top: 10px;
	padding: 10px;
	display: flex;
	flex-direction: row;
	align-items: center;
	border: 1px solid #dee2e6;
	border-radius: 0.375rem;
}

.replyInputArea input {
	flex: 1;
	width: 80%;
}

.replyInputArea img {
	margin-left: 5px;
}

.replyHeader {
	display : flex;
	flex-direction: row;
	justify-content: space-between;
}

.replyContent {
	flex : 1;
}

.modifyReplyArea {
	margin : 10px 5px;
	height : 30px;
	display : flex;
	flex-direction: row;
	justify-content: space-between;
}

.modifyReplyArea input {
	flex : 1;
}
</style>

</head>
<body>

	<div class="container">
		<c:import url="../header.jsp" />

		<div class="content">
			<h1>게시글 상세 페이지</h1>

			<c:if test="${board.isDelete == 'Y' }">
				<c:redirect url="/hboard/listAll?status=wrongAccess" />
			</c:if>

			<div class="boardInfo">
				<div class="mb-3">
					<label for="title" class="form-label">글 번호</label> <input
						type="text" class="form-control" id="boardNo"
						value="${board.boardNo}" readonly>
				</div>

				<div class="mb-3">
					<label for="title" class="form-label">글제목</label> <input
						type="text" class="form-control" id="title"
						value="${board.title }" readonly>
				</div>

				<div class="mb-3">
					<label for="writer" class="form-label">작성자</label> <input
						type="text" class="form-control" id="writer"
						value="${board.writer }(${board.email})" readonly>
				</div>

				<div class="mb-3">
					<label for="writer" class="form-label">작성일</label> <input
						type="text" class="form-control" id="postDate"
						value="${board.postDate }" readonly>
				</div>

				<div class="mb-3">
					<label for="writer" class="form-label">조회수</label> <input
						type="text" class="form-control" id="readCount"
						value="${board.readCount }" readonly>
				</div>

				<div class="mb-3">
					<label for="content" class="form-label">내용</label>
					<div class='content'>${board.content }</div>
				</div>
			</div>

			<div class="btns">
				<button type="button" class="btn btn-primary"
					onclick="location.href='/rboard/modifyBoard?boardNo=${board.boardNo}';">글
					수정</button>

				<button type="button" class="btn btn-secondary"
					onclick="location.href='/rboard/listAll';">리스트페이지로</button>
			</div>


			<div class="replyInputArea">
				<input type="text" class="form-control" id="replyContent"
					placeholder="댓글을 입력하세요." /> <img
					src="/resources/images/saveReply.png" onclick="saveReply();" />

			</div>


			<div class="replyList"></div>
			<div class="replyPagination"></div>

		</div>

		<!-- The Modal 
		<div class="modal" id="myModal" style="display: none;">
			<div class="modal-dialog">
				<div class="modal-content">-->

					<!-- Modal Header
					<div class="modal-header">
						<h4 class="modal-title">MiniProject</h4>
						<button type="button" class="btn-close modalCloseBtn"
							data-bs-dismiss="modal"></button>
					</div> -->

					<!-- Modal body
					<div class="modal-body"></div> -->

					<!-- Modal footer
					<div class="modal-footer">
						<button type="button" class="btn btn-info"
							onclick="location.href='/hboard/removeBoard?boardNo=${param.boardNo}';">삭제</button>
						<button type="button" class="btn btn-danger modalCloseBtn"
							data-bs-dismiss="modal">취소</button>
					</div> -->

				<!-- </div>
			</div>
		</div> -->


		<c:import url="../footer.jsp" />
	</div>
</body>
</html>