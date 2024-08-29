package com.miniproj.message;

import java.util.List;

import com.miniproj.model.FriendVO;
import com.miniproj.model.MessageDTO;
import com.miniproj.model.MessageVO;

public interface MessageDAO {

	
	List<FriendVO> getFriends(String userId) throws Exception;

	int insertMessage(MessageDTO msgDTO) throws Exception;

	List<MessageVO> selectMessages(String receiver) throws Exception;

	int updateIsRead(int msgId) throws Exception;
}
