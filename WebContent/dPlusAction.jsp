<%@page import="java.util.ArrayList"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="diet.Diet"%>
<%@ page import="diet.DietDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 도담도담 </title>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
</head>
<body>
<%
	String fileSave = "/saveFile";
	String real = application.getRealPath(fileSave);
	int max = 1024 * 1024 * 10;
	MultipartRequest mr = new MultipartRequest(request, real, max, "utf-8",
			new DefaultFileRenamePolicy());
	
	Diet diet = new Diet();
	
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	
	String[] dietArray = mr.getParameterValues("dietList");
	for(int idx=0; idx<dietArray.length; idx++) {
		diet.setDietDate(mr.getParameter("dietDate"));
		diet.setDietTime(mr.getParameter("dietTime"));
		diet.setBrelupper(mr.getParameter("brelupper"));
		diet.setFoodName(dietArray[idx]);
		diet.setSaveFileName(mr.getFilesystemName("saveFileName"));
		
		if(userID != null) {
			if(diet.getDietDate().equals("") || diet.getDietTime().equals("") || diet.getFoodName().equals("")) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력 안된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				DietDAO dietDAO = new DietDAO();
				int result = dietDAO.write(userID, diet.getDietDate(), diet.getDietTime(), diet.getBrelupper(), diet.getFoodName(), diet.getSaveFileName());
				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('식단 추가에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				} else {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href='dietListForm.jsp'");
					script.println("</script>");
				}
			}
		}
	}
%>
</body>
</html>