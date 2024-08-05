package com.miniproj.persistence;

import com.miniproj.model.MemberVO;

public interface MemberDAO {
	
	// 유저의 userpoint를 수정하는 메서드
	int updateUserPoint(String userId) throws Exception;
	
	// tmpUserId가 있는지 조회하는 메소드(아이디 중복 검사)
	int selectDuplicateId(String tmpUserId) throws Exception;

	// 회원을 저장하는 메소드
	int insertMember(MemberVO registMember) throws Exception;
}
