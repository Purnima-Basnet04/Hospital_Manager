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
        :root {
            --primary-color: #1976d2;
            --primary-light: #e3f2fd;
            --primary-dark: #0d47a1;
            --success-color: #4caf50;
            --warning-color: #ff9800;
            --danger-color: #f44336;
            --gray-100: #f8f9fa;
            --gray-200: #e9ecef;
            --gray-300: #dee2e6;
            --gray-400: #ced4da;
            --gray-500: #adb5bd;
            --gray-600: #6c757d;
            --gray-700: #495057;
            --gray-800: #343a40;
            --gray-900: #212529;
            --border-radius: 8px;
            --box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: var(--gray-800);
            background-color: #f5f7fa;
            padding-bottom: 40px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Header Styles */
        header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 15px 0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
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
            font-weight: 500;
            transition: all 0.3s;
            padding: 5px 10px;
            border-radius: var(--border-radius);
        }

        nav ul li a:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        /* Page Title */
        .page-title {
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid var(--gray-300);
        }

        .page-title h1 {
            color: var(--primary-dark);
            font-size: 28px;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
        }

        .page-title h1 i {
            margin-right: 10px;
            color: var(--primary-color);
        }

        .page-title p {
            color: var(--gray-600);
            font-size: 16px;
        }

        /* Alert Messages */
        .alert {
            padding: 15px 20px;
            border-radius: var(--border-radius);
            margin-bottom: 25px;
            display: flex;
            align-items: center;
        }

        .alert i {
            margin-right: 10px;
            font-size: 18px;
        }

        .alert-danger {
            background-color: #fdecea;
            color: var(--danger-color);
            border-left: 4px solid var(--danger-color);
        }

        .alert-success {
            background-color: #e8f5e9;
            color: var(--success-color);
            border-left: 4px solid var(--success-color);
        }

        /* Patient Info Card */
        .patient-card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 20px;
            margin-bottom: 30px;
            border-top: 4px solid var(--primary-color);
        }

        .patient-card h2 {
            color: var(--primary-color);
            font-size: 20px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .patient-card h2 i {
            margin-right: 10px;
        }

        .patient-info {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }

        .info-item {
            margin-bottom: 10px;
        }

        .info-label {
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 5px;
            font-size: 14px;
        }

        .info-value {
            color: var(--gray-800);
            font-size: 16px;
        }

        /* Form Styles */
        .edit-form {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 30px;
            margin-bottom: 30px;
        }

        .form-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--gray-200);
        }

        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .form-section-title {
            color: var(--primary-color);
            font-size: 18px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .form-section-title i {
            margin-right: 10px;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--gray-700);
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--gray-300);
            border-radius: var(--border-radius);
            font-size: 16px;
            transition: all 0.3s;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.2);
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

        /* Button Styles */
        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid var(--gray-200);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 24px;
            border-radius: var(--border-radius);
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            text-decoration: none;
        }

        .btn i {
            margin-right: 8px;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
        }

        .btn-outline {
            background-color: transparent;
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
        }

        .btn-outline:hover {
            background-color: var(--primary-light);
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }

            .form-actions {
                flex-direction: column;
                gap: 15px;
            }

            .form-actions .btn {
                width: 100%;
            }

            .patient-info {
                grid-template-columns: 1fr;
            }
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
        <div class="page-title">
            <h1><i class="fas fa-edit"></i> Edit Medical Record</h1>
            <p>Update medical record information for your patient</p>
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

        <% if (medicalRecord != null && patient != null) { %>
        <div class="patient-card">
            <h2><i class="fas fa-user"></i> Patient Information</h2>
            <div class="patient-info">
                <div class="info-item">
                    <div class="info-label">Name</div>
                    <div class="info-value"><%= patient.getName() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">ID</div>
                    <div class="info-value"><%= patient.getId() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Gender</div>
                    <div class="info-value"><%= patient.getGender() != null ? patient.getGender() : "Not specified" %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Date of Birth</div>
                    <div class="info-value"><%= patient.getDateOfBirth() != null ? dateFormat.format(patient.getDateOfBirth()) : "Not specified" %></div>
                </div>
            </div>
        </div>

        <form action="<%= request.getContextPath() %>/doctor/update-medical-record-form" method="post" class="edit-form">
            <input type="hidden" name="id" value="<%= medicalRecord.getId() %>">
            <input type="hidden" name="patientId" value="<%= medicalRecord.getPatientId() %>">

            <div class="form-section">
                <h3 class="form-section-title"><i class="fas fa-clipboard-list"></i> Record Details</h3>
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
            </div>

            <div class="form-section">
                <h3 class="form-section-title"><i class="fas fa-stethoscope"></i> Medical Information</h3>

                <div class="form-group">
                    <label for="diagnosis">Diagnosis</label>
                    <input type="text" id="diagnosis" name="diagnosis" class="form-control" value="<%= medicalRecord.getDiagnosis() != null ? medicalRecord.getDiagnosis() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="symptoms">Symptoms</label>
                    <textarea id="symptoms" name="symptoms" class="form-control" rows="3"><%= medicalRecord.getSymptoms() != null ? medicalRecord.getSymptoms() : "" %></textarea>
                </div>

                <div class="form-group">
                    <label for="treatment">Treatment</label>
                    <textarea id="treatment" name="treatment" class="form-control" rows="3"><%= medicalRecord.getTreatment() != null ? medicalRecord.getTreatment() : "" %></textarea>
                </div>
            </div>

            <div class="form-section">
                <h3 class="form-section-title"><i class="fas fa-prescription-bottle-alt"></i> Prescription & Notes</h3>

                <div class="form-group">
                    <label for="prescription">Prescription</label>
                    <textarea id="prescription" name="prescription" class="form-control" rows="3"><%= medicalRecord.getPrescription() != null ? medicalRecord.getPrescription() : "" %></textarea>
                </div>

                <div class="form-group">
                    <label for="notes">Additional Notes</label>
                    <textarea id="notes" name="notes" class="form-control" rows="4"><%= medicalRecord.getNotes() != null ? medicalRecord.getNotes() : "" %></textarea>
                </div>
            </div>

            <div class="form-actions">
                <a href="<%= request.getContextPath() %>/doctor/view-medical-record?id=<%= medicalRecord.getId() %>" class="btn btn-outline">
                    <i class="fas fa-arrow-left"></i> Cancel
                </a>

                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Save Changes
                </button>
            </div>
        </form>
        <% } else { %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i>
            Medical record or patient information not found.
        </div>
        <div style="text-align: center; margin-top: 30px;">
            <a href="<%= request.getContextPath() %>/doctor/medical-records" class="btn btn-outline">
                <i class="fas fa-arrow-left"></i> Back to Medical Records
            </a>
        </div>
        <% } %>
    </div>
</body>
</html>
