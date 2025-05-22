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
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>Edit Medical Record - LifeCare Medical Center</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
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

        /* Form Styles */
        .edit-record-form {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
        }

        .form-header {
            margin-bottom: 25px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 15px;
        }

        .form-header h2 {
            color: #2c3e50;
            font-size: 24px;
            font-weight: 600;
        }

        .form-header p {
            color: #7f8c8d;
            font-size: 16px;
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            flex: 1;
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #34495e;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .form-control:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
            outline: none;
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23333' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 16px;
            padding-right: 40px;
        }

        /* Patient Info Section */
        .patient-info {
            background-color: #f8f9fa;
            border-left: 4px solid #3498db;
            padding: 15px 20px;
            border-radius: 6px;
            margin-bottom: 25px;
        }

        .patient-info h3 {
            color: #2c3e50;
            font-size: 18px;
            margin-bottom: 10px;
        }

        .patient-info p {
            margin: 5px 0;
            color: #555;
        }

        .patient-info strong {
            font-weight: 600;
            color: #34495e;
        }

        /* Prescription Section */
        .prescription-section {
            background-color: #f0f7ff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            border: 1px solid #d1e6ff;
        }

        .prescription-section h3 {
            color: #0066cc;
            margin-bottom: 15px;
            font-size: 18px;
            border-bottom: 1px solid #d1e6ff;
            padding-bottom: 10px;
        }

        .prescription-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            background-color: white;
            padding: 12px 15px;
            border-radius: 6px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .prescription-item i {
            color: #3498db;
            margin-right: 10px;
            font-size: 18px;
        }

        .prescription-item input {
            flex: 1;
            border: none;
            padding: 8px 0;
            font-size: 16px;
        }

        .prescription-item input:focus {
            outline: none;
        }

        .add-prescription {
            background-color: #e8f4fc;
            border: 1px dashed #3498db;
            border-radius: 6px;
            padding: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .add-prescription:hover {
            background-color: #d1e9f9;
        }

        .add-prescription i {
            color: #3498db;
            margin-right: 8px;
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
            transition: all 0.3s;
            border: none;
            text-decoration: none;
        }

        .btn i {
            margin-right: 8px;
        }

        .btn-primary {
            background-color: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background-color: #2980b9;
        }

        .btn-outline {
            background-color: transparent;
            border: 2px solid #3498db;
            color: #3498db;
        }

        .btn-outline:hover {
            background-color: #f0f7ff;
        }

        .btn-danger {
            background-color: #e74c3c;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c0392b;
        }

        /* Alert Messages */
        .alert {
            padding: 15px 20px;
            border-radius: 6px;
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
            color: #e74c3c;
            border-left: 4px solid #e74c3c;
        }

        .alert-success {
            background-color: #eafaf1;
            color: #27ae60;
            border-left: 4px solid #27ae60;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
                gap: 0;
            }

            .action-buttons {
                flex-direction: column;
                gap: 15px;
            }

            .action-buttons .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/doctor-header.jsp" />

    <div class="container">
        <div class="dashboard-container">
            <jsp:include page="../includes/doctor-sidebar.jsp" />

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
                <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 6px; margin-bottom: 25px; display: flex; align-items: center; border-left: 4px solid #28a745;">
                    <i class="fas fa-check-circle" style="margin-right: 10px; font-size: 18px;"></i>
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

                    <form action="update-medical-record" method="post">
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
                            <textarea id="symptoms" name="symptoms" class="form-control" rows="3"><%= medicalRecord.getSymptoms() != null ? medicalRecord.getSymptoms() : "" %></textarea>
                        </div>

                        <div class="form-group">
                            <label for="treatment">Treatment</label>
                            <textarea id="treatment" name="treatment" class="form-control" rows="3"><%= medicalRecord.getTreatment() != null ? medicalRecord.getTreatment() : "" %></textarea>
                        </div>

                        <div class="form-group">
                            <label for="notes">Additional Notes</label>
                            <textarea id="notes" name="notes" class="form-control" rows="4"><%= medicalRecord.getNotes() != null ? medicalRecord.getNotes() : "" %></textarea>
                        </div>

                        <div class="prescription-section">
                            <h3><i class="fas fa-prescription"></i> Prescription</h3>

                            <div class="prescription-item">
                                <i class="fas fa-pills"></i>
                                <input type="text" name="prescription" placeholder="Enter prescription details" value="<%= medicalRecord.getPrescription() != null ? medicalRecord.getPrescription() : "" %>">
                            </div>

                            <!-- This would be expanded with JavaScript in a real implementation -->
                            <div class="add-prescription">
                                <i class="fas fa-plus-circle"></i>
                                <span>Add Another Medication</span>
                            </div>
                        </div>

                        <div class="action-buttons">
                            <a href="view-medical-record?id=<%= medicalRecord.getId() %>" class="btn btn-outline">
                                <i class="fas fa-arrow-left"></i> Cancel
                            </a>

                            <div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Save Changes
                                </button>
                            </div>
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
                        <a href="medical-records" class="btn btn-outline">
                            <i class="fas fa-arrow-left"></i> Back to Medical Records
                        </a>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <jsp:include page="../includes/footer.jsp" />

    <script>
        // Add JavaScript for dynamic prescription items
        document.addEventListener('DOMContentLoaded', function() {
            const addPrescriptionBtn = document.querySelector('.add-prescription');
            const prescriptionSection = document.querySelector('.prescription-section');

            if (addPrescriptionBtn) {
                addPrescriptionBtn.addEventListener('click', function() {
                    const newItem = document.createElement('div');
                    newItem.className = 'prescription-item';
                    newItem.innerHTML = `
                        <i class="fas fa-pills"></i>
                        <input type="text" name="prescription_additional" placeholder="Enter prescription details">
                        <button type="button" class="remove-item" style="background: none; border: none; color: #e74c3c; cursor: pointer;">
                            <i class="fas fa-times"></i>
                        </button>
                    `;

                    prescriptionSection.insertBefore(newItem, addPrescriptionBtn);

                    // Add event listener to remove button
                    newItem.querySelector('.remove-item').addEventListener('click', function() {
                        prescriptionSection.removeChild(newItem);
                    });
                });
            }
        });
    </script>
</body>
</html>
