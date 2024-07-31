package com.miniproj.persistence;

public interface MemberDAO {
	
	// 유저의 userpoint를 수정하는 메서드
	int updateUserPoint(String userId) throws Exception;
	
	// tmpUserId가 있는지 조회하는 메소드(아이디 중복 검사)
	int selectDuplicateId(String tmpUserId) throws Exception;
}
