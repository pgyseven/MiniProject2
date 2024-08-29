package com.miniproj.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.miniproj.message.MessageService;
import com.miniproj.model.MemberVO;

public class MessageConfirmInterceptor extends HandlerInterceptorAdapter { // extends HandlerInterceptorAdapter 이걸 상속
																			// 받아야 인터셉터 된다.

	@Autowired
	private MessageService mService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		boolean result = true;

		// 로그인을 했을 때, 본인에게 온 메세지의 개수를 가져온다.

		HttpSession ses = request.getSession();

		if (ses.getAttribute("loginMember") != null) {
			// 로그인 했다.
			MemberVO loginMember = (MemberVO) ses.getAttribute("loginMember");
			System.out.println(loginMember.getUserId() + " /쪽지가 있는지 확인하자.");

			int unReadMsgCnt = mService.getMessageCount(loginMember.getUserId());
			System.out.println("읽지 않은 쪽지의 개수 : " + unReadMsgCnt);

			if (unReadMsgCnt > 0) {

				ses.setAttribute("unReadMsgCnt", unReadMsgCnt); // 세션 영역에 저장
			}
		}

		return result;
	}

}
