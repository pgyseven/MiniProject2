function startTimer() {
    let timer = 180;

    let timerInterval = setInterval(displayTime, 1000);

    function displayTime() {
    // 시간이 0보다 작거나 인증이 성공되었으면  ajax를 할 필요가 없다.
        if (timer < 0) {   
            clearInterval(timerInterval);
            $('#authBtn').prop('disabled', true);
            
            if($('#emailValid').val() != 'checked'){
                // 백엔드에 인증시간이 만료되었음을 알려야 한다.
                $.ajax({
                    url: "/member/clearAuthCode", // 데이터가 송수신될 서버의 주소
                    type: "post", // 통신 방식 : GET, POST, PUT, DELETE, PATCH
                    dataType: "text", // 수신 받을 데이터의 타입 (text, xml, json)
                    success: function (data) {
                        // 비동기 통신에 성공하면 자동으로 호출될 callback function
                        console.log(data);
                        
                        if(data == 'success') {
                            alert("인증 시간이 만료되었습니다. 이메일 주소를 다시 입력 후 재인증을 시도하세요.");
                            $('#authenticateDiv').remove();
                            $('#userEmail').val('');
                            $('#userEmail').focus();
                        }
                    }
                });
            }
            
        } else {
            let min = Math.floor(timer / 60);
            let sec = String(timer % 60).padStart(2, '0'); // 초가 두자리 수일 때는 앞에 여백이 없으나 9초가 됐을 때는 09로 찍히도록 앞자리 여백에 0을 넣어주도록 padStart() 사용
            let remainTime = min + ":" + sec;
            $('.timer').html(remainTime);
            --timer;
        }       
    }

    

    
}

