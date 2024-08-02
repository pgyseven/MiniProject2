function startTimer() {
    let timer = 5;

    setInterval(() => {
        // console.log(--timer);
        if(timer >= 0) {
            let min = Math.floor(timer / 60);
            let sec = String(timer % 60).padStart(2, '0'); // 초가 두자리 수일 때는 앞에 여백이 없으나 9초가 됐을 때는 09로 찍히도록 앞자리 여백에 0을 넣어주도록 padStart() 사용
            let remainTime = min + ":" + sec;
            $('.timer').html(remainTime);
            --timer;
        } else {
            $('#authBtn').prop('disabled', true);
            
            // 백엔드에 인증시간이 만료되었음을 알려야 한다.
        }
    }, 1000);
}