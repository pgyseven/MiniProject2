package com.miniproj.controller.member;

import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.miniproj.model.MemberVO;
import com.miniproj.model.MyResponseWithoutData;
import com.miniproj.service.member.MemberService;
import com.miniproj.util.SendMailService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor //생성자를 만들때 필요할때 받아온다. 스프링이 얘를 불러와서 mService; 하고나서 MemberController
public class MemberController {

   private final MemberService mService;
   
   @RequestMapping("/register")
   public void showRegisterForm() {
      
   }
   @RequestMapping(value="/register", method = RequestMethod.POST)
   public void registerMember(MemberVO registMember, @RequestParam("userProfile") MultipartFile userProfile) {
      System.out.println("회원가입 진행~~~~~~~~~~~~~~~~" + registMember.toString());
      System.out.println(userProfile.getOriginalFilename());
   }
   
   
   
   @RequestMapping(value="/isDuplicate", method = RequestMethod.POST, produces = "application/json; charset=UTF-8;")
   public ResponseEntity<MyResponseWithoutData> idIsDuplicate(@RequestParam("tmpUserId") String tmpUserId) {
      
      System.out.println(tmpUserId + "  가 중복되는지 확인");
      
      
      MyResponseWithoutData json = null;
      ResponseEntity<MyResponseWithoutData> result = null;
      
      try {
         
         if(mService.idIsDuplicate(tmpUserId)) {
            //아이디가 중복된다.
            json = new MyResponseWithoutData(200, tmpUserId, "duplicate");
            
            
         }else {
            // 아이디가 중복되지 않는다.
            json = new MyResponseWithoutData(200, tmpUserId, "not duplicate");
         }
         result = new ResponseEntity<MyResponseWithoutData>(json, HttpStatus.OK);
         
      } catch (Exception e) {
         
         e.printStackTrace();
         result = new ResponseEntity<MyResponseWithoutData>(HttpStatus.CONFLICT);
      }
      return result;
   }
   
   @RequestMapping("/callSendMail")
   public ResponseEntity<String> sendMailAuthCode(@RequestParam("tmpUserEmail") String tmpUserEmail, HttpSession session) {
      String authCode = UUID.randomUUID().toString();
      System.out.println(tmpUserEmail + "로 " + authCode + "를 보내자~");
      
      String result = "";
      
      try {
         new SendMailService().sendMail(tmpUserEmail, authCode);
         session.setAttribute("authCode", authCode); // 인증 코드를 세션 객체에 저장
         
         result = "success";
         
         
      }  catch (MessagingException e) {
         
         e.printStackTrace();
         result = "fail";
      }
   
      return new ResponseEntity<String>(result, HttpStatus.OK);
      
   } 
   
   @RequestMapping("/checkAuthCode")
   public ResponseEntity<String> checkAuthCode(@RequestParam("tmpUserAuthCode") String tmpUserAuthCode, HttpSession session) {
      System.out.println(tmpUserAuthCode + "와 세션에 있는 인증코드가 같은지 비교");
      
      String result = "fail";
      
      if(session.getAttribute("authCode") != null) {
    	  String sesAuthCode = (String)session.getAttribute("authCode");
    	  
    	  if(tmpUserAuthCode.equals(sesAuthCode)) {
    		  result = "success";
    	  }
      }
      
      return new ResponseEntity<String>(result, HttpStatus.OK);
   }
   
   @RequestMapping("/clearAuthCode")
   public ResponseEntity<String> clearCode(HttpSession session) {
	   if(session.getAttribute("authCode") != null) {
		   session.removeAttribute("authCode"); // attribute 속성을 지운다.
	   }
	   
	   return new ResponseEntity<String>("success", HttpStatus.OK);
   }
}
