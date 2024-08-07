package com.miniproj.util;

import javax.servlet.http.HttpServletRequest;


/**
 * @작성자 : 802-02
 * @작성일 : 2024. 8. 7.
 * @프로젝트명 : MiniProject
 * @패키지명 : com.miniproj.util
 * @파일명 : DestinationPath.java
 * @클래스명 : DestinationPath
 * @description : 로그인을 하지 않았을 때, 로그인 페이지로 이동하기 전에 원래 가려던 페이지 경로를 저장하는 객체 
 */

public class DestinationPath {
	
	private String destPath; // static을 쓰게 되면 사용자들의 destPath가 다 공유되기 때문에 static을 쓰지 않고 멤버변수로 만들어야 한다.
	
	/**
	 * @작성자 : 802-02
	 * @작성일 : 2024. 8. 7.
	 * @메소드명 : setDestpath
	 * @parameter : HttpServletRequest req : request 객체
	 * @returType : void
	 * @throwsException : 예외 없음
	 * @description : request 객체에서 uri와 queryString을 얻어와 목적지 경로(this.destPath)에 저장 / 
	 *                세션객체에 바인딩
	 */
	public void setDestpath(HttpServletRequest req) {
		// 글 작성 : /hboard/saveBoard (쿼리 스트링 X)
		// 글 수정/삭제 : /hboard/modifyBoard?boardNo=23 (쿼리 스트링 O)
		String uri = req.getRequestURI();
		String queryString = req.getQueryString(); 
		
//		이렇게 if문으로 쓰면 하수임. 아래의 3항 연산자로 표현할 수 있어야 한다.		
//		if(StringUtils.isNullOrEmpty(queryString)) {
//			// 쿼리 스트링이 없다.
//			this.destPath = uri;
//		} else {
//			// 쿼리 스트링이 있다.
//			this.destPath = uri + "?" + queryString; // ?가 빠진 상태로 반환되기 때문에 ?를 따로 붙여줘야 한다.
//		}
		
		this.destPath = (queryString == null) ? uri : uri + "?" + queryString; // 3항 연산자를 이용하자.
		
		req.getSession().setAttribute("destPath", this.destPath); // 세션 객체에 destPath를 저장해준다.
	}
	
	
	/**
	 * @작성자 : 802-02
	 * @작성일 : 2024. 8. 7.
	 * @메소드명 : getDestPath
	 * @parameter : 
	 * @returType : void
	 * @throwsException : 
	 * @description : 
	 */
	public void getDestPath() {
		
	}
}
