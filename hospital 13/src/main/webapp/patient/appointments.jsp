<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.Appointment" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
// Get attributes from both request and session
String username = (String) request.getAttribute("username");
if (username == null) {
    username = (String) session.getAttribute("username");
}

String name = (String) request.getAttribute("name");
if (name == null) {
    name = (String) session.getAttribute("name");
}

String role = (String) request.getAttribute("role");
if (role == null) {
    role = (String) session.getAttribute("role");
}

String displayName = (name != null && !name.isEmpty()) ? name : username;

// Print attributes to console for debugging
System.out.println("Attributes in patient/appointments.jsp:");
System.out.println("username: " + username);
System.out.println("name: " + name);
System.out.println("role: " + role);
System.out.println("displayName: " + displayName);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <!-- Force refresh: <%= System.currentTimeMillis() %> -->
    <title>My Appointments - LifeCare Medical Center</title>
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
            color: #0066cc;
            border: 1px solid #0066cc;
        }

        .btn-outline-primary:hover {
            background-color: #0066cc;
            color: white;
        }

        .btn-sm {
            padding: 8px 15px;
            font-size: 14px;
        }

        .btn-danger {
            background-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        /* Header Styles */
        header {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
        }

        .logo a {
            font-size: 24px;
            font-weight: 700;
            color: #333;
        }

        .logo span {
            color: #0066cc;
        }

        nav ul {
            display: flex;
            list-style: none;
        }

        nav ul li {
            margin-left: 20px;
        }

        nav ul li a {
            color: #333;
            font-weight: 500;
            transition: color 0.3s;
        }

        nav ul li a:hover {
            color: #0066cc;
        }

        nav ul li a.active {
            color: #0066cc;
            font-weight: bold;
        }

        /* User Menu Styles */
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
            font-weight: 500;
        }

        .user-menu-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 4px;
            width: 200px;
            display: none;
            z-index: 1000;
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
            display: flex;
            align-items: center;
            padding: 10px 15px;
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

        /* Dashboard Layout */
        .dashboard-container {
            display: flex;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 250px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-right: 20px;
            height: fit-content;
        }

        .sidebar-header {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .sidebar-header h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 5px;
        }

        .sidebar-header p {
            color: #6c757d;
            font-size: 14px;
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu li {
            margin-bottom: 10px;
        }

        .sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 10px;
            color: #333;
            border-radius: 4px;
            transition: all 0.3s;
        }

        .sidebar-menu li a:hover {
            background-color: #f8f9fa;
            color: #0066cc;
        }

        .sidebar-menu li a.active {
            background-color: #0066cc;
            color: white;
        }

        .sidebar-menu li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
        }

        .welcome-header {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .welcome-header h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 10px;
        }

        .welcome-header p {
            color: #6c757d;
        }

        /* Appointments Section */
        .appointments-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .appointments-container h2 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }

        .appointment-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 15px;
        }

        .appointment-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            transition: transform 0.3s;
        }

        .appointment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .appointment-card h3 {
            font-size: 16px;
            color: #333;
            margin-bottom: 10px;
        }

        .appointment-card p {
            margin-bottom: 5px;
            color: #6c757d;
        }

        .appointment-card .appointment-date {
            display: flex;
            align-items: center;
            color: #0066cc;
            margin: 10px 0;
        }

        .appointment-card .appointment-date i {
            margin-right: 5px;
        }

        .appointment-actions {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .view-all {
            display: block;
            text-align: center;
            margin-top: 15px;
        }

        /* Footer Styles */
        footer {
            background-color: #343a40;
            color: white;
            padding: 60px 0 30px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }

        .footer-section h3 {
            font-size: 18px;
            margin-bottom: 20px;
            color: white;
        }

        .footer-section p {
            margin-bottom: 15px;
            color: #adb5bd;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 10px;
        }

        .footer-section ul li a {
            color: #adb5bd;
            transition: color 0.3s;
        }

        .footer-section ul li a:hover {
            color: #0066cc;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #adb5bd;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                text-align: center;
            }

            nav ul {
                margin-top: 15px;
                justify-content: center;
            }

            nav ul li {
                margin: 0 10px;
            }

            .user-menu {
                margin-top: 15px;
            }

            .dashboard-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                margin-right: 0;
                margin-bottom: 20px;
            }

            .appointment-list {
                grid-template-columns: 1fr;
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
                        <% if (session.getAttribute("username") != null) { %>
                            <% if ("patient".equals(session.getAttribute("role"))) { %>
                                <li><a href="dashboard">Patient Dashboard</a></li>
                            <% } else if ("doctor".equals(session.getAttribute("role"))) { %>
                                <!-- Doctor functionality removed -->
                            <% } else if ("admin".equals(session.getAttribute("role"))) { %>
                                <li><a href="../admin/dashboard.jsp">Admin Dashboard</a></li>
                            <% } %>
                        <% } %>
                        <li><a href="../departments">Departments</a></li>
                        <li><a href="../Service.jsp">Services</a></li>
                        <li><a href="../appointments.jsp">Appointments</a></li>
                        <li><a href="../AboutUs.jsp">About Us</a></li>
                        <li><a href="../ContactUs.jsp">Contact Us</a></li>
                    </ul>
                </nav>
                <div class="user-menu">
                    <div class="user-menu-toggle">
                        <img src="https://via.placeholder.com/40x40" alt="User">
                        <span><%= displayName %></span>
                    </div>
                    <div class="user-menu-dropdown">
                        <ul>
                            <li><a href="profile"><i class="fas fa-user"></i> Profile</a></li>
                            <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                            <li><a href="../logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Dashboard Container -->
    <div class="container">
        <div class="dashboard-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="sidebar-header">
                    <h3>Patient Portal</h3>
                    <p>Manage your health</p>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="appointments" class="active"><i class="fas fa-calendar-check"></i> My Appointments</a></li>
                    <li><a href="book-appointment"><i class="fas fa-plus-circle"></i> Book Appointment</a></li>
                    <li><a href="find-doctor"><i class="fas fa-user-md"></i> Find Doctors</a></li>
                    <li><a href="medical-records"><i class="fas fa-file-medical"></i> Medical Records</a></li>
                    <li><a href="prescriptions"><i class="fas fa-prescription"></i> Prescriptions</a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> Profile</a></li>
                    <li><a href="settings"><i class="fas fa-cog"></i> Settings</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Welcome Header -->
                <div class="welcome-header">
                    <h1>My Appointments</h1>
                    <p>View and manage your upcoming and past appointments.</p>

                    <!-- Success Message -->
                    <c:if test="${not empty successMessage}">
                        <div style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 4px; margin-top: 15px; font-weight: bold;">
                            <i class="fas fa-check-circle" style="margin-right: 10px;"></i> ${successMessage}
                        </div>
                    </c:if>

                    <!-- Error Message -->
                    <c:if test="${not empty errorMessage}">
                        <div style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px; margin-top: 15px; font-weight: bold;">
                            <i class="fas fa-exclamation-circle" style="margin-right: 10px;"></i> ${errorMessage}
                        </div>
                    </c:if>
                </div>

                <!-- Search and Filter -->
                <form action="appointments" method="post" class="search-filter">
                    <input type="text" name="search" placeholder="Search appointments..." value="${searchQuery}">
                    <select name="status" onchange="this.form.submit()">
                        <option value="">All Status</option>
                        <option value="scheduled" ${statusFilter eq 'scheduled' ? 'selected' : ''}>Scheduled</option>
                        <option value="completed" ${statusFilter eq 'completed' ? 'selected' : ''}>Completed</option>
                        <option value="cancelled" ${statusFilter eq 'cancelled' ? 'selected' : ''}>Cancelled</option>
                        <option value="pending" ${statusFilter eq 'pending' ? 'selected' : ''}>Pending</option>
                    </select>
                    <button type="submit" class="btn">Search</button>
                </form>

                <!-- Appointments Table -->
                <div class="appointments-container">
                    <h2>My Appointments</h2>
                    <table class="appointments-table" style="width: 100%; border-collapse: collapse; margin-top: 20px;">
                        <thead>
                            <tr>
                                <th style="padding: 10px; text-align: left; border-bottom: 1px solid #ddd; background-color: #f8f9fa;">ID</th>
                                <th style="padding: 10px; text-align: left; border-bottom: 1px solid #ddd; background-color: #f8f9fa;">Doctor</th>
                                <th style="padding: 10px; text-align: left; border-bottom: 1px solid #ddd; background-color: #f8f9fa;">Department</th>
                                <th style="padding: 10px; text-align: left; border-bottom: 1px solid #ddd; background-color: #f8f9fa;">Date</th>
                                <th style="padding: 10px; text-align: left; border-bottom: 1px solid #ddd; background-color: #f8f9fa;">Time</th>
                                <th style="padding: 10px; text-align: left; border-bottom: 1px solid #ddd; background-color: #f8f9fa;">Status</th>
                                <th style="padding: 10px; text-align: left; border-bottom: 1px solid #ddd; background-color: #f8f9fa;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty appointments}">
                                    <c:forEach var="appointment" items="${appointments}">
                                        <tr>
                                            <td style="padding: 10px; border-bottom: 1px solid #ddd;">A${appointment.id}</td>
                                            <td style="padding: 10px; border-bottom: 1px solid #ddd;">${appointment.doctorName}</td>
                                            <td style="padding: 10px; border-bottom: 1px solid #ddd;">${appointment.departmentName}</td>
                                            <td style="padding: 10px; border-bottom: 1px solid #ddd;">${appointment.appointmentDate}</td>
                                            <td style="padding: 10px; border-bottom: 1px solid #ddd;">${appointment.timeSlot}</td>
                                            <td style="padding: 10px; border-bottom: 1px solid #ddd;">
                                                <c:choose>
                                                    <c:when test="${appointment.status eq 'scheduled' or appointment.status eq 'Scheduled'}"><span class="status-badge status-scheduled">Scheduled</span></c:when>
                                                    <c:when test="${appointment.status eq 'completed' or appointment.status eq 'Completed'}"><span class="status-badge status-completed">Completed</span></c:when>
                                                    <c:when test="${appointment.status eq 'cancelled' or appointment.status eq 'Cancelled'}"><span class="status-badge status-cancelled">Cancelled</span></c:when>
                                                    <c:when test="${appointment.status eq 'pending' or appointment.status eq 'Pending'}"><span class="status-badge status-pending">Pending</span></c:when>
                                                    <c:otherwise><span class="status-badge status-scheduled">${appointment.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 10px; border-bottom: 1px solid #ddd;">
                                                <a href="view-appointment?id=${appointment.id}" class="btn btn-sm">View</a>
                                                <c:if test="${appointment.status eq 'scheduled' or appointment.status eq 'Scheduled' or appointment.status eq 'pending' or appointment.status eq 'Pending'}">
                                                    <a href="reschedule-appointment?id=${appointment.id}" class="btn btn-sm btn-outline-primary">Reschedule</a>
                                                    <a href="cancel-appointment?id=${appointment.id}" class="btn btn-sm btn-danger">Cancel</a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" style="text-align: center; padding: 20px;">No appointments found</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Book New Appointment -->
                <div class="appointments-container" style="text-align: center;">
                    <h2>Need to Schedule a New Appointment?</h2>
                    <p style="margin-bottom: 20px;">Click the button below to book an appointment with one of our specialists.</p>
                    <a href="book-appointment" class="btn">Book New Appointment</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>About Us</h3>
                    <p>LifeCare Medical Center is dedicated to providing exceptional healthcare services with compassion and expertise.</p>
                </div>
                <div class="footer-section">
                    <h3>Quick Links</h3>
                    <ul>
                        <li><a href="../index.jsp">Home</a></li>
                        <li><a href="../departments">Departments</a></li>
                        <li><a href="../Service.jsp">Services</a></li>
                        <li><a href="../appointments.jsp">Appointments</a></li>
                        <li><a href="../AboutUs.jsp">About Us</a></li>
                        <li><a href="../ContactUs.jsp">Contact Us</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Contact Us</h3>
                    <p><i class="fas fa-map-marker-alt"></i> 123 Medical Drive, Health City, HC 12345</p>
                    <p><i class="fas fa-phone"></i> (123) 456-7890</p>
                    <p><i class="fas fa-envelope"></i> info@lifecaremedical.com</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2023 LifeCare Medical Center. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const userMenuToggle = document.querySelector('.user-menu-toggle');
            const userMenuDropdown = document.querySelector('.user-menu-dropdown');

            userMenuToggle.addEventListener('click', function() {
                userMenuDropdown.style.display = userMenuDropdown.style.display === 'block' ? 'none' : 'block';
            });

            // Close dropdown when clicking outside
            document.addEventListener('click', function(event) {
                if (!event.target.closest('.user-menu')) {
                    userMenuDropdown.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
