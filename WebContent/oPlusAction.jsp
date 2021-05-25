<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="outbreak.OutbreakDAO"%>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>
<jsp:useBean id="outbreak" class="outbreak.Outbreak" scope="page"/>
<jsp:setProperty name="outbreak" property="outbreakDate" />
<jsp:setProperty name="outbreak" property="outbreakTime" />
<jsp:setProperty name="outbreak" property="type" />
<jsp:setProperty name="outbreak" property="bodyPart" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 도담도담 </title>
</head>
<body>
<%
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID"); 
	} 
	if(userID != null) {
		if(outbreak.getOutbreakDate() == null || outbreak.getOutbreakTime() == null || outbreak.getType() == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안된 사항이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else {
			OutbreakDAO OutbreakDAO = new OutbreakDAO();
			int result = OutbreakDAO.write(userID, outbreak.getOutbreakDate(), outbreak.getOutbreakTime(), outbreak.getType(), outbreak.getBodyPart());
			if (result == -1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('증상 추가에 실패했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href='outBreakListForm.jsp'");
				script.println("</script>");
			}
		}
	}
%>
</body>
</html>