<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.MedicalRecord, model.User, java.util.List, java.text.SimpleDateFormat" %>
<%
// Get attributes from session
String username = (String) session.getAttribute("username");
String name = (String) session.getAttribute("name");
String role = (String) session.getAttribute("role");

String displayName = (name != null && !name.isEmpty()) ? name : username;

// Get medical record from request
MedicalRecord medicalRecord = (MedicalRecord) request.getAttribute("medicalRecord");
User patient = (User) request.getAttribute("patient");

// Format date
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
String recordDate = medicalRecord != null && medicalRecord.getRecordDate() != null ?
                    dateFormat.format(medicalRecord.getRecordDate()) : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Medical Record - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
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

        header {
            background: linear-gradient(135deg, #0061a8 0%, #0085cc 100%);
            color: white;
            padding: 15px 0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
        }

        .logo h1 {
            font-size: 24px;
            margin-left: 10px;
        }

        nav ul {
            display: flex;
            list-style: none;
        }

        nav ul li {
            margin-left: 20px;
        }

        nav ul li a {
            color: white;
            text-decoration: none;
        }

        .dashboard-container {
            display: flex;
            margin-top: 20px;
        }

        .sidebar {
            width: 250px;
            background-color: white;
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
            color: white;
        }

        .main-content {
            flex: 1;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .content-header {
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .content-header h1 {
            color: #333;
        }

        .alert {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .edit-record-form {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .form-header {
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .patient-info {
            background-color: #f8f9fa;
            border-left: 4px solid #007bff;
            padding: 15px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }

        textarea.form-control {
            min-height: 100px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
        }

        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid #007bff;
            color: #007bff;
        }

        .btn-outline:hover {
            background-color: #007bff;
            color: white;
        }

        .btn-primary {
            background-color: #007bff;
        }

        .btn-primary:hover {
            background-color: #0069d9;
        }

        footer {
            background-color: #333;
            color: white;
            padding: 20px 0;
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <header>
        <div class="container header-container">
            <div class="logo">
                <h1>Hospital Management System</h1>
            </div>
            <nav>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/index.jsp">Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/doctor/dashboard">Dashboard</a></li>
                    <li><a href="<%= request.getContextPath() %>/logout">Logout</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <div class="container">
        <div class="dashboard-container">
            <div class="sidebar">
                <div class="sidebar-header">
                    <h3>Doctor Portal</h3>
                    <p>Welcome, <%= displayName %></p>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="<%= request.getContextPath() %>/doctor/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="<%= request.getContextPath() %>/doctor/appointments"><i class="fas fa-calendar-check"></i> Appointments</a></li>
                    <li><a href="<%= request.getContextPath() %>/doctor/patients"><i class="fas fa-users"></i> Patients</a></li>
                    <li><a href="<%= request.getContextPath() %>/doctor/prescriptions"><i class="fas fa-prescription"></i> Prescriptions</a></li>
                    <li><a href="<%= request.getContextPath() %>/doctor/medical-records" class="active"><i class="fas fa-file-medical"></i> Medical Records</a></li>
                    <li><a href="<%= request.getContextPath() %>/doctor/profile"><i class="fas fa-user"></i> Profile</a></li>
                </ul>
            </div>

            <div class="main-content">
                <div class="content-header">
                    <h1><i class="fas fa-edit"></i> Edit Medical Record</h1>
                    <p>Update medical record information</p>
                </div>

                <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("errorMessage") %>
                </div>
                <% } %>

                <% if (session.getAttribute("successMessage") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= session.getAttribute("successMessage") %>
                </div>
                <% session.removeAttribute("successMessage"); %>
                <% } %>

                <% if (medicalRecord != null) { %>
                <div class="edit-record-form">
                    <div class="form-header">
                        <h2>Edit Medical Record</h2>
                        <p>Update the medical record information below</p>
                    </div>

                    <% if (patient != null) { %>
                    <div class="patient-info">
                        <h3>Patient Information</h3>
                        <p><strong>Name:</strong> <%= patient.getName() %></p>
                        <p><strong>ID:</strong> <%= patient.getId() %></p>
                        <p><strong>Gender:</strong> <%= patient.getGender() != null ? patient.getGender() : "Not specified" %></p>
                        <p><strong>Date of Birth:</strong> <%= patient.getDateOfBirth() != null ? dateFormat.format(patient.getDateOfBirth()) : "Not specified" %></p>
                    </div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/doctor/update-medical-record-form" method="post">
                        <input type="hidden" name="id" value="<%= medicalRecord.getId() %>">
                        <input type="hidden" name="patientId" value="<%= medicalRecord.getPatientId() %>">

                        <div class="form-row">
                            <div class="form-group">
                                <label for="recordType">Record Type</label>
                                <select id="recordType" name="recordType" class="form-control" required>
                                    <option value="">Select Record Type</option>
                                    <option value="visit" <%= "visit".equals(medicalRecord.getRecordType()) ? "selected" : "" %>>Office Visit</option>
                                    <option value="lab" <%= "lab".equals(medicalRecord.getRecordType()) ? "selected" : "" %>>Lab Results</option>
                                    <option value="imaging" <%= "imaging".equals(medicalRecord.getRecordType()) ? "selected" : "" %>>Imaging</option>
                                    <option value="procedure" <%= "procedure".equals(medicalRecord.getRecordType()) ? "selected" : "" %>>Procedure</option>
                                    <option value="other" <%= "other".equals(medicalRecord.getRecordType()) ? "selected" : "" %>>Other</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="recordDate">Record Date</label>
                                <input type="date" id="recordDate" name="recordDate" class="form-control" value="<%= recordDate %>" required>
                            </div>

                            <div class="form-group">
                                <label for="status">Status</label>
                                <select id="status" name="status" class="form-control" required>
                                    <option value="">Select Status</option>
                                    <option value="Active" <%= "Active".equals(medicalRecord.getStatus()) ? "selected" : "" %>>Active</option>
                                    <option value="Completed" <%= "Completed".equals(medicalRecord.getStatus()) ? "selected" : "" %>>Completed</option>
                                    <option value="Cancelled" <%= "Cancelled".equals(medicalRecord.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="diagnosis">Diagnosis</label>
                            <input type="text" id="diagnosis" name="diagnosis" class="form-control" value="<%= medicalRecord.getDiagnosis() != null ? medicalRecord.getDiagnosis() : "" %>" required>
                        </div>

                        <div class="form-group">
                            <label for="symptoms">Symptoms</label>
                            <textarea id="symptoms" name="symptoms" class="form-control"><%= medicalRecord.getSymptoms() != null ? medicalRecord.getSymptoms() : "" %></textarea>
                        </div>

                        <div class="form-group">
                            <label for="treatment">Treatment</label>
                            <textarea id="treatment" name="treatment" class="form-control"><%= medicalRecord.getTreatment() != null ? medicalRecord.getTreatment() : "" %></textarea>
                        </div>

                        <div class="form-group">
                            <label for="notes">Additional Notes</label>
                            <textarea id="notes" name="notes" class="form-control"><%= medicalRecord.getNotes() != null ? medicalRecord.getNotes() : "" %></textarea>
                        </div>

                        <div class="form-group">
                            <label for="prescription">Prescription</label>
                            <textarea id="prescription" name="prescription" class="form-control"><%= medicalRecord.getPrescription() != null ? medicalRecord.getPrescription() : "" %></textarea>
                        </div>

                        <div class="action-buttons">
                            <a href="<%= request.getContextPath() %>/doctor/view-medical-record?id=<%= medicalRecord.getId() %>" class="btn btn-outline">
                                <i class="fas fa-arrow-left"></i> Cancel
                            </a>

                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Save Changes
                            </button>
                        </div>
                    </form>
                </div>
                <% } else { %>
                <div class="edit-record-form">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        Medical record not found or you do not have permission to edit it.
                    </div>
                    <div class="action-buttons" style="justify-content: center;">
                        <a href="<%= request.getContextPath() %>/doctor/medical-records" class="btn btn-outline">
                            <i class="fas fa-arrow-left"></i> Back to Medical Records
                        </a>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <footer>
        <div class="container">
            <p>&copy; 2025 Hospital Management System. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
