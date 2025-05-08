<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Prescription, model.User, java.util.List, java.text.SimpleDateFormat" %>
<%
// Get attributes from session
String username = (String) session.getAttribute("username");
String name = (String) session.getAttribute("name");
String role = (String) session.getAttribute("role");

String displayName = (name != null && !name.isEmpty()) ? name : username;

// Get prescription from request
Prescription prescription = (Prescription) request.getAttribute("prescription");
User patient = (User) request.getAttribute("patient");
List<User> patients = (List<User>) request.getAttribute("patients");

// Format date
SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
String prescriptionDate = prescription != null && prescription.getPrescriptionDate() != null ?
                          dateFormat.format(prescription.getPrescriptionDate()) : "N/A";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Prescription | Hospital Management System</title>
    <link rel="stylesheet" href="../css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
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
            background-color: #f5f7fa;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Header Styles */
        header {
            background: linear-gradient(135deg, #0061a8 0%, #0085cc 100%);
            color: white;
            padding: 15px 0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        header .logo {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        header .logo img {
            height: 50px;
            width: auto;
            filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
        }

        header .logo h1 {
            font-size: 24px;
            font-weight: 600;
            margin: 0;
        }

        header nav ul {
            display: flex;
            list-style: none;
            gap: 20px;
        }

        header nav ul li a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 5px 10px;
            border-radius: 4px;
        }

        header nav ul li a:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        /* Dashboard Container */
        .dashboard-container {
            display: flex;
            margin-top: 30px;
            margin-bottom: 30px;
            min-height: calc(100vh - 300px);
        }

        /* Sidebar Styles */
        .sidebar {
            width: 260px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            padding: 25px 0;
            margin-right: 30px;
            flex-shrink: 0;
        }

        .sidebar-header {
            padding: 0 25px 20px 25px;
            border-bottom: 1px solid #eee;
            margin-bottom: 20px;
        }

        .sidebar-header h3 {
            color: #0061a8;
            font-size: 20px;
            margin-bottom: 5px;
        }

        .sidebar-header p {
            color: #666;
            font-size: 14px;
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
            padding: 12px 25px;
            color: #555;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .sidebar-menu li a i {
            margin-right: 10px;
            font-size: 18px;
            width: 24px;
            text-align: center;
            color: #0085cc;
        }

        .sidebar-menu li a:hover {
            background-color: #f0f7ff;
            color: #0061a8;
        }

        .sidebar-menu li a.active {
            background-color: #e6f2ff;
            color: #0061a8;
            border-left: 4px solid #0061a8;
            font-weight: 600;
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
        }

        .welcome-header {
            margin-bottom: 25px;
        }

        .welcome-header h1 {
            color: #0061a8;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .welcome-header p {
            color: #666;
            font-size: 16px;
        }

        /* Prescription Form Styles */
        .prescription-form {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            padding: 30px;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #0061a8;
            font-size: 15px;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #0085cc;
            box-shadow: 0 0 0 3px rgba(0, 133, 204, 0.2);
            outline: none;
        }

        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23333' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 16px;
            padding-right: 40px;
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 0;
        }

        /* Patient Info Section */
        .patient-info {
            background-color: #f0f7ff;
            border-left: 4px solid #0085cc;
            padding: 15px 20px;
            border-radius: 6px;
            margin-bottom: 25px;
        }

        .patient-info h3 {
            color: #0061a8;
            font-size: 18px;
            margin-bottom: 10px;
        }

        .patient-info p {
            margin: 5px 0;
            color: #555;
        }

        .patient-info strong {
            font-weight: 600;
            color: #0061a8;
        }

        /* Button Styles */
        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 24px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
        }

        .btn i {
            margin-right: 8px;
        }

        .btn-primary {
            background-color: #0085cc;
            color: white;
        }

        .btn-primary:hover {
            background-color: #0061a8;
        }

        .btn-cancel {
            background-color: #f2f2f2;
            color: #555;
        }

        .btn-cancel:hover {
            background-color: #e6e6e6;
        }

        /* Alert Messages */
        .error-message {
            background-color: #fdecea;
            color: #e74c3c;
            padding: 15px 20px;
            border-radius: 6px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            border-left: 4px solid #e74c3c;
        }

        .error-message i {
            margin-right: 10px;
            font-size: 18px;
        }

        /* Footer Styles */
        footer {
            background-color: #2c3e50;
            color: white;
            padding: 40px 0 20px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .footer-section h3 {
            color: #3498db;
            margin-bottom: 15px;
            font-size: 18px;
        }

        .footer-section p {
            margin-bottom: 10px;
            color: #ecf0f1;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 8px;
        }

        .footer-section ul li a {
            color: #ecf0f1;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-section ul li a:hover {
            color: #3498db;
        }

        .footer-section.contact p i {
            margin-right: 10px;
            color: #3498db;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid #34495e;
        }

        /* Responsive Styles */
        @media (max-width: 992px) {
            .dashboard-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                margin-right: 0;
                margin-bottom: 30px;
            }

            .footer-content {
                grid-template-columns: 1fr;
                gap: 20px;
            }
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }

            .action-buttons {
                flex-direction: column;
                gap: 15px;
            }

            .action-buttons .btn {
                width: 100%;
            }

            header nav ul {
                flex-wrap: wrap;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="logo">
            <img src="../images/logo.png" alt="Hospital Logo">
            <h1>City Hospital</h1>
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
                <li><a href="../about.jsp">About Us</a></li>
                <li><a href="../contact.jsp">Contact</a></li>
                <% if (session.getAttribute("username") != null) { %>
                    <li><a href="../logout">Logout</a></li>
                <% } else { %>
                    <li><a href="../login.jsp">Login</a></li>
                    <li><a href="../register.jsp">Register</a></li>
                <% } %>
            </ul>
        </nav>
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
                    <h1>Edit Prescription</h1>
                    <p>Update prescription details for your patient.</p>

                    <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="error-message" style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-top: 15px;">
                        <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("errorMessage") %>
                    </div>
                    <% } %>

                    <% if (request.getParameter("error") != null) { %>
                    <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-top: 15px;">
                        <i class="fas fa-exclamation-circle"></i>
                        <% if (request.getParameter("error").equals("not-found")) { %>
                            Prescription not found.
                        <% } else if (request.getParameter("error").equals("unauthorized")) { %>
                            You are not authorized to edit this prescription.
                        <% } else { %>
                            An error occurred. Please try again.
                        <% } %>
                    </div>
                    <% } %>
                </div>

                <% if (prescription != null) { %>
                <!-- Prescription Form -->
                <div class="prescription-form">
                    <h2 style="color: #0061a8; margin-bottom: 20px; font-size: 22px; border-bottom: 2px solid #f0f7ff; padding-bottom: 10px;">
                        <i class="fas fa-prescription-bottle-alt" style="margin-right: 10px;"></i> Edit Prescription Details
                    </h2>

                    <% if (patient != null) { %>
                    <div class="patient-info">
                        <h3><i class="fas fa-user" style="margin-right: 8px;"></i> Patient Information</h3>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <p><strong>Name:</strong> <%= patient.getName() %></p>
                            <p><strong>ID:</strong> <%= patient.getId() %></p>
                            <p><strong>Gender:</strong> <%= patient.getGender() != null ? patient.getGender() : "Not specified" %></p>
                            <p><strong>Age:</strong> <%= patient.getDateOfBirth() != null ? (new java.util.Date().getYear() - patient.getDateOfBirth().getYear()) : "Not specified" %></p>
                        </div>
                    </div>
                    <% } %>

                    <form action="edit-prescription" method="post">
                        <input type="hidden" name="id" value="<%= prescription.getId() %>">

                        <div class="form-group">
                            <label for="patient">Patient</label>
                            <select id="patient" name="patient" class="form-control" required>
                                <option value="">Select Patient</option>
                                <% if (patients != null) {
                                    for (User p : patients) {
                                        boolean selected = p.getId() == prescription.getPatientId();
                                %>
                                <option value="<%= p.getId() %>" <%= selected ? "selected" : "" %>><%= p.getName() %></option>
                                <% } } %>
                            </select>
                        </div>

                        <div style="background-color: #f8f9fa; border-radius: 8px; padding: 20px; margin-bottom: 25px; border: 1px solid #e9ecef;">
                            <h3 style="color: #0061a8; margin-bottom: 15px; font-size: 18px;">
                                <i class="fas fa-pills" style="margin-right: 8px;"></i> Medication Details
                            </h3>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="medication">Medication</label>
                                    <input type="text" id="medication" name="medication" class="form-control" value="<%= prescription.getMedication() %>" required>
                                </div>

                                <div class="form-group">
                                    <label for="dosage">Dosage</label>
                                    <input type="text" id="dosage" name="dosage" class="form-control" value="<%= prescription.getDosage() %>" required>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="frequency">Frequency</label>
                                    <input type="text" id="frequency" name="frequency" class="form-control" value="<%= prescription.getFrequency() != null ? prescription.getFrequency() : "" %>" required>
                                </div>

                                <div class="form-group">
                                    <label for="duration">Duration</label>
                                    <input type="text" id="duration" name="duration" class="form-control" value="<%= prescription.getDuration() != null ? prescription.getDuration() : "" %>">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="notes">
                                <i class="fas fa-sticky-note" style="margin-right: 8px; color: #0085cc;"></i> Notes
                            </label>
                            <textarea id="notes" name="notes" class="form-control" placeholder="Enter any additional notes or instructions for the patient..."><%= prescription.getNotes() != null ? prescription.getNotes() : "" %></textarea>
                        </div>

                        <div class="form-group">
                            <label for="status">
                                <i class="fas fa-check-circle" style="margin-right: 8px; color: #0085cc;"></i> Status
                            </label>
                            <select id="status" name="status" class="form-control" required>
                                <option value="Active" <%= "Active".equals(prescription.getStatus()) ? "selected" : "" %>>Active</option>
                                <option value="Completed" <%= "Completed".equals(prescription.getStatus()) ? "selected" : "" %>>Completed</option>
                                <option value="Cancelled" <%= "Cancelled".equals(prescription.getStatus()) ? "selected" : "" %>>Cancelled</option>
                            </select>
                        </div>

                        <div class="action-buttons">
                            <a href="view-prescription?id=<%= prescription.getId() %>" class="btn btn-cancel"><i class="fas fa-times"></i> Cancel</a>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save Changes</button>
                        </div>
                    </form>
                </div>
                <% } else { %>
                <div class="prescription-form">
                    <p>Prescription not found or you do not have permission to edit it.</p>
                    <a href="prescriptions" class="btn"><i class="fas fa-arrow-left"></i> Back to Prescriptions</a>
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
                <p>City Hospital is dedicated to providing the best medical care to our patients with state-of-the-art facilities and experienced doctors.</p>
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
                <p><i class="fas fa-envelope"></i> info@cityhospital.com</p>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2025 City Hospital. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
