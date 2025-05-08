<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// Get attributes from session
String username = (String) session.getAttribute("username");
String name = (String) session.getAttribute("name");
String role = (String) session.getAttribute("role");

// Set a default display name
String displayName = (name != null && !name.isEmpty()) ? name : (username != null ? username : "Patient");
%>
<!-- Header -->
<header>
    <div class="container">
        <div class="header-content">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/index.jsp">LifeCare <span>Medical</span></a>
            </div>
            <nav>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/patient/dashboard">Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/departments">Departments</a></li>
                    <li><a href="${pageContext.request.contextPath}/Service.jsp">Services</a></li>
                    <li><a href="${pageContext.request.contextPath}/appointments.jsp">Appointments</a></li>
                </ul>
            </nav>
            <div class="user-menu">
                <div class="user-menu-toggle">
                    <img src="https://ui-avatars.com/api/?name=<%= displayName %>&background=1a73e8&color=fff&size=40" alt="<%= displayName %>" style="border: 2px solid #1a73e8;">
                    <span><%= displayName %></span>
                </div>
            </div>
        </div>
    </div>
</header>
