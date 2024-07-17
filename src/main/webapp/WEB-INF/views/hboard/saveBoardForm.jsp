<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
	let upfiles = new Array(); // 업로드 되는 파일들을 저장하는 배열
	
	$(function(){
		// 업로드 파일 영역에 drag&drop과 관련된 이벤트(파일의 경우 파일이 웹브라우저에서 실행되는 등)를 방지 해야 한다 -> 이벤트 캔슬링
		$('.fileUploadArea').on("dragenter dragover", function(evt) {
			evt.preventDefault();  // 기본 이벤트 캔슬
		});
		
		// 유저가 fileUploadArea에 파일을 드래그&드랍 하면...
		$('.fileUploadArea').on("drop", function(evt){   
			evt.preventDefault();
			
			//console.log(evt.originalEvent.dataTransfer.files);  // 업로드 되는 파일 객체의 정보
			
			for (let file of evt.originalEvent.dataTransfer.files) {				
				// 파일 사이즈 검사 하여 10MB가 넘게되면 파일 업로드가 안되도록...
				if (file.size > 10485760) {
					alert("파일 용량이 너무 큽니다.. 업로드한 파일을 확인해 주세요..!");
				} else {
					upfiles.push(file); // 배열에 담기
					console.log(upfiles);
					
					// 해당 파일 업로드
					fileUpload(file)
					
					
				}
				
			}
			
		});
	});
	
	// 실제로 유저가 업로드한 파일을 컨트롤러단에 전송하여 저장되도록 하는 함수
	function fileUpload(file) {
		let result = false;
		let fd = new FormData();  // FormData 객체 생성 : form태그와 같은 역할의 객체
		fd.append("file", file);
		
		$.ajax({
	         url : '/hboard/upfiles',             // 데이터가 송수신될 서버의 주소
	         type : 'post',                                     // 통신 방식 : GET, POST, PUT, DELETE, PATCH   
	         dataType : 'text',					// 수신 받을 데이터의 타입 (text, xml, json)
			 data : fd,					// 보낼 데이터
	         // processData :  false  -> 데이터를 쿼리스트링 형태로 보내지 안겠다는 설정
	         // contentType 의 디폴트 값이 "application/x-www-form-urlencoded"인데, 파일을 전송하는 방식이기에 "multipart/form-data"로 되어야 하므로..
	         processData: false,
	         contentType : false,
	         async : false,      // 비동기 통신 : false
	         success : function (data) {                       // 비동기 통신에 성공하면 자동으로 호출될 callback function
	            console.log(data);
	         	if (data != null) {
	         		showPreview(file);  // 파일 미리보기
	         	}
	         
	         }, error : function (data) {
	        	 console.log(data);
	        	 if (data == 'fail') {
	        		 alert ('파일을 업로드 하지 못했습니다');
	        		 
	        		 for(let i = 0; i < upfiles.length; i++) {
	        			 if (upfile[i].name == file.name) {
	        				 upfiles.splice(i, 1);  // 배열에서 삭제
	        			 }
	        		 }
	        	 }
	         }
	      });
	}
	
	
	// 넘겨진 file이 이미지 파일이라면 미리보기 하여 출력한다.
	function showPreview(file) {
		let imageType = ["image/jpeg", "image/png", "image/gif"];
		console.log(file);
		let fileType = file.type.toLowerCase();
		if (imageType.indexOf(fileType) != -1) {
			// 이미지 파일이라면...
			alert("이미지 파일이다");
		} else {
			let output = `<div><img src='/resources/images/noimage.png' /><span>\${file.name}</span>`;
			output += `<span><img src='/resources/images/remove.png' width='20px' onclick="remFile(this);" /></span></div>`;
			$('.preview').append(output);
		}
	}
	
	// 업로드한 파일을 지운다. (화면, front배열, 백엔드)
	function remFile(obj) {
		let removedFileName = $(obj).parent().prev().html();
		
		for(let i = 0; i < upfiles.length; i++) {
			if (upfiles[i].name == removedFileName) {
				
				// 파일 삭제 (백엔드단에서 삭제가 성공하면 front 단에서도 배열, 화면에서 삭제 해야 함)
				$.ajax({
	         		url : '/hboard/removefile',             // 데이터가 송수신될 서버의 주소
	         		type : 'post',                                     // 통신 방식 : GET, POST, PUT, DELETE, PATCH   
	         		dataType : 'json',					// 수신 받을 데이터의 타입 (text, xml, json)
					data : {							// 보낼 데이터
						"removedFileName" : removedFileName
					},
	        		async : false,      // 비동기 통신 : false
	         		success : function (data) {                       // 비동기 통신에 성공하면 자동으로 호출될 callback function
	            		console.log(data);
	         		         
	         		}
	      		});
				
				upfiles.splice(i, 1);  // 배열에서 삭제
				console.log(upfiles);
				$(obj).parent().parent().remove();  // 태그 삭제
			}
		}
		
	}
	

    function validBoard() {
        let result = false;
        let title = $('#title').val();
        console.log(title);

        if (title == '' || title.length < 1 || title == null) {
            // 제목을 입력 하지 않았을때
            alert("제목은 반드시 입력하셔야 합니다");
            $('#title').focus();
        } else {
            // 제목을 입력했을 때
            result = true;
        }
        

        // 유효성 검사 하는 자바스크립트에서는 마지막에 boolean 타입의 값을 반환하여
        // 데이터가 백엔드 단으로 넘어갈지 말지를 결정해줘야 한다!!!!!
        return result;
    }
</script>
<style>
.fileUploadArea {
	width: 100%;
	height: 300px;
	background-color: lightgray;
	text-align: center;
	line-height: 300px;
}
</style>
</head>
<body>
	<div class="container">
		<c:import url="./../header.jsp" />

		<h2>게시글 작성</h2>
		<!--  multipart/form-data : 데이터를 여러 조각으로 나누어서 전송하는 방식. 수신되는 곳에서는 재조립이 필요하다. -->
		<form action="saveBoard" method="post">
			<div class="mb-3">
				<label for="title" class="form-label">글제목</label> <input type="text"
					class="form-control" id="title" name="title"
					placeholder="글제목을 입력하세요">
			</div>
			<div class="mb-3">
				<label for="writer" class="form-label">작성자</label> <input
					type="text" class="form-control" id="writer" name="writer"
					placeholder="작성자를 입력하세요">
			</div>
			<div class="mb-3">
				<label for="content" class="form-label">내용</label>
				<textarea class="form-control" id="content" rows="5" name="content"
					placeholder="내용을 입력하세요"></textarea>
			</div>

			<div class="fileUploadArea mb-3">
				<p>업로드할 파일을 요기에 드래그 드랍 하세요!</p>
			</div>

			<div class="preview"></div>


			<button type="submit" class="btn btn-primary"
				onclick="return validBoard();">저장</button>
		</form>


		<c:import url="./../footer.jsp" />
	</div>
</body>
</html>