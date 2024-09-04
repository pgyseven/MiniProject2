package com.miniproj.model;

import java.sql.Timestamp;
import java.util.List;

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
public class SearchBookJSON {
//리플렉터라는것들이 있는 건 내부에서 상속받게 해준다 즉 롬복은 현재 이클래스를 내부에서 상속받는다.
	private String lastBuildDate;
	private int total;
	private int start;
	private int display;
	private List<NaverBook> items;
	
	
}
