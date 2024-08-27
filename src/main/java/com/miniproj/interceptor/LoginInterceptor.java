package com.miniproj.interceptor;

import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Locale;
import java.util.Map;

import javax.print.attribute.standard.Destination;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.WebUtils;

import com.miniproj.model.AutoLoginInfo;
import com.miniproj.model.MemberVO;
import com.miniproj.service.member.MemberService;
import com.miniproj.util.DestinationPath;
import com.mysql.cj.util.StringUtils;

// 직접 로그인하는 동작과정을 인터셉트로 구현
// get방식 post방식으로 요청되어 인터셉트가 동작하는 것을 구분
public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Autowired
	private MemberService service;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		boolean isLoginPageShow = false;
		HttpSession ses = request.getSession();
		// 요청이 GET방식일 때만 수행한다
		if (request.getMethod().toUpperCase().equals("GET")) {
			System.out.println("[LoginInterceptor preHandle()호출]");

			// 이미 로그인이 된 경우 로그인 페이지를 보여줄 필요가 없다
			// 쿠키가 존재하지 않는다면 로그인페이지로 이동
			if (request.getParameter("redirectUrl") != null) {

				// 댓글 작성/수정/삭제 시도하려다 로그인페이지로 인터셉트 되었을 때
				String uri = request.getParameter("redirectUrl");
				int boardNo = Integer.parseInt(request.getParameter("boardNo"));

				if (uri.contains("view")) {

					// 로그인 후 이전 페이지로 이동
					System.out.println("이전 페이지 글번호 : " + boardNo);
					ses.setAttribute("destPath", "/rboard/viewBoard?boardNo=" + boardNo);
				}
			}

			Cookie autoLoginCookie = WebUtils.getCookie(request, "al");
			if (autoLoginCookie != null) { // 쿠키에 저장했던 자동로그인체크 유저의 세션값

				// 자동로그인 쿠키가 있을 때
				String savedCookieSessionId = autoLoginCookie.getValue();

				// 쿠키(맵형식)에 자동로그인정보가 있으면 DB에서 일치하는 유저를 자동로그인시킴 > 로그인페이지 건너뛰기
				MemberVO autoLoginUser = service.checkAutoLogin(savedCookieSessionId);

				ses.setAttribute("loginMember", autoLoginUser);

				Object dp = ses.getAttribute("destPath");
				response.sendRedirect((dp != null) ? (String) dp : "/");

			} else {
				if (request.getSession().getAttribute("loginMember") == null) {
					// 자동로그인 쿠키가 없고, 로그인되어있지 않은 경우에 로그인페이지를 보여줌
					isLoginPageShow = true;
				} else {
					// 쿠키가 없고 로그인한 경우
					isLoginPageShow = false;
				}
			}
		} else if (request.getMethod().toUpperCase().equals("POST")) {
			isLoginPageShow = true;
		}
		return isLoginPageShow;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {

		
		HttpSession ses = request.getSession(); // 로그인요청으로부터 세션을 얻어온다...
		// 포스트방식으로 호출됐을 때만 이 인터셉트가 실행됨
		if (request.getMethod().toUpperCase().equals("POST")) {
			System.out.println("[LoginInterceptor postHandle()호출]");
			Map<String, Object> model = modelAndView.getModel();
			MemberVO loginMember = (MemberVO) model.get("loginMember");

			if (loginMember != null) {
				if (loginMember.getIslock().equals("Y")) {
					System.out.println(loginMember.getUserId() + "계정이 잠긴 유저가 로그인");
				
				ses.setAttribute("destPath", "/member/reAuth");
				
			} else { // 계정이 잠기지 않은 유저
				
				System.out.println("[LoginInterceptor postHandle() : 로그인 성공]");
				
				ses.setAttribute("loginMember", loginMember); // 로그인한 유저의 정보를 세션에 저장

				// request에서 자동로그인 체크 여부 확인(로그인 성공한 사람) > 쿠키에 저장
				if (request.getParameter("remember") != null) { // getParameter : on/null
					saveAutoLoginInfo(request, response); // 자동로그인 정보 저장 메서드
				}
				
			}
				
				// 로그인 하기 이전에 저장한 경로 있다면 그쪽으로 가고 // 없다면 "/ "페이지 이동
				Object tmp = ses.getAttribute("destPath");
				response.sendRedirect((tmp == null) ? "/" : (String) tmp);
			} else {
				System.out.println("[LoginInterceptor postHandle() : 로그인 실패]");
				response.sendRedirect("/member/login?status=fail");
			}
		}

}

	private void saveAutoLoginInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 자동로그인 체크한 유저의 MemberVO DB에 세션값과 만료일 저장
		String sesid = request.getSession().getId();
		MemberVO loginMember = (MemberVO) request.getSession().getAttribute("loginMember");
		String loginUserId = loginMember.getUserId();
		Timestamp allimit = new Timestamp(System.currentTimeMillis() + (1000 * 60 * 60 * 24 * 7)); // 현재날짜시간을 ms단위로 가져옴

		//
//      Instant instant = allimit.toInstant(); // Instant 시간값의 의미를 가지는 추상클래스
//      ZonedDateTime gmtDateTime = instant.atZone(ZoneId.of("GMT"));
//      Timestamp gmtAlLimit = Timestamp.from(gmtDateTime.toInstant());
//      System.out.println(allimit.toString());
//      SimpleDateFormat sd = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z");
//      System.out.println(sd.format(new java.sql.Date(System.currentTimeMillis())));

		if (service.saveAutoLoginInfo(new AutoLoginInfo(loginUserId, sesid, allimit))) {
			// 쿠키만들 때는 name, value, Expires
			// Expires : Session 세션이 유지될 때까지 유효
			Cookie autoLoginCookie = new Cookie("al", request.getSession().getId());
			autoLoginCookie.setMaxAge(60 * 60 * 24 * 7); // 일주일동안 쿠키 유지(자동로그인기간)
			autoLoginCookie.setPath("/"); // 쿠키가 다른 경로에서도 유효하도록 설정
			response.addCookie(autoLoginCookie); // response객체에 쿠키 저장

		}

	}

}
