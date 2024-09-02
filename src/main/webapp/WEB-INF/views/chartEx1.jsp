<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
<meta charset="UTF-8">
<title>INDEX</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Dongle:wght@300;400;700&display=swap" rel="stylesheet">





 <script type="text/javascript">
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(drawChart); // page 가 로딩 되면 drawChart 함수를 호출한다.
      function drawChart() {
        var data = google.visualization.arrayToDataTable([ // chart가 표현할 데이터
          ['통학 수단', '카운트'],
          ['도보',     1],
          ['버스',      2],
          ['지하철',  2]

        ]); //2차원 배열 배열안에 또다른 배열이 있다. 원래 프로그램에는 없으나 편법으로 적용하여 2차원 배열처럼 작동하게~
        

        var options = { // chart의 옵션값 설정
          title: '우리반 통학 수단 차트',
          is3D: true,
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart_3d')); //차트 객체 생성
        chart.draw(data, options); // chart를 주어진 data와 option을 가지고 그려라
      }
    </script>

<style>

	* {
		  font-family: "Dongle", sans-serif;
  font-weight: 400;/* 글자 두껍게 */
  font-style: normal; 
	}
</style>
</head>
<body>
	<div class="container">
		<jsp:include page="./header.jsp"></jsp:include>

		<div class="content">
			<h1>자바스크립트 차트 예제 <i class="fa-solid fa-chart-pie" style="color: #63E6BE;"></i></h1>

		
		
		 <div id="piechart_3d" style="width: 900px; height: 500px;"></div>

		
		
		
		</div>


	

		<jsp:include page="./footer.jsp"></jsp:include>
	</div>
	
	<script src="https://kit.fontawesome.com/1679404ec9.js" crossorigin="anonymous"></script>
</body>
</html>
