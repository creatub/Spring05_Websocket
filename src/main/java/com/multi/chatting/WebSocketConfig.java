package com.multi.chatting;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker // webSocket관련 설정이 작동된다
//implements WebSocketMessageBrokerConfigurer 해야함
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer{

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {

		//브라우저: ws://localhost:9090/컨텍스트/chat ==> sockjs에서 접속할 때 사용(sockjs 연결주소)
		//여러 명 채팅
		registry.addEndpoint("/chat")
		.withSockJS();//버전 낮은 브라우저에서도 사용가능하게 해주는 설정
		
		//챗봇 관련한 엔드포인트 설정==>나중에
		registry.addEndpoint("/chatbot")
		.withSockJS();
		//queue 사용 시 접속 클라이언트를 식별할 HandShakeHandler 설정
	}//-------------------------------

	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) {
		//해당 주소를 구독하는 서버가 클라이언트에게 메시지를 전달한다
		registry.enableSimpleBroker("/topic","/queue");//1:1 대화를 queue로 설정..?
		//클라이언트(js)가 서버로 보낸 메시지를 받는 prefix(접두어)
		registry.setApplicationDestinationPrefixes("/app"); // 접두어 설정
		// /app/chat/topic
	}

}
