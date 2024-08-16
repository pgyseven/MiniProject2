package com.miniproj.model;

import lombok.Builder;
import lombok.Getter;

// @Builder // 클래스 위에 사용하는 Builder annotation은 이 클래스가 가지고 있는 모든 멤버에 대해서 builder 패턴으로 만들어준다. 
// @AllArgsConstructor // 


@Getter
public class MyResponseWithData<T> {
	private int resultCode;
	private String resultMessage;
	private T data; // 실행할 때 데이터 타입을 결정하겠다.
	
	@Builder // 생성자 위에 사용하는 Builder annotation : 아래의 생성자가 가지고 있는 변수를 builder 패턴으로 만들어준다.
	public MyResponseWithData(ResponseType responseType, T data) {
		this.resultCode = responseType.getResultCode();
		this.resultMessage = responseType.getResultMessage();
		this.data = data;
	}
	
	
	
	/**
	 * @작성자 : 802-02
	 * @작성일 : 2024. 8. 16.
	 * @메소드명 : success
	 * @returType : MyResponseWithData
	 * @throwsException : 
	 * @description : data 없이 성공했다는 코드(200)와 "SUCCESS"만 전송하고 싶을 때 쓴다.
	 */
	public static MyResponseWithData success() {
		return MyResponseWithData.builder()
				.responseType(ResponseType.SUCCESS)
				.build();
	}
	
	/**
	 * @작성자 : 802-02
	 * @작성일 : 2024. 8. 16.
	 * @메소드명 : success
	 * @parameter : 제너릭 타입의 json으로 만들어 줄 data
	 * @returType : MyResponseWithData<T>
	 * @throwsException : 
	 * @description : data O + "success" 일 때 성공했다는 코드(200)와 "SUCCESS" 전송
	 */
	public static <T> MyResponseWithData<T> success(T data) { // generic 타입을 사용하는 메소드이기 때문에 genric 타입을 선언해줘야 한다.
		return new MyResponseWithData<>(ResponseType.SUCCESS, data);
	}
	
	
	/**
	 * @작성자 : 802-02
	 * @작성일 : 2024. 8. 16.
	 * @메소드명 : fail
	 * @returType : MyResponseWithData
	 * @throwsException : 
	 * @description : 실패했다는 코드(400)와 "FAIL" 전송
	 */
	public static MyResponseWithData fail() {
		return MyResponseWithData.builder()
				.responseType(ResponseType.FAIL)
				.build();
	}
	
}
