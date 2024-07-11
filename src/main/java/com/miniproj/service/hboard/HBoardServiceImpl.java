package com.miniproj.service.hboard;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;
import com.miniproj.model.PointLogDTO;
import com.miniproj.persistence.HBoardDAO;
import com.miniproj.persistence.PointLogDAO;

// Service단에서 해야할 작업
// 1) Controller에서 넘겨진 파라메터를 처리한 후(비즈니스 로직에 의해(트랜잭션 처리를 통해)) 
// 2) DB작업 이라면 DAO단 호출...
// 3) DAO단에서 반환된 값을 Controller단으로 넘겨줌


@Service   // 아래의 클래스가 서비스 객체임을 컴파일러에 공지
public class HBoardServiceImpl implements HBoardService {
	
	@Autowired
	private HBoardDAO bDao;
	@Autowired
	private PointLogDAO pDao;
	
	@Override
	public List<HBoardVO> getAllBoard() throws Exception {
		
		System.out.println("HBoardServiceImpl.....");
		
		// DAO 단 호출
		List<HBoardVO> lst = bDao.selectAllBoard();
		
		return lst;
	}

	@Override
	
	public boolean saveBoard(HBoardDTO newBoard) throws Exception {
		// 1) newBoard를 DAO단을 통해 insert 해본다 - insert  close 
		if(bDao.insertNewBoard(newBoard)==1) {
			// 2) 1번에서 insert가 성공했을 때 글작성자의 point를 부여한다.  - (select)  close - insert close			
			System.out.println(pDao.insertPointLog(new PointLogDTO(newBoard.getWriter(), "글작성", 0)));
			
			
			// 3) 작성자의 userpoint값 update  close
		}
		
		
		
		return false;
	}

}
