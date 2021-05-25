<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="./css/dodam.css">
<link rel="stylesheet" type="text/css" media="screen" href="./css/jquery-ui.theme.min.css">
<link rel="stylesheet" type="text/css" media="screen" href="./css/ui.jqgrid.css"/>

<script src="./js/jquery-1.11.0.min.js" type="text/javascript"></script>
<script src="./js/i18n/grid.locale-en.js" type="text/javascript"></script>
<script src="./js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script type="text/javascript">
function write(result) {	
	$.jgrid.gridUnload('#list');	// 그리드 지우고 다시 그리기
	
	$("#list").jqGrid({
		datatype: "local",
		data: result,
		mtype: 'get',
		colNames: ['날짜','시간','타입','증상 위치'],
		colModel: [
			{ name: 'outbreakDate', index: 'outbreakDate', width: 100, align: 'center'},
			{ name: 'outbreakTime', index: 'outbreakTime', width: 100, align: 'center'},
			{ name: 'type', index: 'type', width: 100, align: 'center'},
			{ name: 'bodyPart', index: 'bodyPart', width: 100, align: 'center'}
		],
		loadtext: '로딩 중입니다:)',
		emptyrecords: '아직 저장된 증상이 없어요 :)',
		autowidth: true,
		height: 'auto'
	});
}

$(document).ready(function() {
	$("#search").click(function() {
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		$.ajax({
			url: "outBreakListAction.jsp",
			data: {'startDate' : startDate, 'endDate' : endDate},
			dataType: "json",
			success : function(result) {
				write(result);
			},
			error : function(request, status, error) {
				alert("데이터를 불러오지 못했습니다.");
			}
		});
	});
})
</script>
<title> 도담도담 </title>
</head>
<body>
<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 후 사용할 수 있습니다.')");
		script.println("location.href = 'loginForm.jsp'");
		script.println("</script>");
	}
%>
	<jsp:include page="menu.jsp" flush="false"/>

	<div class="dietListForm">
	<%  // value의 date 값 구하기
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String tDate = sdf.format(date);
		Calendar mon = Calendar.getInstance();
		mon.add(Calendar.MONTH, -1);
		String sDate = sdf.format(mon.getTime());
	%>
		<h2 style="margin-bottom:1%"> &nbsp; 내 증상 &nbsp; <input type="date" id="startDate" class="dListDate" value="<%=sDate%>"> - <input type="date" id="endDate" class="dListDate" value="<%=tDate%>">
		<button class="searchBtn" id="search"> 검색 </button> </h2>
		<div style="text-align: right;">
		<button class="dListBtn" onclick="location.href='outBreakPlusForm.jsp'"> 증상 추가 </button>
		<button class="dListBtn" onclick="location.href='medicinePlusForm.jsp'"> 약 정보 추가 </button> 
		<button class="dListBtn" onclick="location.href='dietListForm.jsp'"> 식단 리스트 </button></div>
		<br><br>
		<table id="list"></table>
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