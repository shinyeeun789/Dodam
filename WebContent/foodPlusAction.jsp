<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="food.FoodDAO"%>

<%
	request.setCharacterEncoding("utf-8");
	String foodName = request.getParameter("foodName");
	FoodDAO foodDAO = new FoodDAO();
	JSONArray jsonArray = foodDAO.getFoodJSON(foodName);
	
	response.getWriter().print(jsonArray);
%>
