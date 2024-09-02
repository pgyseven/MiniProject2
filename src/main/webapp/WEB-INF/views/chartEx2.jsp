<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
<meta charset="UTF-8">
<title>INDEX</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script type="text/javascript"
	src="https://www.gstatic.com/charts/loader.js"></script>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Dongle:wght@300;400;700&display=swap"
	rel="stylesheet">







<script>
google.charts.load('current', {'packages':['bar']});
	let students = new Array();
	students[0] = [ "이름", "국어", "영어", "수학", "총점", "평균" ];

	function score() {
		$(".student").each(function(i, student) {

			// 입력된 이름, 국어, 영어 수학점수를 얻어옴
			let stuName = $(student).find('.stuName').val();
			let kor = parseInt($(student).find('.kor').val());
			let eng = parseInt($(student).find('.eng').val());
			let math = parseInt($(student).find('.math').val());

			//총점 평균을 구함
			let tot = kor + eng + math;
			let avg = (tot/3).toFixed(1);

			// 총점, 평균을 출력
			//$(student).find(".tot").text(tot);
			$(student).find('.tot').html(tot);
			$(student).find('.avg').html(avg);

			// students 배열에 학생 1명을 또 다른 배열로 넣음
			students[i + 1] = [ stuName, kor, eng, math, tot, avg];

			console.log(students);
			
			

		});
		drawChart();
	}
	
	 function drawChart() {
	        var data = google.visualization.arrayToDataTable(students);

	        var options = {
	          chart: {
	            title: '성적표',

	          }
	        };

	        var chart = new google.charts.Bar(document.getElementById('columnchart_material'));

	        chart.draw(data, google.charts.Bar.convertOptions(options));
	      }
</script>

<style>
* {
	font-family: "Dongle", sans-serif;
	font-weight: 400; /* 글자 두껍게 */
	font-style: normal;
}
</style>
</head>
<body>
	<div class="container">
		<jsp:include page="./header.jsp"></jsp:include>



		<table border="1">
			<tr>
				<td>이름</td>
				<td>국어</td>
				<td>영어</td>
				<td>수학</td>
				<td>총점</td>
				<td>평균</td>
			</tr>
			<tr class="student">
				<td><input type="text" class="stuName" /></td>
				<td><input type="number" class="kor" /></td>
				<td><input type="number" class="eng" /></td>
				<td><input type="number" class="math" /></td>
				<td class="tot"></td>
				<td class="avg"></td>
			</tr>

			<tr class="student">
				<td><input type="text" class="stuName" /></td>
				<td><input type="number" class="kor" /></td>
				<td><input type="number" class="eng" /></td>
				<td><input type="number" class="math" /></td>
				<td class="tot"></td>
				<td class="avg"></td>
			</tr>

			<tr class="student">
				<td><input type="text" class="stuName" /></td>
				<td><input type="number" class="kor" /></td>
				<td><input type="number" class="eng" /></td>
				<td><input type="number" class="math" /></td>
				<td class="tot"></td>
				<td class="avg"></td>
			</tr>

		</table>
		<input type="button" value="성적입력 완료" onclick="score();" />


		<div id="columnchart_material" style="width: 800px; height: 500px;"></div>

		<jsp:include page="./footer.jsp"></jsp:include>
	</div>

	<script src="https://kit.fontawesome.com/1679404ec9.js"
		crossorigin="anonymous"></script>
</body>
</html>
