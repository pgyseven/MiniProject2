package com.miniproj.reply;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.miniproj.reply.ReplyDAO;

import com.miniproj.model.ReplyVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReplyServiceImpl implements ReplyService {

	private final ReplyDAO rDao;
	
	@Override
	@Transactional(readOnly=true)
	public List<ReplyVO> getAllReplies(int boardNo) throws Exception {
		System.out.println("replyServiceImpl");
		System.out.println(rDao.getAllReplies(boardNo));
		return rDao.getAllReplies(boardNo);
	}

}
