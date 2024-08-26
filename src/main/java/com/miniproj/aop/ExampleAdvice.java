package com.miniproj.aop;

import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component // 스프링 컨테이너에게 객체를 만들어 관리하도록 하는 어노테이션
@Aspect // 아래의 객체를 aop객체로 사용할 것임을 명시하는 어노테이션
public class ExampleAdvice {

	private static final Logger logger = LoggerFactory.getLogger(ExampleAdvice.class); //slf4j 인터셉터는 서블릭에 의해서 작동하므로 서비스단 이후는 접근 못함 그래서 그 이후는 AOP 가 함 완전한 스프링 영역이니깐
	
	@Before("execution(public * com.miniproj.service.hboard.HBoardServiceImpl.*(..))") // 인터셉터에 프리 핸들과 같음
	public void startAOP() {
		System.out.println("================AOP 시작================");
	}



	@After("execution(public * com.miniproj.service.hboard.HBoardServiceImpl.*(..))")
	public void endAOP() {
		System.out.println("================AOP 끝================");
	}
	
}
