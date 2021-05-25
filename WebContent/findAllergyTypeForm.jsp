<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.apache.commons.collections4.ListUtils"%>
<%@page import="food.Food"%>
<%@page import="food.FoodDAO"%>
<%@ page import="java.io.PrintWriter" %>
<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<%@page import="findType.FindType"%>
<%@page import="findType.Type"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name = "viewport" content="width=device-width, initial-scale=1.0">
<title>도담도담</title>
<link rel="stylesheet" href="./css/dodam.css">
<script src="http://code.jquery.com/jquery-2.0.3.min.js"></script>
<script src="http://rendro.github.io/easy-pie-chart/javascripts/jquery.easy-pie-chart.js"></script>
<script type="text/javascript" src="js/easypiechart.js"></script>
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
		
		FindType findType = new FindType();
		FoodDAO foodDAO = new FoodDAO();
		ArrayList<Type> percent = findType.findAllergyType(userID);
		Collections.sort(percent);
	%>
	<script>
        jQuery(document).ready(function($) {
            $('.chart0').easyPieChart({
                easing: 'easeOutBounce',
                barColor : '#F4B183',
                lineWidth: 30,
                lineCap: 'round',
                size: 300,
                animate: 1000,
                onStart: $.noop,
                onStop: $.noop
            });
            $('.chart1').easyPieChart({
                easing: 'easeOutBounce',
                barColor : '#FFD966',
                lineWidth: 30,
                lineCap: 'round',
                size: 300,
                animate: 1000,
                onStart: $.noop,
                onStop: $.noop
            });
            $('.chart2').easyPieChart({
                easing: 'easeOutBounce',
                barColor : '#9DC3E6',
                lineWidth: 30,
                lineCap: 'round',
                size: 300,
                animate: 1000,
                onStart: $.noop,
                onStop: $.noop
            });
        });
    </script>
	
	<jsp:include page="menu.jsp" flush="false"/>
	
    <div class="rFoodDiv">
		<% 
			for(int i=0; i<percent.size(); i++) {
				if(i==3)
					break;
		%>
			<div class="chart chart<%=i%>" data-percent="<%=percent.get(i).getPercent()%>">
		        <span class="percent">
		        	<img src="./picture/유발식재료_<%=percent.get(i).getIngredient()%>.png">
		        </span>
		    </div>
		<%	} %>
	</div>
    
    <div class="safeFoodDiv">
    	<br> <h2> 그 외 예상 유발 식품 </h2> <br>
    <% 	if(percent.size()<=3) {	%>
 			<p style="font-size:15pt"> 없어요 :) </p>
 	<% 	} %>
   	<% 	for(int i=3; i<percent.size(); i++) { %>
   			<p style="font-size:15pt"> <%=percent.get(i).getIngredient()%> (<%=String.format("%.1f",percent.get(i).getPercent())%>%) </p>
   	<% 	} %>
    </div>
    
    <div class="safeFoodDiv">
    	<br> <h2 style="color: #FC511C"> 이 음식들은 피하는 게 좋아요 </h2> <br>
   	<%
   		String allergyType = "";
   		for(Type item : percent) {
   			allergyType += item.getIngredient() + " ";
   		}
		ArrayList<Food> foodList = foodDAO.getDangerFood(allergyType);
		for(Food item : foodList) {
	%>
			<p style="font-size:15pt"> [<%=item.getManufacturer()%>] <%=item.getFoodName()%> </p>
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