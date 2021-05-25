<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.User"%>
<%@ page import="user.UserDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name = "viewport" content="width=device-width, initial-scale=1.0">
<title> 도담도담 </title>
<link rel="stylesheet" href="./css/dodam.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script type="text/javascript">
function proc(result) {
	$("#foodList option").remove();
	if(result.length == 0) {	// 음식 DB에 없는 음식일 경우 출력
		var str = "<option value='" +document.getElementById('foodName').value+ "'>"+ document.getElementById('foodName').value +"</option>";
		$("#foodList").append(str);
	} else {				    // 음식 DB에 있는 음식일 경우 출력
		for(idx in result){
			if(result[idx].manufacturer != null) {
				var str = "<option> ["+result[idx].manufacturer+ "] " + result[idx].foodName +"</option>";
					$("#foodList").append(str);
			} else {
				var str = "<option>"+ result[idx].foodName +"</option>";
				$("#foodList").append(str);
			}
		}
	}
}

$(document).ready(function() {
	$("#btnSearch").click(function() {
		var foodName = $("#foodName").val();
		$.ajax({
			url: "foodPlusAction.jsp",
			data: {'foodName' : foodName},
			dataType: "json",
			success : function(result) {
				proc(result);
			},
			error : function(request, status, error) {
				alert("데이터를 불러오지 못했습니다.");
				$("#foodList option").remove();
			}
		});
	});
})

function mySubmit(type) {
	if(type==1){			// 추가하기
		var selectItem = $("select[name=foodList]").val();
		if(selectItem != null) {
			var strArray = selectItem.split("] ");
			if(strArray.length == 1)
				var foodName = strArray[0];
			else
				var foodName = strArray[1];
			var option = $("<option value='"+foodName+"'>" + selectItem + "</option>");
			$("select[name=dietList]").append(option);
		}
	} else if(type==2){		// 제거하기
		$("select[name=dietList] option:selected").remove();
	}
}
</script>
</head>
<body>
<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 후 사용할 수 있습니다.')");
		script.println("location.href = 'loginForm.jsp'");
		script.println("</script>");
	}
%>
	<jsp:include page="menu.jsp" flush="false"/>
    
    <!-- 식단 추가 폼 -->
    <div class="PlusDiv">
	    <form class="dPlusForm" method="post" enctype="multipart/form-data" action="dPlusAction.jsp">
            <h2> 식단 추가 </h2>
            <div class="dietPlus">
                <select class="brel" name="brelupper">
                    <option value="아침"> 아침 </option>
                    <option value="점심"> 점심 </option>
                    <option value="저녁"> 저녁 </option>
                    <option value="간식"> 간식 </option>
                </select>
                <input type="date" name="dietDate" class="oDate">
                <input type="time" min="00:00:00" max="24:00:00" name="dietTime" class="oTime">
            </div>
            <div class="foodDiv">
				<input type="text" class="inputFood" id="foodName" placeholder="오늘 먹은 음식은?">
				<input type="button" class="findFood" id="btnSearch" value="검색">
				
				<select class="selectMulti" name="foodList" id="foodList" size="5"> </select>
		        <br><br> <button type="button" class="findFood" onclick='mySubmit(1)'> 추가하기 </button>
		        <button type="button" class="findFood" onclick='mySubmit(2)'> 제거하기 </button> <br><br>
		        <select class="selectMulti" name="dietList" multiple> </select>
			</div>
			<h3 style="color: #7C7C7C"> 사진도 추가할 수 있어요:) </h3>
			<input type="file" name="saveFileName">
			<input type="submit" id="BtnAdd" value="추가하기" class="plus">
			<p style="font-size: 10pt; color: red"> 모든 입력이 끝나면 하단 음식 리스트의 모든 값을 선택 후 추가하기를 눌러주세요 </p>
        </form>
    </div>
    
    <footer class="footer-section">
        <div>
            <p> DodamDodam </p>
            <p> 상  호  도담도담  |  대표  신예은 </p>
            <p> 이메일  tlsdpdms789@naver.com </p> <br>

            <hr>

    		<p class="copyright"> <br> ⓒ 2020 DodamDodam </p>
        </div>
    </footer>
</body>
</html>