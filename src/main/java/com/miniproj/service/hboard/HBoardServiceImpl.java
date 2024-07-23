package com.miniproj.service.hboard;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.miniproj.model.BoardDetailInfo;
import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;
import com.miniproj.model.PointLogDTO;
import com.miniproj.persistence.HBoardDAO;
import com.miniproj.persistence.MemberDAO;
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
	@Autowired
	private MemberDAO mDao;
	
	
	
	@Override
	public List<HBoardVO> getAllBoard() throws Exception {
		
		System.out.println("HBoardServiceImpl.....");
		
		// DAO 단 호출
		List<HBoardVO> lst = bDao.selectAllBoard();
		
		return lst;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean saveBoard(HBoardDTO newBoard) throws Exception {
		boolean result = false;
		
		// 1) newBoard를 DAO단을 통해 insert 해본다 - insert  close 
		if(bDao.insertNewBoard(newBoard)==1) {
			// 1-1) 위에서 저장된 게시글의 pk(boardNo)를 가져와야 한다. select
			int newBoardNo = bDao.getMaxBoardNo();
//			System.out.println("방금 저장된 따끈따끈한 글 번호 : " + newBoardNo);
			
			// 1-1-1) 위에서 가져온 글 번호를 ref컬럼에 update
			bDao.updateBoardRef(newBoardNo);
			
			// 1-2) 첨부된 파일이 있다면.. 첨부파일 또한 저장한다..  insert 
			for (BoardUpFilesVODTO file : newBoard.getFileList()) {
				file.setBoardNo(newBoardNo);
				bDao.insertBoardUpFile(file);			
			}
			
			// 2) 1번에서 insert가 성공했을 때 글작성자의 point를 부여한다.  - (select)  close - insert close			
			if (pDao.insertPointLog(new PointLogDTO(newBoard.getWriter(), "글작성", 0)) == 1) {
				// 3) 작성자의 userpoint값 update  close
				if (mDao.updateUserPoint(newBoard.getWriter()) == 1) {
					result = true;
				}	
			}	
		}
		
		return result;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public List<BoardDetailInfo> read(int boardNo, String ipAddr) throws Exception {
		List<BoardDetailInfo> boardInfo =  bDao.selectBoardByBoardNo(boardNo); // select
		
		// 조회수 증가
		if (boardInfo != null) {
			
			int dateDiff = bDao.selectDateDiff(boardNo, ipAddr); // select 
			
			if(dateDiff == -1) {
				// ipAddr유저가 boardNo글을 조회한적이 없다.// 조회 내역 저장 -> 조회수 증가
				if (bDao.saveBoardReadLog(boardNo, ipAddr) == 1) {  // insert
					updateReadCount(boardNo, boardInfo);  // update
				} 
			} else if (dateDiff >= 1) {
				updateReadCount(boardNo, boardInfo); // update
				bDao.updateReadWhen(boardNo, ipAddr);  // 조회수 증가 한 날로 날짜 upddate
			}
		}
		
		
		return boardInfo;
	}

	private void updateReadCount(int boardNo, List<BoardDetailInfo> boardInfo) throws Exception {
		if (bDao.updateReadCount(boardNo) == 1) {
			for (BoardDetailInfo b : boardInfo) {
				b.setReadCount(b.getReadCount() + 1);
			}
		}
	}

	

}
