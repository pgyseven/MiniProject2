package com.miniproj.persistence;

import java.util.List;

import com.miniproj.model.BoardDetailInfo;
import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;

public interface HBoardDAO {

	// 게시판의 전체리스트를 가져오는 메서드
	List<HBoardVO> selectAllBoard() throws Exception;  // 몸체가 없는 추상메서드
	
	// 게시글을 저장하는 메소드
	int insertNewBoard(HBoardDTO newBoard) throws Exception;
	
	// 최근 저장된 글의 글번호를 얻어오는 메서드
	int getMaxBoardNo() throws Exception;
	
	// 업로드된 첨부파일을 저장하는 메서드
	int insertBoardUpFile(BoardUpFilesVODTO upFile) throws Exception;
	
	// 게시글 상세정보를 읽어오는 메서드
	List<BoardDetailInfo> selectBoardByBoardNo(int boardNo) throws Exception;

	// 게시글의 조회수를 증가하는 메서드
	int updateReadCount(int boardNo) throws Exception;

	// ipAddr의 유저가 boardNo글을 언제 조회했는지 날짜 차이를 얻어온다(조회한 적이 없다면 -1 반환)
	int selectDateDiff(int boardNo, String ipAddr) throws Exception;

	// ipAddr의 유저가 boardNo글을 현재 시간에 조회한다고 기록.
	int saveBoardReadLog(int boardNo, String ipAddr) throws Exception;

	// 조회수 증가한 날자로 update 
	int updateReadWhen(int boardNo, String ipAddr) throws Exception;


	
}
