<%@page import="user.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 도담도담 </title>
<link rel="stylesheet" href="./css/dodam.css">
</head>
<body>
	<%
		String userID = null;	
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
	%>
	
	<!-- GNB -->
	<nav class="nav-container">
        <a class="nav-logo" href="main.jsp"> 도담도담 </a>
        <ul>
            <li class="main-menu"><a class="nav-item" href="dietListForm.jsp"> 식단 관리 </a>  
                <ul class="sub-menu">
                    <li><a class="sub-menuLink longLink" href="dietListForm.jsp"> 식단List </a></li>
                    <li><a class="sub-menuLink longLink" href="dietPlusForm.jsp"> 식단 추가 </a></li>
                    <li><a class="sub-menuLink LongLink" href="dietImgForm.jsp"> 내 갤러리 </a></li>
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
    <%
    	String userAllergy = new UserDAO().getAllergy(userID);
    	if(userAllergy == null) {
    %>
    	<a class="nav-item" href="findAllergyTypeForm.jsp"> 원인 분석 </a>
    <% } else { %>
    	<a class="nav-item" href="restrictedFoodForm.jsp"> 섭취 제한 식품 </a>
    <% } %>
    <a class="nav-item" href="outbreakChart.jsp"> 증상 변화 </a>
    <% if(userID == null) { %>
    	<a class="nav-login" href="loginForm.jsp"><img src="./picture/user.png" width="15%" height="15%"> Login </a>
    <% } else { %>
    	<a class="nav-login" href="logoutAction.jsp"><img src="./picture/user.png" width=15% height=15%> Logout </a>
    <% } %>
    </nav>
</body>
</html>