<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - LifeCare Medical Center</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Global Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f8f9fa;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        a {
            text-decoration: none;
            color: #0066cc;
        }

        .btn {
            display: inline-block;
            background-color: #0066cc;
            color: white;
            padding: 12px 24px;
            border-radius: 4px;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
            font-weight: 600;
        }

        .btn:hover {
            background-color: #0052a3;
        }

        .btn-outline-primary {
            background-color: transparent;
            border: 2px solid #0066cc;
            color: #0066cc;
        }

        .btn-outline-primary:hover {
            background-color: #0066cc;
            color: white;
        }

        .btn-sm {
            padding: 8px 16px;
            font-size: 14px;
        }

        .btn-success {
            background-color: #28a745;
        }

        .btn-success:hover {
            background-color: #218838;
        }

        .btn-danger {
            background-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        /* Header Styles */
        header {
            background-color: rgba(255, 255, 255, 0.9);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
        }

        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #0066cc;
        }

        .logo span {
            color: #28a745;
        }

        nav ul {
            display: flex;
            list-style: none;
        }

        nav ul li {
            margin-left: 30px;
        }

        nav ul li a {
            color: #333;
            font-weight: 500;
            transition: color 0.3s;
        }

        nav ul li a:hover {
            color: #0066cc;
        }

        .user-menu {
            position: relative;
        }

        .user-menu-toggle {
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .user-menu-toggle img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
        }

        .user-menu-toggle span {
            margin-right: 5px;
        }

        .user-menu-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: white;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-radius: 4px;
            width: 200px;
            z-index: 1000;
            display: none;
        }

        .user-menu:hover .user-menu-dropdown {
            display: block;
        }

        .user-menu-dropdown ul {
            display: block;
            padding: 10px 0;
        }

        .user-menu-dropdown ul li {
            margin: 0;
        }

        .user-menu-dropdown ul li a {
            display: block;
            padding: 10px 20px;
            color: #333;
            transition: background-color 0.3s;
        }

        .user-menu-dropdown ul li a:hover {
            background-color: #f8f9fa;
        }

        .user-menu-dropdown ul li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* Admin Dashboard */
        .admin-dashboard {
            display: flex;
            padding-top: 80px; /* Account for fixed header */
            min-height: 100vh;
        }

        .admin-sidebar {
            width: 250px;
            background-color: #333;
            color: white;
            padding: 30px 0;
            position: fixed;
            height: calc(100vh - 80px);
            overflow-y: auto;
        }

        .admin-sidebar-header {
            padding: 0 20px 20px;
            border-bottom: 1px solid #444;
            margin-bottom: 20px;
        }

        .admin-sidebar-header h3 {
            font-size: 20px;
            color: white;
        }

        .admin-sidebar-header p {
            font-size: 14px;
            color: #ccc;
        }

        .admin-sidebar-menu {
            list-style: none;
        }

        .admin-sidebar-menu li {
            margin-bottom: 5px;
        }

        .admin-sidebar-menu li a {
            display: block;
            padding: 12px 20px;
            color: #ccc;
            transition: all 0.3s;
            display: flex;
            align-items: center;
        }

        .admin-sidebar-menu li a:hover,
        .admin-sidebar-menu li a.active {
            background-color: #0066cc;
            color: white;
        }

        .admin-sidebar-menu li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .admin-content {
            flex: 1;
            margin-left: 250px;
            padding: 30px;
        }

        .admin-header {
            margin-bottom: 30px;
        }

        .admin-header h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 10px;
        }

        .admin-header p {
            color: #666;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 20px;
            display: flex;
            align-items: center;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            font-size: 24px;
        }

        .stat-icon.patients {
            background-color: #e6f2ff;
            color: #0066cc;
        }

        .stat-icon.doctors {
            background-color: #d4edda;
            color: #28a745;
        }

        .stat-icon.appointments {
            background-color: #fff3cd;
            color: #ffc107;
        }

        .stat-icon.departments {
            background-color: #f8d7da;
            color: #dc3545;
        }

        .stat-info h3 {
            font-size: 24px;
            margin-bottom: 5px;
        }

        .stat-info p {
            color: #666;
            font-size: 14px;
        }

        .recent-section {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 30px;
        }

        .recent-section h2 {
            font-size: 20px;
            margin-bottom: 20px;
            color: #333;
            display: flex;
            align-items: center;
        }

        .recent-section h2 i {
            margin-right: 10px;
            color: #0066cc;
        }

        .recent-table {
            width: 100%;
            border-collapse: collapse;
        }

        .recent-table th,
        .recent-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .recent-table th {
            font-weight: 600;
            color: #333;
        }

        .recent-table tr:hover {
            background-color: #f8f9fa;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-scheduled {
            background-color: #e6f2ff;
            color: #0066cc;
        }

        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }

        .actions {
            display: flex;
            gap: 5px;
        }

        /* Responsive Styles */
        @media (max-width: 992px) {
            .admin-sidebar {
                width: 200px;
            }

            .admin-content {
                margin-left: 200px;
            }
        }

        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
            }

            nav ul {
                margin-top: 20px;
            }

            nav ul li {
                margin-left: 15px;
                margin-right: 15px;
            }

            .admin-dashboard {
                flex-direction: column;
            }

            .admin-sidebar {
                width: 100%;
                height: auto;
                position: static;
                margin-bottom: 20px;
            }

            .admin-content {
                margin-left: 0;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 576px) {
            nav ul {
                flex-wrap: wrap;
                justify-content: center;
            }

            nav ul li {
                margin: 5px 10px;
            }

            .admin-header h1 {
                font-size: 24px;
            }

            .recent-table {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <a href="../index.jsp">LifeCare <span>Medical</span></a>
                </div>
                <nav>
                    <ul>
                        <li><a href="../index.jsp">Home</a></li>
                        <li><a href="../departments">Departments</a></li>
                        <li><a href="../Service.jsp">Services</a></li>
                        <li><a href="../appointments.jsp">Appointments</a></li>
                    </ul>
                </nav>
                <div class="user-menu">
                    <div class="user-menu-toggle">
                        <img src="https://via.placeholder.com/40x40" alt="Admin">
                        <span>Admin</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="user-menu-dropdown">
                        <ul>
                            <li><a href="profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                            <li><a href="settings.jsp"><i class="fas fa-cog"></i> Settings</a></li>
                            <li><a href="../logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Admin Dashboard -->
    <div class="admin-dashboard">
        <!-- Sidebar -->
        <div class="admin-sidebar">
            <div class="admin-sidebar-header">
                <h3>Admin Panel</h3>
                <p>Manage your hospital</p>
            </div>
            <ul class="admin-sidebar-menu">
                <li><a href="dashboard" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                <li><a href="patients"><i class="fas fa-users"></i> Patients</a></li>
                <li><a href="doctors"><i class="fas fa-user-md"></i> Doctors</a></li>
                <li><a href="appointments"><i class="fas fa-calendar-check"></i> Appointments</a></li>
                <li><a href="departments"><i class="fas fa-hospital"></i> Departments</a></li>
                <li><a href="services"><i class="fas fa-stethoscope"></i> Services</a></li>
                <li><a href="reports"><i class="fas fa-chart-bar"></i> Reports</a></li>
                <li><a href="settings"><i class="fas fa-cog"></i> Settings</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="admin-content">
            <div class="admin-header">
                <h1>Dashboard</h1>
                <p>Welcome to the admin dashboard. Here's an overview of your hospital.</p>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon patients">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${patientCount}</h3>
                        <p>Total Patients</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon doctors">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${doctorCount}</h3>
                        <p>Total Doctors</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon appointments">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${appointmentCount}</h3>
                        <p>Appointments</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon departments">
                        <i class="fas fa-hospital"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${departmentCount}</h3>
                        <p>Departments</p>
                    </div>
                </div>
            </div>

            <!-- Recent Appointments -->
            <div class="recent-section">
                <h2><i class="fas fa-calendar-check"></i> Recent Appointments</h2>
                <table class="recent-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th>Department</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="appointment" items="${recentAppointments}">
                            <tr>
                                <td>${appointment.id}</td>
                                <td>${appointment.patient}</td>
                                <td>${appointment.doctor}</td>
                                <td>${appointment.department}</td>
                                <td>${appointment.date}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${appointment.status eq 'scheduled'}"><span class="status-badge status-scheduled">Scheduled</span></c:when>
                                        <c:when test="${appointment.status eq 'completed'}"><span class="status-badge status-completed">Completed</span></c:when>
                                        <c:when test="${appointment.status eq 'cancelled'}"><span class="status-badge status-cancelled">Cancelled</span></c:when>
                                        <c:otherwise><span class="status-badge status-scheduled">${appointment.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions">
                                    <a href="appointments.jsp?action=view&id=${appointment.id}" class="btn btn-sm">View</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty recentAppointments}">
                            <tr>
                                <td colspan="7" style="text-align: center;">No appointments found</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <!-- Recent Doctors -->
            <div class="recent-section">
                <h2><i class="fas fa-user-md"></i> Recent Doctors</h2>
                <table class="recent-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Department</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="doctor" items="${recentDoctors}">
                            <tr>
                                <td>${doctor.id}</td>
                                <td>${doctor.name}</td>
                                <td>${doctor.department}</td>
                                <td><span class="status-badge status-active">${doctor.status}</span></td>
                                <td class="actions">
                                    <a href="doctors.jsp?action=view&id=${doctor.id}" class="btn btn-sm">View</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty recentDoctors}">
                            <tr>
                                <td colspan="5" style="text-align: center;">No doctors found</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        // Simple JavaScript for toggling the user menu
        document.addEventListener('DOMContentLoaded', function() {
            const userMenuToggle = document.querySelector('.user-menu-toggle');
            const userMenuDropdown = document.querySelector('.user-menu-dropdown');

            userMenuToggle.addEventListener('click', function() {
                userMenuDropdown.style.display = userMenuDropdown.style.display === 'block' ? 'none' : 'block';
            });

            // Close the dropdown when clicking outside
            document.addEventListener('click', function(event) {
                if (!userMenuToggle.contains(event.target) && !userMenuDropdown.contains(event.target)) {
                    userMenuDropdown.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
