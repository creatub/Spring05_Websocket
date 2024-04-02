package com.multi.chatting;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OutputMessageVO {
	
	private String from;//보내는 이
	private String to;//받는 이
	private String text;//대화내용
	private String time;//보내는 시간

}
