package com.miniproj.persistence;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.miniproj.model.PointLogDTO;

@Repository
public class PointLogDAOImpl implements PointLogDAO {

	@Autowired
	private SqlSession ses;
	private static String NS = "com.miniproj.mappers.pointlogmapper";
	
	@Override
	public int insertPointLog(PointLogDTO pointLogDTO) throws Exception {		
		
		return ses.insert(NS + ".insertPointLog", pointLogDTO);
	}

}
