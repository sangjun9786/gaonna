<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<style>
    //이벤트 테이블 스타일 시작
    html, body {
		width: 100%;
	    height: 100%;
	    margin: 0;
	    padding: 0;
	}
		
	.wrapper {
	    display: flex;
	    justify-content: center;
	    margin-top: 50px;
	    margin-bottom: 200px;
	}
		
	.inner {
	    display: flex;
	    align-items: flex-start;
	    gap: 60px;
	    box-sizing: border-box;
	}
		
	table {
		table-layout: fixed;
	    border-collapse: collapse;
	    width: 500px;
	    height: 500px;
	    background-color: #fff;
	    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
	}
		
	td {
	    border: 1px solid #ddd;
	    text-align: center;
	    padding: 12px;
	    font-size: 16px;
	}
	
	tr:nth-child(even) {
	    background-color: #f9fcff;
	}
	
	caption {
	    caption-side: top;
	    font-size: 24px;
	    font-weight: bold;
	    margin-bottom: 10px;
	}
		
	.eventInfo {
	    max-width: 500px;
	    background-color: #f7f9fc;
	    padding: 20px;
	    border-radius: 8px;
	    box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
	}
	
	.eventInfo h2 {
	    margin-top: 0;
	    font-size: 28px;
	    color: #333;
	}
	
	.eventInfo p {
	    font-size: 18px;
	    color: #555;
	    margin-bottom: 20px;
	}
	
	.eventInfo button {
	    padding: 10px 20px;
	    font-size: 15px;
	    background-color: #4caf50;
	    color: white;
	    border: none;
	    border-radius: 5px;
	    cursor: pointer;
	}
	
	.eventInfo button:hover {
	    background-color: #45a049;
	}
	//이벤트 테이블 스타일 끝
</style>
</head>
<body>
	<%@include file="/WEB-INF/views/common/header.jsp" %>
	
	<c:if test="${not empty loginUser and empty event}">
	  <script>
	    $(function() {
	      location.href = "${root}/info.ev";
	    });
	  </script>
	</c:if>
    <script>
    	$(function() {
    		$('#attendanceBtn').click(function() {
    			location.href = '${root}/attendance.me';
    		});
    	});
    </script>
	
    <div class="wrapper">
        <div class="inner">
        
            <!-- 회원 로그인 여부에 따라 테이블 조건 분기 -->
            <c:choose>
                <c:when test="${not empty sessionScope.loginUser }">
                    <table id="event">
                        <caption>출석 이벤트</caption>
                        <tbody>
                            <!-- 회원 정보 출석률 정보 받아와 테이블 구성 -->
							<c:set var="cellIndex" value="1" />
							<c:forEach var="i" begin="1" end="6">
								<tr>
									<c:forEach var="j" begin="1" end="5">
										<td
									        <c:if test="${cellIndex <= event.count}">
									          style="background-image: linear-gradient(rgba(255,255,255,0.5), rgba(255,255,255,0.5)),
											           url('${pageContext.request.contextPath}/resources/img/야미콘.png');
											           background-size: cover;
											           background-position: center;
											           background-blend-mode: lighten;
											           font-weight: bold;
											           color: white
											           text-shadow:
													        0 0 2px black,
        													0 0 3px black;"
									        </c:if>
									      >
											<c:choose>
												<c:when test="${cellIndex <= event.count}">
					                                야미!
					                            </c:when>
												<c:otherwise>
					                                ${cellIndex}
					                            </c:otherwise>
											</c:choose>
											<c:set var="cellIndex" value="${cellIndex + 1}" />
										</td>
									</c:forEach>
								</tr>
							</c:forEach>
						</tbody>
                    </table>
                </c:when>

                <c:otherwise>
                    <table>
                        <caption>출석 이벤트</caption>
                        <tbody>
                            <c:forEach var="i" begin="1" end="6">
                                <tr>
                                    <c:forEach var="j" begin="1" end="5">
                                        <td>${(i - 1) * 5 + j}</td>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>

            <div class="eventInfo">
                <h2>출석 이벤트 안내</h2>
                <br>
                <p>
                    매 5일 출석 시 현금처럼 사용 가능한 <br>
                    포인트가 500점 적립됩니다. <br>
                    매 10일 출석 시 1000포인트 적립! <br><br>
                    출석은 하루에 한 번만 가능합니다.
                    <br> <br>
                    해당 기능은 로그인 이후 이용 가능합니다.
                </p>
                <button type="button" id="attendanceBtn">출석하기</button>
            </div>
            
        </div>
    </div>
	
</body>
</html>