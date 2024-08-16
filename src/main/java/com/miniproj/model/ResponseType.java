package com.miniproj.model;

public enum ResponseType { // 값을 주지 않으면 내부적으로 0부터 시작하는 값을 가진다. 배열처럼
	SUCCESS(200), FAIL(400);
	
	private int reslutCode;	
	
	ResponseType(int resultCode) { // enum 타입은 접근제한자가 private해야 한다. 따라서 앞에 접근제한자를 적지 않더라도 private이 생략된 것일 뿐이다.
		this.reslutCode = resultCode;
	}
	
	public int getResultCode() {
		return this.reslutCode;
	}
	
	public String getResultMessage() {
		return this.name(); // name : SUCCESS, FAIL -> int값을 가지고 있는 이름(SUCCESS, FAIL이 String으로 반환된다)
	}
}
