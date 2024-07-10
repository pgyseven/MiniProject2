package com.miniproj.service.hboard;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.miniproj.model.HBoardVO;
import com.miniproj.persistence.HBoardDAO;

@Service   // 아래의 클래스가 서비스 객체임을 컴파일러에 공지
public class HBoardServiceImpl implements HBoardService {
	
	@Autowired
	private HBoardDAO bDao;
	
	@Override
	public List<HBoardVO> getAllBoard() throws Exception {
		
		System.out.println("HBoardServiceImpl.....");
		
		// DAO 단 호출
		List<HBoardVO> lst = bDao.selectAllBoard();
		
		return lst;
	}

}
