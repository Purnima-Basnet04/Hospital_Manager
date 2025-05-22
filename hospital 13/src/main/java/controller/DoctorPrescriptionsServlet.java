package controller;

import dao.PrescriptionDAO;
import dao.UserDAO;
import model.Prescription;
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
import java.util.Map;
import java.util.HashMap;

@WebServlet({"/doctor/prescriptions", "/doctor-prescriptions"})
public class DoctorPrescriptionsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("DoctorPrescriptionsServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("DoctorPrescriptionsServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a doctor
        String role = (String) session.getAttribute("role");
        if (!"doctor".equals(role)) {
            System.out.println("DoctorPrescriptionsServlet: User is not a doctor, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get doctor's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            System.out.println("DoctorPrescriptionsServlet: User ID not found in session");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get prescriptions from database
        List<Prescription> allPrescriptions = new ArrayList<>();
        List<Prescription> activePrescriptions = new ArrayList<>();
        List<Prescription> completedPrescriptions = new ArrayList<>();
        Map<Integer, String> patientNames = new HashMap<>();

        try {
            // Get prescriptions for this doctor
            PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
            allPrescriptions = prescriptionDAO.getPrescriptionsByDoctorId(userId.intValue());
            System.out.println("DoctorPrescriptionsServlet: Found " + allPrescriptions.size() + " prescriptions for doctor ID " + userId);

            // Get all patients instead of just those with appointments
            UserDAO userDAO = new UserDAO();
            List<User> patients = userDAO.getAllPatients();
            System.out.println("DoctorPrescriptionsServlet: Found " + patients.size() + " total patients in the database");

            for (User patient : patients) {
                patientNames.put(patient.getId(), patient.getName());
            }

            // Filter prescriptions by status
            for (Prescription prescription : allPrescriptions) {
                // Set patient name
                int patientId = prescription.getPatientId();
                if (patientNames.containsKey(patientId)) {
                    prescription.setPatientName(patientNames.get(patientId));
                }

                // Filter by status
                String status = prescription.getStatus();
                if (status.equals("Active")) {
                    activePrescriptions.add(prescription);
                } else if (status.equals("Completed")) {
                    completedPrescriptions.add(prescription);
                }
            }

        } catch (Exception e) {
            System.out.println("DoctorPrescriptionsServlet: Error getting prescriptions: " + e.getMessage());
            e.printStackTrace();
        }

        // Set request attributes for the JSP
        request.setAttribute("allPrescriptions", allPrescriptions);
        request.setAttribute("pendingPrescriptions", activePrescriptions); // Keep the same attribute name for JSP compatibility
        request.setAttribute("approvedPrescriptions", completedPrescriptions); // Keep the same attribute name for JSP compatibility
        request.setAttribute("patientNames", patientNames);
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/prescriptions.jsp");
        dispatcher.forward(request, response);
    }
}
