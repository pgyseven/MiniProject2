package com.miniproj.aop;

import java.io.File;
import java.io.FileWriter;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.miniproj.model.LoginDTO;
import com.miniproj.model.MemberVO;
import com.miniproj.persistence.MemberDAO;
import com.miniproj.util.GetClientIPAddr;

/**
 * @작성자 : 802-01
 * @작성일 : 2024. 8. 26.
 * @프로젝트명 : MiniProject2
 * @패키지명 : com.miniproj.aop
 * @파일명 : LoginlogAOP.java
 * @클래스명 : LoginlogAOP
 * @description : 로그인 하는 멤버의 정보를 얻어내어 그 정보를 텍스트 파일로 저장하자! (로그인을 시도하는 유저의 로그를 남겨보자)
 * 
 * 로그인 과정의 프로세스 흐름,(로그인 인터셉터와 AOP의 조합이므로 아래의 흐름을 잘 파악하며 코딩해야한다.)
 * MemberServiceImpl.login() 끝난 후 -> AOP(로그인 실패) -> Controller -> LoginInterceptor.postHandle()
 */
@Component
@Aspect
public class LoginlogAOP { //joinpoint 보다 강력하고 더 많이 씀  그리고 AOP는  리퀘스트 못 받아옴  즉 리퀘스트 세션 다 참조 못함 서브스에서 작동하는거라
	
	private static final Logger logger = LoggerFactory.getLogger(ExampleAdvice.class);
	private String logContent;
	private static Map<String, Integer> tryLoginCount = new ConcurrentHashMap<String, Integer>(); //재너릭에서는 int가 아니라 integer
	// 객체의 것이 아니라 클래스의 것이니깐 this.tryLoginCount 라고 원래는 하면 완됨 LoginlogAOP. tryLoginCount 이렇게 해야하지만 같은 클래스내니깐 생략해도됨
	@Autowired
	private MemberDAO mdao; // aop 스프링 영역에서 동작하니깐 dao 에도 접근 가능
	
	
	// Around : Before + After  동시에 수행되도록 하는 어노테이션
	@Around("execution(* com.miniproj.service.member.MemberSrerviceImpl.login(..))") // @Around 는 before 와 after 둘다 작동함
	public Object betweenMemberLogin(ProceedingJoinPoint pjp) throws Throwable {
		
		logger.info("================AOP Before================");
		
		
		// --------------------------- MemberServiceImpl.login() 가 실행되기 이전에 수행할 부분 ------------------
		Object[] params = pjp.getArgs();
		LoginDTO loginDTO = (LoginDTO)params[0];
		
		logger.info("로그인 시도 하려는 유저 정보 : " + loginDTO.toString());
		
		long curTime = System.currentTimeMillis();
		String loginTime = new Date(curTime).toString();// Date - util 현재 날짜 현재 시간을 long 타입으로 얻어옴
		String who = loginDTO.getUserId();
		String ipAddr = loginDTO.getIpAddr();
		Calendar now = Calendar.getInstance(); //  추상메서드라 new 안되고 싱글톤이라서 겟 인스턴스 해야함
		String year = now.get(Calendar.YEAR) + ""; 
		String month = year + new DecimalFormat("00").format(now.get(Calendar.MONTH) + 1);  
		String when = month + new DecimalFormat("00").format(now.get(Calendar.DATE)); 
		
		this.logContent = loginTime + "," + who + "," + ipAddr;
		
		System.out.println(this.logContent);
		logger.info("================AOP After================");
		
		// --------------------------- MemberServiceImpl.login() 가 실행된 이후에 수행할 부분 ------------------
		// 현재 Advice 에 걸려있는 target 메서드를 호출하고,
		// target 메서드가 반환한 값을 가져온다.
		Object result = pjp.proceed();
		
		if (result == null) {
			this.logContent += "," + "login Fail";
			result = saveLoginFail(who, result);
			
		}else {
			this.logContent += "," + "login Success";
			removeLoginFail(who);
		}
		
		// loginLog.csv로 저장
		String logSavePath = "D:\\lecture\\spring\\MiniProject2\\src\\main\\webapp\\resources\\logs";
		
		FileWriter fw = new FileWriter(logSavePath + File.separator + "log_"+ when + ".csv", true); //여기서 true 해야지 추가됨 즉 덮어쓰기가 안됨
		fw.write(this.logContent);
		fw.write("\n");
		
		fw.flush();
		fw.close();
		
		return result; //  target  메서드 실행 후 반환되는 값을 다시 컨트롤러 단으로 돌려줌
	}


	private void removeLoginFail(String who) {
		// 로그인에 성공 했을 경우 이전에 실패한 기록이 있다면 , 실패한 기록을 삭제 해줘야 한다.
		if(tryLoginCount.containsKey(who)) {
			tryLoginCount.remove(who);
			
		}
		outputTryLoginCount();
	}


	private Object saveLoginFail(String failedUserId, Object result) throws Exception { //스테틱 맴버는 이탤릭체
		// 기존에 로그인 실패한 기록이 있다면 기존의 횟수 +1 다시 저장
		if(tryLoginCount.containsKey(failedUserId)) {
			int beforeFailedCount = this.tryLoginCount.get(failedUserId);
			
			++beforeFailedCount; //고그인 횟수 1증가
			if (beforeFailedCount <= 4) {
				
				tryLoginCount.put(failedUserId, beforeFailedCount);
			}else if(beforeFailedCount == 5){
				//로그인 시도 횟수를 초과한 유저이므로 계정을 잠궈야 한다.
				
				System.out.println(failedUserId + "의 계정을 잠그자~");
				
				mdao.updateAccountLock(failedUserId); //계정잠금
				removeLoginFail(failedUserId); // 계정 잠금 후 이전에 로그인 기록을 삭제
				
				MemberVO memberVO = (MemberVO)result;
				
				result = MemberVO.builder()
						.userId(failedUserId)
						.islock("Y")
						.build();
			
			}
		} else { // 기존에 로그인 실패한 기록이 없다.
			tryLoginCount.put(failedUserId, 1);
		}
		
		
		outputTryLoginCount();
		
		return result;
		
	}


	private void outputTryLoginCount() {
		System.out.println("================로그인 시도 횟수 카운트==============");
		Set<String> keys = tryLoginCount.keySet(); //set 중복되지 않은 키는 중복되지 않으니깐
		for(String k :keys) {
			System.out.println(k + " : " + tryLoginCount.get(k));
			System.out.println("=======================================");
			
		}
			
	}
}
