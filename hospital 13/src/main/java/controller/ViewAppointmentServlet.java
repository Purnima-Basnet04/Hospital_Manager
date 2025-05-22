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

@WebServlet({"/admin/view-appointment", "/doctor/view-appointment", "/patient/view-appointment", "/view-appointment"})
public class ViewAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("ViewAppointmentServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("ViewAppointmentServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user role
        String role = (String) session.getAttribute("role");
        System.out.println("ViewAppointmentServlet: User role: " + role);

        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("ViewAppointmentServlet: userId from session: " + userId);

        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("ViewAppointmentServlet: userId from user object: " + userId);

            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }

        if (userId == null) {
            System.out.println("ViewAppointmentServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get appointment ID from request parameter
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            System.out.println("ViewAppointmentServlet: No appointment ID provided");
            session.setAttribute("errorMessage", "No appointment ID provided");
            redirectBasedOnRole(request, response, role);
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);

            // Get appointment details
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

            if (appointment == null) {
                System.out.println("ViewAppointmentServlet: Appointment not found");
                session.setAttribute("errorMessage", "Appointment not found");
                redirectBasedOnRole(request, response, role);
                return;
            }

            // Check permissions based on role
            if (role.equals("patient") && appointment.getPatientId() != userId) {
                System.out.println("ViewAppointmentServlet: Patient does not have permission to view this appointment");
                session.setAttribute("errorMessage", "You do not have permission to view this appointment");
                redirectBasedOnRole(request, response, role);
                return;
            } else if (role.equals("doctor") && appointment.getDoctorId() != userId) {
                System.out.println("ViewAppointmentServlet: Doctor does not have permission to view this appointment");
                session.setAttribute("errorMessage", "You do not have permission to view this appointment");
                redirectBasedOnRole(request, response, role);
                return;
            }
            // Admin can view all appointments, so no check needed for admin role

            // Set appointment as request attribute
            request.setAttribute("appointment", appointment);

            // Set request attributes for the JSP
            request.setAttribute("username", session.getAttribute("username"));
            request.setAttribute("name", session.getAttribute("name"));
            request.setAttribute("role", session.getAttribute("role"));
            request.setAttribute("userId", userId);

            // Transfer session messages to request attributes and clear them from session
            if (session.getAttribute("errorMessage") != null) {
                request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
                session.removeAttribute("errorMessage");
            }

            if (session.getAttribute("successMessage") != null) {
                request.setAttribute("successMessage", session.getAttribute("successMessage"));
                session.removeAttribute("successMessage");
            }

            // Forward to the appropriate JSP based on role
            String jspPath = "/" + role + "/view-appointment.jsp";
            System.out.println("ViewAppointmentServlet: Forwarding to " + jspPath);
            System.out.println("ViewAppointmentServlet: Appointment details - ID: " + appointment.getId() +
                               ", Patient: " + appointment.getPatientName() +
                               ", Doctor: " + appointment.getDoctorName() +
                               ", Date: " + appointment.getAppointmentDate() +
                               ", Status: " + appointment.getStatus());
            RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("ViewAppointmentServlet: Invalid appointment ID format");
            session.setAttribute("errorMessage", "Invalid appointment ID format");
            redirectBasedOnRole(request, response, role);
        } catch (Exception e) {
            System.out.println("ViewAppointmentServlet: Error retrieving appointment: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error retrieving appointment: " + e.getMessage());
            redirectBasedOnRole(request, response, role);
        }
    }

    private void redirectBasedOnRole(HttpServletRequest request, HttpServletResponse response, String role) throws IOException {
        String redirectPath = request.getContextPath();

        if (role.equals("admin")) {
            redirectPath += "/admin/appointments";
        } else if (role.equals("doctor")) {
            redirectPath += "/doctor/appointments";
        } else {
            redirectPath += "/patient/appointments";
        }

        response.sendRedirect(redirectPath);
    }
}
