<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, model.Prescription, java.text.SimpleDateFormat" %>
<%
// Get attributes from session
String username = (String) session.getAttribute("username");
String name = (String) session.getAttribute("name");
String role = (String) session.getAttribute("role");

String displayName = (name != null && !name.isEmpty()) ? name : username;

// Get prescriptions from request attributes
List<Prescription> allPrescriptions = (List<Prescription>) request.getAttribute("allPrescriptions");
List<Prescription> pendingPrescriptions = (List<Prescription>) request.getAttribute("pendingPrescriptions");
List<Prescription> approvedPrescriptions = (List<Prescription>) request.getAttribute("approvedPrescriptions");
Map<Integer, String> patientNames = (Map<Integer, String>) request.getAttribute("patientNames");

// Date formatter
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
    <title>Prescriptions - Doctor Dashboard</title>
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

        /* Tabs */
        .tabs {
            display: flex;
            margin-bottom: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .tab {
            flex: 1;
            text-align: center;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s;
            border-bottom: 3px solid transparent;
        }

        .tab:hover {
            background-color: #f8f9fa;
        }

        .tab.active {
            border-bottom-color: #0066cc;
            color: #0066cc;
            font-weight: 600;
        }

        /* Prescriptions Table */
        .prescriptions-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .prescriptions-table th,
        .prescriptions-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }

        .prescriptions-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #495057;
        }

        .prescriptions-table tr:hover {
            background-color: #f8f9fa;
        }

        .prescriptions-table .actions {
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

        .status-pending {
            background-color: #fff3cd;
            color: #ffc107;
        }

        .status-approved {
            background-color: #d1e7dd;
            color: #198754;
        }

        .status-rejected {
            background-color: #f8d7da;
            color: #dc3545;
        }

        /* Filter Controls */
        .filter-controls {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .filter-controls select,
        .filter-controls input {
            padding: 8px 15px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }

        .filter-controls select {
            min-width: 150px;
        }

        /* Prescription Form */
        .prescription-form {
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

            .tabs {
                flex-direction: column;
            }

            .form-row {
                flex-direction: column;
                gap: 15px;
            }

            .form-row .form-group {
                margin-bottom: 0;
            }

            .filter-controls {
                flex-direction: column;
            }

            .filter-controls select,
            .filter-controls input,
            .filter-controls button {
                width: 100%;
            }

            .prescriptions-table {
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
                    <li><a href="prescriptions" class="active"><i class="fas fa-prescription"></i> Prescriptions</a></li>
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
                    <h1>Prescriptions</h1>
                    <p>Manage and issue prescriptions for your patients.</p>

                    <% if (session.getAttribute("successMessage") != null) { %>
                    <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-top: 15px;">
                        <i class="fas fa-check-circle"></i> <%= session.getAttribute("successMessage") %>
                        <% session.removeAttribute("successMessage"); %>
                    </div>
                    <% } %>

                    <% if (request.getParameter("success") != null && request.getParameter("success").equals("true")) { %>
                    <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-top: 15px;">
                        <i class="fas fa-check-circle"></i> Prescription created successfully!
                    </div>
                    <% } %>

                    <% if (session.getAttribute("errorMessage") != null) { %>
                    <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-top: 15px;">
                        <i class="fas fa-exclamation-circle"></i> <%= session.getAttribute("errorMessage") %>
                        <% session.removeAttribute("errorMessage"); %>
                    </div>
                    <% } %>

                    <% if (request.getAttribute("errorMessage") != null) { %>
                    <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-top: 15px;">
                        <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("errorMessage") %>
                    </div>
                    <% } %>
                </div>

                <!-- Tabs -->
                <div class="tabs">
                    <div class="tab active" onclick="showTab('all')">All Prescriptions</div>
                    <div class="tab" onclick="showTab('active')">Active</div>
                    <div class="tab" onclick="showTab('completed')">Completed</div>
                    <div class="tab" onclick="showTab('new')">Write New Prescription</div>
                </div>

                <!-- Filter Controls -->
                <div class="filter-controls" id="filter-controls">
                    <select id="patient-filter">
                        <option value="">All Patients</option>
                        <% if (patientNames != null) {
                            for (Map.Entry<Integer, String> entry : patientNames.entrySet()) {
                        %>
                        <option value="<%= entry.getKey() %>"><%= entry.getValue() %></option>
                        <% } } %>
                    </select>
                    <select id="status-filter">
                        <option value="">All Status</option>
                        <option value="Active">Active</option>
                        <option value="Completed">Completed</option>
                        <option value="Cancelled">Cancelled</option>
                    </select>
                    <input type="date" id="date-filter" placeholder="Filter by date">
                    <button class="btn btn-sm">Apply Filters</button>
                </div>

                <!-- Prescriptions Table -->
                <div id="all-prescriptions">
                    <table class="prescriptions-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Patient</th>
                                <th>Medication</th>
                                <th>Dosage</th>
                                <th>Date Issued</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (allPrescriptions != null && !allPrescriptions.isEmpty()) {
                                for (Prescription prescription : allPrescriptions) {
                                    String statusClass = "";
                                    if ("Active".equals(prescription.getStatus())) {
                                        statusClass = "status-pending";
                                    } else if ("Completed".equals(prescription.getStatus())) {
                                        statusClass = "status-approved";
                                    } else if ("Cancelled".equals(prescription.getStatus())) {
                                        statusClass = "status-rejected";
                                    }

                                    String dosageDisplay = prescription.getDosage();
                                    if (prescription.getFrequency() != null) {
                                        dosageDisplay += ", " + prescription.getFrequency();
                                    }
                                    if (prescription.getDuration() != null) {
                                        dosageDisplay += " for " + prescription.getDuration();
                                    }
                            %>
                            <tr>
                                <td>P<%= prescription.getId() %></td>
                                <td><%= prescription.getPatientName() != null ? prescription.getPatientName() : "Unknown Patient" %></td>
                                <td><%= prescription.getMedication() %></td>
                                <td><%= dosageDisplay %></td>
                                <td><%= prescription.getPrescriptionDate() != null ? dateFormat.format(prescription.getPrescriptionDate()) : "N/A" %></td>
                                <td><span class="status-badge <%= statusClass %>"><%= prescription.getStatus() %></span></td>
                                <td class="actions">
                                    <a href="view-prescription?id=<%= prescription.getId() %>" class="btn btn-sm">View</a>
                                    <% if ("Active".equals(prescription.getStatus())) { %>
                                    <a href="edit-prescription?id=<%= prescription.getId() %>" class="btn btn-sm btn-success">Edit</a>
                                    <a href="approve-prescription?id=<%= prescription.getId() %>" class="btn btn-sm btn-success">Complete</a>
                                    <a href="reject-prescription?id=<%= prescription.getId() %>" class="btn btn-sm btn-danger">Cancel</a>
                                    <% } else if ("Cancelled".equals(prescription.getStatus())) { %>
                                    <a href="edit-prescription?id=<%= prescription.getId() %>" class="btn btn-sm btn-success">Edit</a>
                                    <% } else if ("Completed".equals(prescription.getStatus())) { %>
                                    <button onclick="window.print()" class="btn btn-sm btn-success">Print</button>
                                    <% } %>
                                </td>
                            </tr>
                            <% } } else { %>
                            <tr>
                                <td colspan="7" style="text-align: center;">No prescriptions found</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Active Prescriptions -->
                <div id="active-prescriptions" style="display: none;">
                    <table class="prescriptions-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Patient</th>
                                <th>Medication</th>
                                <th>Dosage</th>
                                <th>Date Issued</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (pendingPrescriptions != null && !pendingPrescriptions.isEmpty()) {
                                for (Prescription prescription : pendingPrescriptions) {
                                    String dosageDisplay = prescription.getDosage();
                                    if (prescription.getFrequency() != null) {
                                        dosageDisplay += ", " + prescription.getFrequency();
                                    }
                                    if (prescription.getDuration() != null) {
                                        dosageDisplay += " for " + prescription.getDuration();
                                    }
                            %>
                            <tr>
                                <td>P<%= prescription.getId() %></td>
                                <td><%= prescription.getPatientName() != null ? prescription.getPatientName() : "Unknown Patient" %></td>
                                <td><%= prescription.getMedication() %></td>
                                <td><%= dosageDisplay %></td>
                                <td><%= prescription.getPrescriptionDate() != null ? dateFormat.format(prescription.getPrescriptionDate()) : "N/A" %></td>
                                <td class="actions">
                                    <a href="view-prescription?id=<%= prescription.getId() %>" class="btn btn-sm">View</a>
                                    <a href="edit-prescription?id=<%= prescription.getId() %>" class="btn btn-sm btn-primary">Edit</a>
                                    <a href="approve-prescription?id=<%= prescription.getId() %>" class="btn btn-sm btn-success">Approve</a>
                                    <a href="reject-prescription?id=<%= prescription.getId() %>" class="btn btn-sm btn-danger">Reject</a>
                                </td>
                            </tr>
                            <% } } else { %>
                            <tr>
                                <td colspan="6" style="text-align: center;">No pending prescriptions found</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Completed Prescriptions -->
                <div id="completed-prescriptions" style="display: none;">
                    <table class="prescriptions-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Patient</th>
                                <th>Medication</th>
                                <th>Dosage</th>
                                <th>Date Issued</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (approvedPrescriptions != null && !approvedPrescriptions.isEmpty()) {
                                for (Prescription prescription : approvedPrescriptions) {
                                    String dosageDisplay = prescription.getDosage();
                                    if (prescription.getFrequency() != null) {
                                        dosageDisplay += ", " + prescription.getFrequency();
                                    }
                                    if (prescription.getDuration() != null) {
                                        dosageDisplay += " for " + prescription.getDuration();
                                    }
                            %>
                            <tr>
                                <td>P<%= prescription.getId() %></td>
                                <td><%= prescription.getPatientName() != null ? prescription.getPatientName() : "Unknown Patient" %></td>
                                <td><%= prescription.getMedication() %></td>
                                <td><%= dosageDisplay %></td>
                                <td><%= prescription.getPrescriptionDate() != null ? dateFormat.format(prescription.getPrescriptionDate()) : "N/A" %></td>
                                <td class="actions">
                                    <a href="view-prescription?id=<%= prescription.getId() %>" class="btn btn-sm">View</a>
                                    <a href="print-prescription?id=<%= prescription.getId() %>" class="btn btn-sm btn-success">Print</a>
                                </td>
                            </tr>
                            <% } } else { %>
                            <tr>
                                <td colspan="6" style="text-align: center;">No approved prescriptions found</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- New Prescription Form -->
                <div id="new-prescription" style="display: none;">
                    <div class="prescription-form">
                        <h3>Write New Prescription</h3>
                        <p style="margin-bottom: 15px;">Fill out the form below to create a new prescription. All fields marked with * are required.</p>
                        <form action="add-prescription" method="post">
                            <div class="form-group">
                                <label for="patientId">Patient *</label>
                                <select id="patientId" name="patientId" class="form-control" required>
                                    <option value="">Select Patient</option>
                                    <% if (patientNames != null) {
                                        for (Map.Entry<Integer, String> entry : patientNames.entrySet()) {
                                    %>
                                    <option value="<%= entry.getKey() %>"><%= entry.getValue() %></option>
                                    <% } } %>
                                </select>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="medication">Medication *</label>
                                    <input type="text" id="medication" name="medication" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="dosage">Dosage *</label>
                                    <input type="text" id="dosage" name="dosage" class="form-control" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="frequency">Frequency *</label>
                                    <input type="text" id="frequency" name="frequency" class="form-control" placeholder="e.g., Once Daily, Twice Daily, etc." required>
                                </div>
                                <div class="form-group">
                                    <label for="duration">Duration</label>
                                    <input type="text" id="duration" name="duration" class="form-control" placeholder="e.g., 7 days, 2 weeks, 30 days, etc.">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="instructions">Special Instructions</label>
                                <textarea id="instructions" name="instructions" class="form-control" rows="3" placeholder="Enter any special instructions or notes here"></textarea>
                            </div>
                            <div class="form-group" style="margin-top: 20px;">
                                <button type="submit" class="btn btn-success"><i class="fas fa-save"></i> Save Prescription</button>
                                <button type="reset" class="btn btn-secondary"><i class="fas fa-undo"></i> Reset Form</button>
                            </div>
                        </form>
                    </div>
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

        // Tab switching functionality
        function showTab(tabId, fromUrl = false) {
            // Hide all tab contents
            document.getElementById('all-prescriptions').style.display = 'none';
            document.getElementById('active-prescriptions').style.display = 'none';
            document.getElementById('completed-prescriptions').style.display = 'none';
            document.getElementById('new-prescription').style.display = 'none';
            document.getElementById('filter-controls').style.display = 'flex';

            // Show the selected tab content
            if (tabId === 'all') {
                document.getElementById('all-prescriptions').style.display = 'block';
            } else if (tabId === 'active') {
                document.getElementById('active-prescriptions').style.display = 'block';
            } else if (tabId === 'completed') {
                document.getElementById('completed-prescriptions').style.display = 'block';
            } else if (tabId === 'new') {
                document.getElementById('new-prescription').style.display = 'block';
                document.getElementById('filter-controls').style.display = 'none';
            }

            // Update active tab
            const tabs = document.querySelectorAll('.tab');
            tabs.forEach(tab => {
                tab.classList.remove('active');
                if (tab.getAttribute('onclick').includes("showTab('" + tabId + "'")) {
                    tab.classList.add('active');
                }
            });

            // Only add active class to the clicked element if not called from URL parameter
            if (!fromUrl && event && event.currentTarget) {
                event.currentTarget.classList.add('active');
            }
        }

        // Function to get URL parameters
        function getUrlParameter(name) {
            name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
            var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
            var results = regex.exec(location.search);
            return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
        }

        // Check for URL parameters
        document.addEventListener('DOMContentLoaded', function() {
            var tabParam = getUrlParameter('tab');
            var patientParam = getUrlParameter('patient');

            // If patient parameter exists, select it in the dropdown
            if (patientParam) {
                var patientSelect = document.getElementById('patient');
                if (patientSelect) {
                    for (var i = 0; i < patientSelect.options.length; i++) {
                        if (patientSelect.options[i].value === patientParam) {
                            patientSelect.selectedIndex = i;
                            break;
                        }
                    }
                }

                // If tab parameter is not set but patient is, default to new prescription tab
                if (!tabParam) {
                    tabParam = 'new';
                }
            }

            // Show the specified tab or default to 'all'
            if (tabParam) {
                showTab(tabParam, true);
            } else {
                showTab('all', true);
            }
        });
    </script>
</body>
</html>
