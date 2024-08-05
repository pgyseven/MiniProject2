package com.miniproj.service.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.miniproj.model.MemberVO;
import com.miniproj.model.PointLogDTO;
import com.miniproj.persistence.MemberDAO;
import com.miniproj.persistence.PointLogDAO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor // final한 멤버 mDao에게 생성자를 통해 객체를 주입하는 방식
public class MemberSrerviceImpl implements MemberService {
	
	//@Autowired -> 타입이 같은 것을 찾아서 자동주입하는 것
	private final MemberDAO mDao;
	
	private final PointLogDAO pDao;
	
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

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean saveMember(MemberVO registMember) throws Exception {
		// 취미를 1:N 관계로 만들어야 했는데, 취미를 저장할 테이블을 별도로 만들지 안힉 위해서 여러개의 취미를 아래와 같이 하나의 문자열로 저장한다.
		
		boolean result = false;
		
		String tmpHobbies = "";
		for(String hobby : registMember.getHobby()) {
			tmpHobbies += hobby + ", ";
		}
		
		registMember.setHobbies(tmpHobbies);
		
		// 1) 회원 데이터를 DB에 저장(파일 이름 : 유저 아이디 + .유저가 올린 파일의 확장자 <- 컨트롤러단에서 했음)
		if(mDao.insertMember(registMember) == 1) {
			// 2) 가입한 회원에게 100 포인트 부여(포인트 로그 기록)
			pDao.insertPointLog(new PointLogDTO(registMember.getUserId(), "회원가입", 100));
			result = true;
		}
		
		return result;
	}
}
