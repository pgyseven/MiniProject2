package com.miniproj.controller.hboard;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;
import com.miniproj.model.MyResponseWithoutData;
import com.miniproj.service.hboard.HBoardService;
import com.miniproj.util.FileProcess;


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
	
	@Autowired
	private FileProcess fileProcess;
	
	// 유저가 업로드한 파일을 임시 보관하는 객체 (컬렉션)
	private List<BoardUpFilesVODTO> uploadFileList = new ArrayList<BoardUpFilesVODTO>();

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
	public String saveBoard(HBoardDTO boardDTO, RedirectAttributes redirectAttributes) {
		System.out.println("let's save this board... : " + boardDTO.toString());
		
		String returnPage = "redirect:/hboard/listAll";
		
		try {
			if (service.saveBoard(boardDTO)) {  // 게시글 저장에 성공했다면
				redirectAttributes.addAttribute("status", "success");
			} 
		} catch (Exception e) {   // 게시글 저장에 실패했다면..
			e.printStackTrace();
			
			redirectAttributes.addAttribute("status", "fail");
		}
		
		return returnPage;  // 게시글 전체 목록 페이지로 돌아감
	}
	
	@RequestMapping(value="/upfiles", method = RequestMethod.POST, produces = "application/json; charset=UTF-8;")
	public ResponseEntity<MyResponseWithoutData> saveBoardFile(@RequestParam("file") MultipartFile file, HttpServletRequest request) {
		System.out.println("파일 전송됨... 이제 저장해야 함......");
		
		ResponseEntity<MyResponseWithoutData> result = null;
		// 파일의 기본정보 가져옴
		String contentType = file.getContentType();
		String originalFileName = file.getOriginalFilename();
		long fileSize = file.getSize();
		
		byte[] upfile = null;
		try {
			upfile = file.getBytes();  // 파일의 실제 데이터를 읽어옴
			
			System.out.println("서버의 실제 물리적 경로 : " + request.getSession().getServletContext().getRealPath("/resources/boardUpFiles"));
			String realPath = request.getSession().getServletContext().getRealPath("/resources/boardUpFiles");
			
			BoardUpFilesVODTO fileInfo = fileProcess.saveFileToRealPath(upfile, realPath, contentType, originalFileName, fileSize);
			
//			System.out.println("저장된 파일의 정보 : " + fileInfo.toString());
			
			this.uploadFileList.add(fileInfo);
			
			
			// 7월 17일 가장 먼저 해야 할 코드 : front에서 업로드한 파일을 지웠을때 백엔드에서도 지워야 한다.
			System.out.println("=================================================================");
			System.out.println("현재 파일리스트에 있는 파일들");
			for (BoardUpFilesVODTO f :this.uploadFileList ) {
				System.out.println(f.toString());
			}
			System.out.println("=================================================================");
			
			String tmp = null;
			if (fileInfo.getThumbFileName() != null) {
				// 이미지
				tmp = fileInfo.getNewFileName();
			} else {
				tmp = fileInfo.getNewFileName().substring(fileInfo.getNewFileName().lastIndexOf(File.separator) + 1);
			}
			
			
			MyResponseWithoutData mrw =  MyResponseWithoutData.builder()
				.code(200)
				.msg("success")
				.newFileName(tmp).build();
			
			// 저장된 새로운 파일이름을 json으로 return 시키도록 하자...
			result = new ResponseEntity<MyResponseWithoutData>(mrw, HttpStatus.OK);
			
		} catch (IOException e) {
			e.printStackTrace();
			
			result = new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
			
		}
		
		return result;
		
	}
	
	
	@RequestMapping(value="/removefile", method=RequestMethod.POST)
	public ResponseEntity<MyResponseWithoutData> removeUpFile(@RequestParam("removedFileName") String removeFileName, HttpServletRequest request) {
		System.out.println("업로드된 파일을 삭제 하자~ : " + removeFileName);
		
		boolean removeResult = false;
		
		ResponseEntity<MyResponseWithoutData> result = null;
		
		int removeIndex = -1;
		
		// 넘겨져온 removeFileName이 uploadFileList배열의 originalFileName과 같은것이 있는지 체크하여 있다면 삭제처리 해야 함
		for (int i = 0; i < this.uploadFileList.size(); i++) {
			if (uploadFileList.get(i).getNewFileName().contains(removeFileName)) {
				System.out.println(i + "번째에서 해당 파일 찾았음! : " + uploadFileList.get(i).getNewFileName());
				String realPath = request.getSession().getServletContext().getRealPath("/resources/boardUpFiles");
				
				if(fileProcess.removeFile(realPath + uploadFileList.get(i).getNewFileName())) {
					removeIndex = i;
					removeResult = true;
					break;
				}
				
			}
		}
		
		if (removeResult) {
			uploadFileList.remove(removeIndex);
			System.out.println("=================================================================");
			System.out.println("현재 파일리스트에 있는 파일들");
			for (BoardUpFilesVODTO f :this.uploadFileList ) {
				System.out.println(f.toString());
			}
			System.out.println("=================================================================");
			
			result = new ResponseEntity<MyResponseWithoutData>(new MyResponseWithoutData(200, "", "success"), HttpStatus.OK);
			
			
			
		} else {
			result = new ResponseEntity<MyResponseWithoutData>(new MyResponseWithoutData(400, "", "fail"), HttpStatus.CONFLICT);
		}
		
		return result;
	
	}
	
	
}
