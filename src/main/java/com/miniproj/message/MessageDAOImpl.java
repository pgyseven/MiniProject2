package com.miniproj.message;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.miniproj.model.FriendVO;
import com.miniproj.model.MessageDTO;
import com.miniproj.model.MessageVO;

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
	@Override
	public int insertMessage(MessageDTO msgDTO) throws Exception {
		
		return ses.insert(NS + ".sendMessage", msgDTO);
	}
	@Override
	public List<MessageVO> selectMessages(String receiver) throws Exception {
		
		return ses.selectList(NS + ".getMessages", receiver);
	}
	@Override
	public int updateIsRead(int msgId) throws Exception {
		
		return ses.update(NS + ".updateIsRead", msgId);
	}
	@Override
	public int selectMessageCount(String userId) throws Exception {
		
		return ses.selectOne(NS + ".getMessageCount", userId);
	}
	
	
	
	
}
