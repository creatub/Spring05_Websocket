package com.multi.chatting;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class ChatController {

	@GetMapping("/chatForm")
	public String chatForm() {
		return "webChat/chatUI2";
	}//-------
	
	@MessageMapping("/chat")
	@SendTo("/topic/messages") // topic과 messages를 구독하고 있는 애들에게 보내겠다
	public OutputMessageVO send(MessageVO vo) {
//		log.info("서버가 받은 정보=>"+vo.toString());
		System.out.println("서버가 받은 정보=>"+vo.toString());
		
		String time=new SimpleDateFormat("yy-MM-dd HH:mm:ss").format(new Date());
		log.info("time: "+time);
		
		OutputMessageVO message=new OutputMessageVO(vo.getFrom(),vo.getTo(),vo.getText(),time);
		
		return message;
	}//-------------------
	//챗봇 사용시
	@GetMapping("/chatbotForm")
	public String chatbotForm() {
		
		return "webChat/chatBot";
	}//-------------------------
	
	@MessageMapping("/chatbot")
	//@SendTo("/topic/messages2") //[X] 접속한 사용자에게만 보내려면 topic이 아니라 queue로 전송해야 하고 @SendToUser()를 사용해야 함
	@SendToUser("/queue/messages")//서버가 방금 접속한 클에게만 메시지를 보낸다. (1:1). 구독하는 측에서는 '/user' 접두어를 붙여야 함
	public ResponseMessage sendToUser(MessageVO vo) {
		log.info("********************");
		log.info("서버가 받은 정보=>"+vo.toString());
		String time=new SimpleDateFormat("yy-MM-dd HH:mm:ss").format(new Date());
		ResponseMessage res=new ResponseMessage(vo.getFrom(), vo.getText(), null, time);
		String menu="";
		switch(vo.getText()) {
		case "1":
			menu="챗봇 >> 10) 운동화  11) 모자  12) 가방";
			break;
		case "2":
			menu="챗봇 >> 20) 배송조회  21) 주문 상품 조회";
			break;
		case "10":
			menu="챗봇 >> 100) 나이키  200) 르카프  300) 라코스테";
			break;
		case "100":
			menu="챗봇 >> 1000) 나이키 운동화 세부 내용 1) 다시 처음 메뉴";
			break;
		case "1000":
			menu="챗봇 >> 1001) 나이키 런닝화(1만원)  1002) 나이키 축구화(2만원)  100) 이전 메뉴로";
			break;
		default:
			menu="챗봇>> 선택한 번호는 메뉴에 없는 번호에요. 다시 입력하세요.";
			break;
		}//switch
		res.setMenu(menu);
		
		return res;
	}
	
}/////////////////////
