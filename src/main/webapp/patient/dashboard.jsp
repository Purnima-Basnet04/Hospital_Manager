<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.Appointment" %>
<%@ page import="model.MedicalRecord" %>
<%@ page import="model.Prescription" %>
<%@ page import="model.Bill" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
System.out.println("Attributes in patient/dashboard.jsp:");
System.out.println("username: " + username);
System.out.println("name: " + name);
System.out.println("role: " + role);
System.out.println("displayName: " + displayName);

// Check if we have the necessary attributes, if not redirect to the servlet
if (username == null || role == null || !"patient".equals(role)) {
    System.out.println("Missing required attributes in dashboard.jsp, redirecting to servlet");
    response.sendRedirect(request.getContextPath() + "/patient/dashboard");
    return;
}

// Check if this is a direct access to the JSP (not through the servlet)
String directAccess = (String) request.getAttribute("directAccess");
String dashboardLoaded = (String) session.getAttribute("dashboardLoaded");
Long lastAccess = (Long) session.getAttribute("lastDashboardAccess");

// If this is a direct access to the JSP without going through the servlet
// AND the dashboard hasn't been loaded before, redirect to the servlet
if (directAccess == null && dashboardLoaded == null) {
    System.out.println("Direct access to dashboard.jsp detected without prior loading, redirecting to servlet");
    response.sendRedirect(request.getContextPath() + "/patient/dashboard");
    return;
}

// If it's been more than 5 minutes since the last dashboard access, refresh the data
if (lastAccess != null) {
    long currentTime = System.currentTimeMillis();
    long timeDiff = currentTime - lastAccess;
    // 5 minutes = 5 * 60 * 1000 = 300,000 milliseconds
    if (timeDiff > 300000) {
        System.out.println("Dashboard data is stale (" + (timeDiff / 60000) + " minutes old), refreshing");
        // Clear the dashboard loaded flag to force a complete reload
        session.removeAttribute("dashboardLoaded");
        response.sendRedirect(request.getContextPath() + "/patient/dashboard");
        return;
    }
}

// Get dashboard data from request attributes, falling back to session attributes if needed
// This ensures the dashboard still works when navigating back from another page

// Upcoming appointments
List<Appointment> upcomingAppointments = (List<Appointment>) request.getAttribute("upcomingAppointments");
Integer upcomingAppointmentsCount = (Integer) request.getAttribute("upcomingAppointmentsCount");

if (upcomingAppointments == null) {
    upcomingAppointments = (List<Appointment>) session.getAttribute("dashboardUpcomingAppointments");
    System.out.println("Using session data for upcomingAppointments: " +
                     (upcomingAppointments != null ? upcomingAppointments.size() + " items" : "null"));
}

if (upcomingAppointmentsCount == null) {
    upcomingAppointmentsCount = (Integer) session.getAttribute("dashboardUpcomingAppointmentsCount");
    System.out.println("Using session data for upcomingAppointmentsCount: " + upcomingAppointmentsCount);
}

// Medical records
List<MedicalRecord> medicalRecords = (List<MedicalRecord>) request.getAttribute("medicalRecords");
Integer medicalRecordsCount = (Integer) request.getAttribute("medicalRecordsCount");

if (medicalRecords == null) {
    medicalRecords = (List<MedicalRecord>) session.getAttribute("dashboardMedicalRecords");
    System.out.println("Using session data for medicalRecords: " +
                     (medicalRecords != null ? medicalRecords.size() + " items" : "null"));
}

if (medicalRecordsCount == null) {
    medicalRecordsCount = (Integer) session.getAttribute("dashboardMedicalRecordsCount");
    System.out.println("Using session data for medicalRecordsCount: " + medicalRecordsCount);
}

// Prescriptions
List<Prescription> activePrescriptions = (List<Prescription>) request.getAttribute("activePrescriptions");
Integer activePrescriptionsCount = (Integer) request.getAttribute("activePrescriptionsCount");

if (activePrescriptions == null) {
    activePrescriptions = (List<Prescription>) session.getAttribute("dashboardActivePrescriptions");
    System.out.println("Using session data for activePrescriptions: " +
                     (activePrescriptions != null ? activePrescriptions.size() + " items" : "null"));
}

if (activePrescriptionsCount == null) {
    activePrescriptionsCount = (Integer) session.getAttribute("dashboardActivePrescriptionsCount");
    System.out.println("Using session data for activePrescriptionsCount: " + activePrescriptionsCount);
}

// Bills section removed

// Check if the session is still valid
if (session == null || session.getAttribute("username") == null) {
    System.out.println("Session is invalid or expired, redirecting to login");
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

// Log all session attributes for debugging
java.util.Enumeration<String> attributeNames = session.getAttributeNames();
System.out.println("All session attributes in dashboard.jsp:");
while (attributeNames.hasMoreElements()) {
    String name = attributeNames.nextElement();
    System.out.println("  - " + name + ": " + (session.getAttribute(name) != null ? "not null" : "null"));
}

// If we still don't have the data, redirect to the servlet to fetch fresh data
if (upcomingAppointments == null || medicalRecords == null || activePrescriptions == null) {
    System.out.println("Missing dashboard data, redirecting to servlet to fetch fresh data");
    System.out.println("upcomingAppointments: " + (upcomingAppointments == null ? "null" : "not null"));
    System.out.println("medicalRecords: " + (medicalRecords == null ? "null" : "not null"));
    System.out.println("activePrescriptions: " + (activePrescriptions == null ? "null" : "not null"));

    // Check session attributes
    System.out.println("Session attributes:");
    System.out.println("dashboardUpcomingAppointments: " + (session.getAttribute("dashboardUpcomingAppointments") == null ? "null" : "not null"));
    System.out.println("dashboardMedicalRecords: " + (session.getAttribute("dashboardMedicalRecords") == null ? "null" : "not null"));
    System.out.println("dashboardActivePrescriptions: " + (session.getAttribute("dashboardActivePrescriptions") == null ? "null" : "not null"));

    // Force a reload by clearing the session flag
    session.removeAttribute("dashboardLoaded");

    // Redirect to the servlet to fetch fresh data
    response.sendRedirect(request.getContextPath() + "/patient/dashboard");
    return;
}

// Log all session attributes for debugging
java.util.Enumeration<String> attributeNames = session.getAttributeNames();
System.out.println("All session attributes in dashboard.jsp:");
while (attributeNames.hasMoreElements()) {
    String attributeName = attributeNames.nextElement();
    System.out.println(attributeName + ": " + session.getAttribute(attributeName));
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <!-- Prevent back button issues -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- Force refresh on every load -->
    <meta http-equiv="refresh" content="1800">
    <!-- Force refresh: <%= System.currentTimeMillis() %> -->
    <title>Patient Dashboard - LifeCare Medical Center</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patient-dashboard.css">
    <style>
        /* Global Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f0f4f8;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        a {
            text-decoration: none;
            color: #1a73e8;
            transition: all 0.3s ease;
        }

        a:hover {
            color: #174ea6;
        }

        .btn {
            display: inline-block;
            background-color: #1a73e8;
            color: white;
            padding: 12px 24px;
            border-radius: 6px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-weight: 500;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .btn:hover {
            background-color: #174ea6;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .btn-outline-primary {
            background-color: transparent;
            color: #1a73e8;
            border: 1px solid #1a73e8;
        }

        .btn-outline-primary:hover {
            background-color: #1a73e8;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .btn-sm {
            padding: 8px 16px;
            font-size: 14px;
            border-radius: 4px;
        }

        /* Header Styles */
        header {
            background-color: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
        }

        .logo a {
            font-size: 26px;
            font-weight: 700;
            color: #333;
            display: flex;
            align-items: center;
        }

        .logo a:before {
            content: '+';
            display: inline-block;
            margin-right: 8px;
            background-color: #1a73e8;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            text-align: center;
            line-height: 30px;
            font-size: 20px;
        }

        .logo span {
            color: #1a73e8;
            font-weight: 600;
        }

        nav ul {
            display: flex;
            list-style: none;
        }

        nav ul li {
            margin-left: 25px;
        }

        nav ul li a {
            color: #555;
            font-weight: 500;
            transition: all 0.3s ease;
            position: relative;
            padding: 5px 0;
        }

        nav ul li a:after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            background-color: #1a73e8;
            bottom: 0;
            left: 0;
            transition: width 0.3s ease;
        }

        nav ul li a:hover {
            color: #1a73e8;
        }

        nav ul li a:hover:after {
            width: 100%;
        }

        nav ul li a.active {
            color: #1a73e8;
            font-weight: 600;
        }

        nav ul li a.active:after {
            width: 100%;
        }

        /* User Menu Styles */
        .user-menu {
            position: relative;
        }

        .user-menu-toggle {
            display: flex;
            align-items: center;
            cursor: pointer;
            padding: 8px 15px;
            border-radius: 30px;
            transition: all 0.3s ease;
            border: 1px solid transparent;
        }

        .user-menu-toggle:hover {
            background-color: rgba(26, 115, 232, 0.05);
            border: 1px solid rgba(26, 115, 232, 0.1);
        }

        .user-menu-toggle img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
            border: 2px solid #1a73e8;
        }

        .user-menu-toggle span {
            font-weight: 500;
            color: #333;
        }

        .user-menu-dropdown {
            position: absolute;
            top: calc(100% + 10px);
            right: 0;
            background-color: white;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            width: 220px;
            display: none;
            z-index: 1000;
            overflow: hidden;
            transition: all 0.3s ease;
            transform-origin: top right;
            transform: scale(0.95);
            opacity: 0;
        }

        .user-menu:hover .user-menu-dropdown {
            display: block;
            transform: scale(1);
            opacity: 1;
        }

        .user-menu-dropdown ul {
            display: block;
            padding: 8px 0;
        }

        .user-menu-dropdown ul li {
            margin: 0;
        }

        .user-menu-dropdown ul li a {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: #333;
            transition: all 0.3s ease;
            font-weight: 400;
        }

        .user-menu-dropdown ul li a:hover {
            background-color: rgba(26, 115, 232, 0.05);
            color: #1a73e8;
        }

        .user-menu-dropdown ul li a.active {
            background-color: rgba(26, 115, 232, 0.1);
            color: #1a73e8;
            font-weight: 500;
        }

        .user-menu-dropdown ul li a i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            color: #1a73e8;
            font-size: 16px;
        }

        /* Dashboard Layout */
        .dashboard-container {
            display: flex;
            padding-top: 80px; /* Account for fixed header */
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 250px;
            background-color: white;
            color: #333;
            padding: 30px 0;
            position: fixed;
            height: calc(100vh - 80px);
            overflow-y: auto;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .sidebar-header {
            padding: 0 20px 20px;
            border-bottom: 1px solid #eee;
            margin-bottom: 20px;
        }

        .sidebar-header h3 {
            font-size: 20px;
            color: #0066cc;
            font-weight: 600;
        }

        .sidebar-header p {
            font-size: 14px;
            color: #666;
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu li {
            margin-bottom: 5px;
        }

        .sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: #555;
            transition: all 0.3s;
            border-radius: 0;
            font-weight: 500;
        }

        .sidebar-menu li a:hover {
            background-color: rgba(0, 102, 204, 0.05);
            color: #0066cc;
            border-left: 3px solid #0066cc;
        }

        .sidebar-menu li a.active {
            background-color: rgba(0, 102, 204, 0.1);
            color: #0066cc;
            border-left: 3px solid #0066cc;
            font-weight: 600;
        }

        .sidebar-menu li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
            color: #0066cc;
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
            margin-left: 250px;
            padding: 30px;
            display: block !important;
            opacity: 1 !important;
            visibility: visible !important;
        }

        /* Force dashboard visibility */
        .dashboard-container {
            display: flex !important;
            opacity: 1 !important;
            visibility: visible !important;
        }

        .sidebar {
            display: block !important;
            opacity: 1 !important;
            visibility: visible !important;
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

        /* Stats Grid */
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

        .stat-icon.prescriptions {
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

        /* Dashboard Sections */
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

        /* Tables */
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

        .actions {
            display: flex;
            gap: 5px;
        }

        /* Medical Records */
        .record-card {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.05);
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.03);
        }

        .record-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            border-color: rgba(26, 115, 232, 0.2);
        }

        .record-card h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 12px;
            font-weight: 600;
        }

        .record-card p {
            margin-bottom: 8px;
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }

        .record-card .record-date {
            display: flex;
            align-items: center;
            color: #1a73e8;
            margin: 15px 0;
            font-weight: 500;
            background-color: rgba(26, 115, 232, 0.05);
            padding: 10px;
            border-radius: 6px;
        }

        .record-card .record-date i {
            margin-right: 8px;
            font-size: 16px;
        }

        .view-all {
            display: inline-block;
            text-align: center;
            margin-top: 20px;
            padding: 12px 25px;
            background-color: rgba(26, 115, 232, 0.1);
            color: #1a73e8;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .view-all:hover {
            background-color: #1a73e8;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(26, 115, 232, 0.3);
        }

        /* Footer Styles */
        footer {
            background: linear-gradient(135deg, #2c3e50, #1a1a2e);
            color: white;
            padding: 60px 0 30px;
            margin-top: 50px;
            border-top: 5px solid #1a73e8;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 40px;
            margin-bottom: 40px;
        }

        .footer-section h3 {
            font-size: 20px;
            margin-bottom: 25px;
            color: white;
            font-weight: 600;
            position: relative;
            padding-bottom: 10px;
        }

        .footer-section h3:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 2px;
            background: #1a73e8;
        }

        .footer-section p {
            margin-bottom: 15px;
            color: #b8c2cc;
            line-height: 1.7;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 12px;
        }

        .footer-section ul li a {
            color: #b8c2cc;
            transition: all 0.3s ease;
            display: inline-block;
            padding: 3px 0;
        }

        .footer-section ul li a:hover {
            color: #1a73e8;
            transform: translateX(5px);
        }

        .footer-bottom {
            text-align: center;
            padding-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #b8c2cc;
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

            .dashboard-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                height: auto;
                position: static;
                margin-bottom: 20px;
            }

            .main-content {
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
                    <a href="${pageContext.request.contextPath}/index.jsp">LifeCare <span>Medical</span></a>
                </div>
                <nav>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                        <% if (session.getAttribute("username") != null) { %>
                            <% if ("patient".equals(session.getAttribute("role"))) { %>
                                <li><a href="${pageContext.request.contextPath}/patient/dashboard" class="active">Patient Dashboard</a></li>
                            <% } else if ("doctor".equals(session.getAttribute("role"))) { %>
                                <!-- Doctor dashboard removed -->
                            <% } else if ("admin".equals(session.getAttribute("role"))) { %>
                                <li><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a></li>
                            <% } %>
                        <% } %>
                        <li><a href="${pageContext.request.contextPath}/departments">Departments</a></li>
                        <li><a href="${pageContext.request.contextPath}/Service.jsp">Services</a></li>
                        <li><a href="${pageContext.request.contextPath}/appointments.jsp">Appointments</a></li>
                        <li><a href="${pageContext.request.contextPath}/AboutUs.jsp">About Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/ContactUs.jsp">Contact Us</a></li>
                    </ul>
                </nav>
                <div class="user-menu">
                    <div class="user-menu-toggle">
                        <img src="https://ui-avatars.com/api/?name=<%= displayName %>&background=1a73e8&color=fff&size=40" alt="<%= displayName %>" style="border: 2px solid #1a73e8;">
                        <span><%= displayName %></span>
                    </div>
                    <div class="user-menu-dropdown">
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/patient/profile"><i class="fas fa-user"></i> Profile</a></li>
                            <li><a href="${pageContext.request.contextPath}/patient/dashboard" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                            <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </header>

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
                            <h3>${upcomingAppointmentsCount}</h3>
                            <p>Upcoming Appointments</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/patient/appointments" class="card-link"></a>
                    </div>
                    <div class="stat-card">
                        <i class="fas fa-file-medical stat-icon"></i>
                        <div class="stat-info">
                            <h3>${medicalRecordsCount}</h3>
                            <p>Medical Records</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/patient/medical-records" class="card-link"></a>
                    </div>
                    <div class="stat-card">
                        <i class="fas fa-prescription stat-icon"></i>
                        <div class="stat-info">
                            <h3>${activePrescriptionsCount}</h3>
                            <p>Active Prescriptions</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/patient/prescriptions" class="card-link"></a>
                    </div>
                </div>

                <!-- Recent Appointments -->
                <div class="content-section">
                    <h2><i class="fas fa-calendar-check"></i> Upcoming Appointments</h2>
                    <table class="recent-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Doctor</th>
                                <th>Department</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty upcomingAppointments}">
                                    <c:forEach var="appointment" items="${upcomingAppointments}" varStatus="loop">
                                        <c:if test="${loop.index < 5}"> <!-- Show only the first 5 appointments -->
                                            <tr>
                                                <td>${appointment.id}</td>
                                                <td>Dr. ${appointment.doctorName}</td>
                                                <td>${appointment.departmentName}</td>
                                                <td><fmt:formatDate value="${appointment.appointmentDate}" pattern="MMMM d, yyyy" /></td>
                                                <td>${appointment.timeSlot}</td>
                                                <td>
                                                    <span class="status-badge status-scheduled">Scheduled</span>
                                                </td>
                                                <td class="actions">
                                                    <a href="${pageContext.request.contextPath}/patient/view-appointment?id=${appointment.id}" class="btn btn-sm">View</a>
                                                    <a href="${pageContext.request.contextPath}/edit-appointment?id=${appointment.id}" class="btn btn-sm">Reschedule</a>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" style="text-align: center;">No appointments found</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                    <div style="margin-top: 15px; text-align: center;">
                        <a href="${pageContext.request.contextPath}/patient/book-appointment" class="btn">Book New Appointment</a>
                        <a href="${pageContext.request.contextPath}/patient/appointments" class="btn">View All Appointments</a>
                    </div>
                </div>

                <!-- Recent Medical Records -->
                <div class="content-section">
                    <h2><i class="fas fa-file-medical"></i> Recent Medical Records</h2>
                    <table class="recent-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Doctor</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty medicalRecords}">
                                    <c:forEach var="record" items="${medicalRecords}" varStatus="loop">
                                        <c:if test="${loop.index < 5}"> <!-- Show only the first 5 records -->
                                            <tr>
                                                <td>${record.id}</td>
                                                <td>${record.title}</td>
                                                <td>Dr. ${record.doctorName}</td>
                                                <td><fmt:formatDate value="${record.recordDate}" pattern="MMMM d, yyyy" /></td>
                                                <td class="actions">
                                                    <a href="${pageContext.request.contextPath}/patient/view-medical-record?id=${record.id}" class="btn btn-sm">View</a>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" style="text-align: center;">No medical records found</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                    <div style="margin-top: 15px; text-align: center;">
                        <a href="${pageContext.request.contextPath}/patient/medical-records" class="btn">View All Medical Records</a>
                    </div>
                </div>

                <!-- Active Prescriptions -->
                <div class="content-section">
                    <h2><i class="fas fa-prescription"></i> Active Prescriptions</h2>
                    <table class="recent-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Medication</th>
                                <th>Doctor</th>
                                <th>Prescribed Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty activePrescriptions}">
                                    <c:forEach var="prescription" items="${activePrescriptions}" varStatus="loop">
                                        <c:if test="${loop.index < 5}"> <!-- Show only the first 5 prescriptions -->
                                            <tr>
                                                <td>${prescription.id}</td>
                                                <td>${prescription.medicationName}</td>
                                                <td>Dr. ${prescription.doctorName}</td>
                                                <td><fmt:formatDate value="${prescription.prescriptionDate}" pattern="MMMM d, yyyy" /></td>
                                                <td><span class="status-badge status-active">Active</span></td>
                                                <td class="actions">
                                                    <a href="${pageContext.request.contextPath}/patient/view-prescription?id=${prescription.id}" class="btn btn-sm">View</a>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" style="text-align: center;">No active prescriptions found</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                    <div style="margin-top: 15px; text-align: center;">
                        <a href="${pageContext.request.contextPath}/patient/prescriptions" class="btn">View All Prescriptions</a>
                    </div>
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

    <!-- Include the dedicated dashboard JavaScript file -->
    <script src="${pageContext.request.contextPath}/js/patient-dashboard.js"></script>

    <!-- Inline script to handle immediate visibility issues -->
    <script>
        // Immediate execution to prevent white screen
        (function() {
            console.log('Immediate script execution');

            // Force dashboard to be visible immediately
            document.addEventListener('DOMContentLoaded', function() {
                console.log('DOM loaded - forcing dashboard visibility');
                try {
                    // Make sure main content is visible
                    var mainContent = document.querySelector('.main-content');
                    if (mainContent) {
                        mainContent.style.display = 'block';
                        mainContent.style.opacity = '1';
                        mainContent.style.visibility = 'visible';
                    }

                    // Make sure dashboard container is visible
                    var dashboardContainer = document.querySelector('.dashboard-container');
                    if (dashboardContainer) {
                        dashboardContainer.style.display = 'flex';
                        dashboardContainer.style.opacity = '1';
                        dashboardContainer.style.visibility = 'visible';
                    }

                    // Make sure sidebar is visible
                    var sidebar = document.querySelector('.sidebar');
                    if (sidebar) {
                        sidebar.style.display = 'block';
                        sidebar.style.opacity = '1';
                        sidebar.style.visibility = 'visible';
                    }

                    // Force dashboard link to be active
                    var dashboardLink = document.querySelector('.sidebar-menu li a[href*="/patient/dashboard"]');
                    if (dashboardLink) {
                        dashboardLink.classList.add('active');
                    }
                } catch (e) {
                    console.error('Error in immediate visibility script:', e);
                }
            });
        })();
    </script>
</body>
</html>
