<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="medication.MedicationDAO"%>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>

<jsp:useBean id="medication" class="medication.Medication" scope="page"/>
<jsp:setProperty name="medication" property="medicine" />
<jsp:setProperty name="medication" property="medicineDate" />
<jsp:setProperty name="medication" property="medicineTime" />
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
		if(medication.getMedicineDate() == null || medication.getMedicineTime() == null || medication.getMedicine() == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안된 사항이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else {
			MedicationDAO MedicationDAO = new MedicationDAO();
			int result = MedicationDAO.write(userID, medication.getMedicine(), medication.getMedicineDate(), medication.getMedicineTime());
			if (result == -1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('약 복용 정보 추가에 실패했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href='main.jsp'");
				script.println("</script>");
			}
		}
	}
%>
</body>
</html>