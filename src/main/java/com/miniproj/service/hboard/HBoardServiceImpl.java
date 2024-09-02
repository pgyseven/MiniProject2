package com.miniproj.service.hboard;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.miniproj.model.BoardDetailInfo;
import com.miniproj.model.BoardUpFileStatus;
import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;
import com.miniproj.model.HReplyBoardDTO;
import com.miniproj.model.PagingInfo;
import com.miniproj.model.PagingInfoDTO;
import com.miniproj.model.PointLogDTO;
import com.miniproj.model.SearchCriteriaDTO;
import com.miniproj.model.SeoulTempVO;
import com.miniproj.persistence.HBoardDAO;
import com.miniproj.persistence.MemberDAO;
import com.miniproj.persistence.PointLogDAO;
import com.mysql.cj.util.StringUtils;

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
	@Transactional(readOnly=true)
	public Map<String, Object> getAllBoard(PagingInfoDTO dto, SearchCriteriaDTO searchCriteria) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		System.out.println("HBoardServiceImpl.....");
		
		PagingInfo pi = makePagingInfo(dto, searchCriteria);
		
		// DAO 단 호출
		List<HBoardVO> list = null;
		if(StringUtils.isNullOrEmpty(searchCriteria.getSearchType()) && StringUtils.isNullOrEmpty(searchCriteria.getSearchWord())) {
			list = bDao.selectAllBoard(pi);
		} else {
			list = bDao.selectAllBoard(pi, searchCriteria);
		}
		
		
		resultMap.put("pagingInfo", pi);
		resultMap.put("boardList", list);
		
		return resultMap;
	}

	private PagingInfo makePagingInfo(PagingInfoDTO dto, SearchCriteriaDTO sc) throws Exception {
		PagingInfo pi = new PagingInfo(dto);
		
		
		// 검색어가 있을 때는 검색한 글의 데이터 수를 얻어오는 것부터 페이징 시작
		if(StringUtils.isNullOrEmpty(sc.getSearchType()) && StringUtils.isNullOrEmpty(sc.getSearchWord())) { // 검색어가 없을 때는 전체 데이터 수를 얻어오는 것부터 페이징
			pi.setTotalPostCnt(bDao.getTotalPostCnt()); // 전체 데이터 수 세팅
		} else {
			pi.setTotalPostCnt(bDao.getTotalPostCnt(sc)); // 검색 조건에 따라 검색된 데이터 수 세팅
		}
		
		
		pi.setTotalPageCnt(); // 전체 페이지 수 세팅
		pi.setStartRowIndex(); // 현재 페이지에서 보여주기 시작할 rowIndex 세팅
		
		
		// 페이징 블록 만들기
		pi.setPageBlockNoCurPage();
		pi.setStartPageNoCurBlock();
		pi.setEndPageNoCurBlock();
		
		System.out.println(pi.toString());
		return pi;
		
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
			PointLogDTO pointLogDTO = new PointLogDTO(newBoard.getWriter(), "글작성");
			
			if (pDao.insertPointLog(pointLogDTO) == 1) {
				// 3) 작성자의 userpoint값 update  close
				if (mDao.updateUserPoint(pointLogDTO) == 1) {
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
	
	@Override
	@Transactional(readOnly = true, rollbackFor = Exception.class)
	public List<BoardDetailInfo> read(int boardNo) throws Exception{
		List<BoardDetailInfo> boardInfo =  bDao.selectBoardByBoardNo(boardNo); // select
		return boardInfo;
	}

	private void updateReadCount(int boardNo, List<BoardDetailInfo> boardInfo) throws Exception {
		if (bDao.updateReadCount(boardNo) == 1) {
			for (BoardDetailInfo b : boardInfo) {
				b.setReadCount(b.getReadCount() + 1);
			}
		}
	}

	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean saveReply(HReplyBoardDTO replyBoard) throws Exception {
		boolean result = false;
		
		// 부모글에 대한 다른 답글이 있는 상태에서, 부모글의 답글이 추가되는경우, (자리확보를 위해) 기존의 답글의 refOrder값을 수정해야 한다.
		bDao.updateRefOrder(replyBoard.getRef(), replyBoard.getRefOrder()); // <- update
		
		// 부모글의 boardNo를 ref에, 부모글의 step +1 값을 step에, 부모글의 refOrder + 1  값을 refOrder에 저장한다. 답글 데이터와 함께...
		replyBoard.setStep(replyBoard.getStep() + 1);
		replyBoard.setRefOrder(replyBoard.getRefOrder() + 1);
		
		if (bDao.insertReplyBoard(replyBoard) == 1) {
			result = true;
		}
		
		return result;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public List<BoardUpFilesVODTO> removeBoard(int boardNo) throws Exception {
		
		// 1) 실제 파일을 하드디스크에서도 삭제해야 하므로, 삭제하기 전에 해당글의 첨부파일 정보를 불러와야 한다.
		List<BoardUpFilesVODTO> fileList = bDao.selectBoardUpFiles(boardNo); // select
		
		// 2) boardNo번 글의 첨부파일이 있다면 첨부파일을 삭제해야 한다. 
		bDao.deleteAllBoardUpFiles(boardNo); // delete
		
		// 3) boardNo번 글을 삭제 처리
		if(bDao.deleteBoardByBoardNo(boardNo) == 1) { // update
			return fileList;
		} else {
			return null;
		}
		
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean modifyBoard(HBoardDTO modifyBoard) throws Exception {
		
		boolean result = false;
		
		// 1) 순수 게시글 update
		if(bDao.updateBoardByBoardNo(modifyBoard) == 1) {
			
			// 2) 첨부 파일의 status = INSERT 면 파일을 insert / status = DELETE 면 기존 파일을 delete
			List<BoardUpFilesVODTO> fileList = modifyBoard.getFileList();
			
			for(BoardUpFilesVODTO file : fileList) { 
				if(file.getFileStatus() == BoardUpFileStatus.INSERT) { // insert
					file.setBoardNo(modifyBoard.getBoardNo()); // 저장되는 파일의 글번호를 수정되는 글의 글번호로 세팅
					bDao.insertBoardUpFile(file);
				} else if (file.getFileStatus() == BoardUpFileStatus.DELETE) { // delete
					bDao.deleteBoardUpFile(file.getBoardUpFileNo());
				}
			}
			result = true;
		}

		return result;
	}

	@Override
	@Transactional(readOnly=true)
	public List<HBoardVO> getPopularBoards() throws Exception {
		
		return bDao.selectPopularBoards();
	}

	@Override
	@Transactional(readOnly=true)
	public List<SeoulTempVO> getSeoulTemp() throws Exception {

		return bDao.getSeoulTemp();
	
	}

}
