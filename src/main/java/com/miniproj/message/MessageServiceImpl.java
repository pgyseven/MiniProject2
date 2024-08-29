package com.miniproj.message;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.miniproj.model.FriendVO;
import com.miniproj.model.MessageDTO;
import com.miniproj.model.MessageVO;

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

	@Override
	public List<MessageVO> getReceivedMessage(String receiver) throws Exception {


		List<MessageVO> list = msgDao.selectMessages(receiver);
		
		//가져온 메세지의 읽음 처리
		for(MessageVO message : list) {
			
			msgDao.updateIsRead(message.getMsgId());
			
			
		}
		
		
		
		return list;
	}

	@Override
	@Transactional(readOnly = true)
	public int getMessageCount(String userId) throws Exception {
		
		return msgDao.selectMessageCount(userId);
		
	}
}
