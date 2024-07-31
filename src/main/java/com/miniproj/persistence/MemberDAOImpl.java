package com.miniproj.persistence;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDAOImpl implements MemberDAO {
	
	@Autowired
	private SqlSession ses;
	
	private static String NS = "com.miniproj.mappers.membermapper";

	@Override
	public int updateUserPoint(String userId) throws Exception {
		
		return ses.insert(NS + ".updateUserPoint", userId);
	}

	@Override
	public int selectDuplicateId(String tmpUserId) throws Exception {
		
		return ses.selectOne(NS + ".selectUserId", tmpUserId);
	}

}
