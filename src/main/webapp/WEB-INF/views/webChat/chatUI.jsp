<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>::Chatting::</title>
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
  
<script>
	let socket=null;
	let stompClient=null;
	let nickname;
	function setConnected(connected){//연결 여부에 따라 UI 제어
		/* if(connected){ // jquery로 하는 방법 (쉬움)
			$('#showChat').show();
		}else{
			$('#showChat').hide();
		} */
		//document.getElementById('showChat').style.visibility=connected?'visible':'hidden'; // visibility일 때
		document.getElementById('showChat').style.display=connected?'block':'none';
		document.getElementById('taMsg').innerHTML='';
		
		//document.getElementById('connectBtn').disabled=connected;
		//document.getElementById('disConnectBtn').disabled=!connected;
	}
	function chat_connect(){
		nickname=$('#nickname').val();
		if(!nickname){
			alert('닉네임을 입력하세요');
			$('#nickname').focus();
			return;
		}
		
		socket = new SockJS("${pageContext.request.contextPath}/chat");//end point => "/chat"
		
		stompClient=Stomp.over(socket);//소켓을 이용해서 stomp 생성
		//stomp이용해서 서버에 연결
		stompClient.connect({}, function(frame){
			//alert('연결됨: '+frame);
			$('#status').html(nickname+"님이 챗서버에 연결되었습니다");
			setConnected(true);
			$('#inputMsg').focus();//대화내용 입력 박스에 포커스 주기
			//서버로 메시지를 보내자
			sendMessage(nickname,"all",nickname+"님이 접속했습니다.");

			stompClient.subscribe('/topic/messages', function(msg){
				console.log('subscribe topic->', msg)
				//alert(msg.body)//msg.body==>json형태의 문자열
				let jsonMsg=JSON.parse(msg.body);
				//alert(jsonMsg.from)
				showChatMessage(jsonMsg);
			})//subscribe end----
			
		});//stomp.connect() end----------
	}//connect------------------------------
	
	function sendInput(mymsg){
		//alert(event.keyCode);
		if(event.keyCode==13){//엔터를 쳤을 때 서버에 메시지를 전송하자
			if(mymsg!=''){
				sendMessage(nickname,'all',mymsg);//서버로 메시지 전송
				$('#inputMsg').val('');
				//document.getElementById('inputMsg').value='';
			}
		}
		
	}
	
	function sendMessage(from, to, text){
		let obj={
				from:from,
				to:to,
				text:text,
				mode:'all'
		}
		stompClient.send('/app/chat',{},JSON.stringify(obj));
	}
	
	function showChatMessage(obj){
		let str=`
		<p>
		<label class='badge badge-success'>\${obj.from}</label>
		&nbsp;&nbsp;&nbsp;
		\${obj.text}
		</p>
		`;
		$('#taMsg').append(str);
	}//-------------------------
	
	//서버의 연결을 끊는다
	function chat_disconnect(){
		if(stompClient!=null){
			sendMessage(nickname, "all", nickname+"님이 퇴장하셨습니다");
			stompClient.disconnect();
			$('#status').html("채팅을 연결 후 사용하세요");
			alert('연결 끊음');
			console.log('Disconnected...');
			stompClient=null;
		}
		setConnected(false);
	}
</script>
  
</head>
<body>
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h1>Multishop Chatting</h1>
				<div class="mb-3 mt-3">
					<label for="nickname" class="form-label">닉네임 : </label> <input
						type="text" class="form-control" id="nickname"
						placeholder="Enter nickname" name="nickname">
				</div>
				<!-- 접속하기 -->
				<button type="button" class="btn btn-warning" id="connectBtn" onclick="chat_connect()">채팅서버
					연결하기</button>
				<!-- 접속끊기 -->
				<button type="button" class="btn btn-secondary" id="disConnectBtn" onclick="chat_disconnect()">채팅서버
					연결끊기</button>
			</div>
		</div>
		<!-- 연결상태 알림 -->
		<div class="alert alert-success my-4">
			<strong id="status">채팅을 연결후 사용하세요....</strong>
		</div>
		<div id="showChat" style="display: none">
			<!-- 메시지 입력 -->
			<div class="mb-3 mt-3">
				<label for="inputMsg" class="form-label">메시지 : </label> 
				<input onkeyup="sendInput(this.value)"
					type="text" class="form-control" id="inputMsg"
					placeholder="메시지를 입력하세요." name="inputMsg">
			</div>
			<!-- 대화 내용 -->
			<div id="taMsg"></div>
		</div>
	</div>
	<!-- .container end -->

</body>
</html>