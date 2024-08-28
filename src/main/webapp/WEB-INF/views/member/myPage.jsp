<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<script
   src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
   $(function() {
      // showBasicInfo();
      
      // keyup은 키보드를 눌렀다 뗐을 때 이벤트가 발생한다.
      // keydown은 눌렸을 때 이벤트 발생
      // keypress는 누르고 있는 동안 계속 이벤트 발생
      $('#msgContent').keyup(function(evt){
         let val = $(this).val();
         console.log(val);
         
         $('.curLength').html(val.length);
         
         // keyCode : 키보드의 모든 키마다 코드(ascii code)가 있다.
         // enter 키의 코드값은 13 이다.
         if (evt.keyCode == 13) {
               send();
            }

         });

      });
   
   function send() {
      let sender = '${sessionScope.loginMember.userId}';
      let receiver = $('#receiveUser').val();
      let msgContent = $('#msgContent').val();
      
      let message = { // 객체로 만들어주기
         'sender' : sender,
         'receiver' : receiver,
         'msgContent' : msgContent
      };
      
      $.ajax({
            url : '/message/send',    
            type : 'post', 
            data : JSON.stringify(message),
            headers : {
              'Content-Type' : 'application/json'  
            },
            dataType : 'json',
            async : false,
            success : function(data) {    
               console.log(data);
               if(data.resultCode == 200) {
                  alert('쪽지를 보냈습니다.');
               }

            },
            error : function(data) {
               console.log(data);
            }
         });
   }
   
   function showBasicInfo() {
      $('.basicInfo').show();
      $('.pointInfo').hide();
      $('.myBoard').hide();
      $('.message').hide();
   }
   
   function showPointInfo() {
      $('.basicInfo').hide();
      $('.pointInfo').show();
      $('.myBoard').hide();
      $('.message').hide();
   }
   
   function showMyBoard() {
      $('.basicInfo').hide();
      $('.pointInfo').hide();
      $('.myBoard').show();
      $('.message').hide();
   }
   
   function showMessage() {
      $('.basicInfo').hide();
      $('.pointInfo').hide();
      $('.myBoard').hide();
      $('.message').show();
      
      getRecieveUsers();
   }
   
   function getRecieveUsers() {
      $.ajax({
            url : '/message/getFriends/' + '${sessionScope.loginMember.userId}',    
            type : 'get', 
            dataType : 'json',
            async : false,
            success : function(data) {    
               console.log(data);
               makeReceiveUserList(data);
 
            },
            error : function(data) {
               console.log(data);
            }
         });
   }
   
   function makeReceiveUserList(data) {
      
      let output = "";
      
      $.each(data.data, function(i, friend) { // 동적 바인딩. 태그에 따라서 내용이 바뀌게 해줬음
         output += `<option value='\${friend.friendId}'>\${friend.friendName}</option>`
      });
      
      $('#receiveUser').html(output);
   }
   
   
</script>
<style type="text/css">
   ul.nav li {
      .border : 1px solid #333;
   }
   
   .msgInputArea {
   margin-top : 10px;
   padding : 10px;
   display: flex;
   flex-direction: row;
   align-items: center;
   border: 1px solid #dee2e6;
   border-radius: 0.375rem;
   }

   .msgInputArea input {
   flex: 1;
   width: 80%;
   }
   
   .msgInputArea img {
   margin-left : 5px;
   width : 30px;
   }
</style>
</head>
<body>
   <div class="container">
      <jsp:include page="../header.jsp"></jsp:include>

      <div class="content">
         <h1>마이 페이지</h1>

         <ul class="nav nav-tabs">
            <li class="nav-item"><a href="#" class="nav-link" onclick="showBasicInfo();">기본 정보</a>
               <div class="basicInfo">
                  <h4>기본 정보</h4>
                  <div>${memberInfo}</div>
               </div>
            </li>
            <li class="nav-item"><a href="#" class="nav-link" onclick="showPointInfo();">포인트 내역</a>
               <div class="basicInfo">포인트 내역</div>
            </li>
            <li class="nav-item"><a href="#" class="nav-link" onclick="showMyBoard();">나의 게시물</a>
               <div class="myBoard">나의 게시물</div>
            </li>
            <li class="nav-item"><a href="#" class="nav-link" onclick="showMessage();">쪽지 보내기</a>
               <div class="message">
                  <div class="msgInputArea">
                  
                     <div class="msgContentLength"><span class="curLength"></span> / 100</div>
                     <div class="msgInputBody">
                        <select id="receiveUser">
                        
                        </select>
                     
                        <input type="text" class="form-control" id="msgContent" placeholder="메세지 내용 입력"/> 
                        <img src="/resources/images/sendMessage.png"  onclick="saveReply();" />
                     </div>
                  </div>
               </div>
            </li>         
         </ul>

      </div>



      <jsp:include page="../footer.jsp"></jsp:include>
   </div>
</body>
</html>