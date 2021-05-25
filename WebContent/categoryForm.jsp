<%@page import="java.util.ArrayList"%>
<%@page import="food.Food"%>
<%@page import="food.FoodDAO"%>
<%@page import="user.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>
<jsp:useBean id="food" class="food.Food" scope="page"/>
<jsp:setProperty name="food" property="category" />
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
	String category = request.getParameter("category");
%>
	<jsp:include page="menu.jsp" flush="false"/>
    
    <!-- 음식 리스트 -->
    <h2 class="category-name" align="center"><%=category%></h2>
    <form class="category" method="get" action="foodDetailForm.jsp">
	<%
		FoodDAO foodDAO = new FoodDAO();
		ArrayList<Food> list = foodDAO.categories(category);
		for (int i=0; i<list.size(); i++) {
	%>
			<button class="categoryForm-item" name="foodName" value="<%=list.get(i).getFoodName()%>"> <img src="./picture/<%=list.get(i).getImage()%>" width="60%"><br> 
			[<%=list.get(i).getManufacturer()%>] <%= list.get(i).getFoodName()%> </button>
	<%	} %>
	</form>
    
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