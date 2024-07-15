<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비동기 데이터 통신을 이용하여 xml파일을 전송받아 파싱하여 출력해 보자</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	function getNewsData(){
        $.ajax({
         url : 'https://mbn.co.kr/rss/enter/',             // 데이터가 송수신될 서버의 주소
         type : 'GET',                                     // 통신 방식 : GET, POST, PUT, DELETE, PATCH   
         dataType : 'xml',                                 // 수신 받을 데이터의 타입 (text, xml, json)
         success : function (data) {                       // 비동기 통신에 성공하면 자동으로 호출될 callback function
            console.log(data);
            outputNews(data);
         }
      });
    };

    function outputNews(data) {
        // getElementById() // 아이디 속성으로 태그(단일 속성이기 때문에 element)를 얻어오는 메소드
        // getElementsByClassName() // class 속성으로 태그(여러개일 수 있기 때문에 복수 elements)를 얻어오는 메소드
        
        let channel = data.getElementsByTagName('channel')[0];
        // 태그 이름으로 태그 요소(복수)를 가져와라 / 복수 요소는 무조건 배열 타입으로 가져온다. 우리가 가져오려는 channel은 0번째 배열에 존재한다.
		console.log(channel);

		// xml에서의 문자열 주석처리 한것을 다시 처리해야 출력됨
		let title = channel.getElementsByTagName('title')[0].innerHTML.replace("<![CDATA[", "");
		title = title.replace("]]>", "");
		$('.title').html(title);

		let newsLink = channel.getElementsByTagName('link')[0].innerHTML;
		console.log(newsLink);
		
		$('#newsLink').attr('href', newsLink);	
		
		let description = removeCDATA(channel.getElementsByTagName('description')[0].innerHTML);
		$('.desc').html(description);

		let items = channel.getElementsByTagName('item');
		console.log(items);

		// $.each()와 부트스트랩의 collapse을 이용하여 출력해 보세요....

		let output = '';
		$.each(items, function(i, e){
			output += '<div class="card">';
			let title = removeCDATA($(e).children().eq(0).html());
    		output += `<div class="card-body" data-bs-toggle="collapse" data-bs-target="#demo\${i}">\${title}</div>`;
			let desc = removeCDATA($(e).children().eq(3).html());
			console.log(desc);
			output += `<div id="demo\${i}" class="collapse">\${desc}</div>`;
			output += '</div>';
		});

		$('.newsList').html(output);
    }

	function removeCDATA(str) {
		str = str.replace("<![CDATA[", "");
		return str.replace("]]>", "");
	}
    
	$(function() {
        getNewsData();  
    });
</script>
<style>
	.collapse {
		padding : 8px;
		font-size: 0.8em;
	}
</style>
</head>
<body>
	<div class="container">
		<c:import url="./header.jsp" />

		<div class="content">
			<h1>news.jsp</h1>

			<a id='newsLink'><h3 class="title"></h3></a>
			<h6 class="desc"></h6>

			<div class="newsList"></div>
		</div>

		<c:import url="./footer.jsp" />
	</div>

	
</body>
</html>