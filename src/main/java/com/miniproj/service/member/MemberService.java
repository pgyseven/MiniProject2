package com.miniproj.service.member;

import com.miniproj.model.AutoLoginInfo;
import com.miniproj.model.LoginDTO;
import com.miniproj.model.MemberVO;

public interface MemberService {
	// 아이디 중복여부 검사 메소드
	boolean idIsDuplicate(String tmpUserId) throws Exception;

	// 회원가입하는 메소드
	boolean saveMember(MemberVO registMember) throws Exception;
	
	// 로그인을 시키는 메소드
	MemberVO login(LoginDTO loginDTO) throws Exception;

	// 자동 로그인 정보를 저장시키는 메소드
	boolean saveAutoLoginInfo(AutoLoginInfo autoLoginInfo) throws Exception;

	// 자동로그인을 체크한 유저를 확인하는 메소드
	MemberVO checkAutoLogin(String savedCookieSesId) throws Exception;
	
	// 아이디로 유저의 정보를 얻어오는 메서드
	MemberVO getUserInfo(String userId) throws Exception;
}
