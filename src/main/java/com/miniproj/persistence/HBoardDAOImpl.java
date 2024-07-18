package com.miniproj.persistence;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;

@Repository  // 아래의 클래스가 DAO객체임을 명시
public class HBoardDAOImpl implements HBoardDAO {
	
	@Autowired
	private SqlSession ses;
	
	private static String NS = "com.miniproj.mappers.hboardmapper";

	// throws : 현재 메서드에서 예외가 발생하면 현재 메서드를 호출한 곳에서 예외처리를 하도록 미뤄두는 키워드
	@Override
	public List<HBoardVO> selectAllBoard() throws Exception {
		
		System.out.println("Here is HBoardDAO....");
		
		List<HBoardVO> list = ses.selectList(NS + ".getAllHBoard");
		
//		for (HBoardVO b :list) {
//			System.out.println(b.toString());
//		}
		
		return list; 
	}

	@Override
	public int insertNewBoard(HBoardDTO newBoard) throws Exception {
		
		return ses.insert(NS + ".saveNewBoard", newBoard);
	}

	@Override
	public int getMaxBoardNo() throws Exception {
		return ses.selectOne(NS + ".getMaxNo");
	}

	@Override
	public int insertBoardUpFile(BoardUpFilesVODTO upFile) throws Exception {
		
		return ses.insert(NS + ".saveUpFile", upFile);
	}
	
	

}
