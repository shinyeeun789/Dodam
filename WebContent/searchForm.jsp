<%@page import="java.io.PrintWriter"%>
<%@page import="food.Food"%>
<%@page import="java.util.ArrayList"%>
<%@page import="food.FoodDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
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
	}
	String searchKeyword = request.getParameter("keyword");
	String option = request.getParameter("col");
%>
	<!-- GNB -->
	<jsp:include page="menu.jsp"></jsp:include>
    
    <!-- 검색창 -->
    <div class="search">
        <form method="get" action="searchForm.jsp">
        	<select name="col" class="sfSelect">
        		<option value="식품 이름"> 식품 이름 </option>
        		<option value="제조사"> 제조사 </option>
        	</select>
            <input type="text" name="keyword" class="sfKeyword" placeholder="어떤 제품이 궁금한가요?">
            <button type="submit" class="search-icon"> <img src="./picture/searchIcon.png" alt="search"> </button>
        </form>
    </div>
    
    <!-- 검색 결과 -->
    <form class="searchForm" method="get" action="foodDetailForm.jsp">
    	<%
		FoodDAO foodDAO = new FoodDAO();
    	ArrayList<Food> list = null;
    	if(option.equals("식품 이름")) {
			list = foodDAO.search(null, searchKeyword); 
		} else {
			list = foodDAO.search(searchKeyword, null);
		}%>
			<h4 align="left" style="padding-left:2%"> <%=option %>) "<%= searchKeyword%>" 검색 결과 <%= list.size()%>개 </h4>
	    	<hr style="background-color: gray; border: solid 1px gray;">
		<%	for (int i=0; i<list.size(); i++) {
		%>
				<button class="categoryForm-item" name="foodName" value="<%=list.get(i).getFoodName()%>"> <img src="./picture/<%=list.get(i).getImage()%>" width="60%"><br> 
				[<%=list.get(i).getManufacturer()%>] <%= list.get(i).getFoodName()%> </button>
		  <%} %>
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