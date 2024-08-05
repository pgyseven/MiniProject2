package com.miniproj.service.member;

import com.miniproj.model.MemberVO;

public interface MemberService {
	// 아이디 중복여부 검사 메소드
	boolean idIsDuplicate(String tmpUserId) throws Exception;

	// 회원가입하는 메소드
	boolean saveMember(MemberVO registMember) throws Exception;
}
