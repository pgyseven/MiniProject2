<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기상청 API 데이터와 카카오맵 결합</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9699b3370a9cf5aa1be6da13bb92aa7f"></script> <!-- 여기에 본인의 카카오맵 앱키를 넣어야 합니다. -->

<script>


    $(document).ready(function() {
    	let span = $('.overlayClose');    
    	let overlay = $('.wrap'); 
    	
        getWeatherData();
        
        span.on('click', function() {
        	overlay.hide(); 
        });        
        
        
    });
    



    

    function getWeatherData() {
        const serviceKey = "RRgow1c7tvWE17qrOIVAUIwK8wz6qyNEWm3tRCuSiQ07UUrux%2BH9Uk6lP37qeLXDTrr7Toht5t52ZdjR6Dh4SA%3D%3D";
        const baseDate = "20241008";  // 현재 날짜 (하드코딩된 값)
        const baseTime = "0630";  // 발표 시각 (HHMM 형식)
        const nx = 55;  // x 좌표
        const ny = 127;  // y 좌표

        // 기상청 API 호출 URL 생성
        const url = `https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst?serviceKey=\${serviceKey}&pageNo=1&numOfRows=1000&dataType=JSON&base_date=\${baseDate}&base_time=\${baseTime}&nx=\${nx}&ny=\${ny}`;

        console.log("API 호출 URL:", url);

        // 기상청 API 호출
        $.ajax({
            url: url,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                console.log("기상청 API 응답 데이터:", data);  // 전체 응답 데이터 콘솔에 출력
                if (data.response && data.response.header.resultCode === "00") {
                    alert("기상청 API 데이터 호출 성공!");
                    displayWeatherOnMap(data.response.body.items.item);  // 데이터를 지도에 표시
                } else {
                    alert("기상청 API 호출 실패! 응답 코드: " + data.response.header.resultCode + ", 메시지: " + data.response.header.resultMsg);
                }
            },
            error: function(xhr, status, error) {
                alert(`날씨 데이터를 가져오는 데 실패했습니다. 상태: ${status}, 에러: ${error}`);
                console.log("에러 세부 정보:", xhr);
            }
        });
    }

    // 지도에 날씨 정보를 표시하는 함수
    function displayWeatherOnMap(items) {
        var mapContainer = document.getElementById('map'), // 지도를 표시할 div
            mapOption = { 
                center: new kakao.maps.LatLng(37.5665, 126.9780), // 지도의 중심좌표 (서울)
                level: 5 // 지도의 확대 레벨
            };

        // 지도를 생성합니다.
        var map = new kakao.maps.Map(mapContainer, mapOption);

        // 날씨 데이터를 바탕으로 커스텀 오버레이 내용 생성
        let weatherContent = '<div class="wrap">' + 
                             '    <div class="info">' + 
                             '        <div class="title">날씨 정보<span class="overlayClose">&times;</span></div>' +
                             '        <div class="body">' + 
                             '            <div class="img">' +
                             '                <img src="https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/thumnail.png" width="60" height="60" style="float: left; margin-right: 10px;">' + // 이미지 크기 및 위치 수정
                             '            </div>' + 
                             '            <div class="desc">' + 
                             '                <ul class="weather-list">';

        // 데이터를 반복하여 HTML 내용 생성 (각 category의 첫 번째 데이터만 표시)
        const firstItemsByCategory = getFirstForecastByCategory(items);
        for (const category in firstItemsByCategory) {
            const item = firstItemsByCategory[category];
            const categoryName = getCategoryName(item.category); // 카테고리 이름을 가져옴
			const imgRoot = imgCheck(categoryName, item.fcstValue);
            // categoryName이 null이 아닐 때만 HTML을 생성
            if (categoryName) {
                weatherContent += `<li>\${categoryName}: <img src="\${imgRoot}" alt="날씨 이미지" width="20" height="20"></li>`;
            }
        }

        weatherContent += '                </ul>' +
                          '            </div>' + 
                          '        </div>' + 
                          '    </div>' + 
                          '</div>';

        // 커스텀 오버레이가 표시될 위치 (서울)
        var position = new kakao.maps.LatLng(37.5665, 126.9780); 

        // 지도에 마커를 표시합니다 
        var marker = new kakao.maps.Marker({
            map: map, 
            position: position
        });

        // 커스텀 오버레이 생성
        var customOverlay = new kakao.maps.CustomOverlay({
            position: marker.getPosition(),
            content: weatherContent,
            map: map
        });

        // 커스텀 오버레이를 지도에 표시
        customOverlay.setMap(map);

        // 마커를 클릭하면 커스텀 오버레이를 표시하도록 설정
        kakao.maps.event.addListener(marker, 'click', function() {
            customOverlay.setMap(map);
        });
    }

    // 카테고리별 첫 번째 예보 값을 추출하는 함수
    function getFirstForecastByCategory(items) {
        return items.reduce((acc, item) => {
            if (!acc[item.category]) {
                acc[item.category] = item;
            }
            return acc;
        }, {});
    }

    // 카테고리 코드에 대한 한글 설명을 반환하는 함수
    function getCategoryName(categoryCode) {
        switch (categoryCode) {
            case 'LGT': return "낙뢰";
            case 'PTY': return "강수 형태";
            case 'RN1': return null;
            case 'SKY': return "하늘 상태";
            case 'T1H': return "기온";
            case 'REH': return "습도";
            case 'UUU': return null;
            case 'VVV': return null;
            case 'VEC': return null;
            case 'WSD': return "풍속";
            default: return null;
        }
    }
    
    function imgCheck(category, value) {
        // 기상 값에 따라 이미지를 선택하는 로직
        console.log(category, value);

        if (category === "낙뢰") {
            if (value === '0') {
                return '/resources/images/없음.gif';  // 올바른 확장자로 변경
            } else {
                return '/resources/images/낙뢰.gif';
            }
        }

        if (category === "강수 형태") {
            switch (value) {
                case '0':
                    return '/resources/images/없음.gif';
                case '1':
                    return '/resources/images/비.gif';
                case '2':
                    return '/resources/images/비눈.gif';
                case '3':
                    return '/resources/images/눈.gif';
                case '5':
                    return '/resources/images/빗방울.gif';
                case '6':
                    return '/resources/images/빗방울눈날림.gif';
                default:
                    return '/resources/images/없음.gif';  // 기본 이미지 설정
            }
        }

        if (category === "하늘 상태") {
            switch (value) {
                case '1':
                    return '/resources/images/맑음.gif';
                case '3':
                    return '/resources/images/구름많음.gif';
                case '4':
                    return '/resources/images/흐림.gif';
                default:
                    return '/resources/images/없음.gif';  // 기본 이미지 설정
            }
        }

        if (category === "기온") {
            return '/resources/images/온도.gif';
        }

        if (category === "습도") {
            return '/resources/images/습도.gif';
        }

        if (category === "풍속") {
            return '/resources/images/풍속.gif';
        }

        return '/resources/images/없음.gif';  // 기본 이미지로 설정
    }


</script>
<style>
    .wrap {
        position: absolute;
        left: 0;
        bottom: 40px;
        width: 400px; /* 오버레이 너비 확대 */
        height: 200px; /* 오버레이 높이 조정 */
        margin-left: -175px;
        text-align: left;
        overflow: hidden;
        font-size: 10px; /* 글씨 크기 조절 */
        font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;
        line-height: 1.3;
    }
    .wrap * {
        padding: 0;
        margin: 0;
    }
    .wrap .info {
        width: 348px;
        height: 180px; /* 오버레이 높이 조정 */
        border-radius: 5px;
        border-bottom: 2px solid #ccc;
        border-right: 1px solid #ccc;
        overflow: hidden;
        background: #fff;
    }
    .info .title {
        padding: 5px 0 0 10px;
        height: 30px;
        background: #eee;
        border-bottom: 1px solid #ddd;
        font-size: 14px;
        font-weight: bold;
    }
    .info .body {
        position: relative;
        overflow: hidden;
    }
	.info .desc {
	    position: relative;
	    margin: 10px 0 0 80px;  /* 텍스트가 이미지 오른쪽에 위치하도록 조정 */
	    height: 100px; /* 본문 영역의 높이 축소 */
	    max-height: 100px; /* 최대 높이 지정 */
	    overflow-y: scroll; /* 스크롤바 항상 표시에서 auto로 변경 */
	}
    .info .desc .weather-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
	.info .desc .weather-list li {
	    display: flex; /* 수평 정렬을 위해 flex 사용 */
	    justify-content: space-between; /* 텍스트와 이미지를 일정 간격으로 배치 */
	    align-items: center; /* 수직 정렬 */
	    margin: 5px 0; /* 위아래 여백 */
	    padding: 5px 0;
	}
	
	.info .desc .weather-list li span {
	    flex-grow: 1; /* 텍스트가 일정한 공간을 차지하도록 설정 */
	    text-align: left; /* 텍스트는 왼쪽 정렬 */
	}
	
	.info .desc .weather-list li img {
	    margin-right: 50px; /* 이미지와 텍스트 사이 간격 */
	}
</style>
</head>
<body>
    <h2>기상청 API와 카카오맵 연동 예제</h2>
    <p>현재 서울의 날씨 정보입니다.</p>

    <!-- 지도를 표시할 영역 -->
    <div id="map" style="width:100%;height: 700px;"></div>

    <!-- 날씨 데이터를 화면에 표시할 영역 -->
    <div id="weatherDataOutput" style="margin-top: 20px;">날씨 데이터를 불러오는 중...</div>
</body>
</html>