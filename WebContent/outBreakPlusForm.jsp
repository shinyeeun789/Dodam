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
    
    <!-- 증상 추가 form -->
    <div class="PlusDiv">
        <form class="PlusForm" method="post" action="oPlusAction.jsp">
            <h2> 증상 추가 </h2>
            <div class="dietPlus">
                <input type="date" name="outbreakDate" class="oDate">
                <input type="time" min="00:00:00" max="24:00:00" name="outbreakTime" class="oTime">
            </div>
            <table class="oTable">
                <tr>
                    <td colspan="2"> 
                        <select class="outbreak" name="type">
                            <option value="구토"> 구토 </option>
                            <option value="복통"> 복통 </option>
                            <option value="설사"> 설사 </option>
                            <option value="두드러기"> 두드러기 </option>
                            <option value="부종"> 부종 </option>
                            <option value="재채기"> 재채기 </option>
                            <option value="콧물"> 콧물 </option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div class="bodyPart">
                            <input type="radio" id="contactChoice1"
                                   name="bodyPart" value="얼굴">
                            <label for="contactChoice1">얼굴</label> &nbsp; 
                            <input type="radio" id="contactChoice2" 
                                   name="bodyPart" value="손">
                            <label for="contactChoice2">손</label>  &nbsp; 
                            <input type="radio" id="contactChoice3"
                                   name="bodyPart" value="발">
                            <label for="contactChoice3">발</label>  &nbsp; 
                            <input type="radio" id="contactChoice4"
                                   name="bodyPart" value="다리">
                            <label for="contactChoice1">다리</label>  &nbsp; 
                            <input type="radio" id="contactChoice5"
                                   name="bodyPart" value="팔">
                            <label for="contactChoice2">팔</label>  &nbsp; 
                            <input type="radio" id="contactChoice6"
                                   name="bodyPart" value="상체">
                            <label for="contactChoice3">상체</label>  &nbsp; 
                            <input type="radio" id="contactChoice7"
                                   name="bodyPart" value="하체">
                            <label for="contactChoice3">하체</label>  &nbsp; 
                          </div>
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