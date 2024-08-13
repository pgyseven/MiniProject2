package com.miniproj.controller.hboard;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.miniproj.model.BoardDetailInfo;
import com.miniproj.model.BoardUpFileStatus;
import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;
import com.miniproj.model.PagingInfo;
import com.miniproj.model.PagingInfoDTO;
import com.miniproj.model.SearchCriteriaDTO;
import com.miniproj.service.hboard.RBoardService;
import com.miniproj.util.GetClientIPAddr;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/rboard")
public class RBoardController {

	// Log를 남길 수 있도록 하는 객체
	private static Logger logger = LoggerFactory.getLogger(RBoardController.class);

	private final RBoardService service;

	@RequestMapping("/listAll")
	public void listAll(Model model, @RequestParam(value = "pageNo", defaultValue = "1") int pageNo,
			@RequestParam(value = "pagingSize", defaultValue = "10") int pagingSize, SearchCriteriaDTO searchCriteria) {
		// defaultValue : pageNo 쿼리스트링 값이 생략되어 호출된다면 그 값이 1로 초기값이 부여되도록 한다.(400에러 방지)
		logger.info(pageNo + "번 페이지를 출력하자 & 페이징 사이즈 : " + pagingSize + " (검색조건 : " + searchCriteria.toString() + ")");

		PagingInfoDTO dto = PagingInfoDTO.builder().pageNo(pageNo).pagingSize(pagingSize).build();

		Map<String, Object> result = null;

		try {
			result = service.getAllBoard(dto, searchCriteria);

			PagingInfo pi = (PagingInfo) result.get("pagingInfo");
			List<HBoardVO> list = (List<HBoardVO>) result.get("boardList");

			model.addAttribute("boardList", list); // 데이터 바인딩
			model.addAttribute("PagingInfo", pi);
			model.addAttribute("search", searchCriteria);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("exception", "error");
		}
	}

	@RequestMapping("/showSaveBoardForm")
	public String showSaveBoardForm() {
		return "/rboard/saveBoardForm";
	}

	@RequestMapping(value = "/saveBoard", method = RequestMethod.POST)
	public String saveBoard(HBoardDTO newBoard, RedirectAttributes redirectAttributes) {
		System.out.println(newBoard + "글을 저장하자");

		System.out.println("let'save this board : " + newBoard.toString());

		String returnPage = "redirect:/rboard/listAll";

		try {
			if (service.saveBoard(newBoard)) {
				redirectAttributes.addAttribute("status", "success");
			}
		} catch (Exception e) {
			e.printStackTrace();

			redirectAttributes.addAttribute("status", "fail");
		}
		return returnPage; // 게시글 전체 목록보기 페이지로 돌아간다.
	}

	@RequestMapping(value = { "/viewBoard", "/modifyBoard" })
	public String viewBoard(@RequestParam("boardNo") int boardNo, Model model, HttpServletRequest request) {

		String ipAddr = GetClientIPAddr.getClientIp(request);
		System.out.println(ipAddr + "가 " + boardNo + "번 글을 조회한다!");

		String returnViewPage = "";

		BoardDetailInfo boardDetailInfo = null;

		try {
			if (request.getRequestURI().equals("/rboard/viewBoard")) {

				System.out.println("상세보기 호출...");
				returnViewPage = "/rboard/viewBoard";
				boardDetailInfo = service.read(boardNo, ipAddr);

			} else if (request.getRequestURI().equals("/rboard/modifyBoard")) {

				System.out.println("수정하기 호출...");
				returnViewPage = "/rboard/modifyBoard";
				boardDetailInfo = service.read(boardNo);

			}

		} catch (Exception e1) {

			e1.printStackTrace();
			returnViewPage = "redirect:/rboard/listAll?status=fail";
		}

		model.addAttribute("board", boardDetailInfo);

		return returnViewPage;
	}

	   @RequestMapping(value = "/modifyBoardSave", method = RequestMethod.POST)
	   public String modifyBoardSave(HBoardDTO modifyBoard, RedirectAttributes rediAttributes) {
	      System.out.println(modifyBoard.toString() + "로 수정하자");
	      
	      try { 
	         
	         if(service.modifyBoard(modifyBoard)) {
	            rediAttributes.addAttribute("status", "success");
	         }
	      } catch (Exception e) { //DB의 익셉션 및 IO 익셉션을 모두 포함하기 위하여  익셉션으로 바꿈
	         
	         e.printStackTrace();
	         rediAttributes.addAttribute("status", "fail");
	      }
	      return "redirect:/rboard/viewBoard?boardNo=" + modifyBoard.getBoardNo();

	   }
}
