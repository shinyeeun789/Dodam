<%@page import="outbreak.OutbreakDAO"%>
<%@page import="org.json.simple.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String userID = (String) session.getAttribute("userID");
	request.setCharacterEncoding("utf-8");
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
	OutbreakDAO outbreakDAO = new OutbreakDAO();
	JSONArray outbreakList = outbreakDAO.getOutbreakList(userID, startDate, endDate);
	
	response.getWriter().print(outbreakList);
%>