package com.miniproj.service.member;

public interface MemberService {
	// 아이디 중복여부 검사 메소드
	boolean idIsDuplicate(String tmpUserId) throws Exception;
}
