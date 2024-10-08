package com.miniproj.controller.hboard;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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

import com.miniproj.model.BoardDetailInfo;
import com.miniproj.model.BoardUpFileStatus;
import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;
import com.miniproj.model.HReplyBoardDTO;
import com.miniproj.model.MyResponseWithoutData;
import com.miniproj.model.PagingInfo;
import com.miniproj.model.PagingInfoDTO;
import com.miniproj.model.SearchCriteriaDTO;
import com.miniproj.service.hboard.HBoardService;
import com.miniproj.util.FileProcess;
import com.miniproj.util.GetClientIPAddr;

// Controller 단에서 해야 할 일
// 1) URI 매핑(어떤 URI가 어떤 방식(GET/POST)으로 호출 되었을 때 어떤 메서드에 매핑 시킬 것이냐
// 2) 있다면 view단에서 보내준 매개변수 수집
// 3) 데이터베이스에 대한 CRUD를 수행하기 위해 service단의 해당 메서드를 호출. service단에서 return 값을 view으로 바인딩 view단 호출
// 4) 부가적으로.... 컨트롤러 단은 Servlet에 의해 동작되는 모듈이기 때문에 HttpServletRequest, HttpServletResponse, HttpSession 등의 
//    Servlet 객체들을 이용할 수 있다 -> 이러한 객체들을 이용하여 구현할 기능이 있다면 그 기능은 Controller단에서 구현한다.

@Controller // 아래의 클래스가 컨트롤러 객체임을 명시
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

	private List<BoardUpFilesVODTO> modifyFileList;

	// 게시판 전체 목록 리스트를 출력하는 메서드
	@RequestMapping("/listAll")
	public void listAll(Model model, @RequestParam(value = "pageNo", defaultValue = "1") int pageNo,
			@RequestParam(value = "pagingSize", defaultValue = "10") int pagingSize, SearchCriteriaDTO searchCriteria) {
		// defaultValue : pageNo 쿼리스트링 값이 생략되어 호출된다면 그 값이 1로 초기값이 부여되도록 한다.(400에러 방지)
		logger.info(pageNo + "번 페이지를 출력하자 & 페이징 사이즈 : " + pagingSize + " (검색조건 : " + searchCriteria.toString() + ")");

		PagingInfoDTO dto = PagingInfoDTO.builder().pageNo(pageNo).pagingSize(pagingSize).build();

		// 서비스 단 호출
		List<HBoardVO> list = null;
		Map<String, Object> result = null;
		try {
			result = service.getAllBoard(dto, searchCriteria);

			PagingInfo pi = (PagingInfo) result.get("pagingInfo");
			list = (List<HBoardVO>) result.get("boardList");

			model.addAttribute("boardList", list); // 데이터 바인딩
			model.addAttribute("PagingInfo", pi);
			model.addAttribute("search", searchCriteria);

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("exception", "error");

		}

		// return "/hboard/listAll"; // /hboard/listAll.jsp 으로 포워딩 됨
	}

	// 게시판 글 저장페이지를 출력하는 메서드
	@RequestMapping("/saveBoard")
	public String showSaveBoardForm() {
		return "/hboard/saveBoardForm";
	}

	// 게시글 저장 버튼을 눌렀을때 해당 게시글을 db에 저장하는 메서드
	@RequestMapping(value = "/saveBoard", method = RequestMethod.POST)
	public String saveBoard(HBoardDTO boardDTO, RedirectAttributes redirectAttributes) {
		boardDTO.setFileList(this.uploadFileList); // 첨부파일리스트를 boardDTO에 주입

		System.out.println("let's save this board... : " + boardDTO.toString());

		String returnPage = "redirect:/hboard/listAll";

		try {
			if (service.saveBoard(boardDTO)) { // 게시글 저장에 성공했다면
				redirectAttributes.addAttribute("status", "success");
			}
		} catch (Exception e) { // 게시글 저장에 실패했다면..
			e.printStackTrace();

			redirectAttributes.addAttribute("status", "fail");
		}
		this.uploadFileList.clear();

		return returnPage; // 게시글 전체 목록 페이지로 돌아감
	}

	@RequestMapping(value = "/upfiles", method = RequestMethod.POST, produces = "application/json; charset=UTF-8;")
	public ResponseEntity<MyResponseWithoutData> saveBoardFile(@RequestParam("file") MultipartFile file,
			HttpServletRequest request) {
		System.out.println("파일 전송됨... 이제 저장해야 함......");

		ResponseEntity<MyResponseWithoutData> result = null;

		try {
			BoardUpFilesVODTO fileInfo = fileSave(file, request);

			this.uploadFileList.add(fileInfo);

			// 7월 17일 가장 먼저 해야 할 코드 : front에서 업로드한 파일을 지웠을때 백엔드에서도 지워야 한다.
			System.out.println("=================================================================");
			System.out.println("현재 파일리스트에 있는 파일들");
			for (BoardUpFilesVODTO f : this.uploadFileList) {
				System.out.println(f.toString());
			}
			System.out.println("=================================================================");

			String tmp = null;
			if (fileInfo.getThumbFileName() != null) {
				// 이미지
				tmp = fileInfo.getThumbFileName();
			} else {
				tmp = fileInfo.getNewFileName().substring(fileInfo.getNewFileName().lastIndexOf(File.separator) + 1);
			}

			MyResponseWithoutData mrw = MyResponseWithoutData.builder().code(200).msg("success").newFileName(tmp)
					.build();

			// 저장된 새로운 파일이름을 json으로 return 시키도록 하자...
			result = new ResponseEntity<MyResponseWithoutData>(mrw, HttpStatus.OK);

		} catch (IOException e) {
			e.printStackTrace();

			result = new ResponseEntity<MyResponseWithoutData>(HttpStatus.NOT_ACCEPTABLE);

		}

		return result;

	}

	private BoardUpFilesVODTO fileSave(MultipartFile file, HttpServletRequest request) throws IOException {
		// 파일의 기본정보 가져옴
		String contentType = file.getContentType();
		String originalFileName = file.getOriginalFilename();
		long fileSize = file.getSize();

		byte[] upfile = file.getBytes(); // 파일의 실제 데이터를 읽어옴

		System.out.println(
				"서버의 실제 물리적 경로 : " + request.getSession().getServletContext().getRealPath("/resources/boardUpFiles"));
		String realPath = request.getSession().getServletContext().getRealPath("/resources/boardUpFiles");

		// 실제파일 저장(이름변경, base64, thumbnail)
		BoardUpFilesVODTO fileInfo = fileProcess.saveFileToRealPath(upfile, realPath, contentType, originalFileName,
				fileSize);
		return fileInfo;
	}

	@RequestMapping(value = "/removefile", method = RequestMethod.POST, produces = "application/json; charset=UTF-8;")
	public ResponseEntity<MyResponseWithoutData> removeUpFile(@RequestParam("removedFileName") String removeFileName,
			HttpServletRequest request) {
		System.out.println("업로드된 파일을 삭제 하자~ : " + removeFileName);

		boolean removeResult = false;

		ResponseEntity<MyResponseWithoutData> result = null;

		int removeIndex = -1;

		// 넘겨져온 removeFileName이 uploadFileList배열의 originalFileName과 같은것이 있는지 체크하여 있다면
		// 삭제처리 해야 함
		for (int i = 0; i < this.uploadFileList.size(); i++) {
			if (uploadFileList.get(i).getNewFileName().contains(removeFileName)) {
				System.out.println(i + "번째에서 해당 파일 찾았음! : " + uploadFileList.get(i).getNewFileName());
				String realPath = request.getSession().getServletContext().getRealPath("/resources/boardUpFiles");

				if (fileProcess.removeFile(realPath + uploadFileList.get(i).getNewFileName())) {
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
			for (BoardUpFilesVODTO f : this.uploadFileList) {
				System.out.println(f.toString());
			}
			System.out.println("=================================================================");

			result = new ResponseEntity<MyResponseWithoutData>(new MyResponseWithoutData(200, "", "success"),
					HttpStatus.OK);

		} else {
			result = new ResponseEntity<MyResponseWithoutData>(new MyResponseWithoutData(400, "", "fail"),
					HttpStatus.CONFLICT);
		}

		return result;

	}

	@RequestMapping(value = "/cancelBoard", method = RequestMethod.GET, produces = "application/json; charset=UTF-8;")
	public ResponseEntity<MyResponseWithoutData> cancelBoard(HttpServletRequest request) {
		System.out.println("유저가 업로드 한 모든 파일을 삭제하자!");
		String realPath = request.getSession().getServletContext().getRealPath("/resources/boardUpFiles");
		if (this.uploadFileList.size() > 0) {

			allUploadFileDelete(realPath, this.uploadFileList);

			this.uploadFileList.clear(); // 리스트에 있는 모든 데이터 삭제
		}

		return new ResponseEntity<MyResponseWithoutData>(new MyResponseWithoutData(200, "", "success"), HttpStatus.OK);

	}

	private void allUploadFileDelete(String realPath, List<BoardUpFilesVODTO> fileList) {
		for (int i = 0; i < fileList.size(); i++) {
			fileProcess.removeFile(realPath + fileList.get(i).getNewFileName());

			// 이미지 파일이면 썸네일 파일 또한 삭제 해야 함
			if (fileList.get(i).getThumbFileName() != null || fileList.get(i).getThumbFileName() != "") {
				fileProcess.removeFile(realPath + fileList.get(i).getThumbFileName());
			}
		}
	}

	@RequestMapping("/removeBoard")
	public String removeBoard(@RequestParam("boardNo") int boardNo, RedirectAttributes redirectAttributes,
			HttpServletRequest request) {
		System.out.println(boardNo + "번 글을 삭제하자");

		// Dao단에서 해당 boardNo번 글을 삭제처리한 후
		try {
			System.out.println("removeBoard에 옵니다");
			List<BoardUpFilesVODTO> fileList = service.removeBoard(boardNo);

			String realPath = request.getSession().getServletContext().getRealPath("/resources/boardUpFiles");

			// 첨부파일이 있다면 첨부파일의 정보를 가져와 하드디스크에서도 첨부파일을 삭제해야한다.
			if (fileList.size() > 0) {
				allUploadFileDelete(realPath, fileList);
			}

			redirectAttributes.addAttribute("status", "success");
		} catch (Exception e) {
			e.printStackTrace();

			redirectAttributes.addAttribute("status", "fail");
		}

		return "redirect:/hboard/listAll";

	}

	// 아래의 viewBoard()는 /viewBoard(게시글 상세보기), /modifyBoard(게시글을 수정하기 위해 게시글을 불러오는)
	// 일 때 2번 호출된다.
	@RequestMapping(value = { "/viewBoard", "/modifyBoard" })
	public String viewBoard(@RequestParam("boardNo") String boardNo, Model model, HttpServletRequest request) {
		
		String returnViewPage = "";
		List<BoardDetailInfo> boardDetailInfo = null;

		try {

			String ipAddr = GetClientIPAddr.getClientIp(request);
			System.out.println(ipAddr + "가 " + boardNo + "번 글을 조회한다!");

			if (request.getRequestURI().equals("/hboard/viewBoard")) {
				System.out.println("게시판 상세보기 호출..................");
				returnViewPage = "/hboard/viewBoard";
				boardDetailInfo = service.read(Integer.parseInt(boardNo), ipAddr);

			} else if (request.getRequestURI().equals("/hboard/modifyBoard")) {
				System.out.println("게시판 수정 호출 .................");
				returnViewPage = "/hboard/modifyBoard";
				boardDetailInfo = service.read(Integer.parseInt(boardNo));

				int fileCount = -1;
				for (BoardDetailInfo b : boardDetailInfo) {
					fileCount = b.getFileList().size();
					this.modifyFileList = b.getFileList(); // db에서 가져온 업로드된 파일리스트를 멤버변수에 할당
				}
				model.addAttribute("fileCount", fileCount);

				outputCurModifyFileList();

			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			returnViewPage = "redirect:/hboard/listAll?status=fail";
		} catch (Exception ex) {
			System.out.println(boardNo + " 의 값");
			System.out.println("요기~~~~~~~~~~~~~~~~~" + ex.getMessage());
			returnViewPage = "redirect:/hboard/listAll?status=fail";
		}

		model.addAttribute("boardDetailInfo", boardDetailInfo);

		return returnViewPage;

	}

	private void outputCurModifyFileList() {
		System.out.println("====================================================================================");
		System.out.println("수정: 호출 리스트에 있는 파일들");
		for (BoardUpFilesVODTO file : this.modifyFileList) {

			System.out.println(file.toString());
		}

		System.out.println("=====================================================================================");
	}

	@RequestMapping("/showReplyForm")
	public String showReplyForm() {
		return "/hboard/replyForm";
	}

	@RequestMapping(value = "/saveReply", method = RequestMethod.POST)
	public String saveReplyBoard(HReplyBoardDTO replyBoard, RedirectAttributes redirectAttributes) {
		System.out.println(replyBoard + "를 답글로 저장하자~");

		String returnPage = "redirect:/hboard/listAll";

		try {
			if (service.saveReply(replyBoard)) {
				redirectAttributes.addAttribute("status", "success");
			}
		} catch (Exception e) {
			e.printStackTrace();

			redirectAttributes.addAttribute("status", "fail");
		}

		return returnPage;
	}

	@RequestMapping(value = "/modifyRemoveFileCheck", method = RequestMethod.POST, produces = "application/json; charset=UTF-8;")
	public ResponseEntity<MyResponseWithoutData> modifyRemoveFileCheck(
			@RequestParam("removeFileNo") int removedFilePK) {
		System.out.println(removedFilePK + "파일을 삭제처리하자");

		// 아직 게시판이 최종 수정이 될지 안될지 모르는 상태이기 때문에 파일을 하드에서 삭제할 수 없다.
		// 삭제될 파일을 삭제한다고 체크만 해두고 나중에 게시판이 최종 수정이 되면 그 때 실제 삭제처리해야 한다.
		for (BoardUpFilesVODTO file : this.modifyFileList) {
			if (removedFilePK == file.getBoardUpFileNo()) {
				file.setFileStatus(BoardUpFileStatus.DELETE);
			}
		}
		outputCurModifyFileList();

		return new ResponseEntity<MyResponseWithoutData>(new MyResponseWithoutData(200, null, "success"),
				HttpStatus.OK);
	}

	@RequestMapping(value = "/cancelRemFiles", method = RequestMethod.POST, produces = "application/json; charset=UTF-8;")
	public ResponseEntity<MyResponseWithoutData> cancelRemFiles() {
		System.out.println("파일리스트의 모든 파일 삭제 취소 처리~!~!!~!~!~!~!~!");

		for (BoardUpFilesVODTO file : this.modifyFileList) {
			file.setFileStatus(null);
		}
		outputCurModifyFileList();

		return new ResponseEntity<MyResponseWithoutData>(new MyResponseWithoutData(200, null, "success"),
				HttpStatus.OK);
	}

	@RequestMapping(value = "/modifyBoardSave", method = RequestMethod.POST)
	public String modifyBoardSave(HBoardDTO modifyBoard, @RequestParam("modifyNewFile") MultipartFile[] modifyNewFile,
			HttpServletRequest request, RedirectAttributes redirectAttributes) {
		System.out.println(modifyBoard.toString() + "로 수정하자");

		try { // 서버나 파일 저장시에도 하나라도 안되면 예외 처리로 나오게 범위를 넓혔다
			for (int i = 0; i < modifyNewFile.length; i++) {
				System.out.println("새로 업로드된 파일 :" + modifyNewFile[i].getOriginalFilename());

				BoardUpFilesVODTO fileInfo = fileSave(modifyNewFile[i], request);
				fileInfo.setFileStatus(BoardUpFileStatus.INSERT); // insert 되어야 할 파일임을 기록
				this.modifyFileList.add(fileInfo);
			}

			outputCurModifyFileList();
			// DB에 저장(servixe 호출)
			modifyBoard.setFileList(modifyFileList);
			if (service.modifyBoard(modifyBoard)) {
				redirectAttributes.addAttribute("status", "success");
			}
		} catch (Exception e) { // DB의 익셉션 및 IO 익셉션을 모두 포함하기 위하여 익셉션으로 바꿈

			e.printStackTrace();
			redirectAttributes.addAttribute("status", "fail");
		}
		return "redirect:/hboard/viewBoard?boardNo=" + modifyBoard.getBoardNo();

	}

}
