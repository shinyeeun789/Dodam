<%@page import="food.Food"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="food.FoodDAO"%>
<%@page import="user.UserDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 도담도담 </title>
</head>
<body>
	<%
		String userID = null;	
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		
		UserDAO userDAO = new UserDAO();
		String allergyType = userDAO.getAllergy(userID);
		String[] allergyArr = allergyType.split(" ");
	%>
	<jsp:include page="menu.jsp" flush="false"/>
	
	<div class="rFoodDiv">
	<table style="margin-left: auto; margin-right: auto;">
		<tr>
		<% for(int idx=0; idx<allergyArr.length; idx++) { %>
			<td>
				<img style="width:30%; height:auto;" src="./picture/유발식재료_<%=allergyArr[idx]%>.png">
				<p><%=allergyArr[idx]%> 알레르기를 가지고 있어요 </p> <br>
			</td>
		<% } %>
		</tr>
	</table>
	</div>
	
	<div class="safeFoodDiv">
		<br> <h1> 이 음식들은 안전해요! </h1> <br>
	<%
		FoodDAO foodDAO = new FoodDAO();
		ArrayList<Food> foodList = foodDAO.getSafeFood(allergyType);
		for(int idx=0; idx<foodList.size(); idx++) {
	%>
			<p style="font-size:15pt;"> [<%=foodList.get(idx).getManufacturer()%>] <%=foodList.get(idx).getFoodName()%> </p>
	<%	} %>
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