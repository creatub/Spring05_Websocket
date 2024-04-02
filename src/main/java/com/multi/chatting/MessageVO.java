package com.multi.chatting;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//데이터를 수신할 때 MessageVO에 담아 받는다
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MessageVO {
	private String from;//보내는 이
	private String to;//받는 이
	private String text;//대화내용
	private String mode;//all, one
	
}
