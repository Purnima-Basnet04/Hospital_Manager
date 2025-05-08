<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.Appointment" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
// Get attributes from session
String username = (String) session.getAttribute("username");
String name = (String) session.getAttribute("name");
String role = (String) session.getAttribute("role");
Integer userId = (Integer) session.getAttribute("userId");

// Set a default display name
String displayName = (name != null && !name.isEmpty()) ? name : (username != null ? username : "Patient");

// Debug output
System.out.println("simple-dashboard.jsp: Session attributes");
System.out.println("username: " + username);
System.out.println("name: " + name);
System.out.println("role: " + role);
System.out.println("userId: " + userId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - LifeCare Medical Center</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patient-dashboard.css">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="includes/patient-header.jsp" />

    <!-- Dashboard Container -->
    <div class="container">
        <div class="dashboard-container">
        <!-- Include Sidebar -->
        <jsp:include page="includes/patient-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <div class="page-header">
                <h1>Patient Dashboard</h1>
                <p>Welcome, <%= displayName %>! Here's an overview of your health information.</p>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <i class="fas fa-calendar-check stat-icon"></i>
                    <div class="stat-info">
                        <h3>Appointments</h3>
                        <p>Manage your appointments</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/patient/appointments" class="card-link"></a>
                </div>
                <div class="stat-card">
                    <i class="fas fa-file-medical stat-icon"></i>
                    <div class="stat-info">
                        <h3>Medical Records</h3>
                        <p>View your health records</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/patient/medical-records" class="card-link"></a>
                </div>
                <div class="stat-card">
                    <i class="fas fa-prescription stat-icon"></i>
                    <div class="stat-info">
                        <h3>Prescriptions</h3>
                        <p>Manage your medications</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/patient/prescriptions" class="card-link"></a>
                </div>
            </div>

            <!-- Appointments Section -->
            <div class="content-section">
                <h2><i class="fas fa-calendar-check"></i> Upcoming Appointments</h2>
                <p>View and manage your scheduled appointments with our healthcare providers.</p>
                <div style="margin-top: 20px;">
                    <a href="${pageContext.request.contextPath}/patient/appointments" class="btn">View All Appointments</a>
                    <a href="${pageContext.request.contextPath}/patient/book-appointment" class="btn btn-outline">Book New Appointment</a>
                </div>
            </div>

            <!-- Medical Records Section -->
            <div class="content-section">
                <h2><i class="fas fa-file-medical"></i> Medical Records</h2>
                <p>Access your complete medical history, test results, and treatment plans.</p>
                <div style="margin-top: 20px;">
                    <a href="${pageContext.request.contextPath}/patient/medical-records" class="btn">View Medical Records</a>
                </div>
            </div>

            <!-- Prescriptions Section -->
            <div class="content-section">
                <h2><i class="fas fa-prescription"></i> Prescriptions</h2>
                <p>View your current and past prescriptions, including dosage and refill information.</p>
                <div style="margin-top: 20px;">
                    <a href="${pageContext.request.contextPath}/patient/prescriptions" class="btn">View Prescriptions</a>
                </div>
            </div>
        </div>
    </div>
    </div>

    <script>
        // Simple script to ensure the page is visible
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Admin-style patient dashboard loaded');
            document.body.style.display = 'block';

            // Make sure sidebar active link is set
            var dashboardLink = document.querySelector('.sidebar-menu li a[href*="/patient/dashboard"]');
            if (dashboardLink) {
                dashboardLink.classList.add('active');
            }
        });
    </script>
</body>
</html>
