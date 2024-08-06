package com.miniproj.service.member;

import com.miniproj.model.LoginDTO;
import com.miniproj.model.MemberVO;

public interface MemberService {
	// 아이디 중복여부 검사 메소드
	boolean idIsDuplicate(String tmpUserId) throws Exception;

	// 회원가입하는 메소드
	boolean saveMember(MemberVO registMember) throws Exception;
	
	// 로그인을 시키는 메소드
	MemberVO login(LoginDTO loginDTO) throws Exception;
}
