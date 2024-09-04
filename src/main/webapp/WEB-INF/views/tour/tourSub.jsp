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
	      
/* 	        // 마커가 표시될 위치입니다 
	      var markerPosition  = new kakao.maps.LatLng(mapy, mapx); 

	      // 마커를 생성합니다
	      var marker = new kakao.maps.Marker({
	          position: markerPosition
	      });

	      // 마커가 지도 위에 표시되도록 설정합니다
	      marker.setMap(map);

	      // 아래 코드는 지도 위의 마커를 제거하는 코드입니다
	      // marker.setMap(null);  */
	      
	      
	      
	   // 커스텀 오버레이에 표시할 내용입니다     
	   // HTML 문자열 또는 Dom Element 입니다 
	   var content = '<div class="overlaybox">' +
	       '    <div class="boxtitle">금주 영화순위</div>' +
	       '    <div class="first">' +
	       '        <div class="triangle text">1</div>' +
	       '        <div class="movietitle text">드래곤 길들이기2</div>' +
	       '    </div>' +
	       '    <ul>' +
	       '        <li class="up">' +
	       '            <span class="number">2</span>' +
	       '            <span class="title">명량</span>' +
	       '            <span class="arrow up"></span>' +
	       '            <span class="count">2</span>' +
	       '        </li>' +
	       '        <li>' +
	       '            <span class="number">3</span>' +
	       '            <span class="title">해적(바다로 간 산적)</span>' +
	       '            <span class="arrow up"></span>' +
	       '            <span class="count">6</span>' +
	       '        </li>' +
	       '        <li>' +
	       '            <span class="number">4</span>' +
	       '            <span class="title">해무</span>' +
	       '            <span class="arrow up"></span>' +
	       '            <span class="count">3</span>' +
	       '        </li>' +
	       '        <li>' +
	       '            <span class="number">5</span>' +
	       '            <span class="title">안녕, 헤이즐</span>' +
	       '            <span class="arrow down"></span>' +
	       '            <span class="count">1</span>' +
	       '        </li>' +
	       '    </ul>' +
	       '</div>';

	   // 커스텀 오버레이가 표시될 위치입니다 
	   var position = new kakao.maps.LatLng(mapy, mapx);  

	   // 커스텀 오버레이를 생성합니다
	   var customOverlay = new kakao.maps.CustomOverlay({
	       position: position,
	       content: content,
	       xAnchor: 0.3,
	       yAnchor: 0.91
	   });

	   // 커스텀 오버레이를 지도에 표시합니다
	   customOverlay.setMap(map);
	      
	   }
	
	
</script>
<style>
.overlaybox {position:relative;width:360px;height:350px;background:url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/box_movie.png') no-repeat;padding:15px 10px;}
.overlaybox div, ul {overflow:hidden;margin:0;padding:0;}
.overlaybox li {list-style: none;}
.overlaybox .boxtitle {color:#fff;font-size:16px;font-weight:bold;background: url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png') no-repeat right 120px center;margin-bottom:8px;}
.overlaybox .first {position:relative;width:247px;height:136px;background: url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/thumb.png') no-repeat;margin-bottom:8px;}
.first .text {color:#fff;font-weight:bold;}
.first .triangle {position:absolute;width:48px;height:48px;top:0;left:0;background: url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/triangle.png') no-repeat; padding:6px;font-size:18px;}
.first .movietitle {position:absolute;width:100%;bottom:0;background:rgba(0,0,0,0.4);padding:7px 15px;font-size:14px;}
.overlaybox ul {width:247px;}
.overlaybox li {position:relative;margin-bottom:2px;background:#2b2d36;padding:5px 10px;color:#aaabaf;line-height: 1;}
.overlaybox li span {display:inline-block;}
.overlaybox li .number {font-size:16px;font-weight:bold;}
.overlaybox li .title {font-size:13px;}
.overlaybox ul .arrow {position:absolute;margin-top:8px;right:25px;width:5px;height:3px;background:url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/updown.png') no-repeat;} 
.overlaybox li .up {background-position:0 -40px;}
.overlaybox li .down {background-position:0 -60px;}
.overlaybox li .count {position:absolute;margin-top:5px;right:15px;font-size:10px;}
.overlaybox li:hover {color:#fff;background:#d24545;}
.overlaybox li:hover .up {background-position:0 0px;}
.overlaybox li:hover .down {background-position:0 -20px;}   
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