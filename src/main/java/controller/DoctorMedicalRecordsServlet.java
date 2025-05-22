package controller;

import dao.UserDAO;
import dao.MedicalRecordDAO;
import model.User;
import model.MedicalRecord;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet({"/doctor/medical-records", "/doctor-medical-records"})
public class DoctorMedicalRecordsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("DoctorMedicalRecordsServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("DoctorMedicalRecordsServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a doctor
        String role = (String) session.getAttribute("role");
        if (!"doctor".equals(role)) {
            System.out.println("DoctorMedicalRecordsServlet: User is not a doctor, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get doctor's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            System.out.println("DoctorMedicalRecordsServlet: User ID not found in session");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get all patients from database
        UserDAO userDAO = new UserDAO();
        List<User> patients = userDAO.getAllPatients();

        // Get selected patient ID from request parameter
        String patientIdStr = request.getParameter("patient");

        // Get medical records for the selected patient
        List<MedicalRecord> medicalRecords = new ArrayList<>();
        User selectedPatient = null;

        if (patientIdStr != null && !patientIdStr.isEmpty()) {
            try {
                int patientId = Integer.parseInt(patientIdStr);

                // Get patient details
                selectedPatient = userDAO.getUserById(patientId);

                // Get medical records
                MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
                medicalRecords = medicalRecordDAO.getMedicalRecordsByPatientId(patientId);

                System.out.println("DoctorMedicalRecordsServlet: Found " + medicalRecords.size() +
                                   " medical records for patient ID " + patientId);
            } catch (NumberFormatException e) {
                System.out.println("DoctorMedicalRecordsServlet: Invalid patient ID: " + patientIdStr);
            }
        }

        // Set request attributes for the JSP
        request.setAttribute("patients", patients);
        request.setAttribute("patientId", patientIdStr);
        request.setAttribute("selectedPatient", selectedPatient);
        request.setAttribute("medicalRecords", medicalRecords);
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/medical-records.jsp");
        dispatcher.forward(request, response);
    }
}
