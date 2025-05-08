package controller;

import dao.MedicalRecordDAO;
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

@WebServlet({"/patient/view-medical-record", "/view-medical-record"})
public class ViewMedicalRecordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("ViewMedicalRecordServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("ViewMedicalRecordServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("ViewMedicalRecordServlet: User is not a patient, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get patient's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            session.setAttribute("userId", userId);
        }
        
        if (userId == null) {
            System.out.println("ViewMedicalRecordServlet: User ID not found in session");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get medical record ID from request parameter
        String recordIdStr = request.getParameter("id");
        if (recordIdStr == null || recordIdStr.isEmpty()) {
            System.out.println("ViewMedicalRecordServlet: No medical record ID provided");
            session.setAttribute("errorMessage", "No medical record ID provided");
            response.sendRedirect(request.getContextPath() + "/patient/medical-records");
            return;
        }

        try {
            int recordId = Integer.parseInt(recordIdStr);
            
            // Get medical record details
            MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
            MedicalRecord medicalRecord = medicalRecordDAO.getMedicalRecordById(recordId);
            
            if (medicalRecord == null) {
                System.out.println("ViewMedicalRecordServlet: Medical record not found");
                session.setAttribute("errorMessage", "Medical record not found");
                response.sendRedirect(request.getContextPath() + "/patient/medical-records");
                return;
            }
            
            // Check if the medical record belongs to the logged-in patient
            if (medicalRecord.getPatientId() != userId) {
                System.out.println("ViewMedicalRecordServlet: Medical record does not belong to the logged-in patient");
                session.setAttribute("errorMessage", "You do not have permission to view this medical record");
                response.sendRedirect(request.getContextPath() + "/patient/medical-records");
                return;
            }
            
            // Set medical record as request attribute
            request.setAttribute("medicalRecord", medicalRecord);
            
            // Set request attributes for the JSP
            request.setAttribute("username", session.getAttribute("username"));
            request.setAttribute("name", session.getAttribute("name"));
            request.setAttribute("role", session.getAttribute("role"));
            request.setAttribute("userId", userId);
            
            // Forward to the JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/view-medical-record.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            System.out.println("ViewMedicalRecordServlet: Invalid medical record ID format");
            session.setAttribute("errorMessage", "Invalid medical record ID format");
            response.sendRedirect(request.getContextPath() + "/patient/medical-records");
        } catch (Exception e) {
            System.out.println("ViewMedicalRecordServlet: Error retrieving medical record: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error retrieving medical record: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/medical-records");
        }
    }
}
