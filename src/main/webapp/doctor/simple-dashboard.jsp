<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// Get attributes from session
String username = (String) session.getAttribute("username");
String name = (String) session.getAttribute("name");
String role = (String) session.getAttribute("role");

String displayName = (name != null && !name.isEmpty()) ? name : username;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>Doctor Dashboard - LifeCare Medical Center</title>
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

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .stat-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
            transition: transform 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card i {
            font-size: 24px;
            color: #0066cc;
            margin-bottom: 10px;
        }

        .stat-card h3 {
            font-size: 24px;
            color: #333;
            margin-bottom: 5px;
        }

        .stat-card p {
            color: #6c757d;
        }

        /* Dashboard Sections */
        .dashboard-section {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .dashboard-section h2 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }

        /* Appointment Cards */
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

        /* Patient List */
        .patient-list {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }

        .patient-list th,
        .patient-list td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }

        .patient-list th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #495057;
        }

        .patient-list tr:hover {
            background-color: #f8f9fa;
        }

        .patient-list .actions {
            display: flex;
            gap: 5px;
        }

        /* Status Badges */
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-scheduled {
            background-color: #e3f2fd;
            color: #0d6efd;
        }

        /* View All Link */
        .view-all {
            display: block;
            text-align: center;
            margin-top: 15px;
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

            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }

            .appointment-list {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 576px) {
            .stats-grid {
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
                                <li><a href="simple-dashboard.jsp" class="active">Doctor Dashboard</a></li>
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
                            <li><a href="profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                            <li><a href="simple-dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
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
                    <li><a href="simple-dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="appointments.jsp"><i class="fas fa-calendar-check"></i> My Appointments</a></li>
                    <li><a href="patients.jsp"><i class="fas fa-users"></i> My Patients</a></li>
                    <li><a href="prescriptions.jsp"><i class="fas fa-prescription"></i> Prescriptions</a></li>
                    <li><a href="medical-records.jsp"><i class="fas fa-file-medical"></i> Medical Records</a></li>
                    <li><a href="schedule.jsp"><i class="fas fa-clock"></i> My Schedule</a></li>
                    <li><a href="profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                    <li><a href="settings.jsp"><i class="fas fa-cog"></i> Settings</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Welcome Header -->
                <div class="welcome-header">
                    <h1>Doctor Dashboard</h1>
                    <p>Welcome, Dr. <%= displayName %>! Here's an overview of your appointments and patients.</p>
                </div>

                <!-- Stats Grid -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <i class="fas fa-calendar-check"></i>
                        <h3>42</h3>
                        <p>Total Appointments</p>
                    </div>
                    <div class="stat-card">
                        <i class="fas fa-user-clock"></i>
                        <h3>15</h3>
                        <p>Scheduled</p>
                    </div>
                    <div class="stat-card">
                        <i class="fas fa-check-circle"></i>
                        <h3>25</h3>
                        <p>Completed</p>
                    </div>
                    <div class="stat-card">
                        <i class="fas fa-times-circle"></i>
                        <h3>2</h3>
                        <p>Cancelled</p>
                    </div>
                </div>

                <!-- Today's Appointments -->
                <div class="dashboard-section">
                    <h2>Today's Appointments</h2>
                    <div class="appointment-list">
                        <div class="appointment-card">
                            <h3>John Smith</h3>
                            <p><strong>Department:</strong> Cardiology</p>
                            <div class="appointment-date">
                                <i class="fas fa-clock"></i>
                                <span>10:30 AM</span>
                            </div>
                            <p><strong>Status:</strong> <span class="status-badge status-scheduled">Scheduled</span></p>
                            <div class="appointment-actions">
                                <a href="view-patient.jsp?id=1" class="btn btn-sm">View Patient</a>
                                <a href="start-consultation.jsp?id=1" class="btn btn-sm btn-success">Start Consultation</a>
                            </div>
                        </div>
                        <div class="appointment-card">
                            <h3>Jane Smith</h3>
                            <p><strong>Department:</strong> Cardiology</p>
                            <div class="appointment-date">
                                <i class="fas fa-clock"></i>
                                <span>11:30 AM</span>
                            </div>
                            <p><strong>Status:</strong> <span class="status-badge status-scheduled">Scheduled</span></p>
                            <div class="appointment-actions">
                                <a href="view-patient.jsp?id=2" class="btn btn-sm">View Patient</a>
                                <a href="start-consultation.jsp?id=2" class="btn btn-sm btn-success">Start Consultation</a>
                            </div>
                        </div>
                    </div>
                    <a href="appointments.jsp" class="view-all">View All Appointments</a>
                </div>

                <!-- Recent Patients -->
                <div class="dashboard-section">
                    <h2>Recent Patients</h2>
                    <table class="patient-list">
                        <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Last Visit</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>John Smith</td>
                                <td>May 10, 2025</td>
                                <td class="actions">
                                    <a href="view-patient.jsp?id=1" class="btn btn-sm">View</a>
                                    <a href="medical-records.jsp?patient=1" class="btn btn-sm">Records</a>
                                    <a href="write-prescription.jsp?patient=1" class="btn btn-sm btn-success">Prescribe</a>
                                </td>
                            </tr>
                            <tr>
                                <td>Jane Smith</td>
                                <td>May 8, 2025</td>
                                <td class="actions">
                                    <a href="view-patient.jsp?id=2" class="btn btn-sm">View</a>
                                    <a href="medical-records.jsp?patient=2" class="btn btn-sm">Records</a>
                                    <a href="write-prescription.jsp?patient=2" class="btn btn-sm btn-success">Prescribe</a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <a href="patients.jsp" class="view-all">View All Patients</a>
                </div>

                <!-- Pending Prescriptions -->
                <div class="dashboard-section">
                    <h2>Pending Prescriptions</h2>
                    <div class="appointment-list">
                        <div class="appointment-card">
                            <h3>John Doe</h3>
                            <p><strong>Medication:</strong> Amoxicillin 500mg</p>
                            <p><strong>Requested:</strong> May 10, 2025</p>
                            <div class="appointment-actions">
                                <a href="view-prescription.jsp?id=1" class="btn btn-sm">View Details</a>
                                <a href="approve-prescription.jsp?id=1" class="btn btn-sm btn-success">Approve</a>
                            </div>
                        </div>
                        <div class="appointment-card">
                            <h3>Jane Smith</h3>
                            <p><strong>Medication:</strong> Lisinopril 10mg</p>
                            <p><strong>Requested:</strong> May 9, 2025</p>
                            <div class="appointment-actions">
                                <a href="view-prescription.jsp?id=2" class="btn btn-sm">View Details</a>
                                <a href="approve-prescription.jsp?id=2" class="btn btn-sm btn-success">Approve</a>
                            </div>
                        </div>
                    </div>
                    <a href="prescriptions.jsp" class="view-all">View All Prescriptions</a>
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
