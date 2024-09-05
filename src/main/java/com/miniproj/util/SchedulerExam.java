package com.miniproj.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.miniproj.service.member.MemberService;

@Component // 컴포넌트로 선언하면 MVC  패턴에 포함은 안되지만 스프링으로 관리하겠다임
@EnableScheduling
public class SchedulerExam {

	
	   @Autowired
	   private MemberService mService;

	
	// 예약한 스캐줄에 작동 하루에 한번 또는 유저가 없는 시간에 또는 몇분마다 몇초마다 한달에 한번 이런식으로도 가능
	  @Scheduled(cron = "0/10 * * * * *") // 10초에 한번씩 Scheduler 작동
	   public void testScheduler() {
	      System.out.println("스케줄러 작동 ~~~~~~");
	      System.out.println(mService.toString()); 
	      
	      // 이걸 이용해서 3일 후 구매완료 기능 구현하기
	   }
	}
