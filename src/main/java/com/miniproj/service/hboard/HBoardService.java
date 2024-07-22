package com.miniproj.service.hboard;

import java.util.List;

import com.miniproj.model.BoardDetailInfo;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;


public interface HBoardService {
	
	// 게시판 전제 리스트 조회
	public List<HBoardVO> getAllBoard() throws Exception;
	
	// 게시판 글 작성
	boolean saveBoard(HBoardDTO newBoard) throws Exception;

	// 게시판 상세 보기
	public List<BoardDetailInfo> read(int boardNo) throws Exception;
	
	
	// 게시판 글 수정
	
	
	
	
	
	// 게시판 글 삭제
	
	
	
}
