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

@WebServlet("/doctor/view-medical-record")
public class DoctorViewMedicalRecordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("DoctorViewMedicalRecordServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("DoctorViewMedicalRecordServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a doctor
        String role = (String) session.getAttribute("role");
        if (!"doctor".equals(role)) {
            System.out.println("DoctorViewMedicalRecordServlet: User is not a doctor, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get doctor's ID from session
        Integer doctorId = (Integer) session.getAttribute("userId");
        if (doctorId == null) {
            System.out.println("DoctorViewMedicalRecordServlet: Doctor ID not found in session");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get medical record ID from request parameter
        String recordIdStr = request.getParameter("id");
        if (recordIdStr == null || recordIdStr.isEmpty()) {
            System.out.println("DoctorViewMedicalRecordServlet: No medical record ID provided");
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
                System.out.println("DoctorViewMedicalRecordServlet: Medical record not found");
                request.setAttribute("errorMessage", "Medical record not found");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/medical-records");
                dispatcher.forward(request, response);
                return;
            }

            // Get patient details to set patient name
            UserDAO userDAO = new UserDAO();
            User patient = userDAO.getUserById(medicalRecord.getPatientId());
            if (patient != null) {
                medicalRecord.setPatientName(patient.getName());
            }

            // Set default values for null fields
            if (medicalRecord.getRecordType() == null || medicalRecord.getRecordType().isEmpty()) {
                medicalRecord.setRecordType("visit");
                System.out.println("DoctorViewMedicalRecordServlet: Set default record type to 'visit'");
            }

            if (medicalRecord.getStatus() == null || medicalRecord.getStatus().isEmpty()) {
                medicalRecord.setStatus("Active");
                System.out.println("DoctorViewMedicalRecordServlet: Set default status to 'Active'");
            }

            // Check for success parameter
            String successParam = request.getParameter("success");
            if (successParam != null && successParam.equals("true")) {
                System.out.println("DoctorViewMedicalRecordServlet: Medical record updated successfully");
            }

            // Check for error parameter
            String errorParam = request.getParameter("error");
            if (errorParam != null) {
                if (errorParam.equals("update-failed")) {
                    request.setAttribute("errorMessage", "Failed to update medical record. Please try again.");
                } else if (errorParam.equals("not-found")) {
                    request.setAttribute("errorMessage", "Medical record not found.");
                } else if (errorParam.equals("unauthorized")) {
                    request.setAttribute("errorMessage", "You do not have permission to view this medical record.");
                }
            }

            // Set medical record as request attribute
            request.setAttribute("medicalRecord", medicalRecord);

            // Log the edit URL for debugging
            String editUrl = request.getContextPath() + "/doctor/edit-medical-record?id=" + medicalRecord.getId();
            System.out.println("DoctorViewMedicalRecordServlet: Edit URL would be: " + editUrl);

            // Forward to the JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/view-medical-record.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("DoctorViewMedicalRecordServlet: Invalid medical record ID format");
            request.setAttribute("errorMessage", "Invalid medical record ID format");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/medical-records");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.out.println("DoctorViewMedicalRecordServlet: Error retrieving medical record: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving medical record: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/medical-records");
            dispatcher.forward(request, response);
        }
    }
}
