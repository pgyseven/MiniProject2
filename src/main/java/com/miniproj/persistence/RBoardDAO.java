package com.miniproj.persistence;

import java.util.List;

import com.miniproj.model.BoardDetailInfo;
import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;
import com.miniproj.model.HReplyBoardDTO;
import com.miniproj.model.PagingInfo;
import com.miniproj.model.SearchCriteriaDTO;

public interface RBoardDAO{
   
   //게시판의 전체 리스트를 가져오는 메서드
   List<HBoardVO>selectAllBoard(PagingInfo pi) throws Exception; //여기 퍼블릭 안쓴 이유 원래는 public abstrat 앱스트릭트는 생략되어도 그렇게 된다 없으면 퍼블릭이란것
    // 몸체가 없는 추상 메서드
   
   //게시글을 저장하는 메소드
   int insertNewBoard(HBoardDTO newBoard) throws Exception;
   
   //최근 저장된 글의 글번호를 얻어오는 메서드
   int getMaxBoardNo() throws Exception;

   //BoardUpFilesMemberJoinVO selectBoardDetailInfoByBoardNo(int boardNo); //  이건 설명위해서 추가 했던건 첨부파일 중복으로 인해서 로우가 여러줄인 한개의 게시긆 정보를 불러올때 처리 방법 이걸로는 안된다는 아이러니 설명 위해서 추가 BoardUpFilesMemberJoinVO 이미 이안에서 첨부 파일은 리스트로 받아오기에 여기서 리스트로 할 필요는 없다.


   //게시글 상세정보를 읽어오는 메서드
   BoardDetailInfo selectBoardByBoardNo(int BoardNo) throws Exception;

   
   //boardNo 번 게시글의 삭제 처리 하는 메서드
   int deleteBoardByBoardNo(int boardNo) throws Exception;

   
   // 인기글 5개 가져오기
   List<HBoardVO> selectPopBoards() throws Exception;
   
   
   // 게시판의 전체 글 수를 얻어오는 메서드(검색어가 없을 때)
   int getTotalPostCnt() throws Exception;
   
   //게시판의 전체 글 수를 얻어오는 메서드(검색어가 있을 때) 오버로드
   int getTotalPostCnt(SearchCriteriaDTO sc) throws Exception;
   
   // 검색어가 있는 경우 검색된 글을 페이징 하여 가져오는 메서드
   List<HBoardVO> selectAllBoard(PagingInfo pi, SearchCriteriaDTO searchCriteria) throws Exception;
}
