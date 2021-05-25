<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.User"%>
<%@ page import="user.UserDAO"%>
<%@page import="outbreak.OutbreakDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name = "viewport" content="width=device-width, initial-scale=1.0">
<title> 도담도담 </title>
<link rel="stylesheet" href="./css/dodam.css">
<!-- 슬라이드 배너 플러그인 -->
<link rel="shortcut icon" href="../favicon.ico"> 
<link href='http://fonts.googleapis.com/css?family=Open+Sans+Condensed:700,300,300italic' rel='stylesheet' type='text/css'>
<link rel="stylesheet" type="text/css" href="css/demo.css" />
<link rel="stylesheet" type="text/css" href="css/style.css" />
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<!-- jmpress plugin -->
<script type="text/javascript" src="js/jmpress.min.js"></script>
<!-- jmslideshow plugin : extends the jmpress plugin -->
<script type="text/javascript" src="js/jquery.jmslideshow.js"></script>
<script type="text/javascript" src="js/modernizr.custom.48780.js"></script>
</head>
<body>
	<%
		String userID = null;	
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
	%>
	<jsp:include page="menu.jsp" flush="false"/>
    
    <!-- Main Slide Banner -->
    <section id="jms-slideshow" class="jms-slideshow">
    <% if(userID == null) { %>	
		<div class="step" data-color="color-1">
			<div class="jms-content">
				<h3>알레르기 유발 식재료</h3>
				<p>난류, 우유, 메밀, 땅콩, 대두, 밀, 고등어, 게, 새우, 돼지고기, 복숭아, 토마토, 호두, 닭고기, 쇠고기, 오징어, 조개류(굴, 전복, 홍합 포함)</p>
			</div>
			<img src="./picture/allergy.png" width="40%"/>
		</div>
		<div class="step" data-color="color-2" data-y="500" data-scale="0.4" data-rotate-x="30">
			<div class="jms-content">
				<h3>더 많은 기능은</h3>
				<p>로그인 후 사용 가능합니다.</p>
				<a class="jms-link" href="loginForm.jsp">로그인 하러 가기</a>
			</div>
		</div>
	<% } else { %>
    	<div class="step" data-color="color-5">
			<div class="jms-content">
				<h3> 오늘 하루는 </h3>
				<p> 어땠나요? <p>
				<p> 오늘 있었던 일을 기록해주세요! </p>
				<a class="jms-link" href="dietPlusForm.jsp"> 식단 추가 </a>
				<a class="jms-link" href="outBreakPlusForm.jsp"> 증상 추가 </a>
				<a class="jms-link" href="medicinePlusForm.jsp"> 약 복용 정보 추가 </a>
			</div>
			<img src="./picture/question.png" width="30%"/>
		</div>
		<div class="step" data-color="color-2" data-y="500" data-scale="0.4" data-rotate-x="30">
			<div class="jms-content">
			<%
				UserDAO userDAO = new UserDAO();
				String allergyType= userDAO.getAllergy(userID);
				if(allergyType != null) {
					String[] allergyArr = allergyType.split(" ");
			%>
					<h3> <%=userID%>님의 <br> 알레르기 원인 식품은 </h3>
					<p> <% for(int idx=0; idx<allergyArr.length; idx++) { %>
							<%=allergyArr[idx]%> 
						<% } %>입니다.</p>
			<%	} else { %>
					<h3> 식단과 증상 정보가 많으면 </h3>
					<p> 더 정확하게 알레르기 원인 식품을 예상할 수 있어요 </p>
					<a class="jms-link" href="findAllergyTypeForm.jsp"> 원인 식품 예상하러 가기 </a>
			<%	} %>
			</div>
			<img src="./picture/smile.png" width="40%"/>
		</div>
		<div class="step" data-color="color-4" data-x="-100" data-z="1500" data-rotate="170">
			<div class="jms-content">
				<h3> 한 달 동안의 <br> 알레르기 발생 횟수는 </h3>
			<%
				OutbreakDAO outbreakDAO = new OutbreakDAO();
			%>
				<p> 총 <%=outbreakDAO.getTotalCount(userID)%>번입니다. </p>
			</div>
			<img src="./picture/graphBar.png" width="28%" style="margin-top: 3%"/>
		</div>
    <% } %>
	</section>
	<script type="text/javascript">
	$(function() {
		var jmpressOpts	= {
			animation		: { transitionDuration : '0.8s' }
		};
		$( '#jms-slideshow' ).jmslideshow( $.extend( true, { jmpressOpts : jmpressOpts }, {
			autoplay	: true,
			bgColorSpeed: '0.8s',
			arrows		: false
		}));
	});
	</script>
	
	<!-- 식품 검색창 -->
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
    
   <!-- 식품 카테고리  -->
    <div class="category">
    	<form method="get" action="categoryForm.jsp">
    		<button class="category-item" name="category" value="피자"><img src="./picture/카테고리_피자.png" width="60%"><br> 피자 </button>
    		<button class="category-item" name="category" value="치킨"><img src="./picture/카테고리_치킨.png" width="60%"><br> 치킨 </button>
    		<button class="category-item" name="category" value="분식"><img src="./picture/카테고리_분식.png" width="60%"><br> 분식 </button>
    		<button class="category-item" name="category" value="패스트푸드"><img src="./picture/카테고리_패스트푸드.png" width="60%"><br> 패스트푸드 </button>
    		<button class="category-item" name="category" value="빵"><img src="./picture/카테고리_빵.png" width="60%"><br> 빵 </button>
    		<button class="category-item" name="category" value="간식"><img src="./picture/카테고리_간식.png" width="60%"><br> 간식 </button>
    		<button class="category-item" name="category" value="가공식품"><img src="./picture/카테고리_가공식품.png" width="60%"><br> 가공식품 </button>
    		<button class="category-item" name="category" value="기타"><img src="./picture/카테고리_기타.png" width="60%"><br> 기타 </button>
    	</form>
    </div>
    
    <footer class="footer-section">
        <div>
			<img src="./picture/logo_white.png" width="250px">
			<br>
            <p> 상호  도담도담 &nbsp;  &nbsp; |  &nbsp; &nbsp; 대표  신예은 </p>
            <p> 이메일  tlsdpdms789@naver.com </p> <br><br><br>

			<hr>
			
			<p> <br><br><br> 제공하는 정보의 알러지 성분은 제품의 제조사에서 제공한 정보이며, 알레르기 유발 식재료의 종류는 식약처장에서 발표한 자료입니다. 또한, 본 웹에서 제공하는 모든 정보는 참고 사항입니다. </p>
			<p> 모든 이미지는 <a class="img-copyright" href="https://www.flaticon.com">Flaticon</a>과 <a class="img-copyright" href="https://www.iconfinder.com">IconFinder</a>에서 제공한 이미지를 사용했습니다.</p> <br>
    		<p class="copyright"> ⓒ 2020 DodamDodam </p>
        </div>
    </footer>
</body>
</html>
