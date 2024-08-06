package com.miniproj.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.miniproj.model.MemberVO;


// 역할 : 직접 로그인을 하는 동작과정을 인터셉터로 구현한다.(유저가 로그인 페이지로 가서 로그인 할 때 사용)

public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		System.out.println("[LoginInterceptor...preHandle() 호출]");
		
		// 이미 로그인이 되어있는 경우에는 로그인 페이지를 보여줄 필요가 없다.
		// 로그인이 되어있지 않은 경우에만 로그인 페이지를 보여줘야 한다.
		
		return true;
	}

	@Override
	// GET방식으로 요청된건지 POST방식으로 요청되어서 인터셉터가 동작하는지를 구분해서 코딩을 해야 한다.
	// 이 인터셉터는 POST방식으로 요청되었을 때만 동작해야 한다.
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		
		if (request.getMethod().toUpperCase().equals("POST")) {
			// POST방식으로 호출했을 때만 실행되도록 한다.
			System.out.println("[LoginInterceptor...postHandle() 호출]");
			Map<String, Object> model = modelAndView.getModel();
			MemberVO loginMember = (MemberVO) model.get("loginMember");
			if (loginMember != null) {
				System.out.println("[LoginInterceptor...postHandle() : 로그인 성공!]");

				// 로그인한 유저의 세션에 해당 유저의 정보를 넣어준다.
				HttpSession ses = request.getSession();
				ses.setAttribute("loginMember", loginMember);

				// 홈페이지로 이동
				response.sendRedirect("/");

			} else {
				System.out.println("[LoginInterceptor...postHandle() : 로그인 실패!]");

				response.sendRedirect("/member/login?status=fail");
			} 
		}
	}

}
