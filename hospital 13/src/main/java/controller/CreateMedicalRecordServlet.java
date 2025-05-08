package controller;

import dao.MedicalRecordDAO;
import model.MedicalRecord;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;

@WebServlet("/doctor/save-medical-record")
public class CreateMedicalRecordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("username") == null || !"doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get doctor ID from session
        Integer doctorId = (Integer) session.getAttribute("userId");
        if (doctorId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get form data
            String patientIdStr = request.getParameter("patientId");
            String recordType = request.getParameter("recordType");
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            System.out.println("CreateMedicalRecordServlet: Creating medical record for patient " + patientIdStr +
                               ", type: " + recordType + ", title: " + title);

            // Debug information for request parameters
            System.out.println("CreateMedicalRecordServlet: All request parameters:");
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                System.out.println("  " + paramName + ": " + paramValue);
            }

            // Validate form data
            StringBuilder missingFields = new StringBuilder();
            if (patientIdStr == null || patientIdStr.isEmpty()) {
                missingFields.append("Patient ID, ");
            }
            if (recordType == null || recordType.isEmpty()) {
                missingFields.append("Record Type, ");
            }
            if (title == null || title.isEmpty()) {
                missingFields.append("Title, ");
            }
            if (content == null || content.isEmpty()) {
                missingFields.append("Content, ");
            }

            if (missingFields.length() > 0) {
                String missing = missingFields.substring(0, missingFields.length() - 2); // Remove trailing comma and space
                System.out.println("CreateMedicalRecordServlet: Missing required fields: " + missing);

                // Store error in session instead of request for redirect
                session.setAttribute("errorMessage", "Please fill in all required fields: " + missing);
                response.sendRedirect(request.getContextPath() + "/doctor/medical-records?patient=" + patientIdStr + "&error=missing-fields");
                return;
            }

            // Parse patient ID
            int patientId = Integer.parseInt(patientIdStr);

            // Create medical record object
            MedicalRecord medicalRecord = new MedicalRecord();
            medicalRecord.setPatientId(patientId);
            medicalRecord.setDoctorId(doctorId);
            medicalRecord.setRecordType(recordType);
            medicalRecord.setDiagnosis(title); // Using title as diagnosis for simplicity
            medicalRecord.setNotes(content);   // Using content as notes for simplicity
            medicalRecord.setRecordDate(new Date());
            medicalRecord.setStatus("Active");

            // Set empty values for required fields that aren't in the form
            medicalRecord.setSymptoms("");
            medicalRecord.setTreatment("");
            medicalRecord.setPrescription("");

            System.out.println("CreateMedicalRecordServlet: Created medical record object with fields:");
            System.out.println("  patientId: " + medicalRecord.getPatientId());
            System.out.println("  doctorId: " + medicalRecord.getDoctorId());
            System.out.println("  recordType: " + medicalRecord.getRecordType());
            System.out.println("  diagnosis: " + medicalRecord.getDiagnosis());
            System.out.println("  notes: " + medicalRecord.getNotes());
            System.out.println("  recordDate: " + medicalRecord.getRecordDate());
            System.out.println("  status: " + medicalRecord.getStatus());
            System.out.println("  symptoms: " + medicalRecord.getSymptoms());
            System.out.println("  treatment: " + medicalRecord.getTreatment());
            System.out.println("  prescription: " + medicalRecord.getPrescription());

            // Save medical record to database
            MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
            boolean success = medicalRecordDAO.createMedicalRecord(medicalRecord);

            if (success) {
                System.out.println("CreateMedicalRecordServlet: Medical record created successfully");
                response.sendRedirect(request.getContextPath() + "/doctor/medical-records?patient=" + patientIdStr + "&success=true");
            } else {
                System.out.println("CreateMedicalRecordServlet: Failed to create medical record");
                response.sendRedirect(request.getContextPath() + "/doctor/medical-records?patient=" + patientIdStr + "&error=create-failed");
            }

        } catch (NumberFormatException e) {
            System.out.println("CreateMedicalRecordServlet: Invalid patient ID format: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Invalid patient ID format. Please try again.");
            response.sendRedirect(request.getContextPath() + "/doctor/medical-records");
        } catch (Exception e) {
            System.out.println("CreateMedicalRecordServlet: Error creating medical record: " + e.getMessage());
            System.out.println("Exception type: " + e.getClass().getName());
            e.printStackTrace();

            String errorMsg = "An error occurred while creating the medical record: " + e.getMessage();

            // Check for common database-related errors
            if (e.getMessage() != null) {
                if (e.getMessage().contains("Communications link failure") ||
                    e.getMessage().contains("Connection refused")) {
                    errorMsg = "Could not connect to the database. Please check your database connection.";
                } else if (e.getMessage().contains("Table") && e.getMessage().contains("doesn't exist")) {
                    errorMsg = "Database table not found. Please contact system administrator.";
                }
            }

            session.setAttribute("errorMessage", errorMsg);

            // Include patient ID in redirect if available
            String patientIdStr = request.getParameter("patientId");
            if (patientIdStr != null && !patientIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/doctor/medical-records?patient=" + patientIdStr + "&error=server-error");
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/medical-records?error=server-error");
            }
        }
    }
}
