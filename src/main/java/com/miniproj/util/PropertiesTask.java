package com.miniproj.util;

import java.io.IOException;
import java.io.Reader;
import java.util.Properties;

import org.apache.ibatis.io.Resources;

/**
 * @작성자 : 802-01
 * @작성일 : 2024. 9. 5.
 * @프로젝트명 : MiniProject2
 * @패키지명 : com.miniproj.util
 * @파일명 : PropertiesTask.java
 * @클래스명 : PropertiesTask
 * @description : classpath:dbconfig.properties 파일에서 넘겨 받은 key의 value를 반환하도록.
 */
public class PropertiesTask {
	public static String getPropertiesValue(String key) throws IOException {
		String resources = "dbconfig.properties";
		
		Properties prop = new Properties(); //비어 있는 properties 객체 생성
		
		Reader reader = Resources.getResourceAsReader(resources); //파일 읽을때 에러날수 있어서 아이오 익셉션
		
		prop.load(reader); //reader가 가리키는 파일을 읽어서 prop객체에 key, value를 구분하여 넣어준다.
		
		return (String)prop.get(key);
	}
}
