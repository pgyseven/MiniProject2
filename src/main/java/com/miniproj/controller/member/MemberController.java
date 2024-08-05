package com.miniproj.controller.member;

import java.io.IOException;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.servlet.http.HttpServletRequest;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.miniproj.model.MemberVO;
import com.miniproj.model.MyResponseWithoutData;
import com.miniproj.service.member.MemberService;
import com.miniproj.util.FileProcess;
import com.miniproj.util.SendMailService;
import com.mysql.cj.util.StringUtils;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor //생성자를 만들때 필요할때 받아온다. 스프링이 얘를 불러와서 mService; 하고나서 MemberController
public class MemberController {

   private final MemberService mService;
   private final FileProcess fp;
   
   @RequestMapping("/register")
   public void showRegisterForm() {
      
   }
   @RequestMapping(value="/register", method = RequestMethod.POST)
   public String registerMember(MemberVO registMember, @RequestParam("userProfile") MultipartFile userProfile, 
		   RedirectAttributes redirectAttributes, HttpServletRequest request) {
     
      String resultPage = "redirect:/";  // 성공했을 경우 index로 이동
      
      String realPath = request.getSession().getServletContext().getRealPath("/resources/userImg");
      System.out.println("실제 파일 저장 경로 : " + realPath);
      
      // (프로필 파일 이름 : 유저 아이디 + .유저가 올린 파일의 확장자)
      String tmpUserProfileName = userProfile.getOriginalFilename();  
      if (!StringUtils.isNullOrEmpty(tmpUserProfileName)) {
         String ext = tmpUserProfileName.substring(tmpUserProfileName.lastIndexOf(".") + 1);
          registMember.setUserImg(registMember.getUserId() + "." + ext);
      }
      
      System.out.println("회원가입 진행~~~~~~~~~~~~~~~~" + registMember.toString());
      
		try {
			// 프로필을 올렸는지 확인
			if (mService.saveMember(registMember)) {
				redirectAttributes.addAttribute("status", "success");

				if (!StringUtils.isNullOrEmpty(tmpUserProfileName)) { // 유저가 프로필 파일을 업로드했을 때
					fp.saveUserProfileFile(userProfile.getBytes(), realPath, registMember.getUserImg());
				}
			}

		} catch (Exception e) { // IOException(파일 처리시 발생한 예외), SQLException(DB작업시 발생한 예외)

			e.printStackTrace();
			
			if(e instanceof IOException) {
				redirectAttributes.addAttribute("status", "fileFail");
				
				// DB에 방금 전 회원가입한 유저(registerMember.getUserId())를 회원가입 취소처리
				// service 호출 -> dao 호출
			} else { // IOExeption이 발생하지 않았을 경우 -> SQLExeption
				redirectAttributes.addAttribute("status", "fail");
			}
			
			resultPage = "redirect:/member/register"; // 실패한 경우 다시 회원 가입 페이지로 이동
			

		}
		return resultPage;
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
         // new SendMailService().sendMail(tmpUserEmail, authCode); <- 실제 메일을 보내는 부분. 어차피 인증 코드는 콘솔창에 보이니까 그걸로 사용하자
         session.setAttribute("authCode", authCode); // 인증 코드를 세션 객체에 저장
         
         result = "success";
         
         
      }  catch (Exception e) {
         
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
