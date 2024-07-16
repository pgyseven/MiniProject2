package com.miniproj.util;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Calendar;
// import java.lang.*;  // 생략  (java.lang 패키지는 기본 패키지이다)

import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Component;

import com.miniproj.model.BoardUpFilesVODTO;

@Component   // 스프링 컨테이너에게 객체를 만들어 관리하도록 하는 어노테이션
public class FileProcess{
	
	// file을 realPath에 저장하는 메서드
	public BoardUpFilesVODTO saveFileToRealPath(byte[] upfile, String realPath, String contentType, String originalFileName, long fileSize) throws IOException {
		BoardUpFilesVODTO result = null;
		
		
		// 파일이 실제 저장되는 경로 realPath + "/년/월/일" 경로 
		String[] ymd = makeCalendarPath(realPath);
		makeDirectory(realPath, ymd);
		
		String saveFilePath = realPath + ymd[ymd.length - 1];  // 실제 파일의 저장 경로
		
		String newFileName = null;
		String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
		if (fileSize > 0) {
			if(checkFileExist(saveFilePath, originalFileName)) {  // 파일 이름이 중복 되는지 검사 중복 된다면, 파일 이름 변경
				newFileName = renameFileName(originalFileName);
			} else {
				newFileName = originalFileName;
			}
			
			if (ImageMimeType.isImage(ext)) {
				// 이미지 파일임 -> 썸네일 이미지, base64문자열을 만들고  이미지와 함께 저장해야 한다.
			} else {
				// 이미지 파일이 아니다.  그냥 현재 파일만 하드디스크에 저장하면 된다.
				File saveFile = new File(saveFilePath + File.separator + newFileName);
				FileUtils.writeByteArrayToFile(saveFile, upfile); // 실제 파일 저장
				
				result = BoardUpFilesVODTO.builder()
						.ext(contentType)
						.newFileName(newFileName)
						.originalFileName(originalFileName)
						.size(fileSize)
						.build();
						
			}
		}
		
		return  result;   // 저장된 파일의 정보를 담은 객체
	}
	
	
	// 파일 이름 바꾸는 메서드
	// 예 : originalFileName_timestamp.확장자
	private String renameFileName(String originalFileName) {
		String timestamp = System.currentTimeMillis() + "";
		String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
		String fileNameWithOutExt = originalFileName.substring(0, originalFileName.lastIndexOf("."));
		
		String newFileName = fileNameWithOutExt + "_" + timestamp + "." + ext;
		
		System.out.println("old filename : " + originalFileName);
		System.out.println("새로운 파일 이름 : " + newFileName);
		
		return newFileName;
	}

	// originalFileName이 saveFilePath에 존재 하는지 안하는지.. (파일 중복 여부)
	// 중복된 파일이 있다면 true, 없다면 false
	private boolean checkFileExist(String saveFilePath, String originalFileName) {
		File tmp = new File(saveFilePath);
		
		boolean isFind = false;
		
		for (String name : tmp.list()) {
			if (name.equals(originalFileName)) {
				System.out.println("이름이 같은게 있다");
				isFind = true;
				break;
			}
		}
		
		if (!isFind) {
			System.out.println("이름이 같은 파일이 없는 상태");
		}
		
		return isFind;
	}






	// 파일이 저장될 경로의 디렉토리 구조를 "/년/월/일" 형태로 만드는 메서드
	private String[] makeCalendarPath(String realPath) {
		Calendar now = Calendar.getInstance();  // 현재날짜시간 객체
		String year = File.separator + now.get(Calendar.YEAR) + "";   // \2024
		String month = year + File.separator + new DecimalFormat("00").format(now.get(Calendar.MONTH) + 1);   // \2024\07
		String date = month + File.separator + new DecimalFormat("00").format(now.get(Calendar.DATE));   // \2024\07\16
		System.out.println(year + ", " + month + ", " + date);
		
		String[] ymd = {year, month, date};
		
		return ymd;
		
	}

	// 실제 directory를 만드는 메서드
	// 가변인자 메서드 (전달된 year, month, date의 값이 ymd 하나의 배열로 처리)
	private void makeDirectory(String realPath, String[] ymd) {
		if (!new File(realPath + ymd[ymd.length - 1]).exists()) {
			// 디렉토리 생성해야 함
			for (String path : ymd) {
				File tmp = new File(realPath + path);  // realPath + \2024\07\16
				if (!tmp.exists()) {
					tmp.mkdir();
				}
			}
		}
	}
}
