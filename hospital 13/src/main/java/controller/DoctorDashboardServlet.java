package controller;

import dao.AppointmentDAO;
import model.Appointment;
import model.User;
import util.DatabaseConnection;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import dao.PrescriptionDAO;
import model.Prescription;

@WebServlet({"/doctor/dashboard", "/doctor-dashboard"})
public class DoctorDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("DoctorDashboardServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("DoctorDashboardServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a doctor
        String role = (String) session.getAttribute("role");
        if (!"doctor".equals(role)) {
            System.out.println("DoctorDashboardServlet: User is not a doctor, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get doctor's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("DoctorDashboardServlet: userId from session: " + userId);

        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("DoctorDashboardServlet: userId from user object: " + userId);

            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }

        if (userId == null) {
            System.out.println("DoctorDashboardServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get doctor's appointments
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        List<Appointment> appointments = appointmentDAO.getAppointmentsByDoctorId(userId);

        System.out.println("DoctorDashboardServlet: Found " + (appointments != null ? appointments.size() : 0) + " appointments for doctor ID " + userId);

        // If no appointments found, check if there's an issue with the database or query
        if (appointments == null || appointments.isEmpty()) {
            System.out.println("DoctorDashboardServlet: No appointments found. Checking database connection...");
            try {
                // Check if the doctor exists
                boolean doctorExists = checkDoctorExists(userId);
                System.out.println("DoctorDashboardServlet: Doctor exists in database: " + doctorExists);

                // Check if there are any appointments in the system
                int totalAppointments = getTotalAppointmentsCount();
                System.out.println("DoctorDashboardServlet: Total appointments in system: " + totalAppointments);

                // Add this information to the request for debugging
                request.setAttribute("doctorExists", doctorExists);
                request.setAttribute("totalSystemAppointments", totalAppointments);

                // No longer creating sample appointments
                if (totalAppointments == 0 || !hasAppointmentsForDoctor(userId)) {
                    System.out.println("DoctorDashboardServlet: No appointments found for doctor. Using empty list.");
                    appointments = new ArrayList<>();
                }
            } catch (Exception e) {
                System.out.println("DoctorDashboardServlet: Error checking database: " + e.getMessage());
                e.printStackTrace();
            }
        }

        request.setAttribute("appointments", appointments);

        // Count appointments by status
        int totalAppointments = 0;
        int scheduledAppointments = 0;
        int completedAppointments = 0;
        int cancelledAppointments = 0;

        if (appointments != null) {
            totalAppointments = appointments.size();

            for (Appointment appointment : appointments) {
                String status = appointment.getStatus();
                if ("Scheduled".equalsIgnoreCase(status)) {
                    scheduledAppointments++;
                } else if ("Completed".equalsIgnoreCase(status)) {
                    completedAppointments++;
                } else if ("Cancelled".equalsIgnoreCase(status)) {
                    cancelledAppointments++;
                }
            }
        }

        request.setAttribute("totalAppointments", totalAppointments);
        request.setAttribute("scheduledAppointments", scheduledAppointments);
        request.setAttribute("completedAppointments", completedAppointments);
        request.setAttribute("cancelledAppointments", cancelledAppointments);

        // Get prescriptions for this doctor
        try {
            PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
            List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByDoctorId(userId);
            request.setAttribute("prescriptions", prescriptions);
            System.out.println("DoctorDashboardServlet: Found " + (prescriptions != null ? prescriptions.size() : 0) + " prescriptions for doctor ID " + userId);
        } catch (Exception e) {
            System.out.println("DoctorDashboardServlet: Error getting prescriptions: " + e.getMessage());
            e.printStackTrace();
            // Set an empty list if there's an error
            request.setAttribute("prescriptions", new ArrayList<>());
        }

        // Set request attributes for the JSP
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/dashboard.jsp");
        dispatcher.forward(request, response);
    }

    private boolean checkDoctorExists(int doctorId) {
        String sql = "SELECT COUNT(*) FROM users WHERE id = ? AND (LOWER(role) = 'doctor' OR LOWER(role) = 'Doctor')";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, doctorId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error checking if doctor exists: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    private int getTotalAppointmentsCount() {
        String sql = "SELECT COUNT(*) FROM appointments";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.out.println("Error getting total appointments count: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    private boolean hasAppointmentsForDoctor(int doctorId) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, doctorId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error checking if doctor has appointments: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Method removed to prevent hardcoded data

    private List<Integer> getPatientIds() {
        List<Integer> patientIds = new ArrayList<>();
        String sql = "SELECT id FROM users WHERE LOWER(role) = 'patient' LIMIT 5";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                patientIds.add(rs.getInt("id"));
            }

        } catch (SQLException e) {
            System.out.println("Error getting patient IDs: " + e.getMessage());
            e.printStackTrace();
        }

        return patientIds;
    }
}
