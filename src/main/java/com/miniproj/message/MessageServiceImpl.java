package com.miniproj.message;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.miniproj.model.FriendVO;

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

}
