package controller;

import dao.MedicalRecordDAO;
import dao.UserDAO;
import model.MedicalRecord;
import model.User;

import jakarta.servlet.RequestDispatcher;
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

@WebServlet("/doctor/edit-medical-record")
public class EditMedicalRecordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("EditMedicalRecordServlet: doGet method called");
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("username") == null || !"doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get medical record ID from request parameter
        String recordIdStr = request.getParameter("id");
        System.out.println("EditMedicalRecordServlet: Record ID = " + recordIdStr);
        if (recordIdStr == null || recordIdStr.isEmpty()) {
            System.out.println("EditMedicalRecordServlet: No medical record ID provided");
            request.setAttribute("errorMessage", "No medical record ID provided");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/medical-records");
            dispatcher.forward(request, response);
            return;
        }

        try {
            int recordId = Integer.parseInt(recordIdStr);

            // Get medical record details
            MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
            MedicalRecord medicalRecord = medicalRecordDAO.getMedicalRecordById(recordId);

            if (medicalRecord == null) {
                System.out.println("EditMedicalRecordServlet: Medical record not found");
                request.setAttribute("errorMessage", "Medical record not found");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/medical-records");
                dispatcher.forward(request, response);
                return;
            }

            // Get patient details
            UserDAO userDAO = new UserDAO();
            User patient = userDAO.getUserById(medicalRecord.getPatientId());

            // Set default values for null fields
            if (medicalRecord.getRecordType() == null || medicalRecord.getRecordType().isEmpty()) {
                medicalRecord.setRecordType("visit");
                System.out.println("EditMedicalRecordServlet: Set default record type to 'visit'");
            }

            if (medicalRecord.getStatus() == null || medicalRecord.getStatus().isEmpty()) {
                medicalRecord.setStatus("Active");
                System.out.println("EditMedicalRecordServlet: Set default status to 'Active'");
            }

            // Check for any error messages in the request
            if (request.getParameter("error") != null) {
                String error = request.getParameter("error");
                if ("validation".equals(error)) {
                    request.setAttribute("errorMessage", "Please fill in all required fields.");
                } else if ("database".equals(error)) {
                    request.setAttribute("errorMessage", "Database error occurred. Please try again.");
                }
            }

            // Set attributes for JSP
            request.setAttribute("medicalRecord", medicalRecord);
            request.setAttribute("patient", patient);

            // Log the forward destination
            System.out.println("EditMedicalRecordServlet: Forwarding to /doctor/edit-medical-record.jsp");
            System.out.println("EditMedicalRecordServlet: Medical Record ID = " + medicalRecord.getId());
            System.out.println("EditMedicalRecordServlet: Patient ID = " + medicalRecord.getPatientId());
            System.out.println("EditMedicalRecordServlet: Record Type = " + medicalRecord.getRecordType());
            System.out.println("EditMedicalRecordServlet: Status = " + medicalRecord.getStatus());

            // Forward to edit page
            RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/edit-medical-record.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("EditMedicalRecordServlet: Invalid medical record ID format");
            request.setAttribute("errorMessage", "Invalid medical record ID format");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/medical-records");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.out.println("EditMedicalRecordServlet: Error retrieving medical record: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving medical record: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/medical-records");
            dispatcher.forward(request, response);
        }
    }
}
