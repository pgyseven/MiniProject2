package com.miniproj.message;

import java.util.List;

import com.miniproj.model.FriendVO;

public interface MessageService {
	
	List<FriendVO> getFriends(String userId) throws Exception;

}