package com.miniproj.service.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.miniproj.persistence.MemberDAO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor // final한 멤버 mDao에게 생성자를 통해 객체를 주입하는 방식
public class MemberSrerviceImpl implements MemberService {
	
	//@Autowired -> 타입이 같은 것을 찾아서 자동주입하는 것
	private final MemberDAO mDao;
	
//	public void setMemberDAO(MemberDAO mdao) {
//		this.mDao = mdao;
//	}

	@Override
	public boolean idIsDuplicate(String tmpUserId) throws Exception {
		
		boolean result = false;
		
		if(mDao.selectDuplicateId(tmpUserId) == 1) {
			result = true; // 중복되는게 있음
		};
		
		return result;
	}
}
