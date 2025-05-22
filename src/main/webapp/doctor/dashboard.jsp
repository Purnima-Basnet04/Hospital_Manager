<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Appointment" %>
<%@ page import="model.Prescription" %>
<%@ page import="java.text.SimpleDateFormat" %>
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

// Get appointments from request
List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");

// Set default values if attributes are null
Integer totalAppointmentsObj = (Integer) request.getAttribute("totalAppointments");
Integer scheduledAppointmentsObj = (Integer) request.getAttribute("scheduledAppointments");
Integer completedAppointmentsObj = (Integer) request.getAttribute("completedAppointments");
Integer cancelledAppointmentsObj = (Integer) request.getAttribute("cancelledAppointments");

int totalAppointments = (totalAppointmentsObj != null) ? totalAppointmentsObj : 0;
int scheduledAppointments = (scheduledAppointmentsObj != null) ? scheduledAppointmentsObj : 0;
int completedAppointments = (completedAppointmentsObj != null) ? completedAppointmentsObj : 0;
int cancelledAppointments = (cancelledAppointmentsObj != null) ? cancelledAppointmentsObj : 0;

// Format date
SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
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

        .btn-danger {
            background-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }

        .btn-warning:hover {
            background-color: #e0a800;
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

        .status-completed {
            background-color: #d1e7dd;
            color: #198754;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #dc3545;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #ffc107;
        }

        /* View All Link */
        .view-all {
            display: block;
            text-align: center;
            margin-top: 15px;
        }

        /* Footer Styles */
        footer {
            background-color: #343a40;
            color: white;
            padding: 40px 0;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px;
        }

        .footer-section h3 {
            font-size: 18px;
            margin-bottom: 15px;
            color: #f8f9fa;
        }

        .footer-section p {
            color: #adb5bd;
            margin-bottom: 10px;
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
            color: white;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 20px;
            margin-top: 20px;
            border-top: 1px solid #495057;
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
                                <li><a href="dashboard.jsp" class="active">Doctor Dashboard</a></li>
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
                            <li><a href="dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
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
                    <li><a href="dashboard" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="appointments"><i class="fas fa-calendar-check"></i> My Appointments</a></li>
                    <li><a href="patients"><i class="fas fa-users"></i> My Patients</a></li>
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
                    <h1>Doctor Dashboard</h1>
                    <p>Welcome, Dr. <%= displayName %>! Here's an overview of your appointments and patients.</p>
                </div>

                <!-- Stats Grid -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <i class="fas fa-calendar-check"></i>
                        <h3><%= totalAppointments %></h3>
                        <p>Total Appointments</p>
                    </div>
                    <div class="stat-card">
                        <i class="fas fa-user-clock"></i>
                        <h3><%= scheduledAppointments %></h3>
                        <p>Scheduled</p>
                    </div>
                    <div class="stat-card">
                        <i class="fas fa-check-circle"></i>
                        <h3><%= completedAppointments %></h3>
                        <p>Completed</p>
                    </div>
                    <div class="stat-card">
                        <i class="fas fa-times-circle"></i>
                        <h3><%= cancelledAppointments %></h3>
                        <p>Cancelled</p>
                    </div>
                </div>

                <!-- Today's Appointments -->
                <div class="dashboard-section">
                    <h2>Today's Appointments</h2>
                    <div class="appointment-list">
                        <%
                        boolean hasTodayAppointments = false;
                        if (appointments != null && !appointments.isEmpty()) {
                            java.util.Date today = new java.util.Date();
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            String todayStr = sdf.format(today);

                            for (Appointment appointment : appointments) {
                                if (sdf.format(appointment.getAppointmentDate()).equals(todayStr) &&
                                    "Scheduled".equalsIgnoreCase(appointment.getStatus())) {
                                    hasTodayAppointments = true;
                        %>
                        <div class="appointment-card">
                            <h3><%= appointment.getPatientName() %></h3>
                            <p><strong>Department:</strong> <%= appointment.getDepartmentName() %></p>
                            <div class="appointment-date">
                                <i class="fas fa-clock"></i>
                                <span><%= timeFormat.format(appointment.getAppointmentDate()) %> | <%= appointment.getTimeSlot() %></span>
                            </div>
                            <p><strong>Status:</strong> <span class="status-badge status-scheduled"><%= appointment.getStatus() %></span></p>
                            <% if (appointment.getNotes() != null && !appointment.getNotes().isEmpty()) { %>
                            <p><strong>Notes:</strong> <%= appointment.getNotes() %></p>
                            <% } %>
                            <div class="appointment-actions">
                                <a href="view-patient?id=<%= appointment.getPatientId() %>" class="btn btn-sm">View Patient</a>
                                <a href="start-consultation?id=<%= appointment.getId() %>" class="btn btn-sm btn-success">Start Consultation</a>
                            </div>
                        </div>
                        <%
                                }
                            }
                        }

                        if (!hasTodayAppointments) {
                            // Check if there are any appointments at all
                            boolean hasAnyAppointments = (appointments != null && !appointments.isEmpty());
                            Integer totalSystemAppointments = (Integer) request.getAttribute("totalSystemAppointments");
                            Boolean doctorExists = (Boolean) request.getAttribute("doctorExists");
                        %>
                        <div style="grid-column: 1 / -1; text-align: center; padding: 20px;">
                            <p>No appointments scheduled for today.</p>

                            <% if (!hasAnyAppointments) { %>
                                <p style="margin-top: 10px; color: #6c757d;">
                                    You don't have any appointments in the system yet.
                                    <% if (totalSystemAppointments != null && totalSystemAppointments == 0) { %>
                                        There are no appointments in the system.
                                    <% } %>
                                </p>

                            <% } %>
                        </div>
                        <% } %>
                    </div>
                    <a href="appointments" class="view-all">View All Appointments</a>
                </div>

                <!-- Recent Patients -->
                <div class="dashboard-section">
                    <h2>Recent Patients</h2>
                    <%
                    if (appointments != null && !appointments.isEmpty()) {
                        // Create a map to track unique patients
                        java.util.Map<Integer, String> recentPatients = new java.util.LinkedHashMap<>();

                        // Get the 5 most recent unique patients
                        for (Appointment appointment : appointments) {
                            recentPatients.put(appointment.getPatientId(), appointment.getPatientName());
                            if (recentPatients.size() >= 5) break;
                        }

                        if (!recentPatients.isEmpty()) {
                    %>
                    <table class="patient-list">
                        <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Last Visit</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            for (java.util.Map.Entry<Integer, String> entry : recentPatients.entrySet()) {
                                int patientId = entry.getKey();
                                String patientName = entry.getValue();

                                // Find the most recent appointment for this patient
                                java.util.Date lastVisit = null;
                                for (Appointment appointment : appointments) {
                                    if (appointment.getPatientId() == patientId) {
                                        if (lastVisit == null || appointment.getAppointmentDate().after(lastVisit)) {
                                            lastVisit = appointment.getAppointmentDate();
                                        }
                                    }
                                }
                            %>
                            <tr>
                                <td><%= patientName %></td>
                                <td><%= lastVisit != null ? dateFormat.format(lastVisit) : "N/A" %></td>
                                <td class="actions">
                                    <a href="view-patient?id=<%= patientId %>" class="btn btn-sm">View</a>
                                    <a href="medical-records?patient=<%= patientId %>" class="btn btn-sm">Records</a>
                                    <a href="prescriptions?patient=<%= patientId %>&tab=new" class="btn btn-sm btn-success">Prescribe</a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <%
                        } else {
                    %>
                    <p style="text-align: center; padding: 20px;">No patient records found.</p>
                    <%
                        }
                    } else {
                    %>
                    <p style="text-align: center; padding: 20px;">No patient records found.</p>
                    <% } %>
                    <a href="patients" class="view-all">View All Patients</a>
                </div>

                <!-- Pending Prescriptions -->
                <div class="dashboard-section">
                    <h2>Pending Prescriptions</h2>
                    <%
                    List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
                    if (prescriptions != null && !prescriptions.isEmpty()) {
                    %>
                    <div class="appointment-list">
                        <% for (Prescription prescription : prescriptions) { %>
                        <div class="appointment-card">
                            <h3><%= prescription.getPatientName() != null ? prescription.getPatientName() : "Patient ID: " + prescription.getPatientId() %></h3>
                            <p><strong>Medication:</strong> <%= prescription.getMedication() %> <%= prescription.getDosage() %></p>
                            <p><strong>Prescribed:</strong> <%= prescription.getPrescriptionDate() != null ? new java.text.SimpleDateFormat("MMM d, yyyy").format(prescription.getPrescriptionDate()) : "N/A" %></p>
                            <div class="appointment-actions">
                                <a href="view-prescription?id=<%= prescription.getId() %>" class="btn btn-sm">View Details</a>
                                <% if ("pending".equalsIgnoreCase(prescription.getStatus())) { %>
                                <a href="approve-prescription?id=<%= prescription.getId() %>" class="btn btn-sm btn-success">Approve</a>
                                <% } %>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    <% } else { %>
                    <p style="text-align: center; padding: 20px;">No pending prescriptions found.</p>
                    <% } %>
                    <a href="prescriptions" class="view-all">View All Prescriptions</a>
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
