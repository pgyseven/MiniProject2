package com.miniproj.message;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.miniproj.model.FriendVO;
import com.miniproj.model.MessageDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MessageServiceImpl implements MessageService {

	private final MessageDAO msgDao;
	
	@Override
	@Transactional(readOnly = true)
	public List<FriendVO> getFriends(String userId) throws Exception {
		return msgDao.getFriends(userId);
		
	}

	@Override
	public boolean sendMsg(MessageDTO msgDTO) throws Exception {
		
		boolean result = false;
		
		if(msgDao.insertMessage(msgDTO)==1) {
		result = true;
	}
		 return result;
}
}
