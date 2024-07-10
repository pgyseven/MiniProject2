package com.miniproj.persistence;

import java.util.List;

import com.miniproj.model.HBoardVO;

public interface HBoardDAO {

	// 게시판의 전체리스트를 가져오는 메서드
	List<HBoardVO> selectAllBoard() throws Exception;  // 몸체가 없는 추상메서드
}
