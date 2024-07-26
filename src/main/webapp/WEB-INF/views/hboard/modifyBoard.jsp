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
		
	
	let removeFilesArr = [];	
	function removeFile() {
		$('.fileCheck').each(function(i, item){
            if ($(item).is(':checked')) { // = 파일을 삭제하겠다고 체크가 되어있다면
                let tmp = $(item).attr('id'); // 선택된 파일의 id값을 얻어옴
				removeFilesArr.push(tmp); // id값을 removeFilesArr에 저장
            }
        });
		console.log("삭제될 파일 : " + removeFilesArr); // removeFilesArr에 저장된 id값을 console.log로 출력

		$.each(removeFilesArr, function(i, item) {
         $.ajax({
            url : '/hboard/modifyRemoveFileCheck',            
            type : 'post',            
            dataType : 'json',           
          data : {"removeFileNo" : item},                        
            async : false, 
            success : function (data) {     
               console.log(data);
             if(data.msg =='success') {
               $('#' + item).parent().parent().css('opacity', 0.2);
            }
            }, error : function (data){
            }
               
         });
         });
   }

   function cancelRemFiles() {
      $.ajax({
         url : '/hboard/cancelRemFiles',
         type : 'post',
         dataType : 'json',

         async : false,
         success : function(data) {
            console.log(data);
            if (data.msg == 'success') {
               $('.fileCheck').each(function(i, item) {
                  $(item).prop('checked', false);
                  $('#' + $(item).attr('id')).parent().parent().css('opacity',1);
               });
               
               $('.removeUpFileBtn').attr('disabled', true);
               $('.removeUpFileBtn').val("선택된 파일이 없습니다.");
            }
         }, error : function(data) {

         }
      });
   }

	function removeFileCheck(fileId) {
        let chkCount = isCheckBoxChecked();
        if (chkCount > 0) {
            $('.removeUpFileBtn').removeAttr('disabled');
            $('.removeUpFileBtn').val(chkCount + "개 파일을 삭제합니다");
        } else if (chkCount == 0) {
            $('.removeUpFileBtn').attr('disabled', true);
            console.log($('.removeUpFileBtn').val());
            $('.removeUpFileBtn').val("선택된 파일이 없습니다");
        }       
    }
    function isCheckBoxChecked() {
        let result = 0;
        $('.fileCheck').each(function(i, item){
            if ($(item).is(':checked')) {
                result++;
            }
        });
        console.log(result);
        return result;
    }

	function addRows(obj) {
		let rowCnt = $('.fileListTable tr').length;
		console.log('tr 갯수 : ' + rowCnt);
		let row = $(obj).parent().parent();
        let inputFileTag = `<tr><td colspan='2'><input class='form-control' type='file' id='newFile_\${rowCnt}' onchange='showPreview(this);' /></td>
							<td><input type="button" class="btn btn-info cancelRemove" value="cancel" onclick="cancelAddFile(this);"/></td></tr>`;
        $(inputFileTag).insertBefore(row); // inputFileTag를 row 위로 추가
	}

	function showPreview(obj) {
		
		console.log(obj.files[0]);
		let imageType = ["image/jpeg", "image/png", "image/gif"];
		
		// 파일 타입 확인
		let fileType = obj.files[0].type;
		
		let fileName = obj.files[0].name;
		if (imageType.indexOf(fileType) != -1) { // 이미지 파일이다.
			let reader = new FileReader(); // FileReader 객체 생성
        	reader.onload = function(e) { 
            // reader객체에 의해 파일을 읽기 완료하면 실행되는 콜백함수
			let imgTag = `<div style='padding:6px;'><img src='\${e.target.result}' width='40px' /><span>\${fileName}</span></div>`;
			$(imgTag).insertAfter(obj);
        	}
        	reader.readAsDataURL(obj.files[0]); // 업로드된 파일을 읽어온다.
		} else { // 파일이 이미지가 아니라면
			let imgTag = `<div style='padding:6px;'><img src='/resources/images/noimage.png' width='40px' /><span>\${fileName}</span></div>`;
			$(imgTag).insertAfter(obj);
		}


    }
	

	function cancelAddFile(obj) {
        let fileTag = $(obj).parent().prev().children().eq(0);
		$(fileTag).val(''); // input file tag의 value를 초기화
		$(obj).parent().parent().remove(); 
    }
</script>
<style>
	.fileBtns{
		display: flex;
		justify-content: flex-end;
	}
	.fileBtns input{
		margin-left: 5px;
	}

	
</style>
</head>
<body>

	<div class="container">
		<c:import url="../header.jsp"></c:import>

		<div class="content">
			<h1>게시글 수정 페이지</h1>


			<c:forEach var="board" items="${boardDetailInfo}">

				<div class="boardInfo">
					<div class="mb-3">
						<label for="boardNo" class="form-label">글 번호</label> <input
							type="text" class="form-control" id="boardNo"
							value="${board.boardNo}" readonly>
					</div>
					<div class="mb-3">
						<label for="title" class="form-label">글 제목</label> <input
							type="text" class="form-control" id="title"
							value="${board.title}">
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
						<textarea class="form-control" id="content" rows="5">
                  ${board.content}
                  </textarea>
					</div>
				</div>


				<div class="fileList" style="padding: 15px">
					<table class="table table-hover fileListTable">
						<thead>
							<tr>
								<th>#</th>
								<th>uploadedFiles</th>
								<th>fileName</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="file" items="${board.fileList}">
								<c:if test="${file.boardUpFileNo != '0'}">
									<tr>
										<td>
											<input class="form-check-input fileCheck" type="checkbox" id="${file.boardUpFileNo}" onclick="removeFileCheck(this.id);"/>
										</td>
										<td>
											<c:choose>
												<c:when test="${file.thumbFileName != null}">
												<!-- 이미지파일이라면 -->
													<img src="/resources/boardUpFiles/${file.newFileName}"  width="40px;"/>
												</c:when>
												<c:when test="${file.thumbFileName == null}">
												<!-- 이미지파일이 아니라면 -->
													<a href="/resources/boardUpFiles/${file.newFileName}">
														<img src="/resources/images/noimage.png" />
														${file.newFileName}
													</a>
												</c:when>
											</c:choose>
										</td>
										<td>
											${file.newFileName}
										</td>
									</tr>
								</c:if>
							</c:forEach>
							<tr>
								<td colspan="3" style="text-align : center;">
									<img src="/resources/images/add.png" onclick="addRows(this);"/>
								</td>
							</tr>
						</tbody>
					</table>

					<div class="fileBtns">
						<input type="button" class="btn btn-danger removeUpFileBtn" disabled value="선택한 파일 삭제" onclick="removeFile();"/>						
						<input type="button" class="btn btn-info cancelRemove" value="파일 삭제 취소" onclick="cancelRemFiles();"/>						
					</div>
				</div>


				<div calss="btns">
					<button type="button" class="btn btn-info" onclick="location.href='/hboard/listAll';">리스트페이지로</button>
				</div>
			</c:forEach>
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
