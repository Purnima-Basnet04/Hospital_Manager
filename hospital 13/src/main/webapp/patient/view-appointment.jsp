<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.Appointment" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
System.out.println("Attributes in patient/view-appointment.jsp:");
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
    <title>View Appointment - LifeCare Medical Center</title>
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
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background-color: #0066cc;
            color: white;
            padding: 12px 20px;
            border-radius: 6px;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 15px;
            text-decoration: none;
        }

        .btn:hover {
            background-color: #0052a3;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 102, 204, 0.2);
        }

        .btn-outline-primary {
            background-color: transparent;
            color: #0066cc;
            border: 2px solid #0066cc;
        }

        .btn-outline-primary:hover {
            background-color: #f0f7ff;
            transform: translateY(-2px);
        }

        .btn-danger {
            background-color: #e53935;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c62828;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(229, 57, 53, 0.2);
        }

        .btn-sm {
            padding: 8px 15px;
            font-size: 14px;
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

        /* Appointment Details Styles */
        .appointment-details {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            padding: 30px;
            margin-bottom: 30px;
        }

        .appointment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .appointment-header h2 {
            margin: 0;
            color: #333;
            font-size: 22px;
            font-weight: 600;
        }

        .appointment-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
            padding: 0 10px;
        }

        .info-group {
            margin-bottom: 20px;
            position: relative;
            padding-left: 5px;
        }

        .info-group label {
            display: block;
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
            font-size: 15px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-group p {
            color: #333;
            font-size: 17px;
            font-weight: 500;
            margin: 0;
        }

        .info-group .text-muted {
            color: #6c757d;
            font-size: 14px;
            margin-top: 5px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 8px 15px;
            border-radius: 50px;
            font-size: 14px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        .status-badge i {
            margin-right: 5px;
        }

        .status-scheduled {
            background-color: #e3f2fd;
            color: #1976d2;
        }

        .status-completed {
            background-color: #e8f5e9;
            color: #388e3c;
        }

        .status-cancelled {
            background-color: #ffebee;
            color: #d32f2f;
        }

        .status-pending {
            background-color: #fff8e1;
            color: #ffa000;
        }

        .appointment-notes {
            background-color: #f9f9f9;
            padding: 20px 25px;
            border-radius: 8px;
            margin-bottom: 30px;
            border-left: 4px solid #0066cc;
        }

        .appointment-notes h3 {
            margin: 0 0 12px 0;
            font-size: 16px;
            color: #555;
            font-weight: 600;
        }

        .appointment-notes p {
            margin: 0;
            color: #333;
            line-height: 1.6;
        }

        .appointment-actions {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .appointment-actions div {
            display: flex;
            gap: 10px;
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

            .appointment-info {
                grid-template-columns: 1fr;
            }

            .appointment-actions {
                flex-direction: column;
            }

            .appointment-actions .btn {
                width: 100%;
                margin-bottom: 10px;
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
                                <li><a href="../doctor/dashboard">Doctor Dashboard</a></li>
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
                    <h1>Appointment Details</h1>
                    <p>View the details of your appointment.</p>
                </div>

                <!-- Appointment Details -->
                <div class="appointment-details">
                    <div class="appointment-header">
                        <h2><i class="fas fa-calendar-alt" style="color: #0066cc; margin-right: 10px;"></i>Appointment #${appointment.id}</h2>
                        <c:choose>
                            <c:when test="${appointment.status eq 'scheduled' or appointment.status eq 'Scheduled'}"><span class="status-badge status-scheduled"><i class="fas fa-clock"></i> Scheduled</span></c:when>
                            <c:when test="${appointment.status eq 'completed' or appointment.status eq 'Completed'}"><span class="status-badge status-completed"><i class="fas fa-check-circle"></i> Completed</span></c:when>
                            <c:when test="${appointment.status eq 'cancelled' or appointment.status eq 'Cancelled'}"><span class="status-badge status-cancelled"><i class="fas fa-ban"></i> Cancelled</span></c:when>
                            <c:when test="${appointment.status eq 'pending' or appointment.status eq 'Pending'}"><span class="status-badge status-pending"><i class="fas fa-hourglass-half"></i> Pending</span></c:when>
                            <c:otherwise><span class="status-badge status-scheduled"><i class="fas fa-info-circle"></i> ${appointment.status}</span></c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${empty appointment}">
                        <p>Appointment not found.</p>
                    </c:if>

                    <c:if test="${not empty appointment}">
                        <div class="appointment-info">
                            <div>
                                <div class="info-group">
                                    <label><i class="fas fa-user-md" style="margin-right: 5px;"></i>Doctor</label>
                                    <p>${appointment.doctorName}</p>
                                </div>
                                <div class="info-group">
                                    <label><i class="fas fa-hospital" style="margin-right: 5px;"></i>Department</label>
                                    <p>${appointment.departmentName}</p>
                                </div>
                                <div class="info-group">
                                    <label><i class="fas fa-id-card-alt" style="margin-right: 5px;"></i>Doctor ID</label>
                                    <p>${appointment.doctorId}</p>
                                </div>
                            </div>
                            <div>
                                <div class="info-group">
                                    <label><i class="fas fa-calendar-day" style="margin-right: 5px;"></i>Date</label>
                                    <p><fmt:formatDate value="${appointment.appointmentDate}" pattern="EEEE, MMMM d, yyyy" /></p>
                                </div>
                                <div class="info-group">
                                    <label><i class="fas fa-clock" style="margin-right: 5px;"></i>Time</label>
                                    <p>${appointment.timeSlot}</p>
                                </div>
                                <div class="info-group">
                                    <label><i class="fas fa-history" style="margin-right: 5px;"></i>Booking Information</label>
                                    <p>Booked on: <fmt:formatDate value="${appointment.createdAt}" pattern="MMM d, yyyy 'at' h:mm a" /></p>
                                    <c:if test="${appointment.updatedAt != appointment.createdAt}">
                                        <p class="text-muted">Last updated: <fmt:formatDate value="${appointment.updatedAt}" pattern="MMM d, yyyy 'at' h:mm a" /></p>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <div class="appointment-notes">
                            <h3><i class="fas fa-sticky-note" style="margin-right: 8px;"></i>Reason for Visit</h3>
                            <p>${not empty appointment.notes ? appointment.notes : 'No notes available'}</p>
                        </div>

                        <div class="appointment-actions">
                            <a href="appointments" class="btn btn-outline-primary"><i class="fas fa-arrow-left"></i> Back to Appointments</a>

                            <div>
                                <c:if test="${appointment.status eq 'scheduled' or appointment.status eq 'Scheduled' or appointment.status eq 'pending' or appointment.status eq 'Pending'}">
                                    <a href="edit-appointment?id=${appointment.id}" class="btn"><i class="fas fa-edit"></i> Edit</a>
                                    <a href="cancel-appointment?id=${appointment.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this appointment?');"><i class="fas fa-times-circle"></i> Cancel</a>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
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
