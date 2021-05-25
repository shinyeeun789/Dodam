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
	
	String foodName = request.getParameter("foodName");
	String userAllergy = new UserDAO().getAllergy(userID);
	String[] arrIngredient, arrUserAllergy;
	FoodDAO foodDAO = new FoodDAO();
	Food food = foodDAO.foodData(foodName);

	if(userAllergy == null) {
%>
	<p> <%=food.getIngredient()%>
<%
	} else {
		arrIngredient = (food.getIngredient()).split(" ");
		arrUserAllergy = userAllergy.split(" ");
		for(int i=0; i<arrIngredient.length; i++) {
			int count = 0;
			for(int j=0; j<arrUserAllergy.length; j++) {
				if(arrIngredient[i].equals(arrUserAllergy[j])) {
					%> <strong style="color:red"><%=arrIngredient[i] %></strong> <%
				}else {
					count++;
				}
			}
			if(count==arrUserAllergy.length) { %>
				<%=arrIngredient[i] %> <%
			}
		}	
	}
%>
</body>
</html>