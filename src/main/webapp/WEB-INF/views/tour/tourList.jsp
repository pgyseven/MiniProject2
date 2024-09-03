<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공공데이터 포털 한국관광정보 api</title>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	const serviceKey = "RRgow1c7tvWE17qrOIVAUIwK8wz6qyNEWm3tRCuSiQ07UUrux%2BH9Uk6lP37qeLXDTrr7Toht5t52ZdjR6Dh4SA%3D%3D";
	$(function(){
		getTourList();
		
		
	});
	
	
	function getTourList() {
		$('.loading').show()
		
		  $.ajax({
		         url : `https://apis.data.go.kr/B551011/KorService1/areaBasedList1?serviceKey=\${serviceKey}&numOfRows=100&pageNo=1&MobileOS=ETC&MobileApp=AppTest&_type=json&listYN=Y&arrange=A&contentTypeId=39&areaCode=1`,             
		         type : 'GET',                                     
		         dataType : 'json',                                
		         success : function (data) {                      
		            console.log(data);
		  			outpurTours(data);
		         },
		         complete : function(){
					$('.loading').hide()
				 }
		      });
		
		
	}


	function outpurTours(data) {
	      let items = data.response.body.items.item;
	      
	      let output = '';
	      $.each(items, function(i, tour) {
	         output += `<div class = "tour" onclick="location.href='/tourSub?contentid=\${tour.contentid}';">`;
	         
	         output += `<div class="tourTumbImg">`;     
	         if ( tour.firstimage2 != ''){
	        	 output += `<img src="\${tour.firstimage2}" />`;
	         }else{
	        	 output += `<img src="/resources/images/no-image.png" />`;
	         }
	        
	         output += `</div>`;
	         output += `<div class="tourText">`;
	         output += `<div class="tourTitle">\${tour.title}</div>`;
	         output += `<div class="tourDescription">\${tour.addr1}</div>`;
	         output += `</div>`;
	         
	         output += `</div>`;
	      });
	      
	      $('.tourList').html(output);
	   }
</script>
<style>

div.content {

	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;

}

div.tourList {
	margin: 20px auto;
}

div.tour {
	width: 240px;
	border: 1px solid #ccc;
	float: left;
	margin: 20px 15px;
}

div.tourTumbImg img {
	width: 100%; 
}

div.tour:hover {
	border: 1px solid #ff00d4;
}

div.tourText {
	padding: 10px;
}

div.tourTitle {
	text-align: center;
}

div.tourDescription {
	font-size: 0.7em; /*1em = 16pixel */
	text-align: center;
}

div.myfooter {
	clear: left;
}
</style>
</head>
<body>
	<div class="container">
		<c:import url="../header.jsp" />

		<div class="content">
			<h1>위치기반 관광정보</h1>
			
			
			<div class="loading" sytle="display:none;">
		 <img src="/resources/images/loading.gif"  width="400px" />
        
		</div>
			
			
			<div class="tourList">
			
			
			
		</div>

		<c:import url="../footer.jsp" />
		
		</div>
		
		
	</div>





</body>
</html>