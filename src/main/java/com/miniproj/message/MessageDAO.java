package com.miniproj.message;

import java.util.List;

import com.miniproj.model.FriendVO;

public interface MessageDAO {

	
	List<FriendVO> getFriends(String userId) throws Exception;
}
