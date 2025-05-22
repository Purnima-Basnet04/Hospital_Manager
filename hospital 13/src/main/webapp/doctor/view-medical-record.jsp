<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.MedicalRecord, java.text.SimpleDateFormat" %>
<%
// Get attributes from session and request
String username = (String) session.getAttribute("username");
String name = (String) session.getAttribute("name");
String role = (String) session.getAttribute("role");
MedicalRecord medicalRecord = (MedicalRecord) request.getAttribute("medicalRecord");

String displayName = (name != null && !name.isEmpty()) ? name : username;

// Format date
SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
String recordDate = medicalRecord != null && medicalRecord.getRecordDate() != null ?
                    dateFormat.format(medicalRecord.getRecordDate()) : "N/A";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>View Medical Record - LifeCare Medical Center</title>
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
            padding: 0 15px;
        }

        /* Header Styles */
        header {
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }

        .logo {
            display: flex;
            align-items: center;
        }

        .logo img {
            height: 40px;
            margin-right: 10px;
        }

        .logo h1 {
            font-size: 1.5rem;
            color: #007bff;
            margin: 0;
        }

        nav ul {
            display: flex;
            list-style: none;
        }

        nav ul li {
            margin-left: 20px;
        }

        nav ul li a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            transition: color 0.3s;
        }

        nav ul li a:hover {
            color: #007bff;
        }

        /* Dashboard Container */
        .dashboard-container {
            display: flex;
            margin-top: 20px;
            min-height: calc(100vh - 180px);
        }

        /* Sidebar Styles */
        .sidebar {
            width: 250px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-right: 20px;
        }

        .sidebar-header {
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .sidebar-header h3 {
            color: #007bff;
            margin-bottom: 5px;
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu li {
            margin-bottom: 10px;
        }

        .sidebar-menu li a {
            display: block;
            padding: 10px;
            text-decoration: none;
            color: #333;
            border-radius: 4px;
            transition: all 0.3s;
        }

        .sidebar-menu li a:hover, .sidebar-menu li a.active {
            background-color: #007bff;
            color: #fff;
        }

        .sidebar-menu li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .welcome-header {
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .welcome-header h1 {
            color: #333;
            margin-bottom: 5px;
        }

        .welcome-header p {
            color: #666;
        }

        /* Medical Record Styles */
        .medical-record-details {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .record-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .record-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }

        .record-type {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: bold;
            margin-right: 10px;
        }

        .record-type-visit {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .record-type-lab {
            background-color: #d4edda;
            color: #155724;
        }

        .record-type-imaging {
            background-color: #e2e3e5;
            color: #383d41;
        }

        .record-type-procedure {
            background-color: #f8d7da;
            color: #721c24;
        }

        .record-type-other {
            background-color: #fff3cd;
            color: #856404;
        }

        .record-date {
            font-size: 16px;
            color: #666;
        }

        .record-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .info-group {
            margin-bottom: 15px;
        }

        .info-label {
            font-weight: bold;
            color: #666;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 16px;
            color: #333;
        }

        .record-content {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }

        .record-content p {
            margin-bottom: 10px;
        }

        .record-content p:last-child {
            margin-bottom: 0;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn {
            display: inline-block;
            padding: 8px 15px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #0069d9;
        }

        .btn-print {
            background-color: #6c757d;
        }

        .btn-edit {
            background-color: #28a745;
        }

        .btn-delete {
            background-color: #dc3545;
        }

        /* Footer Styles */
        footer {
            background-color: #333;
            color: #fff;
            padding: 30px 0;
            margin-top: 20px;
        }

        .footer-content {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }

        .footer-section {
            flex: 1;
            min-width: 250px;
            margin-bottom: 20px;
        }

        .footer-section h3 {
            color: #fff;
            margin-bottom: 15px;
            font-size: 1.2rem;
        }

        .footer-section p, .footer-section ul {
            color: #ccc;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 8px;
        }

        .footer-section ul li a {
            color: #ccc;
            text-decoration: none;
            transition: color 0.3s;
        }

        .footer-section ul li a:hover {
            color: #fff;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid #444;
            max-width: 1200px;
            margin: 0 auto;
            padding-left: 15px;
            padding-right: 15px;
        }

        @media print {
            header, .sidebar, .action-buttons, .welcome-header h1, .welcome-header p, footer {
                display: none;
            }

            body, .container, .dashboard-container, .main-content {
                margin: 0;
                padding: 0;
                width: 100%;
                background-color: white;
            }

            .medical-record-details {
                box-shadow: none;
                border: 1px solid #ddd;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="header-container">
            <div class="logo">
                <img src="../images/logo.png" alt="LifeCare Medical Center Logo">
                <h1>LifeCare Medical Center</h1>
            </div>
            <nav>
                <ul>
                    <li><a href="../index.jsp">Home</a></li>
                    <li><a href="dashboard">Doctor Dashboard</a></li>
                    <li><a href="../departments">Departments</a></li>
                    <li><a href="../Service.jsp">Services</a></li>
                    <li><a href="../about.jsp">About Us</a></li>
                    <li><a href="../contact.jsp">Contact</a></li>
                    <li><a href="../logout">Logout</a></li>
                </ul>
            </nav>
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
                    <h1>View Medical Record</h1>
                    <p>Detailed information about the medical record.</p>

                    <% if (request.getParameter("success") != null && request.getParameter("success").equals("true")) { %>
                    <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 4px; margin-top: 15px; border-left: 4px solid #28a745; font-weight: bold; font-size: 16px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
                        <i class="fas fa-check-circle" style="margin-right: 10px; font-size: 18px;"></i> Medical record has been updated successfully.
                    </div>
                    <% } %>

                    <% if (session.getAttribute("successMessage") != null) { %>
                    <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 4px; margin-top: 15px; border-left: 4px solid #28a745; font-weight: bold; font-size: 16px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
                        <i class="fas fa-check-circle" style="margin-right: 10px; font-size: 18px;"></i> <%= session.getAttribute("successMessage") %>
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                    <% } %>

                    <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px; margin-top: 15px; border-left: 4px solid #dc3545;">
                        <i class="fas fa-exclamation-circle" style="margin-right: 10px;"></i> <%= request.getAttribute("errorMessage") %>
                    </div>
                    <% } %>
                </div>

                <% if (medicalRecord != null) { %>
                <!-- Medical Record Details -->
                <div class="medical-record-details">
                    <div class="record-header">
                        <div class="record-title">
                            <%
                            String recordTypeClass = "record-type-other";
                            if ("visit".equalsIgnoreCase(medicalRecord.getRecordType())) {
                                recordTypeClass = "record-type-visit";
                            } else if ("lab".equalsIgnoreCase(medicalRecord.getRecordType())) {
                                recordTypeClass = "record-type-lab";
                            } else if ("imaging".equalsIgnoreCase(medicalRecord.getRecordType())) {
                                recordTypeClass = "record-type-imaging";
                            } else if ("procedure".equalsIgnoreCase(medicalRecord.getRecordType())) {
                                recordTypeClass = "record-type-procedure";
                            }
                            %>
                            <span class="record-type <%= recordTypeClass %>"><%= medicalRecord.getRecordType() %></span>
                            <%= medicalRecord.getDiagnosis() %>
                        </div>
                        <div class="record-date"><%= recordDate %></div>
                    </div>

                    <div class="record-info">
                        <div>
                            <div class="info-group">
                                <div class="info-label">Patient Name</div>
                                <div class="info-value"><%= medicalRecord.getPatientName() != null ? medicalRecord.getPatientName() : "Unknown Patient" %></div>
                            </div>

                            <div class="info-group">
                                <div class="info-label">Record Type</div>
                                <div class="info-value"><%= medicalRecord.getRecordType() != null ? medicalRecord.getRecordType() : "Visit" %></div>
                            </div>
                        </div>

                        <div>
                            <div class="info-group">
                                <div class="info-label">Doctor Name</div>
                                <div class="info-value"><%= medicalRecord.getDoctorName() != null ? medicalRecord.getDoctorName() : "Unknown Doctor" %></div>
                            </div>

                            <div class="info-group">
                                <div class="info-label">Status</div>
                                <div class="info-value"><%= medicalRecord.getStatus() != null ? medicalRecord.getStatus() : "Active" %></div>
                            </div>
                        </div>
                    </div>

                    <h3>Record Details</h3>
                    <div class="record-content">
                        <% if (medicalRecord.getSymptoms() != null && !medicalRecord.getSymptoms().isEmpty()) { %>
                        <p><strong>Symptoms:</strong> <%= medicalRecord.getSymptoms() %></p>
                        <% } %>

                        <% if (medicalRecord.getTreatment() != null && !medicalRecord.getTreatment().isEmpty()) { %>
                        <p><strong>Treatment:</strong> <%= medicalRecord.getTreatment() %></p>
                        <% } %>

                        <% if (medicalRecord.getNotes() != null && !medicalRecord.getNotes().isEmpty()) { %>
                        <p><strong>Notes:</strong> <%= medicalRecord.getNotes() %></p>
                        <% } %>
                    </div>

                    <div class="action-buttons">
                        <a href="<%= request.getContextPath() %>/doctor/medical-records?patient=<%= medicalRecord.getPatientId() %>" class="btn"><i class="fas fa-arrow-left"></i> Back to Records</a>
                        <button onclick="window.print()" class="btn btn-print"><i class="fas fa-print"></i> Print Record</button>

                        <!-- Direct hardcoded link to edit form -->
                        <a href="http://localhost:8083/hospital_war_exploded/doctor/better-edit-form?id=<%= medicalRecord.getId() %>" class="btn btn-edit" style="background-color: #28a745; color: white; font-weight: bold; text-decoration: none;">
                            <i class="fas fa-edit"></i> Edit Record
                        </a>

                        <!-- Alternative edit button using form submission -->
                        <form action="<%= request.getContextPath() %>/doctor/better-edit-form" method="get" style="display: inline; margin-left: 10px;">
                            <input type="hidden" name="id" value="<%= medicalRecord.getId() %>">
                            <button type="submit" class="btn" style="background-color: #fd7e14; color: white; font-weight: bold;">
                                <i class="fas fa-edit"></i> Edit (Alt)
                            </button>
                        </form>
                    </div>
                </div>
                <% } else { %>
                <div class="medical-record-details">
                    <p>Medical record not found or you do not have permission to view it.</p>
                    <a href="medical-records" class="btn"><i class="fas fa-arrow-left"></i> Back to Medical Records</a>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="footer-content">
            <div class="footer-section about">
                <h3>About Us</h3>
                <p>LifeCare Medical Center is dedicated to providing the best medical care to our patients with state-of-the-art facilities and experienced doctors.</p>
            </div>
            <div class="footer-section links">
                <h3>Quick Links</h3>
                <ul>
                    <li><a href="../index.jsp">Home</a></li>
                    <li><a href="../departments">Departments</a></li>
                    <li><a href="../doctors">Doctors</a></li>
                    <li><a href="../contact.jsp">Contact</a></li>
                </ul>
            </div>
            <div class="footer-section contact">
                <h3>Contact Info</h3>
                <p><i class="fas fa-map-marker-alt"></i> 123 Medical Drive, City, Country</p>
                <p><i class="fas fa-phone"></i> +1 234 567 8901</p>
                <p><i class="fas fa-envelope"></i> info@lifecaremedical.com</p>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2025 LifeCare Medical Center. All rights reserved.</p>
        </div>
    </footer>
    <script>
        function goToEditPage(recordId) {
            window.location.href = 'http://localhost:8083/hospital_war_exploded/doctor/better-edit-form?id=' + recordId;
        }
    </script>

    <!-- Add a direct edit button at the bottom of the page -->
    <% if (medicalRecord != null) { %>
    <div style="position: fixed; bottom: 20px; right: 20px;">
        <button onclick="goToEditPage(<%= medicalRecord.getId() %>)"
                style="background-color: #28a745; color: white; border: none; border-radius: 50%; width: 60px; height: 60px; font-size: 24px; cursor: pointer; box-shadow: 0 4px 8px rgba(0,0,0,0.2);">
            <i class="fas fa-edit"></i>
        </button>
    </div>
    <% } %>
</body>
</html>
