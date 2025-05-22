<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.MedicalRecord, model.User, java.util.List, java.text.SimpleDateFormat" %>
<%
// Get attributes from session
String username = (String) session.getAttribute("username");
String name = (String) session.getAttribute("name");
String role = (String) session.getAttribute("role");

// Get medical record from request
MedicalRecord medicalRecord = (MedicalRecord) request.getAttribute("medicalRecord");
User patient = (User) request.getAttribute("patient");

// Format date
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
String recordDate = medicalRecord != null && medicalRecord.getRecordDate() != null ?
                    dateFormat.format(medicalRecord.getRecordDate()) : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Simple Edit Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input, select, textarea {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }
        button {
            padding: 10px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        .error {
            color: red;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <h1>Edit Medical Record</h1>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>

    <% if (medicalRecord != null) { %>
    <form action="<%= request.getContextPath() %>/doctor/update-medical-record-form" method="post">
        <input type="hidden" name="id" value="<%= medicalRecord.getId() %>">
        <input type="hidden" name="patientId" value="<%= medicalRecord.getPatientId() %>">

        <div class="form-group">
            <label for="recordType">Record Type:</label>
            <select id="recordType" name="recordType" required>
                <option value="">Select Record Type</option>
                <option value="visit" <%= "visit".equals(medicalRecord.getRecordType()) ? "selected" : "" %>>Office Visit</option>
                <option value="lab" <%= "lab".equals(medicalRecord.getRecordType()) ? "selected" : "" %>>Lab Results</option>
                <option value="imaging" <%= "imaging".equals(medicalRecord.getRecordType()) ? "selected" : "" %>>Imaging</option>
                <option value="procedure" <%= "procedure".equals(medicalRecord.getRecordType()) ? "selected" : "" %>>Procedure</option>
                <option value="other" <%= "other".equals(medicalRecord.getRecordType()) ? "selected" : "" %>>Other</option>
            </select>
        </div>

        <div class="form-group">
            <label for="recordDate">Record Date:</label>
            <input type="date" id="recordDate" name="recordDate" value="<%= recordDate %>" required>
        </div>

        <div class="form-group">
            <label for="status">Status:</label>
            <select id="status" name="status" required>
                <option value="">Select Status</option>
                <option value="Active" <%= "Active".equals(medicalRecord.getStatus()) ? "selected" : "" %>>Active</option>
                <option value="Completed" <%= "Completed".equals(medicalRecord.getStatus()) ? "selected" : "" %>>Completed</option>
                <option value="Cancelled" <%= "Cancelled".equals(medicalRecord.getStatus()) ? "selected" : "" %>>Cancelled</option>
            </select>
        </div>

        <div class="form-group">
            <label for="diagnosis">Diagnosis:</label>
            <input type="text" id="diagnosis" name="diagnosis" value="<%= medicalRecord.getDiagnosis() != null ? medicalRecord.getDiagnosis() : "" %>" required>
        </div>

        <div class="form-group">
            <label for="symptoms">Symptoms:</label>
            <textarea id="symptoms" name="symptoms"><%= medicalRecord.getSymptoms() != null ? medicalRecord.getSymptoms() : "" %></textarea>
        </div>

        <div class="form-group">
            <label for="treatment">Treatment:</label>
            <textarea id="treatment" name="treatment"><%= medicalRecord.getTreatment() != null ? medicalRecord.getTreatment() : "" %></textarea>
        </div>

        <div class="form-group">
            <label for="notes">Notes:</label>
            <textarea id="notes" name="notes"><%= medicalRecord.getNotes() != null ? medicalRecord.getNotes() : "" %></textarea>
        </div>

        <div class="form-group">
            <label for="prescription">Prescription:</label>
            <textarea id="prescription" name="prescription"><%= medicalRecord.getPrescription() != null ? medicalRecord.getPrescription() : "" %></textarea>
        </div>

        <div class="form-group">
            <button type="submit">Save Changes</button>
            <a href="<%= request.getContextPath() %>/doctor/view-medical-record?id=<%= medicalRecord.getId() %>" style="margin-left: 10px; text-decoration: none;">Cancel</a>
        </div>
    </form>
    <% } else { %>
    <p>Medical record not found or you do not have permission to edit it.</p>
    <a href="<%= request.getContextPath() %>/doctor/medical-records">Back to Medical Records</a>
    <% } %>
</body>
</html>
