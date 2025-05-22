<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header>
    <!-- Top Header -->
    <div class="top-header">
        <div class="container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/">
                    <div class="logo-icon">+</div>
                    <span>LifeCare Medical Center</span>
                </a>
            </div>
            <div class="auth-buttons">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-login">Login</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-register">Register</a>
                    </c:when>
                    <c:otherwise>
                        <div class="user-menu">
                            <span>Welcome, ${sessionScope.username}</span>
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Logout</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Main Navigation -->
    <nav class="main-nav">
        <div class="container">
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/appointments">Appointments</a></li>
                <li><a href="${pageContext.request.contextPath}/departments">Departments</a></li>
                <li><a href="${pageContext.request.contextPath}/services">Services</a></li>
                <c:if test="${not empty sessionScope.user}">
                    <li>
                        <c:choose>
                            <c:when test="${sessionScope.role eq 'doctor'}">
                                <!-- Doctor has no dashboard -->
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/${sessionScope.role}/dashboard.jsp">Dashboard</a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </c:if>
            </ul>

            <!-- Mobile Menu Button -->
            <div class="mobile-menu-btn">
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>
    </nav>
</header>