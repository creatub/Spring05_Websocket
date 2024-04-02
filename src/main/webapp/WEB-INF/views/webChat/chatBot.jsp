<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>::ChatBot::</title>
<!-- ----------------------------------------- -->
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<!-- jQuery library -->
<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<!-- Popper JS -->
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<!-- Latest compiled JavaScript -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- -------------------------------------------- -->
<!-- websocket 라이브러리 추가 CDN -->
  <!--  https://cdnjs.com/libraries/sockjs-client  -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
  <!--  https://cdnjs.com/libraries/stomp.js -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<!-- 화면이 로드되자 마자 챗봇 서버에 접속 -->
<script>
	$(function(){
		chat_connect();
		
		$('#text').keyup(function(evt){
			if(evt.keyCode==13){//엔터 입력시
				if($(this).val()!=''){
					sendMessage();
					$(this).val('');
				}
			}
			
		})
	})//$() end-------------
	
	function chat_connect(){
		socket=new SockJS("${pageContext.request.contextPath}/chatbot");//end point
		stompClient=Stomp.over(socket);
		
		stompClient.connect({}, function(frame){
			//alert(frame);
			console.log('frame=>', frame);
			stompClient.subscribe('/user/queue/messages',function(msg){
				//alert(msg.body);
				//alert('queue: '+msg.body)
				let jsonMsg=JSON.parse(msg.body);
				showChatMessage(jsonMsg);
				
			})//subscribe() end -------
		})
	}//-----------------
	/*
	<div id="response">
		<p>menu</p>
	</div>
	*/
	function showChatMessage(obj){
		let res=document.getElementById('response');
		
		let p = document.createElement('p');//p태그
		let txt=document.createTextNode(obj.menu);//텍스트 노드		
		p.appendChild(txt);
		res.appendChild(p);
	}//-----------------------
	
	function sendMessage(){
		let from='Guest';
		let text=$('#text').val();
		let obj={
				from:from,
				text:text,
				mode:'one'
		}
		stompClient.send('/app/chatbot',{},JSON.stringify(obj));
	}//-------------------------
	
	function chat_disconnect(){
		alert('연결끊음')
		if(stompClient!=null){
			stompClient.disconnect();
			stompClient=null;
		}		
		console.log('Disconnected...');
	}//-----------------
</script>
</head>
<body onunload="chat_disconnect()">
	<div class='container'>
		<br><br>
		<img src="resources/chat1.png" height="136">
		<img src="resources/chat2.png" height="150" width="237">
		
		<div class="alert alert-danger" style="width: 500px;">
		<div>챗 봇>> 1)상품소개  	2)주문확인</div>
		<br>
		<div id="response">
			<!-- <p>응답메뉴</p> -->
		</div>
		<div class="form-floating mb-3 mt-3" id="taMsg">
		<table>
		<tr>
			<td><input type="text" class="form-control" id="text" style="width: 400px; background: yellow"></td>
			<td><button id="sendMessage" onclick="sendMessage();"class="btn btn-primary">Send</button></td>
		</tr>
		</table>
		</div>
	</div>
	</div>
</body>
</html>