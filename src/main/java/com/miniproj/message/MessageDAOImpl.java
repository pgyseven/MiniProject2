package com.miniproj.message;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.miniproj.model.FriendVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class MessageDAOImpl implements MessageDAO {

	private final SqlSession ses;
	private static final String NS = "com.miniproj.mappers.messagemapper";
	@Override
	public List<FriendVO> getFriends(String userId) throws Exception {
		
		return ses.selectList(NS + ".getFriends", userId);
	}
	
	
	
	
}
