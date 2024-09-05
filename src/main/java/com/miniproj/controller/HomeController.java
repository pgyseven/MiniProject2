package com.miniproj.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.miniproj.model.HBoardVO;
import com.miniproj.model.MyResponseWithData;
import com.miniproj.model.MyResponseWithoutData;
import com.miniproj.model.SearchBookJSON;
import com.miniproj.service.hboard.HBoardService;
import com.miniproj.util.PropertiesTask;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@Autowired
	private HBoardService hbService;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model, HttpSession ses) {

		if (ses.getAttribute("destPath") != null) {
			ses.removeAttribute("destPath");
		}
		
		try {
			System.out.println(PropertiesTask.getPropertiesValue("naverApiKey"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
//		logger.info("Welcome home! The client locale is {}.", locale);
//		
//		Date date = new Date();
//		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
//		
//		String formattedDate = dateFormat.format(date);
//		
//		model.addAttribute("serverTime", formattedDate );

		return "index";
	}

	@RequestMapping("/weather")
	public void goWeatherPage() {

	}

	@RequestMapping("/movie")
	public void goMoviePage() {

	}

	@RequestMapping("/news")
	public void goNewsPage() {

	}

	@RequestMapping("/saveCookie")
	public ResponseEntity<String> saveCookie(HttpServletResponse response) {
		System.out.println("쿠키를 저장하자");

		Cookie myCookie = new Cookie("notice", "N"); // name, value

		myCookie.setMaxAge(60 * 60 * 24); // 쿠키 만료일 설정(만료일이 되면 자동으로 쿠키가 삭제된다.)

		response.addCookie(myCookie);

		return new ResponseEntity<String>("success", HttpStatus.OK);
	}

	@RequestMapping(value = "/readCookie", produces = "application/json; charset=UTF-8;")
	public ResponseEntity<MyResponseWithoutData> readCookie(HttpServletRequest request) {
		System.out.println("쿠키를 읽어보자");

		MyResponseWithoutData result = null;

		Cookie[] cookies = request.getCookies();
		// 이름이 notice인 쿠키가 있는지 확인
		for (int i = 0; i < cookies.length; i++) {
			if (cookies[i].getName().equals("notice") && cookies[i].getValue().equals("N")) {
				// 이름이 notice인 쿠키가 있고, 그 값이 N이다.
				result = new MyResponseWithoutData(200, null, "success");
			}
		}

		if (result == null) {
			result = new MyResponseWithoutData(400, null, "fail");
		}

		return new ResponseEntity<MyResponseWithoutData>(result, HttpStatus.OK);
	}

	@RequestMapping(value = "/get5Boards", produces = "application/json; charset=UTF-8;")
	public ResponseEntity<List<HBoardVO>> get5Boards() {
		ResponseEntity<List<HBoardVO>> result = null;
		try {
			List<HBoardVO> popBoards = hbService.getPopularBoards();

			result = new ResponseEntity<List<HBoardVO>>(popBoards, HttpStatus.OK);
		} catch (Exception e) {

			e.printStackTrace();
			result = new ResponseEntity<List<HBoardVO>>(HttpStatus.CONFLICT);
		}
		return result;
	}

	@RequestMapping("/sampleInterceptor")
	public void sampleInterceptor() {
		// interceptor의 preHandle이 동작
		System.out.println("sampleInterceptor() 호출!!!!!!!!!!!!!!");

		// /sampleInterceptor.jsp를 찾아 response
	}

	@RequestMapping("/chartEx1")
	public String showCartPage() {
		return "/chartEx3";
	}

	@RequestMapping(value = "/seoulTemp", produces = "application/json; charset=UTF-8;")
	public ResponseEntity getSeoulTemp() {

		ResponseEntity result = null;

		try {
			hbService.getSeoulTemp();

			result = new ResponseEntity(MyResponseWithData.success(hbService.getSeoulTemp()), HttpStatus.OK);
		} catch (Exception e) {

			e.printStackTrace();
			result = new ResponseEntity(MyResponseWithData.fail(), HttpStatus.BAD_REQUEST);
		}

		return result;
	}

	@RequestMapping("/mapEx1")
	public String showMapEx1() {
		return "/tour/tourList";
	}

	@RequestMapping("/tourSub")
	public String showMapEx1Subfd() {
		return "/tour/tourSub";
	}

	@RequestMapping("/bookSearch")
	public String showBookSearch() {
		return "/bookSearch";
	}

	@RequestMapping(value = "/searchBook", produces = "application/json; charset=UTF-8;")
	public @ResponseBody String searchBook(@RequestParam("searchValue") String query) { // @ResponseBody 제이슨 형식의 문자열이 반환된다고 알려준거임
		System.out.println(query + " 책을 검색하자");

		String clientId = "eXCsDoRaGoMbaWd2ns_Z"; // 애플리케이션 클라이언트 아이디
		String clientSecret = "_jzpe2QpKd"; // 애플리케이션 클라이언트 시크릿

		String text = null;
		try {
			text = URLEncoder.encode(query, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException("검색어 인코딩 실패", e);
		}

		String apiURL = "https://openapi.naver.com/v1/search/book.json?query=" + text; // JSON 을 요청할 api 주소

		Map<String, String> requestHeaders = new HashMap<>(); // 위의 쿼리문과 함께 편지봉투에 아이디와 비번
		requestHeaders.put("X-Naver-Client-Id", clientId);
		requestHeaders.put("X-Naver-Client-Secret", clientSecret);

		String responseBody = get(apiURL, requestHeaders); // 응답된 json / 메서드 호출

		System.out.println(responseBody);
		
		// 이 결과에 나오는 책들은 DB 에 없으므로 ... insert를 시킨다. -> DTO 객체로 변환(json문자열 -> 자바객체)

		makeJavaObject(responseBody);
		
		return responseBody;
	}

	private void makeJavaObject(String responseBody) {
		Gson gson = new Gson();
		SearchBookJSON obj = gson.fromJson(responseBody, SearchBookJSON.class);
		System.out.println(obj.toString());
		
	}

	private String get(String apiURL, Map<String, String> requestHeaders) {
		HttpURLConnection con = connect(apiURL);
		
		try {
            con.setRequestMethod("GET"); //통신방식 지정 네이버 서버는 get 방식이라 써있음
            
            // Map<String, String>(api서버에 접속하기 위한 id, pwd)를 반복하기 위해 Map.entry<K,V> 를 사용
            // 반복하며 request 객체의 속성에 넣어줌
            for(Map.Entry<String, String> header :requestHeaders.entrySet()) { // 우리는 맵 이전에 로그인로그 aop 에서는 키리스트 가져와서 해당 값을 가져왔지만 이렇게 할 수 있다.
                con.setRequestProperty(header.getKey(), header.getValue());
            }


            int responseCode = con.getResponseCode(); //api 서버에 접속하여 응답코드를 얻어옴, 응답코드를 얻어옴 즉 우리 ajax에서400 200코드 얻어오는식
            if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
                return readBody(con.getInputStream()); // api 서버가 응답하는 (스트림데이터)2진데이터를 얻어와 readBody() 로 호출 / Input 내 톰캣서버 기준으로 들어오는 네이버api 로부터 입력되는 데이터 즉 네이버 서버가 준 데이터를 가져옴
            } else { // 오류 발생
                return readBody(con.getErrorStream());
            }
        } catch (IOException e) {
            throw new RuntimeException("API 요청과 응답 실패", e);
        } finally {
            con.disconnect(); // api 서버 접속 해제
        }
		
	
	}
	
	
	
    private String readBody(InputStream body){
        InputStreamReader streamReader = null;
		try {
			streamReader = new InputStreamReader(body, "UTF-8"); // InputStreamReader 1바이트 즉 1문자씩 읽음 사실 버터드 리더를 쓰기위한거

		} catch (UnsupportedEncodingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} 

        try (BufferedReader lineReader = new BufferedReader(streamReader)) { //여기 try괄호는 통신객체 만들때 예외처리 즉 버터드 리더로 만들때 성공과 실패 가를때 여기서 성공하면 바로 아래줄 //라인 리더는 한줄씩 //BufferedReader 버퍼 메모리! 인풋 스트림 리더로 읽어도 되지만 cpu가 다른걸 못함 그래서 이걸 버퍼드 한테 맞겨서 걔가 한문자씩 조합다 해서 한번에 보내게 그동한 cpu는 다른일 함
            StringBuilder responseBody = new StringBuilder();//StringBuilder 객체 생성 / 스트링보다는 스트링 빌더가 내부에서 더 빠르다 많은 문자열은 이걸로!


            String line;
            while ((line = lineReader.readLine()) != null) { //널이 아니면 즉 데이터가 없는 데이터의 끝이 아닐동안 반복하면서 읽음
                responseBody.append(line); //문자열을 담은 객체에 추가
            }


            return responseBody.toString(); // json 문자열 반환
        } catch (IOException e) {
            throw new RuntimeException("API 응답을 읽는 데 실패했습니다.", e);
        }
    }
    

	//apiURL 주소로 부터 그 주소의 서버에 접속 할 수 있는 connection 객체를 얻어서 반환해주는...
	private HttpURLConnection connect(String apiURL) {
		try {
			URL url = new URL(apiURL); // 스트링으로(문자열로된 서버의 주소를) 받은 주소를 실제 url 객체로 만듬
			return (HttpURLConnection) url.openConnection(); // (HttpURLConnection) 다운캐스팅 부모가 URL 커넥션/ 커넥션 객체를 얻어옴 즉 디비에 접속하기 위해  URLConnection
		} catch (MalformedURLException e) { //url 주소 잘못되면
			throw new RuntimeException("API URL이 잘못되었습니다. : " + apiURL, e);
		} catch (IOException e) { //연결객체 못 얻어오면
			throw new RuntimeException("연결이 실패했습니다. : " + apiURL, e);
		}

	}
}