<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	// 8344c161e851343f33ceb78f3de3fc62
	let baseUrl = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=8344c161e851343f33ceb78f3de3fc62&targetDt=20240714";
	$(function(){
		getMovieApi();
	});


	function getMovieApi() {
		
		$.ajax({
			url : baseUrl,             // 데이터가 송수신될 서버의 주소
			type : 'GET',             // 통신 방식 : GET, POST, PUT, DELETE, PATCH   
			dataType : 'json',         // 수신 받을 데이터의 타입 (text, xml, json)
			success : function (data) {     // 비동기 통신에 성공하면 자동으로 호출될 callback function
				console.log(data);
				outputMovie(data);
			}

		});
	}


	function outputMovie(data) {
		$('.title').html(data.boxOfficeResult.boxofficeType);
		$('.outputDate').html("집계 일자 : " + data.boxOfficeResult.showRange);

		let output = '<div class="list-group">';
		$.each(data.boxOfficeResult.dailyBoxOfficeList, function(i, e){
			console.log(e);
			output += '<a href="#" class="list-group-item list-group-item-action">' + e.movieNm + '</a>';
		});

		output += "</div>";

		$('.boxOffice').html(output);
	}
	
</script>
</head>
<body>
	<div class="container">
		<c:import url="./header.jsp" />

		<div class="content">
			<h1>movie.jsp</h1>

			<h5 class="title"></h5>
			<h6 class="outputDate"></h6>

			<div class="boxOffice">
				
			</div>
		</div>

		<c:import url="./footer.jsp" />
	</div>
</body>
</html>