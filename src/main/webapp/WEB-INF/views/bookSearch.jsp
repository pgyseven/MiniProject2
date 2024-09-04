<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	$(function(){
		
		$('#searchBtn').click(function(){
			let searchValue = $('#searchValue').val();
			
			if(searchValue != ''){

				        $.ajax({
				         url : '/searchBook',             
				         type : 'GET',         
				         data : {
				        	 
				        	 "searchValue" : searchValue
				         },
				         dataType : 'json',                                 
				         success : function (data) {                     
				            console.log(data);
				           
				         }
				      });
				 
				
			}
			
			
		});
		
		
		
		
		
		
		
	});
	
	function getNewsData(){
        $.ajax({
         url : 'https://mbn.co.kr/rss/enter/',             // 데이터가 송수신될 서버의 주소
         type : 'GET',                                     // 통신 방식 : GET, POST, PUT, DELETE, PATCH   
         dataType : 'xml',                                 // 수신 받을 데이터의 타입 (text, xml, json)
         success : function (data) {                       // 비동기 통신에 성공하면 자동으로 호출될 callback function
            console.log(data);
           
         }
      });
    };


</script>


<style>

</style>
</head>
<body>
	<input type="text" placeholder="검색할 책을 입력하세요..." id="searchValue" />
	<button id="searchBtn">검색</button>
</body>
</html>