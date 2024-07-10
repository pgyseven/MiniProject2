package com.miniproj.persistence;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.miniproj.model.HBoardVO;

@Repository  // 아래의 클래스가 DAO객체임을 명시
public class HBoardDAOImpl implements HBoardDAO {
	
	@Autowired
	private SqlSession ses;
	
	private static String NS = "com.miniproj.mappers.hboardmapper";

	@Override
	public List<HBoardVO> selectAllBoard() {
		
		System.out.println("Here is HBoardDAO....");
		
		List<HBoardVO> list = ses.selectList(NS + ".getAllHBoard");
		
//		for (HBoardVO b :list) {
//			System.out.println(b.toString());
//		}
		
		return list; 
	}

}
