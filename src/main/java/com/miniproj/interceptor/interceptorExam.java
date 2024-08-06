// 패키지명.클래스명 => class full name
package com.miniproj.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

// Interceptor는 컨트롤러에 들어오는 요청 request와 컨트롤러가 응답하는 response를 가로채는 역할을 한다.

public class interceptorExam extends HandlerInterceptorAdapter {
	// adapter 패턴 : 어떤 객체를 만들 때 가이드 역할을 하는 객체가  adapter 객체이다. 그리고 이것은 추상 클래스다.
	// HandlerInterceptorAdapter(추상 클래스)를 상속받아 비로소 interceptorExam가 인터셉터 객체가 된 것이다.
	// 추상 클래스는 일반 멤버도 가지고 있기 때문에 interceptorExam를 객체로 만들 수 있다. 그러나 추상 클래스의 기능을 구현해도 좋다면 오버라이딩해서 구현해도 된다.
	
	
	@Override
	// preHandle : mapping되는 컨트롤러단의 메소드가 호출되기 이전에 request와 response를 빼앗아와서 동작
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		
		System.out.println("인터셉터 preHandle 동작~~~~~~~~~~~~");
		
		// return false; <- 해당 컨트롤러단의 메소드로 제어가 돌아가지 않는다.
		// return true; <- 해당 컨트롤러단의 메소드로 제어가 돌아간다.
		return super.preHandle(request, response, handler);
	}

	@Override
	// postHandle : mapping되는 컨트롤러단의 메소드가 호출되어 실행된 후에 request와 response를 빼앗아와서 동작
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		
		
		System.out.println("인터셉터 postHandle 동작!~!~!~!~!~!~");
		super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	// afterCompletion : 해당 interceptor의 preHandle, postHandle의 모든 과정이 끝난 후(view단에 렌더링 된 후)에 request와 response를 빼앗아와서 동작
	// 모든 예외를 한꺼번에 공통으로 처리할 때 이 메소드를 사용한다.
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		
		
		System.out.println("인터셉터 afterCompletion 동작!!!!!!!!!!!!!!!!!!");
		super.afterCompletion(request, response, handler, ex);
	}

	
}
