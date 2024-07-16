package com.miniproj.util;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Calendar;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.miniproj.model.BoardUpFilesVODTO;

@Component   // 스프링 컨테이너에게 객체를 만들어 관리하도록 하는 어노테이션
public class FileProcess{
	
	// file을 realPath에 저장하는 메서드
	public BoardUpFilesVODTO saveFileToRealPath(byte[] upfile, String realPath, String ext, String originalFileName, long fileSize) {
		BoardUpFilesVODTO result = null;
		
		
		// 파일이 실제 저장되는 경로 realPath + "/년/월/일" 경로 
		String[] ymd = makeCalendarPath(realPath);
		makeDirectory(realPath, ymd);
		
		return  result;
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
