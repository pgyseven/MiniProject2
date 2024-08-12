package com.miniproj.service.hboard;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.miniproj.model.BoardDetailInfo;
import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;
import com.miniproj.model.HReplyBoardDTO;
import com.miniproj.model.PagingInfo;
import com.miniproj.model.PagingInfoDTO;
import com.miniproj.model.PointLogDTO;
import com.miniproj.model.SearchCriteriaDTO;
import com.miniproj.persistence.MemberDAO;
import com.miniproj.persistence.PointLogDAO;
import com.miniproj.persistence.RBoardDAO;
import com.mysql.cj.util.StringUtils;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class RBoardServiceImpl implements RBoardService {

	private final RBoardDAO rDao;
	private final PointLogDAO pDao;
	private final MemberDAO mDao;

	@Override
	@Transactional(readOnly = true)
	public Map<String, Object> getAllBoard(PagingInfoDTO dto, SearchCriteriaDTO searchCriteria) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		PagingInfo pi = makePagingInfo(dto, searchCriteria);

		// DAO 단 호출
		List<HBoardVO> lst = null;
		if (StringUtils.isNullOrEmpty(searchCriteria.getSearchType())
				&& StringUtils.isNullOrEmpty(searchCriteria.getSearchWord())) {
			lst = rDao.selectAllBoard(pi); // 검색어가 없을때
		} else {
			lst = rDao.selectAllBoard(pi, searchCriteria);
		}

		resultMap.put("pagingInfo", pi);
		resultMap.put("boardList", lst);
		return resultMap;
	}

	private PagingInfo makePagingInfo(PagingInfoDTO dto, SearchCriteriaDTO sc) throws Exception {
		PagingInfo pi = new PagingInfo(dto);

		// 검색어가 있을 때는 검색한 글의 데이터 수를 얻어오는 것부터 페이지 시작
		if (StringUtils.isNullOrEmpty(sc.getSearchType()) && StringUtils.isNullOrEmpty(sc.getSearchWord())) { // mysql.cj.mt
			// 검색어가 없을 때는 데이터 수를 얻어오는 것 부터 페이징 시작
			pi.setTotalPostCnt(rDao.getTotalPostCnt()); // 전체 데이터 수 세팅
		} else {
			pi.setTotalPostCnt(rDao.getTotalPostCnt(sc)); // 검색조건에 따라 검색된 데이터 수 세팅
		}

		pi.setTotalPageCnt(); // 전체 페이지 수 세팅
		pi.setStartRowIndex(); // 현재 페이지에서 보여주기 시작할 rowIndex

		// 페이징 블럭 만들기
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

		// 1) newBoard를 DAO단을 통해 insert 해본다 - insert close
		if (rDao.insertNewBoard(newBoard) == 1) {
			
			// 2) 1번에서 insert가 성공했을 때 글작성자의 point를 부여한다. - (select) close - insert close
			PointLogDTO pointLogDTO = new PointLogDTO(newBoard.getWriter(), "글작성");

			if (pDao.insertPointLog(pointLogDTO) == 1) {
				
				// 3) 작성자의 userpoint값 update close
				if (mDao.updateUserPoint(pointLogDTO) == 1) {
					result = true;
				}
			}
		}

		return result;
	}

	@Override
	public List<BoardDetailInfo> read(int boardNo, String ipAddr) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<BoardDetailInfo> read(int boardNo) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean saveReply(HReplyBoardDTO replyBoard) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public List<BoardUpFilesVODTO> removeBoard(int boardNo) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean modifyBoard(HBoardDTO modifyBoard) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public List<HBoardVO> getPopularBoards() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
