<%@page import="org.json.simple.JSONArray"%>
<%@page import="diet.DietDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String userID = (String) session.getAttribute("userID");
	request.setCharacterEncoding("utf-8");
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
	DietDAO dietDAO = new DietDAO();
	JSONArray dietList = dietDAO.getDietList(userID, startDate, endDate);
	
	response.getWriter().print(dietList);
%>