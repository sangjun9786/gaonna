<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>신고하기</title>
</head>
<body>
    <h3>🚩 신고하기</h3>
    <form action="${pageContext.request.contextPath}/report/insert" method="post">
        <input type="hidden" name="reportType" value="${reportType}">
        <input type="hidden" name="targetNo" value="${targetNo}">
        <textarea name="reason" rows="6" cols="50" placeholder="신고 사유를 입력하세요" required></textarea>
        <br>
        <button type="submit">신고 등록</button>
    </form>
    <a href="javascript:history.back()">뒤로가기</a>
</body>
</html>
