package com.miniproj.util;

import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;

public class SendMailService {
	
	@Autowired
	ResourceLoader resourceLoader;
	
	private String username;
	private String password;
	
	public void sendMail(String emailAddr, String activationCode) throws AddressException, MessagingException, IOException {
		String subject = "miniproject.com에서 보내는 회원가입 이메일 인증번호 입니다.";
		String message = "회원가입을 환영합니다. 인증번호 : " + activationCode + "를 입력하시고 회원가입을 완료해주세요.";
		
		// naver 이메일서버를 이용해서 메일을 보내려면 메일서버 환경설정을 해야한다.
		// ★Properties 객체 : java.util 클래스에 있고, Map 인터페이스가 부모이다. 따라서 key와 value로 데이터를 관리할 수 있다.
		//                     -> 데이터를 파일로 불러오고 저장하기 수월하다.
		Properties props = new Properties();
		
		props.put("mail.smtp.host", "smtp.naver.com");  // smtp 호스트 주소 등록
		props.put("mail.smtp.port", "465");  // naver smtp의 포트번호
		props.put("mail.smtp.starttls.required", "true"); // 동기식 전송을 위해 설정
		props.put("mail.smtp.ssl.protocols", "TLSv1.2"); // 보안인증을 위한 설정
		props.put("mail.smtp.ssl.enable", "true");  // SSL 사용
		props.put("mail.smtp.auth", "true"); // 인증 과정을 거치겠다.
		
		
		
		getAccount();
		
		Session mailSession = Session.getInstance(props, new Authenticator() {

			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				
				return new PasswordAuthentication(username, password);
			}
			
		});
		System.out.println(mailSession.toString());
		
		if(mailSession != null) {
			MimeMessage mime = new MimeMessage(mailSession);
			
			mime.setFrom(new InternetAddress("kgykgy1123@naver.com")); // 보내는 사람 메일 주소
			mime.addRecipient(RecipientType.TO, new InternetAddress(emailAddr)); // 받는 사람 메일 주소
			
			// 메일 제목과 본문 세팅
			mime.setSubject(subject);
			mime.setText(message);
			
			// Transport : 메일 전송하는 객체
			Transport trans = mailSession.getTransport("smtp");
			trans.connect(username, password);
			
			trans.send(mime);
			trans.close();
		}
	}

	private void getAccount() throws IOException {
		
		Properties account = new Properties();

		account.load(new FileReader("D:\\lecture\\spring\\MiniProject\\src\\main\\webapp\\WEB-INF\\config.properties"));
		
		this.username = (String)account.get("username");
		this.password = (String)account.get("password");
	}
}
