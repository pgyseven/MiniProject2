package com.miniproj.message;

import java.util.List;

import com.miniproj.model.FriendVO;
import com.miniproj.model.MessageDTO;
import com.miniproj.model.MessageVO;

public interface MessageService {
	
	List<FriendVO> getFriends(String userId) throws Exception;

	boolean sendMsg(MessageDTO msgDTO) throws Exception;

	List<MessageVO> getReceivedMessage(String receiver) throws Exception;

}