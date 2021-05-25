<%@page import="diet.Diet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="food.FoodDAO"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="java.io.PrintWriter"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name = "viewport" content="width=device-width, initial-scale=1.0">
<title>도담도담</title>
<link rel="stylesheet" href="./css/dodam.css">
</head>
<body>
	<%
		String userID = null;	
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		} else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인 후 사용할 수 있습니다.')");
			script.println("location.href = 'loginForm.jsp'");
			script.println("</script>");
		}
	%>
	<jsp:include page="menu.jsp" flush="false"/>
	
	<div class="imgListDiv">
		<h2> 내 사진들 </h2>
	<% 	FoodDAO foodDAO = new FoodDAO();
		ArrayList<Diet> list = foodDAO.getFoodImage(userID);
		for (int i=0; i<list.size(); i++) {
			if(list.get(i).getSaveFileName() == null)
				continue; %>
			<img src="./saveFile/<%=list.get(i).getSaveFileName()%>" title="<%=list.get(i).getDietDate()%>에 먹은 식단이에요">
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