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
	
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9699b3370a9cf5aa1be6da13bb92aa7f"></script>
<script>
	const serviceKey = "RRgow1c7tvWE17qrOIVAUIwK8wz6qyNEWm3tRCuSiQ07UUrux%2BH9Uk6lP37qeLXDTrr7Toht5t52ZdjR6Dh4SA%3D%3D";

	const mapKey ="9699b3370a9cf5aa1be6da13bb92aa7f";
	
	$(function(){
		getTour();
		
		
	});
	
	
	function getTour() {
		
		
		  $.ajax({
		         url : `https://apis.data.go.kr/B551011/KorService1/detailCommon1?serviceKey=\${serviceKey}&MobileOS=ETC&MobileApp=AppTest&_type=json&contentId=${param.contentid}&contentTypeId=39&defaultYN=Y&firstImageYN=Y&areacodeYN=Y&catcodeYN=Y&addrinfoYN=Y&mapinfoYN=Y&overviewYN=Y&numOfRows=10&pageNo=1`,             
		         type : 'GET',                                     
		         dataType : 'json',         
		         async : false,
		         success : function (data) {                      
		            console.log(data);
		  			output(data.response.body.items.item[0]);

					
		         },
		         complete : function(){
			
				 }
		      });
		
		
	}
	function output(data){ 
		$('.tourTitle').html(data.title);
		$('.tourImage').html(`<img src='\${data.firstimage}' />`);
		
		
		showMap(data.mapx, data.mapy, data.mlevel);
		
		
	}
	
	function showMap(mapx, mapy, mlevel){
		
		var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
		var options = { //지도를 생성할 때 필요한 기본 옵션
			center: new kakao.maps.LatLng(mapy, mapx), //지도의 중심좌표.
			level: mlevel //지도의 레벨(확대, 축소 정도)
		};

		var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
		
	}
	
	
</script>
<style>

</style>
</head>
<body>
	<div class="container">
		<c:import url="../header.jsp" />

		<div class="content">
		
		<div class="tourImage">
		
		</div>
		
			<h1 class="tourTitle"></h1>
			
			
			
			<div id="map" style="width:500px;height:400px;"></div>
		
		</div>

		<c:import url="../footer.jsp" />
	</div>


</body>
</html>