<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
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

// Format date
SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
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
    <title>My Patients - Doctor Dashboard</title>
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

        .btn-success {
            background-color: #28a745;
        }

        .btn-success:hover {
            background-color: #218838;
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

        /* Search and Filter */
        .search-filter {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .search-filter input[type="text"] {
            flex: 1;
            padding: 8px 15px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }

        .search-filter select {
            padding: 8px 15px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
            min-width: 150px;
        }

        /* Patients Grid */
        .patients-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .patient-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s;
        }

        .patient-card:hover {
            transform: translateY(-5px);
        }

        .patient-header {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .patient-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            margin-right: 15px;
        }

        .patient-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .patient-info {
            color: #6c757d;
            font-size: 14px;
        }

        .patient-details {
            padding: 15px;
        }

        .patient-details p {
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }

        .patient-details p i {
            width: 20px;
            margin-right: 10px;
            color: #0066cc;
        }

        .patient-actions {
            display: flex;
            gap: 10px;
            padding: 0 15px 15px;
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

            .search-filter {
                flex-direction: column;
            }

            .search-filter input[type="text"],
            .search-filter select,
            .search-filter button {
                width: 100%;
            }

            .patients-grid {
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
                                <li><a href="../patient/dashboard">Patient Dashboard</a></li>
                            <% } else if ("doctor".equals(session.getAttribute("role"))) { %>
                                <li><a href="dashboard">Doctor Dashboard</a></li>
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
                    <h3>Doctor Portal</h3>
                    <p>Manage your patients</p>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="appointments"><i class="fas fa-calendar-check"></i> My Appointments</a></li>
                    <li><a href="patients" class="active"><i class="fas fa-users"></i> My Patients</a></li>
                    <li><a href="prescriptions"><i class="fas fa-prescription"></i> Prescriptions</a></li>
                    <li><a href="medical-records"><i class="fas fa-file-medical"></i> Medical Records</a></li>
                    <li><a href="schedule"><i class="fas fa-clock"></i> My Schedule</a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> Profile</a></li>
                    <li><a href="settings"><i class="fas fa-cog"></i> Settings</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Welcome Header -->
                <div class="welcome-header">
                    <h1>My Patients</h1>
                    <p>View and manage your patient records.</p>
                </div>

                <!-- Search and Filter -->
                <form action="patients" method="post" class="search-filter">
                    <input type="text" name="search" placeholder="Search patients..." value="${searchQuery}">
                    <select name="condition">
                        <option value="" ${conditionFilter eq '' ? 'selected' : ''}>All Conditions</option>
                        <option value="hypertension" ${conditionFilter eq 'hypertension' ? 'selected' : ''}>Hypertension</option>
                        <option value="diabetes" ${conditionFilter eq 'diabetes' ? 'selected' : ''}>Diabetes</option>
                        <option value="asthma" ${conditionFilter eq 'asthma' ? 'selected' : ''}>Asthma</option>
                        <option value="arthritis" ${conditionFilter eq 'arthritis' ? 'selected' : ''}>Arthritis</option>
                    </select>
                    <button type="submit" class="btn">Search</button>
                </form>

                <!-- Patients Grid -->
                <div class="patients-grid">
                    <c:choose>
                        <c:when test="${not empty patients}">
                            <c:forEach var="patient" items="${patients}">
                                <div class="patient-card">
                                    <div class="patient-header">
                                        <img src="https://via.placeholder.com/60x60" alt="Patient" class="patient-avatar">
                                        <div>
                                            <h3 class="patient-name">${patient.name}</h3>
                                            <p class="patient-info">
                                                <c:if test="${patient.dateOfBirth != null}">
                                                    <%
                                                        User patient = (User)pageContext.getAttribute("patient");
                                                        if (patient.getDateOfBirth() != null) {
                                                            java.util.Calendar dob = java.util.Calendar.getInstance();
                                                            dob.setTime(patient.getDateOfBirth());
                                                            java.util.Calendar now = java.util.Calendar.getInstance();
                                                            int age = now.get(java.util.Calendar.YEAR) - dob.get(java.util.Calendar.YEAR);
                                                            if (now.get(java.util.Calendar.DAY_OF_YEAR) < dob.get(java.util.Calendar.DAY_OF_YEAR)) {
                                                                age--;
                                                            }
                                                            out.print(age + " years, ");
                                                        }
                                                    %>
                                                </c:if>
                                                ${patient.gender}
                                            </p>
                                        </div>
                                    </div>
                                    <div class="patient-details">
                                        <p><i class="fas fa-phone"></i> ${not empty patient.phone ? patient.phone : 'Not provided'}</p>
                                        <p><i class="fas fa-envelope"></i> ${not empty patient.email ? patient.email : 'Not provided'}</p>
                                        <p><i class="fas fa-calendar-alt"></i> Last Visit:
                                            <%
                                                // TODO: Get last appointment date from database
                                                out.print("Recent");
                                            %>
                                        </p>
                                        <p><i class="fas fa-heartbeat"></i> ${not empty patient.medicalHistory ? patient.medicalHistory : 'No conditions recorded'}</p>
                                    </div>
                                    <div class="patient-actions">
                                        <a href="view-patient?id=${patient.id}" class="btn btn-sm">View Profile</a>
                                        <a href="medical-records?patient=${patient.id}" class="btn btn-sm">Medical Records</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="grid-column: 1 / -1; text-align: center; padding: 20px; background-color: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
                                <h3>No patients found</h3>
                                <p>You don't have any patients assigned to you yet.</p>

                                <div style="margin-top: 20px;">
                                    <p>This could be because there are no patients or appointments in the system.</p>
                                    <p>You can create test patients and appointments to see patients in your dashboard:</p>
                                    <div style="display: flex; gap: 10px; justify-content: center; margin-top: 15px;">
                                        <a href="fix-patients" class="btn btn-success">Fix My Patients Dashboard</a>
                                    </div>
                                    <p style="margin-top: 15px; font-size: 14px;">This will automatically create test patients and appointments for you.</p>
                                </div>

                                <!-- Debug information -->
                                <div style="margin-top: 20px; padding: 10px; background-color: #f8f9fa; border-radius: 4px; text-align: left; font-size: 12px;">
                                    <h4>Debug Information:</h4>
                                    <p>Doctor ID: ${debug_userId}</p>
                                    <p>Patient Count: ${debug_patientCount}</p>
                                    <p>Username: ${username}</p>
                                    <p>Name: ${name}</p>
                                    <p>Role: ${role}</p>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
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
