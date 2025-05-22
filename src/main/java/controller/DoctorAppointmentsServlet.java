package controller;

import dao.AppointmentDAO;
import model.Appointment;
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
import java.util.List;

@WebServlet({"/doctor/appointments", "/doctor-appointments"})
public class DoctorAppointmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("DoctorAppointmentsServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("DoctorAppointmentsServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a doctor
        String role = (String) session.getAttribute("role");
        if (!"doctor".equals(role)) {
            System.out.println("DoctorAppointmentsServlet: User is not a doctor, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get doctor's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            System.out.println("DoctorAppointmentsServlet: User ID not found in session");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get doctor's appointments
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        List<Appointment> appointments = appointmentDAO.getAppointmentsByDoctorId(userId);

        System.out.println("DoctorAppointmentsServlet: Found " + (appointments != null ? appointments.size() : 0) + " appointments for doctor ID " + userId);

        // If no appointments found, check if there's an issue with the database or query
        if (appointments == null || appointments.isEmpty()) {
            System.out.println("DoctorAppointmentsServlet: No appointments found. Checking database connection...");
            try {
                // Check if the doctor exists
                boolean doctorExists = checkDoctorExists(userId);
                System.out.println("DoctorAppointmentsServlet: Doctor exists in database: " + doctorExists);

                // Check if there are any appointments in the system
                int totalAppointments = getTotalAppointmentsCount();
                System.out.println("DoctorAppointmentsServlet: Total appointments in system: " + totalAppointments);

                // Add this information to the request for debugging
                request.setAttribute("doctorExists", doctorExists);
                request.setAttribute("totalAppointments", totalAppointments);
            } catch (Exception e) {
                System.out.println("DoctorAppointmentsServlet: Error checking database: " + e.getMessage());
                e.printStackTrace();
            }
        }

        // Set appointments as request attribute
        request.setAttribute("appointments", appointments);

        // Set request attributes for the JSP
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/appointments.jsp");
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
}
