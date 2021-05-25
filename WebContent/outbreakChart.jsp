<%@page import="medication.MedicineCount"%>
<%@page import="medication.MedicationDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="outbreak.OutbreakDAO"%>
<%@page import="outbreak.OutbreakCount"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 도담도담 </title>
<link rel="stylesheet" href="./css/dodam.css">
<script src="./js/Chart.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
</head>
<body>
<%
	String userID = null;	
	if(session.getAttribute("userID") != null){
		userID = (String)session.getAttribute("userID");
	
		MedicationDAO medicationDAO = new MedicationDAO();
		OutbreakDAO outbreakDAO = new OutbreakDAO();
		ArrayList<OutbreakCount> countList = outbreakDAO.getoutbreakCount(userID);
		MedicineCount medicineInfo = medicationDAO.getMaxMedicine(userID);
		
		String maxType = outbreakDAO.getMaxType(userID, 1);
		String typeNum = outbreakDAO.getMaxType(userID, 2);
		int countType = outbreakDAO.getTypeCount(userID);
		String maxBodyPart = outbreakDAO.getMaxBodypart(userID, 1);
		String bodypartNum = outbreakDAO.getMaxBodypart(userID, 2);
		int countBodypart = outbreakDAO.getBodypartCount(userID);
		
%>
	<jsp:include page="menu.jsp" flush="false"/>
	
	<div class="outbreakChartDiv">
		<canvas id="myChart"></canvas>
	</div>
	
	<script type="text/javascript">
	var ctx = document.getElementById("myChart");
	var myChart = new Chart(ctx, {
		type: 'line',
		data: {
			labels: [
				<% for(int idx=0; idx<countList.size(); idx++) { %>
					<%if(idx==countList.size()) { %>
					'<%= countList.get(idx).getOutbreakMonth() %>'
					<%} %>
				'<%= countList.get(idx).getOutbreakMonth() %>',
				<% } %>
			],
			datasets: [{
				label: "알러지 발생 횟수",
				fill: false,
				borderColor: "#f1c40f",
				borderWidth: 3,
				data: [
				<% for(int idx=0; idx<countList.size(); idx++) { %>
					<%if(idx==countList.size()) { %>
						'<%= countList.get(idx).getCount() %>'
					<%} %>
						'<%= countList.get(idx).getCount() %>',
					<% } %>
				],
			}]
		},
		options: {
			animation: {
		        duration: 0
			},
			scales: {
				yAxes: [{
					ticks: {
						min: 0,
						stepSize: 1
					}
				}]
			}
		}
	});
	</script>
	
	<div class="safeFoodDiv">
	<% if(maxType.equals("") || maxBodyPart.equals("")) { %>
		<h2> 아직 증상 데이터가 많지 않아요. </h2>
		<p style="font-size:15pt"> 증상이 나타난다면 기록해주세요! </p>	
	<% } else {%>
    	<br> <h2> 내 몸에 <strong style="color:#44546A">"<%=maxType%>"</strong> 형태로 <strong style="color:#44546A">"<%=maxBodyPart%>"</strong>에 많이 났어요 </h2> <br>
   		<p style="font-size:15pt"> <%=countType%>번 중 <%=typeNum%>번이 <%=maxType%> 형태입니다. </p>
   		<p style="font-size:15pt"> <%=countBodypart%>번 중 <%=bodypartNum%>번이 <%=maxBodyPart%>에 증상이 나타났어요. </p>
   	<% } %>
    </div>
    
    <div class="safeFoodDiv">
    <% if(medicineInfo.getMedicine() == null) { %>
    	<h2> 아직 약 복용 정보가 없어요. </h2>
    	<p style="font-size:15pt"> 약을 복용했다면 기록해주세요! </p>
    <% } else { %>
    	<h2> 지난 5개월 동안 나의 약 복용 정보 </h2>
		<p style="font-size:15pt"> <strong style="color:#44546A">"<%=medicineInfo.getMedicine()%>"</strong> 을 <strong style="color:#44546A">"<%=medicineInfo.getCount()%>"</strong>번 섭취했어요. </p>
	<% } %>
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
    
<%
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 후 사용할 수 있습니다.')");
		script.println("location.href = 'loginForm.jsp'");
		script.println("</script>");
	}
%>
</body>
</html>