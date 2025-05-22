package controller;

import dao.AppointmentDAO;
import model.Appointment;
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

@WebServlet({"/patient/appointments", "/patient-appointments"})
public class PatientAppointmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("PatientAppointmentsServlet: doGet called");

        // Check for any messages in the session and transfer them to request attributes
        if (session != null) {
            if (session.getAttribute("successMessage") != null) {
                request.setAttribute("successMessage", session.getAttribute("successMessage"));
                session.removeAttribute("successMessage");
                System.out.println("PatientAppointmentsServlet: Transferred success message to request");
            }
            if (session.getAttribute("errorMessage") != null) {
                request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
                session.removeAttribute("errorMessage");
                System.out.println("PatientAppointmentsServlet: Transferred error message to request");
            }
        }

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("PatientAppointmentsServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("PatientAppointmentsServlet: User is not a patient, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get patient's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("PatientAppointmentsServlet: userId from session: " + userId);

        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("PatientAppointmentsServlet: userId from user object: " + userId);

            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }

        if (userId == null) {
            System.out.println("PatientAppointmentsServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get patient's appointments
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        List<Appointment> appointments = appointmentDAO.getAppointmentsByPatientId(userId);

        System.out.println("PatientAppointmentsServlet: Found " + (appointments != null ? appointments.size() : 0) + " appointments for patient ID " + userId);

        // Set appointments as request attribute
        request.setAttribute("appointments", appointments);

        // Set request attributes for the JSP
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));
        request.setAttribute("userId", userId);

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/appointments.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle search and filter functionality
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
        String statusFilter = request.getParameter("status");

        System.out.println("PatientAppointmentsServlet: doPost called with search=" + searchQuery + ", status=" + statusFilter);

        // Get all appointments for this patient
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        List<Appointment> appointments = appointmentDAO.getAppointmentsByPatientId(userId);

        // TODO: Implement filtering logic based on search query and status

        // Set attributes for the JSP
        request.setAttribute("appointments", appointments);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));
        request.setAttribute("userId", userId);

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/appointments.jsp");
        dispatcher.forward(request, response);
    }
}
