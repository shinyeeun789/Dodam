<%@page import="user.User"%>
<%@page import="food.Food"%>
<%@page import="food.FoodDAO"%>
<%@page import="user.UserDAO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name = "viewport" content="width=device-width, initial-scale=1.0">
<title> 도담도담 </title>
<link rel="stylesheet" href="./css/dodam.css">
</head>
<body>
<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
%>
	<jsp:include page="menu.jsp" flush="false"/>
    
    <!-- 식품 상세 정보 -->
<%
	String foodName = request.getParameter("foodName");
	UserDAO userDAO = new UserDAO();
	FoodDAO foodDAO = new FoodDAO();
	Food food = foodDAO.foodData(foodName);
%>
	<div class="foodDetailImg"><img src="./picture/<%=food.getImage()%>"></div>
	<div class="foodDetailDiv">
		<h3> [<%=food.getManufacturer()%>] <%=food.getFoodName()%> </h3>
		<br><hr style="background-color: gray; border: solid 1px gray;"><br>
		<h3> 성분 정보 </h3>
		<jsp:include page="foodDetailAction.jsp" flush="false"/>
		<br><br>
		<h3> 교차 오염 정보 </h3>
		<% if(food.getCrossContamination() == null) {%>
			<p> 교차 오염 정보가 없습니다. </p>
		<%} else {%>
			<p> <strong style="color: #595959;"><%=food.getCrossContamination()%></strong>를 원료로 한 제품과 같은 제조시설에서 제조하였습니다. </p> 
		<%} %>
		
		<br><br>
	<%
		int checkSafeFood = foodDAO.checkFood(userDAO.getAllergy(userID), food.getIngredient());
		if(checkSafeFood == 0) {%>
			<img src="./picture/식품찾기_웃음.png" width="10%" height="auto"> 안전한 식품이에요:)
	<%} else if(checkSafeFood == 1) { %>
			<img src="./picture/식품찾기_슬픔.png" width="10%" height="auto"> 추천하지 않아요:(
	<%}%>
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