package com.miniproj.service.hboard;

import java.util.List;
import java.util.Map;

import com.miniproj.model.BoardDetailInfo;
import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;
import com.miniproj.model.HReplyBoardDTO;
import com.miniproj.model.PagingInfoDTO;


public interface HBoardService {
	
	// 게시판 전제 리스트 조회
	public Map<String, Object> getAllBoard(PagingInfoDTO dto) throws Exception;
	
	// 게시판 글 작성
	boolean saveBoard(HBoardDTO newBoard) throws Exception;

	// 게시판 상세 보기
	public List<BoardDetailInfo> read(int boardNo, String ipAddr) throws Exception;

	// 게시글 수정을 위해 게시글을 불러오는 메소드(위의 게시판 상세보기 메소드 overloading 했다.)
	// read(int boardNo, String ipAddr) 오버로딩
	public List<BoardDetailInfo> read(int boardNo) throws Exception;
	
	// 게시글 답글 달기
	public boolean saveReply(HReplyBoardDTO replyBoard) throws Exception;

	// 게시판 글 삭제
	public List<BoardUpFilesVODTO> removeBoard(int boardNo) throws Exception;

	// 게시판 글 수정
	public boolean modifyBoard(HBoardDTO modifyBoard) throws Exception;

	// 인기글 5개 가져오기
	public List<HBoardVO> getPopularBoards() throws Exception;


	
	// 게시판 페이징
	
	
	// 게시글 검색
	
	
		
}
