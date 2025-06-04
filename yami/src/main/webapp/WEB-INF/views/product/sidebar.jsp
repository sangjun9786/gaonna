<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
    .sidebar {
        width: 250px;
        padding: 20px;
        border-right: 1px solid #ccc;
    }

    .sidebar h4 {
        margin-top: 20px;
        font-weight: bold;
    }

    .write-btn {
        display: block;
        width: 100%;
        background-color: #ff6600;
        color: white;
        border: none;
        padding: 12px;
        font-size: 16px;
        border-radius: 4px;
        text-align: center;
        margin-bottom: 30px;
        text-decoration: none;
    }

    .write-btn:hover {
        background-color: #e05500;
        text-decoration: none;
        color: white;
    }
</style>

<div class="sidebar">
    <!-- 글작성 버튼 -->
    <a href="${pageContext.request.contextPath}/productEnrollForm.pr" class="write-btn">글작성</a>
    
    <h4>위치</h4>
    <ul>
        <li><input type="checkbox"> 강남구</li>
        <li><input type="checkbox"> 역삼동</li>
        <li><input type="checkbox"> 청담동</li>
        <li><input type="checkbox"> 당산동</li>
    </ul>

    <h4>카테고리</h4>
    <ul>
        <li><input type="checkbox"> 패션잡화</li>
        <li><input type="checkbox"> 전자기기</li>
        <li><input type="checkbox"> 가전/주방</li>
    </ul>
</div>