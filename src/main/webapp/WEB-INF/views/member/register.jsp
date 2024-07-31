<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script
    src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<title>회원 가입 페이지</title>
<script>
    function getAddr() {
        // 적용예 (api 호출 전에 검색어 체크)     
        if (!checkSearchedWord(document.form.keyword)) {
            return;
        }

        $.ajax({
            url : "https://business.juso.go.kr/addrlink/addrLinkApiJsonp.do" //인터넷망
            ,
            type : "post",
            data : $("#form").serialize(),
            dataType : "jsonp",
            crossDomain : true,
            success : function(jsonStr) {
                $("#list").html("");
                var errCode = jsonStr.results.common.errorCode;
                var errDesc = jsonStr.results.common.errorMessage;
                if (errCode != "0") {
                    alert(errCode + "=" + errDesc);
                } else {
                    if (jsonStr != null) {
                        makeListJson(jsonStr);
                    }
                }
            },
            error : function(xhr, status, error) {
                alert("에러발생");
            }
        });
    }

    function makeListJson(jsonStr) {
        var htmlStr = "";
        htmlStr += "<table>";
        $(jsonStr.results.juso).each(function() {
            htmlStr += "<tr onclick='handleClick(this);'>";
            htmlStr += "<td class='roadAddr'>" + this.roadAddr + "</td>";
            htmlStr += "<td>" + this.jibunAddr + "</td>";
            htmlStr += "<td>" + this.zipNo + "</td>";
            htmlStr += "</tr>";
        });
        htmlStr += "</table>";
        $("#list").html(htmlStr);
    }
    
    function handleClick(row) {
        // 클릭된 row에서 roadAddr 값을 가져오기
        var roadAddr = $(row).find(".roadAddr").text();
        
        // ID가 selectedAddr인 요소에 roadAddr 값을 표시하기
        $("#selectedAddr").val(roadAddr);
    }

    //특수문자, 특정문자열(sql예약어의 앞뒤공백포함) 제거
    function checkSearchedWord(obj) {
        if (obj.value.length > 0) {
            //특수문자 제거
            var expText = /[%=><]/;
            if (expText.test(obj.value) == true) {
                alert("특수문자를 입력 할수 없습니다.");
                obj.value = obj.value.split(expText).join("");
                return false;
            }

            //특정문자열(sql예약어의 앞뒤공백포함) 제거
            var sqlArray = new Array(
            //sql 예약어
            "OR", "SELECT", "INSERT", "DELETE", "UPDATE", "CREATE", "DROP",
                    "EXEC", "UNION", "FETCH", "DECLARE", "TRUNCATE");

            var regex;
            for (var i = 0; i < sqlArray.length; i++) {
                regex = new RegExp(sqlArray[i], "gi");

                if (regex.test(obj.value)) {
                    alert("\"" + sqlArray[i] + "\"와(과) 같은 특정문자로 검색할 수 없습니다.");
                    obj.value = obj.value.replace(regex, "");
                    return false;
                }
            }
        }
        return true;
    }

    function enterSearch() {
        var evt_code = (window.netscape) ? ev.which : event.keyCode;
        if (evt_code == 13) {
            event.keyCode = 0;
            getAddr(); //jsonp사용시 enter검색 
        }
    }
</script>
</head>
<body>
    <c:import url="../header.jsp" />

    <div class="container">
        <h1>회원가입페이지</h1>

        <form method="post">
            <div class="mb-3 mt-3">
                <label for="userId" class="form-label">아이디: </label> 
                <input type="text" class="form-control" id="userId" placeholder="아이디를 입력하세요..." name="userId" />
            </div>

            <div class="mb-3 mt-3">
                <label for="userPwd1" class="form-label">패스워드: </label> 
                <input type="password" class="form-control" id="userPwd1" placeholder="비밀번호를 입력하세요..." name="userPwd" />
            </div>

            <div class="mb-3 mt-3">
                <label for="userPwd1" class="form-label">패스워드 확인: </label> 
                <input type="password" class="form-control" id="userPwd2" placeholder="비밀번호를 확인하세요..." />
            </div>

            <div class="mb-3 mt-3">
                <label for="userEmail" class="form-label">이메일: </label> 
                <input type="text" class="form-control" id="userEmail" name="userEmail" />
            </div>

            <div class="form-check">
                <input type="radio" class="form-check-input" id="radio1" name="optradio" value="option1" checked>여성<label class="form-check-label" for="radio1"></label>
            </div>
            <div class="form-check">
                <input type="radio" class="form-check-input" id="radio2" name="optradio" value="option2">남성<label class="form-check-label" for="radio2"></label>
            </div>

            <div class="mb-3 mt-3">
                <label for="mobile" class="form-label">휴대전화: </label> 
                <input type="text" class="form-control" id="mobile" placeholder="전화번호를 입력하세요..." name="userMobile" />
            </div>

            <div class="mb-3 mt-3">
                <label for="memberProfile" class="form-label">회원 프로필: </label> 
                <input type="file" class="form-control" id="userProfile" name="memberProfile" />
            </div>

            <div class="mb-3 mt-3">
                <label for="selectedAddr" class="form-label">주소: </label> 
                <input type="text" class="form-control" id="selectedAddr" placeholder="선택된 주소가 여기에 표시됩니다." readonly />
            
                <label for="mobile" class="form-label"></label> 
                <input type="text" class="form-control" id="address" placeholder="상세주소를 입력하세요..." name="userAddress" />
            </div>

            <div class="form-check">
                <input class="form-check-input" type="checkbox" id="agree" name="agree" value="Y" /> 
                <label class="form-check-label">회원가입 조항에 동의합니다</label>
            </div>

            <!-- form 태그는 항상 submit / reset 버튼과 함께 사용 -->
            <input type="submit" class="btn btn-success" value="회원가입" /> 
            <input type="reset" class="btn btn-danger" value="취소" />
        </form>

      <form name="form" id="form" method="post">
         <input type="hidden" name="currentPage" value="1" />
         <input type="hidden" name="countPerPage" value="10" />
         <input type="hidden" name="resultType" value="json" /> 
         <input type="hidden" name="confmKey" value="devU01TX0FVVEgyMDI0MDczMDE3MzQ0NDExNDk3NTY=" />
         <!-- 요청 변수 설정 (승인키) -->
         <input type="text" name="keyword" value="" onkeydown="enterSearch();" />
         <!-- 요청 변수 설정 (키워드) -->
         <input type="button" onClick="getAddr();" value="주소검색하기" />
         <div id="list"></div>
         <!-- 검색 결과 리스트 출력 영역 -->
      </form>
   </div>



   <c:import url="../footer.jsp" />
</body>
</html>