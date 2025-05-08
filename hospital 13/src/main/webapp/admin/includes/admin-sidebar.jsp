<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get the current page to highlight the active menu item
    String currentPage = request.getRequestURI();
    String contextPath = request.getContextPath();
    
    // Extract the page name from the URI
    String pageName = currentPage.substring(currentPage.lastIndexOf("/") + 1);
    if (pageName.contains(".")) {
        pageName = pageName.substring(0, pageName.indexOf("."));
    }
    
    System.out.println("Admin Sidebar: Current page is " + pageName);
%>
<!-- Admin Sidebar -->
<div class="admin-sidebar">
    <div class="admin-sidebar-header">
        <h3>Admin Panel</h3>
        <p>Manage your hospital</p>
    </div>
    <ul class="admin-sidebar-menu">
        <li>
            <a href="<%= contextPath %>/admin/dashboard" class="<%= "dashboard".equals(pageName) ? "active" : "" %>">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="<%= contextPath %>/admin/patients" class="<%= "patients".equals(pageName) ? "active" : "" %>">
                <i class="fas fa-user-injured"></i> Patients
            </a>
        </li>
        <li>
            <a href="<%= contextPath %>/admin/doctors" class="<%= "doctors".equals(pageName) ? "active" : "" %>">
                <i class="fas fa-user-md"></i> Doctors
            </a>
        </li>
        <li>
            <a href="<%= contextPath %>/admin/appointments" class="<%= "appointments".equals(pageName) ? "active" : "" %>">
                <i class="fas fa-calendar-check"></i> Appointments
            </a>
        </li>
        <li>
            <a href="<%= contextPath %>/admin/departments" class="<%= "departments".equals(pageName) ? "active" : "" %>">
                <i class="fas fa-hospital"></i> Departments
            </a>
        </li>
        <li>
            <a href="<%= contextPath %>/admin/services" class="<%= "services".equals(pageName) ? "active" : "" %>">
                <i class="fas fa-stethoscope"></i> Services
            </a>
        </li>
        <li>
            <a href="<%= contextPath %>/admin/reports" class="<%= "reports".equals(pageName) ? "active" : "" %>">
                <i class="fas fa-chart-bar"></i> Reports
            </a>
        </li>
        <li>
            <a href="<%= contextPath %>/admin/settings" class="<%= "settings".equals(pageName) ? "active" : "" %>">
                <i class="fas fa-cog"></i> Settings
            </a>
        </li>
    </ul>
</div>
