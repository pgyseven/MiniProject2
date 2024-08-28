package com.miniproj.message;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.miniproj.model.FriendVO;
import com.miniproj.model.MyResponseWithData;
import com.miniproj.model.ResponseType;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/message")
@RequiredArgsConstructor
public class MessageController {
	private final MessageService msgService;
	
	@GetMapping(value="/getFriends/{userId}") //  포스트 방식 풋 방식 딜리티 방식도 있다.
	public ResponseEntity getRecieveUsers(@PathVariable("userId") String userId) {
		System.out.println(userId + "친구 목록 불러오자");
		
		ResponseEntity result = null;
//		MyResponseWithData<List<FriendVO>> fList = null;
		List<FriendVO> fList = null;
		
		try {
			
			
//			fList = new MyResponseWithData<List<FriendVO>>(ResponseType.SUCCESS, msgService.getFriends(userId));
//			
//			result = new ResponseEntity(fList, HttpStatus.OK);
			
			fList = msgService.getFriends(userId);
			
			result = new ResponseEntity(MyResponseWithData.success(fList), HttpStatus.OK);
			
			
		} catch (Exception e) {
			e.printStackTrace();
			result = new ResponseEntity(MyResponseWithData.fail(), HttpStatus.BAD_REQUEST); // 400 값
		}
		return result;
	}
}
