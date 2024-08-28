package com.miniproj.message;

import java.util.List;

import com.miniproj.model.FriendVO;
import com.miniproj.model.MessageDTO;

public interface MessageDAO {

	
	List<FriendVO> getFriends(String userId) throws Exception;

	int insertMessage(MessageDTO msgDTO)throws Exception;
}
