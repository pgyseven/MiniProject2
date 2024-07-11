package com.miniproj.controller.hboard;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;
import com.miniproj.service.hboard.HBoardService;


// Controller 단에서 해야 할 일
// 1) URI 매핑(어떤 URI가 어떤 방식(GET/POST)으로 호출 되었을 때 어떤 메서드에 매핑 시킬 것이냐
// 2) 있다면 view단에서 보내준 매개변수 수집
// 3) 데이터베이스에 대한 CRUD를 수행하기 위해 service단의 해당 메서드를 호출. service단에서 return 값을 view으로 바인딩 view단 호출
// 4) 부가적으로.... 컨트롤러 단은 Servlet에 의해 동작되는 모듈이기 때문에 HttpServletRequest, HttpServletResponse, HttpSession 등의 
//    Servlet 객체들을 이용할 수 있다 -> 이러한 객체들을 이용하여 구현할 기능이 있다면 그 기능은 Controller단에서 구현한다.

@Controller   // 아래의 클래스가 컨트롤러 객체임을 명시
@RequestMapping("/hboard")
public class HBoardController {
	
	// Log를 남길 수 있도록 하는 객체
	private static Logger logger = LoggerFactory.getLogger(HBoardController.class);

	@Autowired
	private HBoardService service;

	// 게시판 전체 목록 리스트를 출력하는 메서드
	@RequestMapping("/listAll")
	public void listAll(Model model) {
		logger.info("HboardController.listAll()..............");
		
		// 서비스 단 호출
		List<HBoardVO> list = null;
		try {
			list = service.getAllBoard();
			model.addAttribute("boardList", list);  // 데이터 바인딩
		} catch (Exception e) {
			model.addAttribute("exception", "error");
		}

		
		// return "/hboard/listAll";    // /hboard/listAll.jsp 으로 포워딩 됨
	}
	
	
	// 게시판 글 저장페이지를 출력하는 메서드
	@RequestMapping("/saveBoard")
	public String showSaveBoardForm() {
		return "/hboard/saveBoardForm";
	}
	
	// 게시글 저장 버튼을 눌렀을때 해당 게시글을 db에 저장하는 메서드
	@RequestMapping(value="/saveBoard", method = RequestMethod.POST)
	public void saveBoard(HBoardDTO boardDTO) {
		System.out.println("let's save this board... : " + boardDTO.toString());
		try {
			service.saveBoard(boardDTO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	
}
