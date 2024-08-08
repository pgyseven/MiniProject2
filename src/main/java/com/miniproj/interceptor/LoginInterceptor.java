package com.miniproj.interceptor;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.miniproj.model.AutoLoginInfo;
import com.miniproj.model.MemberVO;
import com.miniproj.service.member.MemberService;
import com.mysql.cj.util.StringUtils;


// 역할 : 직접 로그인을 하는 동작과정을 인터셉터로 구현한다.(유저가 로그인 페이지로 가서 로그인 할 때 사용)

public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Autowired
	private MemberService service;
	
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
				
				// 만약 자동로그인(remember me)을 체크한 유저라면~
				if (request.getParameter("remember") != null) {
					saveAutoLoginInfo(request, response);
				}

//				if(ses.getAttribute("destPath") != null) {
//					response.sendRedirect((String)ses.getAttribute("destPath"));
//				} else {
//					response.sendRedirect("/");
//				}
				
				// 위의 if문을 3항 연산자로 바꿔서 사용했음
				// 로그인하기 이전에 저장한 경로가 있다면 그 경로로 가고
				// 없다면 "/"로 페이지 이동
				Object tmp = ses.getAttribute("destPath");
				response.sendRedirect((tmp == null) ? "/" : (String)tmp);
				
				

			} else {
				System.out.println("[LoginInterceptor...postHandle() : 로그인 실패!]");

				response.sendRedirect("/member/login?status=fail");
			} 
		}
	}

	private void saveAutoLoginInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 자동로그인을 체크한 유저의 컬럼에 세션값과 만료일을 DB에 저장해줘야 한다.
		String sesid = request.getSession().getId();
		MemberVO loginMember = (MemberVO)request.getSession().getAttribute("loginMember");
		String loginUserId = loginMember.getUserId();		
		
		Timestamp allimit = new Timestamp(System.currentTimeMillis() + (1000 * 60 * 60 * 24 * 7));
		
		Instant instant = allimit.toInstant();
		ZonedDateTime gmtDateTime = instant.atZone(ZoneId.of("GMT"));
		Timestamp gmtAlLimit = Timestamp.from(gmtDateTime.toInstant());
		
		System.out.println("timestamp : " + allimit.toString());
		
		SimpleDateFormat sd = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z");
		
		System.out.println("simpledateFormat : " + sd.format(new java.sql.Date(System.currentTimeMillis())));
		
		if(service.saveAutoLoginInfo(new AutoLoginInfo(loginUserId, sesid, allimit))) {
			
			// 자동로그인을 체크 했을 때의 세션을 쿠키에 넣어둔다.
			Cookie autoLoginCookie = new Cookie("al", request.getSession().getId()); // al에 유저아이디가 아닌 세션 아이디를 넣어준다.
			autoLoginCookie.setMaxAge(60 * 60 * 24 * 7); // 일주일동안 쿠키 유지(자동 로그인 기간 : 일주일)
			autoLoginCookie.setPath("/"); // 쿠키가 저장될 경로 설정(해당 경로일 때 쿠키 확인 가능)
			response.addCookie(autoLoginCookie);
		}
		
	}

}
