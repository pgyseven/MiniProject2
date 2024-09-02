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

google.charts.load('current', {'packages':['line']});
	$(function(){
		getSeoulTemp();
	});
	function getSeoulTemp(){

		$.ajax({
         url : '/seoulTemp',             // 데이터가 송수신될 서버의 주소
         type : 'GET',                                     // 통신 방식 : GET, POST, PUT, DELETE, PATCH   
         dataType : 'json',                                 // 수신 받을 데이터의 타입 (text, xml, json)
         success : function (data) {                       // 비동기 통신에 성공하면 자동으로 호출될 callback function
            console.log(data);
            if (data.resultCode == 200) {
                dataToArray(data.data);
            }

			

         }
      });



	}

	// 데이터([{}]. 배열안의 객체 형태) 를 2차원 배열로 바꿈
	function dataToArray(data) {
		let seoulTemps = [];
		//seoulTemps[0] = ["날짜", "평균기온", " 최저기온", "최고기온"]
		$.each(data, function(i, row){
			
			let tempData = new Date(row.writtenData).toDateString();
			let avgTemp = row.avgTemp;
			let minTemp = row.minTemp
			let maxTemp = row.maxTemp
			
			seoulTemps[i] = [tempData, avgTemp, minTemp, maxTemp];
			
			
		});
		
		//console.log(seoulTemps);
		drawChart(seoulTemps);
		
		
	}
	
	function drawChart(seoulTemps) {
	    var data = new google.visualization.DataTable();
	    data.addColumn('string', '날짜');  // 날짜는 문자열로 추가해야 합니다.
	    data.addColumn('number', '평균기온');
	    data.addColumn('number', '최저기온');
	    data.addColumn('number', '최고기온');

	    data.addRows(seoulTemps);

	    var options = {
	        chart: {
	            title: '2023년의 서울 기온 차트',
	          
	        },
	        width: 900,
	        height: 500,
	        axes: {
	            x: {
	                0: {side: 'top'}
	            }
	        }
	    };

	    var chart = new google.charts.Line(document.getElementById('linechart_material'));

	    chart.draw(data, google.charts.Line.convertOptions(options));
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


<div id="linechart_material"></div>
	
		<jsp:include page="./footer.jsp"></jsp:include>
	</div>

</body>
</html>
