<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기상청 API 데이터와 카카오맵 결합</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9699b3370a9cf5aa1be6da13bb92aa7f"></script>

<script>

    $(document).ready(function() {
        loadICData();
    });

    // 도로공사 API에서 IC 데이터 가져오기
    function loadICData() {
        const apiKey = "3131669207";  // 도로공사 API 인증키
        const url = `https://data.ex.co.kr/openapi/locationinfo/locationinfoUnit?key=\${apiKey}&type=json&numOfRows=1000&pageNo=1`;

        $.ajax({
            url: url,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                if (data && data.code === "SUCCESS") {
                    // 영업소 위치 데이터가 성공적으로 수신되면 해당 위치에 마커 표시
                    const icData = data.list;
                    displayMarkersOnMap(icData);
                } else {
                    alert("영업소 위치 데이터 호출 실패: " + data.message);
                }
            },
            error: function(xhr, status, error) {
                alert(`도로공사 API 데이터를 가져오는 데 실패했습니다. 상태: ${status}, 에러: ${error}`);
                console.log("에러 세부 정보:", xhr);
            }
        });
    }

    // 지도에 마커와 날씨 정보를 표시하는 함수
function displayMarkersOnMap(icData) {
    var mapContainer = document.getElementById('map'),
        mapOption = { 
            center: new kakao.maps.LatLng(37.5665, 126.9780),
            level: 7
        };
    var map = new kakao.maps.Map(mapContainer, mapOption);

    map.addOverlayMapTypeId(kakao.maps.MapTypeId.TRAFFIC); // 교통정보 추가

    const icListEl = document.getElementById('icList'); // IC 목록을 표시할 UL 엘리먼트 찾기

    icData.forEach(ic => {
        const xValue = parseFloat(ic.xValue);
        const yValue = parseFloat(ic.yValue);

        if (!isNaN(xValue) && !isNaN(yValue)) {
            const markerPosition = new kakao.maps.LatLng(yValue, xValue);
            const marker = new kakao.maps.Marker({
                map: map,
                position: markerPosition,
                title: ic.unitName // 마커의 title 속성에 영업소 이름 추가
            });

            marker.customOverlay = null;

            // 마커 클릭 시 오버레이 표시
            kakao.maps.event.addListener(marker, 'click', function() {
                if (marker.customOverlay && marker.customOverlay.getMap()) {
                    marker.customOverlay.setMap(null);
                    marker.customOverlay = null;
                } else {
                    getWeatherDataForLocation(markerPosition, ic.unitName, map, marker);
                }
            });

            // 1. IC 목록에 리스트 항목 추가
            const listItem = document.createElement('li');
            listItem.innerHTML = ic.unitName;
            listItem.style.cursor = "pointer";
            listItem.onclick = function() {
                map.panTo(markerPosition); // 클릭 시 해당 위치로 지도 이동
                kakao.maps.event.trigger(marker, 'click');  // 클릭 시 마커의 클릭 이벤트 트리거
            };
            icListEl.appendChild(listItem);  // IC 목록에 항목 추가
        }
    });
}

	
	// 특정 위치에 대한 기상청 날씨 데이터를 가져와서 마커에 표시하는 함수
	function getWeatherDataForLocation(position, unitName, map, marker) {
	    const serviceKey = "RRgow1c7tvWE17qrOIVAUIwK8wz6qyNEWm3tRCuSiQ07UUrux%2BH9Uk6lP37qeLXDTrr7Toht5t52ZdjR6Dh4SA%3D%3D";
	    const baseDate = "20241008";
	    const baseTime = "0630";
	    const ny = Math.round(position.getLng());
	    const nx = Math.round(position.getLat());
	
	    const weatherUrl = `https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst?serviceKey=\${serviceKey}&pageNo=1&numOfRows=1000&dataType=JSON&base_date=\${baseDate}&base_time=\${baseTime}&nx=\${nx}&ny=\${ny}`;
		console.log(weatherUrl);
	    $.ajax({
	        url: weatherUrl,
	        type: 'GET',
	        dataType: 'json',
	        success: function(data) {
	            if (data.response && data.response.header.resultCode === "00") {
	                // 오버레이를 표시할 때 마커도 전달하여 해당 마커에 연결된 오버레이로 관리
	                displayWeatherOverlay(data.response.body.items.item, unitName, position, map, marker);
	            }
	        }
	    });
	}
	
	// 지도에 날씨 정보를 표시하는 함수
	function displayWeatherOverlay(items, unitName, position, map, marker) {
	    let weatherContent = '<div class="wrap">' + 
	                         '    <div class="info">' + 
	                         '        <div class="title">' + unitName + ' 날씨 정보</div>' +
	                         '        <div class="body">' + 
	                         '            <div class="img">' +
	                         '                <img src="/resources/images/car.gif" width="60" height="60" style="float: left; margin-right: 10px;">' + 
	                         '            </div>' + 
	                         '            <div class="desc">' + 
	                         '                <ul class="weather-list">';
	
	    const firstItemsByCategory = getFirstForecastByCategory(items);
	    for (const category in firstItemsByCategory) {
	        const item = firstItemsByCategory[category];
	        const categoryName = getCategoryName(item.category);
	        const imgRoot = imgCheck(categoryName, item.fcstValue);
	        const weatherValue = valueCheck(categoryName, item.fcstValue);
	
	        if (categoryName) {
	            weatherContent += `<li>\${categoryName}: <div>\${weatherValue}</div> <img src="\${imgRoot}" alt="날씨 이미지" width="30" height="30"></li>`;
	        }
	    }
	
	    weatherContent += '                </ul>' +
	                      '            </div>' + 
	                      '        </div>' + 
	                      '    </div>' + 
	                      '</div>';
	
	    // 오버레이 생성
	    const customOverlay = new kakao.maps.CustomOverlay({
	        position: position,
	        content: weatherContent,
	        xAnchor: 0.5,
	        yAnchor: 1.5,
	        map: map
	    });
	
	    // 기존 오버레이가 있으면 닫기
	    if (marker.customOverlay) {
	        marker.customOverlay.setMap(null);
	    }
	
	    // 새 오버레이를 마커의 속성으로 저장
	    marker.customOverlay = customOverlay;
	
	    // 오버레이 표시
	    customOverlay.setMap(map);
	}



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
    
    function valueCheck(category, value) {
        // 기상 값에 따라 이미지를 선택하는 로직
        console.log("값확인을 위한 콘솔로그"+category, value);

        if (category === "낙뢰") {
                return value + "kA(킬로암페어)";
        }

        if (category === "강수 형태") {
            switch (value) {
                case '0':
                    return "강수 없음";
                case '1':
                    return "비";
                case '2':
                    return "비 또는 눈";
                case '3':
                    return "눈";
                case '5':
                    return "빗방울";
                case '6':
                    return "빗방울,눈날림";
                default:
                    return '/resources/images/없음.gif';  // 기본 이미지 설정
            }
        }

        if (category === "하늘 상태") {
            switch (value) {
                case '1':
                    return "맑음";
                case '3':
                    return "구름많음";
                case '4':
                    return "흐림";
                default:
                    return '/resources/images/없음.gif';  // 기본 이미지 설정
            }
        }

        if (category === "기온") {
            return  value + "℃";
        }

        if (category === "습도") {
            return value + "%";
        }

        if (category === "풍속") {
            return value + "m/s";
        }

        return '/resources/images/없음.gif';  // 기본 이미지로 설정
    }
</script>
<style>
    .wrap {
        position: absolute;
        left: 0;
        bottom: 40px;
        width: 400px;
        height: 220px;
        margin-left: -200px;
        font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;
        line-height: 1.5;
        
    }
    .wrap .info {
        width: 360px;
        height: 200px;
        border-radius: 5px;
        border: 1px solid #ccc;
        background: #fff;
        overflow: hidden;
        border-radius: 20px;
        background-color: rgba(255, 255, 255, 0.9); /* 배경색만 투명하게 설정 */
        
    }
    .info .title {
		padding: 5px 10px 5px 10px; /* 좌우 여백 조정 */
	    background: #eee;
	    font-size: 15px;
	    font-weight: bold;
	    text-align: left;
	    position: relative; /* 닫기 버튼 위치 조정을 위해 position 추가 */
	    
    }
    .info .desc {
        margin: 1px 0 0 50px;
        height: 150px;
        overflow-y: auto;
    }
    .info .desc .weather-list li {
        display: flex;
        justify-content: space-between;
        padding: 5px;
    }
    /* CSS 수정 부분 */

	.overlayClose {
	    position: absolute;
	    right: 8px;  /* 닫기 버튼을 제목 오른쪽에 위치하도록 조정 */
	    top: 8px;    /* 닫기 버튼이 제목 상단에 맞게 조정 */
	    font-size: 14px;  /* 닫기 버튼의 크기 조정 */
	    cursor: pointer;  /* 마우스 커서를 손가락 모양으로 변경 */
	    color: #333;
	}
	.img img {
		margin-left: 30px;
		margin-top: 45px;
	}
	#menu_wrap {
    position: absolute;
    top: 120px;   /* 상단 여백을 줄여서 지도의 상단에 맞춤 */
    left: 10px;
    height: 680px;  /* 지도 높이와 일치하도록 설정 */
    width: 250px;
    margin: 0;  /* 여백 제거 */
    padding: 5px;
    overflow-y: auto;
    background: rgba(255, 255, 255, 0.9);
    z-index: 10;  /* z-index 값을 지도보다 높게 설정 */
    font-size: 12px;
    border-radius: 10px;
    background-color: rgba(255, 255, 255, 0.5); /* 배경색만 투명하게 설정 */
}



#icList {
    list-style: none;
    padding: 0;
    margin: 0;
    
}

#icList li {
    padding: 8px;
    border-bottom: 1px solid #ccc;
    background-color: #f9f9f9;
    cursor: pointer;
    background-color: rgba(255, 255, 255, 0.3); /* 배경색만 투명하게 설정 */
}
#icList li:hover {
    background-color: #e0e0e0;
}
	
</style>
</head>
<body>
    <h2>기상청 API와 한국도로공사 API를 활용하여 카카오맵 연동한 예제</h2>
    <p>각 IC(도로공사 영업소 기준) 날씨 정보입니다.</p>
    <div id="menu_wrap" class="bg_white">
    <div class="option">
        <b>영업소 목록</b>
    </div>
    <hr>
    <ul id="icList"></ul> <!-- IC 목록을 표시할 UL 태그 추가 -->
</div>
    
    <div id="map" style="width:100%;height: 700px;"></div>
</body>
</html>
