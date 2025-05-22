<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.User, model.MedicalRecord, java.text.SimpleDateFormat" %>
<%
// Get attributes from session and request
String username = (String) session.getAttribute("username");
String name = (String) session.getAttribute("name");
String role = (String) session.getAttribute("role");
List<User> patients = (List<User>) request.getAttribute("patients");
String patientId = (String) request.getAttribute("patientId");
User selectedPatient = (User) request.getAttribute("selectedPatient");
List<MedicalRecord> medicalRecords = (List<MedicalRecord>) request.getAttribute("medicalRecords");

String displayName = (name != null && !name.isEmpty()) ? name : username;

// If patientId is null, check request parameter (for form submission)
if (patientId == null) {
    patientId = request.getParameter("patient");
}

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
    <title>Medical Records - Doctor Dashboard</title>
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

        /* Patient Selector */
        .patient-selector {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .patient-selector select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 16px;
            margin-bottom: 10px;
        }

        /* Medical Records */
        .medical-records {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .medical-records h2 {
            font-size: 20px;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }

        .record-item {
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e9ecef;
        }

        .record-item:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }

        .record-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .record-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }

        .record-date {
            color: #6c757d;
            font-size: 14px;
        }

        .record-content {
            margin-bottom: 10px;
        }

        .record-meta {
            display: flex;
            justify-content: space-between;
            color: #6c757d;
            font-size: 14px;
        }

        .record-doctor {
            display: flex;
            align-items: center;
        }

        .record-doctor img {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            margin-right: 5px;
        }

        /* Record Types */
        .record-type {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            margin-right: 5px;
        }

        .record-type-visit {
            background-color: #e3f2fd;
            color: #0d6efd;
        }

        .record-type-lab {
            background-color: #d1e7dd;
            color: #198754;
        }

        .record-type-imaging {
            background-color: #fff3cd;
            color: #ffc107;
        }

        .record-type-procedure {
            background-color: #f8d7da;
            color: #dc3545;
        }

        /* New Record Form */
        .new-record-form {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-row {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
        }

        .form-row .form-group {
            flex: 1;
            margin-bottom: 0;
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

            .form-row {
                flex-direction: column;
                gap: 15px;
            }

            .form-row .form-group {
                margin-bottom: 0;
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
                    <li><a href="patients"><i class="fas fa-users"></i> My Patients</a></li>
                    <li><a href="prescriptions"><i class="fas fa-prescription"></i> Prescriptions</a></li>
                    <li><a href="medical-records" class="active"><i class="fas fa-file-medical"></i> Medical Records</a></li>
                    <li><a href="schedule"><i class="fas fa-clock"></i> My Schedule</a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> Profile</a></li>
                    <li><a href="settings"><i class="fas fa-cog"></i> Settings</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Welcome Header -->
                <div class="welcome-header">
                    <h1>Medical Records</h1>
                    <p>View and manage patient medical records.</p>
                </div>

                <!-- Patient Selector -->
                <div class="patient-selector">
                    <form action="medical-records" method="get">
                        <select name="patient" id="patient-select" onchange="this.form.submit()">
                            <option value="">Select a Patient</option>
                            <% if (patients != null) {
                                for (User patient : patients) {
                                    String selected = String.valueOf(patient.getId()).equals(patientId) ? "selected" : "";
                            %>
                            <option value="<%= patient.getId() %>" <%= selected %>><%= patient.getName() %></option>
                            <% } } %>
                        </select>
                    </form>
                </div>

                <% if (patientId != null && !patientId.isEmpty()) { %>
                <!-- Patient Records -->
                <div class="medical-records">
                    <h2>
                        <% if (selectedPatient != null) { %>
                            <%= selectedPatient.getName() %>'s Medical Records
                        <% } else { %>
                            Patient's Medical Records
                        <% } %>
                    </h2>

                    <% if (medicalRecords != null && !medicalRecords.isEmpty()) { %>
                        <% for (MedicalRecord record : medicalRecords) { %>
                        <!-- Record Item -->
                        <div class="record-item">
                            <div class="record-header">
                                <div class="record-title">
                                    <%
                                    String recordTypeClass = "record-type-other";
                                    if ("visit".equalsIgnoreCase(record.getRecordType())) {
                                        recordTypeClass = "record-type-visit";
                                    } else if ("lab".equalsIgnoreCase(record.getRecordType())) {
                                        recordTypeClass = "record-type-lab";
                                    } else if ("imaging".equalsIgnoreCase(record.getRecordType())) {
                                        recordTypeClass = "record-type-imaging";
                                    } else if ("procedure".equalsIgnoreCase(record.getRecordType())) {
                                        recordTypeClass = "record-type-procedure";
                                    }
                                    %>
                                    <span class="record-type <%= recordTypeClass %>"><%= record.getRecordType() %></span>
                                    <%= record.getDiagnosis() %>
                                </div>
                                <div class="record-date"><%= record.getRecordDate() != null ? dateFormat.format(record.getRecordDate()) : "N/A" %></div>
                            </div>
                            <div class="record-content">
                                <% if (record.getSymptoms() != null && !record.getSymptoms().isEmpty()) { %>
                                <p><strong>Symptoms:</strong> <%= record.getSymptoms() %></p>
                                <% } %>
                                <% if (record.getTreatment() != null && !record.getTreatment().isEmpty()) { %>
                                <p><strong>Treatment:</strong> <%= record.getTreatment() %></p>
                                <% } %>
                                <% if (record.getNotes() != null && !record.getNotes().isEmpty()) { %>
                                <p><strong>Notes:</strong> <%= record.getNotes() %></p>
                                <% } %>
                            </div>
                            <div class="record-meta">
                                <div class="record-doctor">
                                    <img src="https://via.placeholder.com/24x24" alt="Doctor">
                                    <span><%= record.getDoctorName() != null ? record.getDoctorName() : "Unknown Doctor" %></span>
                                </div>
                                <div class="record-actions">
                                    <a href="view-medical-record?id=<%= record.getId() %>" class="btn btn-sm">View</a>
                                    <a href="edit-medical-record?id=<%= record.getId() %>" class="btn btn-sm">Edit</a>
                                    <button onclick="window.print()" class="btn btn-sm">Print</button>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    <% } else { %>
                        <div class="no-records">
                            <p>No medical records found for this patient.</p>
                        </div>
                    <% } %>

                </div>

                <!-- Add New Record -->
                <div class="new-record-form">
                    <h2>Add New Medical Record</h2>
                    <form action="save-medical-record" method="post">
                        <input type="hidden" name="patientId" value="<%= patientId %>">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="record-type">Record Type</label>
                                <select id="record-type" name="recordType" class="form-control" required>
                                    <option value="">Select Record Type</option>
                                    <option value="visit">Office Visit</option>
                                    <option value="lab">Lab Results</option>
                                    <option value="imaging">Imaging</option>
                                    <option value="procedure">Procedure</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="record-title">Title</label>
                                <input type="text" id="record-title" name="title" class="form-control" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="record-content">Content</label>
                            <textarea id="record-content" name="content" class="form-control" rows="6" required></textarea>
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-success">Save Record</button>
                            <button type="reset" class="btn">Reset</button>
                        </div>
                    </form>
                </div>
                <% } else { %>
                <div class="medical-records">
                    <h2>Please select a patient to view their medical records</h2>
                    <p>Use the dropdown above to select a patient and view their medical history.</p>
                </div>
                <% } %>
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
