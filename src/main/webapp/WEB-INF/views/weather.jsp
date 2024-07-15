<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오늘의 날씨(연습)</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	let apiKey = 'e3d6df7622a5cd65dca26e2c8231e08a';
	let baseUrl = 'https://api.openweathermap.org/data/2.5/weather?appid=' 
		+ apiKey + "&q=seoul&units=metric";

	$(function(){
		getWeatherData();
	});

	function getWeatherData() {
		$.ajax({
			url : baseUrl,             // 데이터가 송수신될 서버의 주소
			type : 'GET',             // 통신 방식 : GET, POST, PUT, DELETE, PATCH   
			dataType : 'json',         // 수신 받을 데이터의 타입 (text, xml, json)
			success : function (data) {     // 비동기 통신에 성공하면 자동으로 호출될 callback function
				console.log(data);
				outputWeather(data);
			}, error : function () {    // 비동기 통신에 실패하면 자동으로 호출될 callback function

			}, complete : function ()  {   // 통신 성공/실패 여부에 상관없이 마지막에 호출될 callback function

			}

		});
	}

	// 날씨 json data를 parsing하여 출력
	function outputWeather(data) {
		let cityName = data.name;
		$('#cityName').html(cityName);
		let dt = new Date(data.dt).toLocaleString();
		$('#outputTime').html("출력 시간 : " + dt);

		$('.curWeather').html(data.weather[0].main);
		$('.curTemp').html(data.main.temp);
		$('.weatherIcon').html("<img src='https://openweathermap.org/img/wn/" + data.weather[0].icon + "@4x.png'/>")
	}

</script>
</head>
<body>
	<div class="container">
		<c:import url="./header.jsp" />

		<div class="content">
			<h1><span id="cityName"></span> 지역의 오늘 날씨</h1>
			<div id="outputTime"></div>
			<div class="weatherInfo">
				<div class="curWeather"></div>
				<div class="curTemp"></div>
				<div class="weatherIcon"></div>
				상세날씨(description)

				최고온도
				최저온도
				풍속 , 풍향

				해뜨는시간
				해지는시간
				
			</div>
		</div>

		<c:import url="./footer.jsp" />
	</div>
	
</body>
</html>