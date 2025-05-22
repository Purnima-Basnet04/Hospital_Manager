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
import java.util.List;
import java.util.ArrayList;

@WebServlet({"/patient/medical-records", "/patient-medical-records"})
public class PatientMedicalRecordsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("PatientMedicalRecordsServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("PatientMedicalRecordsServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("PatientMedicalRecordsServlet: User is not a patient, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get patient's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("PatientMedicalRecordsServlet: userId from session: " + userId);

        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("PatientMedicalRecordsServlet: userId from user object: " + userId);

            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }

        if (userId == null) {
            System.out.println("PatientMedicalRecordsServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get patient's medical records
        MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
        List<MedicalRecord> medicalRecords = medicalRecordDAO.getMedicalRecordsByPatientId(userId);

        // If medicalRecords is null, initialize it as an empty list
        if (medicalRecords == null) {
            medicalRecords = new ArrayList<>();
        }

        System.out.println("PatientMedicalRecordsServlet: Found " + medicalRecords.size() + " medical records for patient ID " + userId);

        // Set medical records as request attribute
        request.setAttribute("medicalRecords", medicalRecords);

        // Set request attributes for the JSP
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));
        request.setAttribute("userId", userId);

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/medical-records.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle search functionality
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is a patient
        if (session == null || session.getAttribute("username") == null || !"patient".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            session.setAttribute("userId", userId);
        }

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String searchQuery = request.getParameter("search");

        System.out.println("PatientMedicalRecordsServlet: doPost called with search=" + searchQuery);

        // Get all medical records for this patient
        MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
        List<MedicalRecord> medicalRecords = medicalRecordDAO.getMedicalRecordsByPatientId(userId);

        // If medicalRecords is null, initialize it as an empty list
        if (medicalRecords == null) {
            medicalRecords = new ArrayList<>();
        }

        // TODO: Implement filtering logic based on search query

        // Set attributes for the JSP
        request.setAttribute("medicalRecords", medicalRecords);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));
        request.setAttribute("userId", userId);

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/medical-records.jsp");
        dispatcher.forward(request, response);
    }
}
