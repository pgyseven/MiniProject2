package com.miniproj.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

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

import com.miniproj.model.HBoardVO;
import com.miniproj.model.MyResponseWithData;
import com.miniproj.model.MyResponseWithoutData;
import com.miniproj.service.hboard.HBoardService;

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
		
		
		if(ses.getAttribute("destPath")!= null) {
			ses.removeAttribute("destPath");
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
		
		myCookie.setMaxAge(60*60*24); // 쿠키 만료일 설정(만료일이 되면 자동으로 쿠키가 삭제된다.)
		
		response.addCookie(myCookie);
		
		return new ResponseEntity<String>("success", HttpStatus.OK);
	}
	
	@RequestMapping(value="/readCookie", produces="application/json; charset=UTF-8;")
	public ResponseEntity<MyResponseWithoutData> readCookie(HttpServletRequest request) {
		System.out.println("쿠키를 읽어보자");
		
		MyResponseWithoutData result = null;
		
		Cookie[] cookies = request.getCookies();
		// 이름이 notice인 쿠키가 있는지 확인
		for(int i = 0 ; i < cookies.length ; i++) {
			if(cookies[i].getName().equals("notice") && cookies[i].getValue().equals("N")) {
				// 이름이 notice인 쿠키가 있고, 그 값이 N이다.
				result = new MyResponseWithoutData(200, null, "success");
			} 
		}
		
		if(result == null) {
			result = new MyResponseWithoutData(400, null, "fail");
		}
		
		return new ResponseEntity<MyResponseWithoutData>(result, HttpStatus.OK);
	}
	
	   @RequestMapping(value="/get5Boards", produces = "application/json; charset=UTF-8;")
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
	   
	   
	   
	   @RequestMapping(value="/seoulTemp" , produces = "application/json; charset=UTF-8;")
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
	   
	   
	}