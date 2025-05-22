<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get user information from session
    String username = (String) session.getAttribute("username");
    String name = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");

    // Use name if available, otherwise use username
    String displayName = (name != null && !name.isEmpty()) ? name : username;
%>
<!-- Header -->
<header>
    <div class="container">
        <div class="header-content">
            <div class="logo">
                <a href="<%= request.getContextPath() %>/index.jsp">LifeCare <span>Medical</span></a>
            </div>
            <nav>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/index.jsp">Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/dashboard">Admin Dashboard</a></li>
                    <li><a href="<%= request.getContextPath() %>/departments">Departments</a></li>
                    <li><a href="<%= request.getContextPath() %>/Service.jsp">Services</a></li>
                    <li><a href="<%= request.getContextPath() %>/appointments.jsp">Appointments</a></li>
                </ul>
            </nav>
            <div class="user-menu">
                <div class="user-menu-toggle">
                    <img src="https://via.placeholder.com/40x40" alt="Admin">
                    <span><%= displayName %></span>
                </div>
                <div class="user-menu-dropdown">
                    <ul>
                        <li><a href="<%= request.getContextPath() %>/admin/profile"><i class="fas fa-user"></i> Profile</a></li>
                        <li><a href="<%= request.getContextPath() %>/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                        <li><a href="<%= request.getContextPath() %>/admin/settings"><i class="fas fa-cog"></i> Settings</a></li>
                        <li><a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</header>
