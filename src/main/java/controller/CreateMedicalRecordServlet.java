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
            
            // Validate form data
            if (patientIdStr == null || patientIdStr.isEmpty() || 
                recordType == null || recordType.isEmpty() ||
                title == null || title.isEmpty() ||
                content == null || content.isEmpty()) {
                
                request.setAttribute("errorMessage", "Please fill in all required fields");
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
            
        } catch (Exception e) {
            System.out.println("CreateMedicalRecordServlet: Error creating medical record: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/medical-records?error=server-error");
        }
    }
}
