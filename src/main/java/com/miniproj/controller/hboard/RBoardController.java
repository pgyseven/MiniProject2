package com.miniproj.controller.hboard;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.miniproj.model.HBoardVO;
import com.miniproj.model.PagingInfo;
import com.miniproj.model.PagingInfoDTO;
import com.miniproj.model.SearchCriteriaDTO;
import com.miniproj.service.hboard.RBoardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/rboard")
public class RBoardController {
	
	// Log를 남길 수 있도록 하는 객체
	private static Logger logger = LoggerFactory.getLogger(RBoardController.class);
	
	private final RBoardService service;
	
	@RequestMapping("/listAll")
	public void listAll(Model model, @RequestParam(value="pageNo", defaultValue = "1") int pageNo,
			@RequestParam(value="pagingSize", defaultValue = "10") int pagingSize, SearchCriteriaDTO searchCriteria) {
		// defaultValue : pageNo 쿼리스트링 값이 생략되어 호출된다면 그 값이 1로 초기값이 부여되도록 한다.(400에러 방지)
		logger.info(pageNo + "번 페이지를 출력하자 & 페이징 사이즈 : " + pagingSize + " (검색조건 : " + searchCriteria.toString() + ")");

		PagingInfoDTO dto = PagingInfoDTO.builder()
			.pageNo(pageNo)
			.pagingSize(pagingSize)
			.build();
		
		Map<String, Object> result = null;
		
		try {
			result = service.getAllBoard(dto, searchCriteria);
			
			PagingInfo pi = (PagingInfo)result.get("pagingInfo");
			List<HBoardVO> list =(List<HBoardVO>)result.get("boardList");
			
			model.addAttribute("boardList", list); // 데이터 바인딩
			model.addAttribute("PagingInfo", pi);
			model.addAttribute("search", searchCriteria);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("exception", "error");
		}
	}
}