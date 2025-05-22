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

    // Special case for view-appointment
    boolean isViewingAppointment = pageName.equals("view-appointment");

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
            <a href="<%= contextPath %>/admin/appointments" class="<%= "appointments".equals(pageName) || isViewingAppointment ? "active" : "" %>">
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

<style>
    /* Admin Sidebar Styles */
    .admin-sidebar {
        width: 250px;
        background-color: #333;
        color: white;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        padding: 20px 0;
        margin-right: 30px;
        height: fit-content;
        position: sticky;
        top: 100px;
    }

    .admin-sidebar-header {
        padding: 0 20px 20px;
        border-bottom: 1px solid #444;
        margin-bottom: 20px;
    }

    .admin-sidebar-header h3 {
        font-size: 18px;
        color: white;
        margin-bottom: 5px;
        font-weight: 600;
    }

    .admin-sidebar-header p {
        font-size: 14px;
        color: #aaa;
        margin: 0;
    }

    .admin-sidebar-menu {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .admin-sidebar-menu li {
        margin-bottom: 5px;
    }

    .admin-sidebar-menu li a {
        display: flex;
        align-items: center;
        padding: 12px 20px;
        color: #ccc;
        text-decoration: none;
        transition: all 0.3s;
        border-left: 3px solid transparent;
    }

    .admin-sidebar-menu li a:hover {
        background-color: #444;
        color: white;
        border-left-color: #0066cc;
    }

    .admin-sidebar-menu li a.active {
        background-color: #0066cc;
        color: white;
        border-left-color: white;
    }

    .admin-sidebar-menu li a i {
        margin-right: 10px;
        width: 20px;
        text-align: center;
    }

    /* Responsive Styles */
    @media (max-width: 992px) {
        .admin-sidebar {
            width: 220px;
        }
    }

    @media (max-width: 768px) {
        .admin-sidebar {
            width: 100%;
            margin-right: 0;
            margin-bottom: 20px;
            position: static;
        }
    }
</style>
