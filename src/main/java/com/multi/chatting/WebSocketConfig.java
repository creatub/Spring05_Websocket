package com.multi.chatting;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker // webSocket���� ������ �۵��ȴ�
//implements WebSocketMessageBrokerConfigurer �ؾ���
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer{

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {

		//������: ws://localhost:9090/���ؽ�Ʈ/chat ==> sockjs���� ������ �� ���(sockjs �����ּ�)
		//���� �� ä��
		registry.addEndpoint("/chat")
		.withSockJS();//���� ���� ������������ ��밡���ϰ� ���ִ� ����
		
		//ê�� ������ ��������Ʈ ����==>���߿�
		registry.addEndpoint("/chatbot")
		.withSockJS();
		//queue ��� �� ���� Ŭ���̾�Ʈ�� �ĺ��� HandShakeHandler ����
	}//-------------------------------

	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) {
		//�ش� �ּҸ� �����ϴ� ������ Ŭ���̾�Ʈ���� �޽����� �����Ѵ�
		registry.enableSimpleBroker("/topic","/queue");//1:1 ��ȭ�� queue�� ����..?
		//Ŭ���̾�Ʈ(js)�� ������ ���� �޽����� �޴� prefix(���ξ�)
		registry.setApplicationDestinationPrefixes("/app"); // ���ξ� ����
		// /app/chat/topic
	}

}
