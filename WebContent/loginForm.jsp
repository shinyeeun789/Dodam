<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" intial-scale="1">
<title>도담도담</title>
<link rel="stylesheet" href="./css/dodam.css">
</head>
<body>
	<!-- GNB -->
	<nav class="nav-container">
        <a class="nav-logo" href="main.jsp"> 도담도담 </a>
        <ul>
            <li class="main-menu"><a class="nav-item" href="dietListForm.jsp"> 식단 관리 </a>  
                <ul class="sub-menu">
                    <li><a class="sub-menuLink longLink" href="dietListForm.jsp"> 식단List </a></li>
                    <li><a class="sub-menuLink longLink" href="foodPlusForm.jsp"> 식단 추가 </a></li>
                </ul>
            </li>  
        </ul>
        <ul>
            <li class="main-menu"><a class="nav-item" href="outBreakListForm.jsp"> 증상 관리 </a>  
                <ul class="sub-menu">
                    <li><a class="sub-menuLink longLink" href="outBreakListForm.jsp"> 증상List </a></li>
                    <li><a class="sub-menuLink longLink" href="outBreakPlusForm.jsp"> 증상 추가 </a></li>
                </ul>
            </li>  
        </ul>
        <a class="nav-item" href="findAllergyTypeForm.jsp"> 원인 분석 </a>
        <a class="nav-item" href="outbreakChart.jsp"> 증상 변화 </a>
        <a class="nav-login" href="loginForm.jsp"><img src="./picture/user.png" width="15%" height="15%"> Login </a>
    </nav>
    
    <!-- 로그인 폼 -->
    <div class="loginZone">
        <h2> 로그인 </h2>
    	<form method="post" action="loginAction.jsp" class="loginForm">
    		<input type="text" class="input" placeholder="아이디" name="userID"> <br>
    		<input type="password" class="input" placeholder="비밀번호" name="userPassword"> <br>
    		<input type="submit" class="inputLogin" value = "로그인">
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