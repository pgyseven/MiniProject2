package com.miniproj.model;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Getter
@Setter
@ToString
public class BoardUpFilesVODTO {
	private int boardUpFileNo;
	private String newFileName;
	private String originalFileName;
	private String thumbFileName;
	private String ext;
	private long size;
	private int boardNo;
	private String base64Img;
	
	// 게시물 수정시 첨부파일의 상태를 기록하는 변수(ex : "INSERT" -> 새로 저장된 파일, "DELETE" -> 삭제될 파일
	private BoardUpFileStatus fileStatus; 
}
