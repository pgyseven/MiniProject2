package com.miniproj.util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Base64;
import java.util.Calendar;
// import java.lang.*;  // 생략  (java.lang 패키지는 기본 패키지이다)

import javax.imageio.ImageIO;

import org.apache.commons.io.FileUtils;
import org.imgscalr.Scalr;
import org.imgscalr.Scalr.Mode;
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
			
			File saveFile = new File(saveFilePath + File.separator + newFileName);
			FileUtils.writeByteArrayToFile(saveFile, upfile); // 실제 파일 저장
			
			if (ImageMimeType.isImage(ext)) {
				// 이미지 파일임 -> 썸네일 이미지, base64문자열을 만들고  이미지와 함께 저장해야 한다.
				String thumbImgName = makeThumbNailImage(saveFilePath, newFileName);
				
				// base64문자열로 encoding
				// base64인코딩 : 이진수(binary) 데이터를 Text로 바꾸는 인코딩의 하나로써 
				// 이진수 데이터를 ASCII(아스키코드) 영역의 문자로만 이루어진 문자열로 바꾸는 인코딩 방식이다.
				// 특징 : 파일을 별도로 저장할 공간이 필요하지 않다. (하지만, 문자열을 저장해야 한다면 파일을 저장하는 것보다 크기가 더 크다 )
				// 특징 : 인코딩 디코딩에 따른 부하가 걸린다.
				// 용량이 큰 이미지는 문자열로 만들지 못한다 -> 썸네일 이미지만 base64로 처리할것!
				
				String base64Str = makeBase64String(saveFilePath + File.separator + thumbImgName);
				
//				System.out.println("===========================================================");
//				System.out.println(base64Str);
//				System.out.println("===========================================================");
				
				result = BoardUpFilesVODTO.builder()
						.ext(contentType)
						.newFileName(ymd[2] + File.separator + newFileName)
						.originalFileName(ymd[2] + File.separator + originalFileName)
						.size(fileSize)
						.base64Img(base64Str)
						.thumbFileName(ymd[2] + File.separator + thumbImgName)
						.build();
				
				System.out.println(result.toString());
				
			} else {
				// 이미지 파일이 아니다.  그냥 현재 파일만 하드디스크에 저장하면 된다.		
				result = BoardUpFilesVODTO.builder()
						.ext(contentType)
						.newFileName(ymd[2] + File.separator + newFileName)
						.originalFileName(ymd[2] + File.separator + originalFileName)
						.size(fileSize)
						.build();
						
			}
		}
		
		return  result;   // 저장된 파일의 정보를 담은 객체
	}
	
	private String makeBase64String(String thumbNailFileName) throws IOException {
		String result = null;
		
		// 썸네일 파일의 경로로 File객체 생성
		File thumb = new File(thumbNailFileName);
		
		// File객체가 가리키는 파일을 읽어와 byte[] 
		byte[] upfile = FileUtils.readFileToByteArray(thumb);
		
		// 인코딩
		result = Base64.getEncoder().encodeToString(upfile);
		
		
		return result;
	}

	private String makeThumbNailImage(String saveFilePath, String newFileName) throws IOException {
		// 원본 이미지 파일을 읽음
		BufferedImage originalImage = ImageIO.read(new File(saveFilePath + File.separator + newFileName));
		// 원본 이미지 파일을 읽어 세로 크기를 50px로 맞춰 resizing 하도록...
		BufferedImage thumbNailImage = Scalr.resize(originalImage, Mode.FIT_TO_HEIGHT, 50);  
		
		String thumbImgName = "thumb_" + newFileName;
		
		File saveThumbImg = new File(saveFilePath + File.separator + thumbImgName);
		String ext = thumbImgName.substring(thumbImgName.lastIndexOf(".") + 1);
		
		if(ImageIO.write(thumbNailImage, ext,  saveThumbImg)) {
			return thumbImgName;
		} else {
			return null;
		}
	}
	
	
	// 업로드 되었던 파일을 하드디스크에서 삭제하는 메서드
	// removeFileName : realPath + 년월일경로 + 파일 이름.확장자
	public boolean removeFile(String removeFileName) {
		boolean result = false;
		
		File tmpFile = new File(removeFileName);
		
		if (tmpFile.exists()) {
			result = tmpFile.delete();
		}
		
		return result;
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
		
		String[] dirs = tmp.list();
		if (dirs != null) {
			for (String name : tmp.list()) {
				if (name.equals(originalFileName)) {
					System.out.println("이름이 같은게 있다");
					isFind = true;
					break;
				}
			}
		} else {  // 경로에 기존 업로드된 파일이나 폴더가 없을 때....
			return isFind; 
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
