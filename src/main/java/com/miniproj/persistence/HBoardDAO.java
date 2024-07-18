package com.miniproj.persistence;

import java.util.List;

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
	
	// 업로드된 첨부파일을 저장하는 쿼리문
	int insertBoardUpFile(BoardUpFilesVODTO upFile) throws Exception; 
}
