<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>YAMI 관리센터</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">
    <%@include file="/WEB-INF/views/common/header.jsp"%>
    
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10 col-xxl-8">
                
                <!-- 최고관리자 전용 -->
                <c:if test="${loginUser.roleType == 'superAdmin'}">
                    <div class="card shadow-sm mb-4">
                        <div class="card-header bg-secondary text-white">
                            <h4 class="mb-0"><i class="bi bi-shield-lock me-2"></i>시스템 관리</h4>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <a href="${root}/updateAdmin.ad" class="btn btn-outline-secondary w-100 d-flex align-items-center">
                                        <i class="bi bi-people-fill me-2"></i>관리자 조회/수정
                                    </a>
                                </div>
                                <div class="col-md-6">
                                    <a href="${root}/insertAdmin.ad" class="btn btn-outline-secondary w-100 d-flex align-items-center">
                                        <i class="bi bi-person-plus me-2"></i>관리자 추가
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- 일반 회원 관리 -->
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0"><i class="bi bi-person-gear me-2"></i>회원 관리</h4>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-3">
                            <c:choose>
                                <c:when test="${loginUser.roleType != 'viewer'}">
                                    <a href="${root}/updateUser.ad" class="btn btn-outline-success d-flex align-items-center">
                                        <i class="bi bi-pencil-square me-2"></i>회원 조회/수정
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${root}/updateUser.ad" class="btn btn-outline-success d-flex align-items-center">
                                        <i class="bi bi-eye me-2"></i>회원 조회
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
				<!-- 게시글 관리 등등 -->
				<div class="card shadow-sm mb-4 mt-4">
				    <div class="card-header bg-primary text-white">
				        <h4 class="mb-0"><i class="bi bi-journal-text me-2"></i>게시글 관리</h4>
				    </div>
				    <div class="card-body">
				        <div class="row g-3">
				            <div class="col-md-6">
				                <a href="${root}/updateBoard.ad" class="btn btn-outline-primary w-100 d-flex align-items-center">
				                    <c:choose>
				                        <c:when test="${loginUser.roleType != 'viewer'}">
				                            <i class="bi bi-journal-text me-2"></i>게시글 조회/수정
				                        </c:when>
				                        <c:otherwise>
				                            <i class="bi bi-journal-text me-2"></i>게시글 조회
				                        </c:otherwise>
				                    </c:choose>
				                </a>
				            </div>
				            
				            <div class="col-md-6">
				                <a href="${root}/updateReply.ad" class="btn btn-outline-primary w-100 d-flex align-items-center">
				                    <c:choose>
				                        <c:when test="${loginUser.roleType != 'viewer'}">
						                    <i class="bi bi-chat-dots me-2"></i>댓글 조회/수정
				                        </c:when>
				                        <c:otherwise>
				                            <i class="bi bi-chat-dots me-2"></i>댓글 조회
				                        </c:otherwise>
				                    </c:choose>
				                </a>
				            </div>
				            
				            <div class="col-md-6">
				                <a href="${root}/updateBoardMember.ad" class="btn btn-outline-primary w-100 d-flex align-items-center">
				                    <c:choose>
				                        <c:when test="${loginUser.roleType != 'viewer'}">
						                    <i class="bi bi-journal-text me-2"></i>특정 회원이 작성한 게시글 조회/수정
				                        </c:when>
				                        <c:otherwise>
				                            <i class="bi bi-journal-text me-2"></i>특정 회원이 작성한 게시글 조회
				                        </c:otherwise>
				                    </c:choose>
				                </a>
				            </div>
				            
				            <div class="col-md-6">
				                <a href="${root}/updateReplyMember.ad" class="btn btn-outline-primary w-100 d-flex align-items-center">
				                    <c:choose>
				                        <c:when test="${loginUser.roleType != 'viewer'}">
						                    <i class="bi bi-chat-dots me-2"></i>특정 회원이 작성한 댓글 조회/수정
				                        </c:when>
				                        <c:otherwise>
				                            <i class="bi bi-chat-dots me-2"></i>특정 회원이 작성한 댓글 조회
				                        </c:otherwise>
				                    </c:choose>
				                </a>
				            </div>
				        </div>
				    </div>
				</div>

            </div>
        </div>
    </div>
</body>
</html>
