<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="java.io.PrintWriter" %>
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
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 후 사용할 수 있습니다.')");
		script.println("location.href = 'loginForm.jsp'");
		script.println("</script>");
	}
%>
	<jsp:include page="menu.jsp" flush="false"/>
    
    <!-- 약 복용 정보 추가 form -->
    <div class="PlusDiv">
        <form class="PlusForm" method="post" action="mPlusAction.jsp">
            <h2> 약 복용 정보 추가 </h2>
            <div class="dietPlus">
                <input type="date" name="medicineDate" class="oDate">
                <input type="time" min="00:00:00" max="24:00:00" name="medicineTime" class="oTime">
            </div>
            <table class="oTable">
                <tr>
                    <td colspan="2"> 
                        <input type="text" class="inputMedicine" name="medicine" placeholder="어떤 약을 복용했나요?">
                    </td>
                </tr>
                <tr>
                    <td colspan="2"> <input class="plus" type="submit" value="추가하기"> </td>
                </tr>
            </table>
        </form>
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