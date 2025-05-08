<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Prescription, model.User, java.text.SimpleDateFormat" %>
<%
// Get attributes from session
String username = (String) session.getAttribute("username");
String name = (String) session.getAttribute("name");
String role = (String) session.getAttribute("role");
Integer doctorId = (Integer) session.getAttribute("userId");

String displayName = (name != null && !name.isEmpty()) ? name : username;

// Get prescription from request
Prescription prescription = (Prescription) request.getAttribute("prescription");
User patient = (User) request.getAttribute("patient");

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
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>View Prescription - LifeCare Medical Center</title>
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

        /* Prescription Styles */
        .prescription-details {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .prescription-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .prescription-id {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }

        .prescription-status {
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: bold;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-approved {
            background-color: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
        }

        .prescription-info {
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

        .prescription-notes {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
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

        .btn-approve {
            background-color: #28a745;
        }

        .btn-reject {
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

            .prescription-details {
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
                    <h1>View Prescription</h1>
                    <p>Detailed information about the prescription.</p>

                    <% if (request.getParameter("success") != null) { %>
                        <% if (request.getParameter("success").equals("approved")) { %>
                        <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-top: 15px;">
                            <i class="fas fa-check-circle"></i> Prescription has been approved successfully!
                        </div>
                        <% } else if (request.getParameter("success").equals("rejected")) { %>
                        <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-top: 15px;">
                            <i class="fas fa-check-circle"></i> Prescription has been rejected successfully!
                        </div>
                        <% } else if (request.getParameter("success").equals("true")) { %>
                        <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-top: 15px;">
                            <i class="fas fa-check-circle"></i> Prescription has been updated successfully!
                        </div>
                        <% } %>
                    <% } %>

                    <% if (request.getParameter("error") != null) { %>
                        <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-top: 15px;">
                            <i class="fas fa-exclamation-circle"></i>
                            <% if (request.getParameter("error").equals("update-failed")) { %>
                                Failed to update prescription status. Please try again.
                            <% } else { %>
                                An error occurred. Please try again.
                            <% } %>
                        </div>
                    <% } %>
                </div>

                <% if (prescription != null) { %>
                <!-- Prescription Details -->
                <div class="prescription-details">
                    <div class="prescription-header">
                        <div class="prescription-id">Prescription #<%= prescription.getId() %></div>
                        <%
                        String statusClass = "";
                        if ("Active".equals(prescription.getStatus())) {
                            statusClass = "status-pending";
                        } else if ("Completed".equals(prescription.getStatus())) {
                            statusClass = "status-approved";
                        } else if ("Cancelled".equals(prescription.getStatus())) {
                            statusClass = "status-rejected";
                        }
                        %>
                        <div class="prescription-status <%= statusClass %>"><%= prescription.getStatus() %></div>
                    </div>

                    <!-- Patient Information Section -->
                    <h3><i class="fas fa-user-injured"></i> Patient Information</h3>
                    <div class="prescription-info">
                        <div>
                            <div class="info-group">
                                <div class="info-label">Patient Name</div>
                                <div class="info-value"><%= prescription.getPatientName() != null ? prescription.getPatientName() : "Unknown Patient" %></div>
                            </div>

                            <% if (patient != null) { %>
                            <div class="info-group">
                                <div class="info-label">Patient ID</div>
                                <div class="info-value"><%= patient.getId() %></div>
                            </div>

                            <div class="info-group">
                                <div class="info-label">Gender</div>
                                <div class="info-value"><%= patient.getGender() != null ? patient.getGender() : "N/A" %></div>
                            </div>

                            <div class="info-group">
                                <div class="info-label">Date of Birth</div>
                                <div class="info-value"><%= patient.getDateOfBirth() != null ? dateFormat.format(patient.getDateOfBirth()) : "N/A" %></div>
                            </div>
                            <% } %>
                        </div>

                        <div>
                            <% if (patient != null) { %>
                            <div class="info-group">
                                <div class="info-label">Email</div>
                                <div class="info-value"><%= patient.getEmail() != null ? patient.getEmail() : "N/A" %></div>
                            </div>

                            <div class="info-group">
                                <div class="info-label">Phone</div>
                                <div class="info-value"><%= patient.getPhone() != null ? patient.getPhone() : "N/A" %></div>
                            </div>

                            <div class="info-group">
                                <div class="info-label">Blood Group</div>
                                <div class="info-value"><%= patient.getBloodGroup() != null ? patient.getBloodGroup() : "N/A" %></div>
                            </div>

                            <div class="info-group">
                                <div class="info-label">Address</div>
                                <div class="info-value"><%= patient.getAddress() != null ? patient.getAddress() : "N/A" %></div>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- Prescription Information Section -->
                    <h3><i class="fas fa-file-prescription"></i> Prescription Information</h3>
                    <div class="prescription-info">
                        <div>
                            <div class="info-group">
                                <div class="info-label">Prescription ID</div>
                                <div class="info-value">P<%= prescription.getId() %></div>
                            </div>

                            <div class="info-group">
                                <div class="info-label">Prescription Date</div>
                                <div class="info-value"><%= prescriptionDate %></div>
                            </div>

                            <div class="info-group">
                                <div class="info-label">Status</div>
                                <div class="info-value"><span class="<%= statusClass %>"><%= prescription.getStatus() %></span></div>
                            </div>
                        </div>

                        <div>
                            <div class="info-group">
                                <div class="info-label">Doctor Name</div>
                                <div class="info-value"><%= name %></div>
                            </div>

                            <div class="info-group">
                                <div class="info-label">Doctor ID</div>
                                <div class="info-value"><%= doctorId %></div>
                            </div>

                            <div class="info-group">
                                <div class="info-label">Department</div>
                                <div class="info-value">General Medicine</div>
                            </div>
                        </div>
                    </div>

                    <!-- Medication Details Section -->
                    <h3><i class="fas fa-pills"></i> Medication Details</h3>
                    <div class="prescription-info" style="background-color: #f8f9fa; padding: 15px; border-radius: 8px; border-left: 4px solid #007bff;">
                        <div>
                            <div class="info-group">
                                <div class="info-label">Medication Name</div>
                                <div class="info-value" style="font-weight: bold; color: #007bff;"><%= prescription.getMedication() %></div>
                            </div>

                            <div class="info-group">
                                <div class="info-label">Dosage</div>
                                <div class="info-value"><%= prescription.getDosage() %></div>
                            </div>
                        </div>

                        <div>
                            <div class="info-group">
                                <div class="info-label">Frequency</div>
                                <div class="info-value"><%= prescription.getFrequency() != null ? prescription.getFrequency() : "N/A" %></div>
                            </div>

                            <div class="info-group">
                                <div class="info-label">Duration</div>
                                <div class="info-value"><%= prescription.getDuration() != null ? prescription.getDuration() : "N/A" %></div>
                            </div>
                        </div>
                    </div>

                    <!-- Administration Instructions -->
                    <div style="margin-top: 15px; padding: 10px; background-color: #fff3cd; border-radius: 4px; border-left: 4px solid #ffc107;">
                        <h4><i class="fas fa-exclamation-triangle"></i> Administration Instructions</h4>
                        <ul style="margin-left: 20px;">
                            <% if (prescription.getDosage() != null && prescription.getDosage().toLowerCase().contains("mg")) { %>
                            <li>Take with a full glass of water</li>
                            <% } %>
                            <% if (prescription.getFrequency() != null && prescription.getFrequency().toLowerCase().contains("daily")) { %>
                            <li>Take at the same time each day for best results</li>
                            <% } %>
                            <li>Complete the full course of medication even if symptoms improve</li>
                            <li>Do not take with alcohol</li>
                            <li>Store at room temperature away from moisture and heat</li>
                        </ul>
                    </div>

                    <!-- Possible Side Effects -->
                    <div style="margin-top: 15px; padding: 10px; background-color: #f8d7da; border-radius: 4px; border-left: 4px solid #dc3545;">
                        <h4><i class="fas fa-heartbeat"></i> Possible Side Effects</h4>
                        <ul style="margin-left: 20px;">
                            <li>Nausea or upset stomach</li>
                            <li>Drowsiness</li>
                            <li>Dizziness</li>
                            <li>Headache</li>
                        </ul>
                        <p style="margin-top: 10px; font-style: italic;">Contact your doctor immediately if you experience severe side effects or allergic reactions.</p>
                    </div>

                    <% if (prescription.getNotes() != null && !prescription.getNotes().isEmpty()) { %>
                    <h3><i class="fas fa-sticky-note"></i> Doctor's Notes</h3>
                    <div class="prescription-notes" style="background-color: #e2f0d9; border-radius: 4px; border-left: 4px solid #28a745; padding: 15px; margin-top: 15px;">
                        <p style="font-style: italic;"><i class="fas fa-quote-left" style="color: #28a745;"></i> <%= prescription.getNotes() %> <i class="fas fa-quote-right" style="color: #28a745;"></i></p>
                    </div>
                    <% } %>

                    <% if (patient != null && patient.getMedicalHistory() != null && !patient.getMedicalHistory().isEmpty()) { %>
                    <h3><i class="fas fa-history"></i> Patient Medical History</h3>
                    <div style="background-color: #e6f3ff; border-radius: 4px; border-left: 4px solid #17a2b8; padding: 15px; margin-top: 15px;">
                        <p><%= patient.getMedicalHistory() %></p>
                    </div>
                    <% } else { %>
                    <h3><i class="fas fa-history"></i> Patient Medical History</h3>
                    <div style="background-color: #e6f3ff; border-radius: 4px; border-left: 4px solid #17a2b8; padding: 15px; margin-top: 15px;">
                        <p>No medical history available for this patient.</p>
                    </div>
                    <% } %>

                    <!-- Action Buttons Section -->
                    <div class="action-buttons" style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                        <a href="prescriptions" class="btn" style="background-color: #6c757d;"><i class="fas fa-arrow-left"></i> Back to Prescriptions</a>

                        <% if ("Active".equals(prescription.getStatus())) { %>
                            <a href="edit-prescription?id=<%= prescription.getId() %>" class="btn btn-primary" style="background-color: #007bff;"><i class="fas fa-edit"></i> Edit Prescription</a>
                            <a href="approve-prescription?id=<%= prescription.getId() %>" class="btn btn-approve" style="background-color: #28a745;"><i class="fas fa-check"></i> Complete Prescription</a>
                            <a href="reject-prescription?id=<%= prescription.getId() %>" class="btn btn-reject" style="background-color: #dc3545;"><i class="fas fa-times"></i> Cancel Prescription</a>
                        <% } else if ("Completed".equals(prescription.getStatus())) { %>
                            <button onclick="window.print()" class="btn btn-print" style="background-color: #17a2b8;"><i class="fas fa-print"></i> Print Prescription</button>
                            <a href="#" onclick="generatePDF()" class="btn" style="background-color: #6610f2;"><i class="fas fa-file-pdf"></i> Download PDF</a>
                        <% } else if ("Cancelled".equals(prescription.getStatus())) { %>
                            <a href="edit-prescription?id=<%= prescription.getId() %>" class="btn btn-primary" style="background-color: #007bff;"><i class="fas fa-edit"></i> Edit Prescription</a>
                        <% } %>

                        <a href="patients" class="btn" style="background-color: #fd7e14;"><i class="fas fa-users"></i> View All Patients</a>
                    </div>

                    <!-- JavaScript for PDF generation -->
                    <script>
                        function generatePDF() {
                            window.print();
                            // In a real application, you would use a library like jsPDF or call a server-side API
                            // to generate a proper PDF file
                            alert('In a production environment, this would generate a PDF file for download.');
                        }
                    </script>
                </div>
                <% } else { %>
                <div class="prescription-details">
                    <p>Prescription not found or you do not have permission to view it.</p>
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
</body>
</html>
