package com.miniproj.model;

import java.sql.Date;
import java.sql.Timestamp;

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
public class SeoulTempVO {
	private int tempNo;
	private Date writtenDate;
	private float avgTemp;
	private float minTemp;
	private float maxTemp;
	

}
