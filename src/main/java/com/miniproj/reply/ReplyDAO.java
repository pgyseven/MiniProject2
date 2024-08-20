package com.miniproj.reply;

import java.util.List;

import com.miniproj.model.PagingInfo;
import com.miniproj.model.ReplyDTO;
import com.miniproj.model.ReplyVO;

public interface ReplyDAO {
   public List<ReplyVO> getAllReplies(int boardNo, PagingInfo pi) throws Exception;

   public int getTotalPostCnt(int boardNo) throws Exception;
   
   int insertNewReply(ReplyDTO newReplyDTO)throws Exception;
}