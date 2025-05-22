package controller;

import dao.MedicalRecordDAO;
import dao.UserDAO;
import model.MedicalRecord;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/doctor/update-medical-record-form")
public class SaveMedicalRecordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("SaveMedicalRecordServlet: doPost method called");
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
            String idStr = request.getParameter("id");
            String patientIdStr = request.getParameter("patientId");
            String recordType = request.getParameter("recordType");
            String recordDateStr = request.getParameter("recordDate");
            String status = request.getParameter("status");
            String diagnosis = request.getParameter("diagnosis");
            String symptoms = request.getParameter("symptoms");
            String treatment = request.getParameter("treatment");
            String notes = request.getParameter("notes");
            String prescription = request.getParameter("prescription");

            System.out.println("SaveMedicalRecordServlet: Updating medical record ID " + idStr);
            System.out.println("SaveMedicalRecordServlet: patientId = " + patientIdStr);
            System.out.println("SaveMedicalRecordServlet: recordType = " + recordType);
            System.out.println("SaveMedicalRecordServlet: recordDate = " + recordDateStr);
            System.out.println("SaveMedicalRecordServlet: status = " + status);
            System.out.println("SaveMedicalRecordServlet: diagnosis = " + diagnosis);
            System.out.println("SaveMedicalRecordServlet: symptoms = " + symptoms);
            System.out.println("SaveMedicalRecordServlet: treatment = " + treatment);
            System.out.println("SaveMedicalRecordServlet: notes = " + notes);
            System.out.println("SaveMedicalRecordServlet: prescription = " + prescription);

            // Validate form data
            if (idStr == null || idStr.isEmpty() ||
                patientIdStr == null || patientIdStr.isEmpty() ||
                recordType == null || recordType.isEmpty() ||
                recordDateStr == null || recordDateStr.isEmpty() ||
                status == null || status.isEmpty() ||
                diagnosis == null || diagnosis.isEmpty()) {

                request.setAttribute("errorMessage", "Please fill in all required fields");
                request.getRequestDispatcher("/doctor/edit-record?id=" + idStr).forward(request, response);
                return;
            }

            // Parse IDs
            int id = Integer.parseInt(idStr);
            int patientId = Integer.parseInt(patientIdStr);

            // Parse date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date recordDate = dateFormat.parse(recordDateStr);

            // Get existing medical record
            MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
            MedicalRecord medicalRecord = medicalRecordDAO.getMedicalRecordById(id);

            if (medicalRecord == null) {
                request.setAttribute("errorMessage", "Medical record not found");
                request.getRequestDispatcher("/doctor/medical-records").forward(request, response);
                return;
            }

            // Update medical record object
            medicalRecord.setPatientId(patientId);
            medicalRecord.setDoctorId(doctorId);
            medicalRecord.setRecordType(recordType);
            medicalRecord.setRecordDate(recordDate);
            medicalRecord.setStatus(status);
            medicalRecord.setDiagnosis(diagnosis);
            medicalRecord.setSymptoms(symptoms);
            medicalRecord.setTreatment(treatment);
            medicalRecord.setNotes(notes);
            medicalRecord.setPrescription(prescription);

            // Save medical record to database
            boolean success = medicalRecordDAO.updateMedicalRecord(medicalRecord);

            if (success) {
                System.out.println("SaveMedicalRecordServlet: Medical record updated successfully");
                // Set a session attribute for the success message to persist through the redirect
                session.setAttribute("successMessage", "Medical record updated successfully");
                response.sendRedirect(request.getContextPath() + "/doctor/view-medical-record?id=" + id + "&success=true");
            } else {
                System.out.println("SaveMedicalRecordServlet: Failed to update medical record");
                request.setAttribute("errorMessage", "Failed to update medical record. Please try again.");
                request.setAttribute("medicalRecord", medicalRecord); // Keep the form data
                request.setAttribute("patient", new UserDAO().getUserById(patientId)); // Get patient info again
                request.getRequestDispatcher("/doctor/better-edit-form?id=" + id).forward(request, response);
            }

        } catch (NumberFormatException e) {
            System.out.println("SaveMedicalRecordServlet: Invalid ID format: " + e.getMessage());
            request.setAttribute("errorMessage", "Invalid ID format");
            request.getRequestDispatcher("/doctor/medical-records").forward(request, response);
        } catch (ParseException e) {
            System.out.println("SaveMedicalRecordServlet: Invalid date format: " + e.getMessage());
            request.setAttribute("errorMessage", "Invalid date format");
            request.getRequestDispatcher("/doctor/better-edit-form?id=" + request.getParameter("id")).forward(request, response);
        } catch (Exception e) {
            System.out.println("SaveMedicalRecordServlet: Error updating medical record: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating medical record: " + e.getMessage());
            request.getRequestDispatcher("/doctor/better-edit-form?id=" + request.getParameter("id")).forward(request, response);
        }
    }
}
