package com.miniproj.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.miniproj.util.DestinationPath;

/**
 * @작성자 : 802-02
 * @작성일 : 2024. 8. 7.
 * @프로젝트명 : MiniProject
 * @패키지명 : com.miniproj.interceptor
 * @파일명 : AuthInterceptor.java
 * @클래스명 : AuthInterceptor
 * @description : 
 *  로그인 인증이 필요한 페이지에서 클라이언트가 현재 로그인 상태의 여부를 검사한다.
    로그인 인증이 필요한 페이지 : 글작성, 글수정, 글삭제, 댓글작성/수정/삭제, 관리자 페이지의 모든 기능
    로그인이 되어있지 않으면 로그인을 하도록 유도, 로그인이 되어있다면 계속 원래 클라이언트가 하려던 작업을 수행하도록 한다.
    )로그인이 되어있지 않아서 로그인 페이지로 끌려갔다면 로그인을 성공한 뒤에는 원래 하려던 기능의 페이지로 돌아가게 해야한다. 
    )글수정, 글삭제, 댓글 수정/삭제 는 로그인되어 있어야할 뿐 아니라 그 글(댓글)의 주인인지도 확인해야 한다.
 */
public class AuthInterceptor extends HandlerInterceptorAdapter {

	   /**
	    * @작성자 : 802-02
	    * @작성일 : 2024. 8. 7.
	    * @메소드명 : preHandle
	    * @parameter : request, response, handler
	    * @throwsException : 
	    * @description : 
	    */
	   @Override
	   public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
	         throws Exception {
	      
	      boolean goOriginPath = false; // 원래의 목적지(기능)
	      System.out.println("[AuthInterceptor]...... preHandle 작동중!!!");
	      
	      HttpSession ses = request.getSession();
	      if (ses.getAttribute("loginMember") == null) { //로그인을 하지 않았다.
	         System.out.println("[AuthInterceptor] : 로그인 하지 않았다!");
	         
	         new DestinationPath().setDestpath(request); // 로그인하기 전 호출했던 페이지의 경로를 세션 객체에 저장
	         
	         response.sendRedirect("/member/login"); // 로그인 페이지로 끌려감(제어를 빼앗긴다)
	         
	         
	      } else { //로그인을 했다.
	         System.out.println("[AuthInterceptor] : 로그인 OK 되어있다!");
	         goOriginPath = true;
	      }
	      
	      return goOriginPath;
	   }
	
}
