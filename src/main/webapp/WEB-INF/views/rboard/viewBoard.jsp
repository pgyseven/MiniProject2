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
      getAllReplies();
      
      $('.modalCloseBtn').click(function() {
         $('#myModal').hide();
      });
      
      
   });

   function showRemoveModal() {
      let boardNo = $('#boardNo').val();
      $('.modal-body').html(boardNo + '글을 삭제 할까요?')
      $('#myModal').show(500); /* 밀리세컨드 단위고 0.5초 속도로 천천히 보여줌 */
   }
   
   function getAllReplies() {
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
      
      $.each(replies.data.replyList, function(i, reply) {
         output += `<a href="#" class="list-group-item list-group-item-action reply">`;      
         output += `<div class='replyBody'>`;
         
         output += `<div class='replyerProfile'>`;
         output += `<img src='/resources/userImg/\${reply.userImg}'/>`;
         output += `</div>`;
         
         output += `<div class='replyBodyArea'>`;
         output += `<div class='replyContent'>\${reply.content}</div>`;
         output += `<div class='replyInfo'>`;
         output += `<div class='regDate'>\${reply.regDate}</div>`;
         output += `<div class='replyer'>\${reply.replyer}</div>`;
         output += `</div>`;
         
         output += `</div>`;
         output += `</div>`;
         output += `</a>`;
      });
      output += ``;
        
      output += `</div>`;
      
      $(".replyList").html(output);
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
      color : rgba(0,0,0,0.6); /* 60% 불투명하게 색이 나온다. */   
   }
   
   .replyBodyArea {
      flex : 1;
      margin-left: 20px;
   }
   
   .replyerProfile img {
      width: 50px;
      border-radius: 25px;
      border : 1px solid lightgray;
      
   }
   
   .replyInfo {
   	display : flex;
   	flex-direction : row;
   	justify-content: space-between;
   	font-size: 0.7rem;
   	color : rgba(0,0,0,0.4);
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

         <!-- 댓글 섹션 추가 -->
         <div class="comments-section">
            <h3>댓글</h3>

            <!-- 댓글 목록 -->
            <c:forEach items="${comments}" var="comment">
               <div class="comment">
                  <p>
                     <strong>${comment.writer}</strong> - <span>${comment.commentDate}</span>
                  </p>
                  <p>${comment.content}</p>
               </div>
            </c:forEach>

            <div class="pagination justify-content-center"
               style="margin: 20px 0">
               <ul class="pagination">
                  <c:if test="${pagingInfo.pageNo > 1}">
                     <li class="page-item"><a class="page-link"
                        href="/rboard/listAll?pageNo=${pagingInfo.pageNo - 1}&pagingSize=${param.pagingSize}&searchType=${search.searchType}&searchWord=${search.searchWord}">◀</a>
                     </li>
                  </c:if>

                  <c:forEach begin="${pagingInfo.startPageNo}"
                     end="${pagingInfo.endPageNo}" var="i">
                     <li class="page-item ${pagingInfo.pageNo == i ? 'active' : ''}">
                        <a class="page-link"
                        href="/rboard/listAll?pageNo=${i}&pagingSize=${param.pagingSize}&searchType=${search.searchType}&searchWord=${search.searchWord}">${i}</a>
                     </li>
                  </c:forEach>

                  <c:if test="${pagingInfo.pageNo < pagingInfo.totalPageCnt}">
                     <li class="page-item"><a class="page-link"
                        href="/rboard/listAll?pageNo=${pagingInfo.pageNo + 1}&pagingSize=${param.pagingSize}&searchType=${search.searchType}&searchWord=${search.searchWord}">▶</a>
                     </li>
                  </c:if>
               </ul>
            </div>

            <!-- 댓글 작성 폼 -->
            <form action="/rboard/addComment" method="post">
               <input type="hidden" name="boardNo" value="${board.boardNo}">
               <div class="form-group">
                  <label for="commentContent">새 댓글:</label>
                  <textarea class="form-control" id="commentContent" name="content"
                     rows="3" required></textarea>
               </div>
               <button type="submit" class="btn btn-primary">댓글 작성</button>
            </form>
         </div>

         <div calss="btns">
            <button type="button" class="btn btn-primary"
               onclick="location.href='/rboard/modifyBoard?boardNo=${board.boardNo}';">
               글수정</button>
            <button type="button" class="btn btn-info"
               onclick="location.href='/rboard/listAll';">리스트페이지로 돌아가기</button>
         </div>
      </div>
      
      <div class="replyList">
         
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
