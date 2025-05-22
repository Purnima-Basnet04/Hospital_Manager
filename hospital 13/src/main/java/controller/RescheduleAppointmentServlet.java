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
import java.sql.Date;
import java.text.SimpleDateFormat;

@WebServlet({"/patient/reschedule-appointment", "/reschedule-appointment"})
public class RescheduleAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("RescheduleAppointmentServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("RescheduleAppointmentServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("RescheduleAppointmentServlet: User is not a patient, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get patient's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("RescheduleAppointmentServlet: userId from session: " + userId);
        
        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("RescheduleAppointmentServlet: userId from user object: " + userId);
            
            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }
        
        if (userId == null) {
            System.out.println("RescheduleAppointmentServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get appointment ID from request parameter
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            System.out.println("RescheduleAppointmentServlet: No appointment ID provided");
            session.setAttribute("errorMessage", "No appointment ID provided");
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Get appointment details
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                System.out.println("RescheduleAppointmentServlet: Appointment not found");
                session.setAttribute("errorMessage", "Appointment not found");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            // Check if the appointment belongs to the logged-in patient
            if (appointment.getPatientId() != userId) {
                System.out.println("RescheduleAppointmentServlet: Appointment does not belong to the logged-in patient");
                session.setAttribute("errorMessage", "You do not have permission to reschedule this appointment");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            // Check if the appointment is already cancelled or completed
            if ("Cancelled".equalsIgnoreCase(appointment.getStatus()) || "Completed".equalsIgnoreCase(appointment.getStatus())) {
                System.out.println("RescheduleAppointmentServlet: Appointment is already " + appointment.getStatus());
                session.setAttribute("errorMessage", "This appointment is already " + appointment.getStatus() + " and cannot be rescheduled");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            // Set appointment as request attribute
            request.setAttribute("appointment", appointment);
            
            // Set request attributes for the JSP
            request.setAttribute("username", session.getAttribute("username"));
            request.setAttribute("name", session.getAttribute("name"));
            request.setAttribute("role", session.getAttribute("role"));
            request.setAttribute("userId", userId);
            
            // Forward to the JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/reschedule-appointment.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            System.out.println("RescheduleAppointmentServlet: Invalid appointment ID format");
            session.setAttribute("errorMessage", "Invalid appointment ID format");
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        } catch (Exception e) {
            System.out.println("RescheduleAppointmentServlet: Error retrieving appointment: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error retrieving appointment: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("RescheduleAppointmentServlet: doPost called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("RescheduleAppointmentServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("RescheduleAppointmentServlet: User is not a patient, redirecting to index");
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
            System.out.println("RescheduleAppointmentServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form data
        String appointmentIdStr = request.getParameter("appointmentId");
        String appointmentDateStr = request.getParameter("appointmentDate");
        String timeSlot = request.getParameter("timeSlot");

        System.out.println("RescheduleAppointmentServlet: Form data - appointmentId=" + appointmentIdStr + 
                           ", date=" + appointmentDateStr + ", timeSlot=" + timeSlot);

        try {
            // Parse form data
            int appointmentId = Integer.parseInt(appointmentIdStr);
            Date appointmentDate = Date.valueOf(appointmentDateStr);
            
            // Get appointment details
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                System.out.println("RescheduleAppointmentServlet: Appointment not found");
                session.setAttribute("errorMessage", "Appointment not found");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            // Check if the appointment belongs to the logged-in patient
            if (appointment.getPatientId() != userId) {
                System.out.println("RescheduleAppointmentServlet: Appointment does not belong to the logged-in patient");
                session.setAttribute("errorMessage", "You do not have permission to reschedule this appointment");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            // Check if the appointment is already cancelled or completed
            if ("Cancelled".equalsIgnoreCase(appointment.getStatus()) || "Completed".equalsIgnoreCase(appointment.getStatus())) {
                System.out.println("RescheduleAppointmentServlet: Appointment is already " + appointment.getStatus());
                session.setAttribute("errorMessage", "This appointment is already " + appointment.getStatus() + " and cannot be rescheduled");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            // Reschedule the appointment
            boolean success = appointmentDAO.rescheduleAppointment(appointmentId, appointmentDate, timeSlot);
            
            if (success) {
                System.out.println("RescheduleAppointmentServlet: Appointment rescheduled successfully");
                
                // Format the date for the success message
                SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
                String formattedDate = dateFormat.format(appointmentDate);
                
                // Create a detailed success message
                StringBuilder successMsg = new StringBuilder();
                successMsg.append("Your appointment with Dr. ").append(appointment.getDoctorName());
                successMsg.append(" has been successfully rescheduled to ");
                successMsg.append(formattedDate).append(" at ").append(timeSlot).append(".");
                
                session.setAttribute("successMessage", successMsg.toString());
            } else {
                System.out.println("RescheduleAppointmentServlet: Failed to reschedule appointment");
                session.setAttribute("errorMessage", "Failed to reschedule appointment. Please try again.");
            }
            
            // Redirect back to appointments page
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
            
        } catch (NumberFormatException e) {
            System.out.println("RescheduleAppointmentServlet: Invalid appointment ID format");
            session.setAttribute("errorMessage", "Invalid appointment ID format");
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        } catch (IllegalArgumentException e) {
            System.out.println("RescheduleAppointmentServlet: Invalid date format: " + e.getMessage());
            session.setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD format.");
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        } catch (Exception e) {
            System.out.println("RescheduleAppointmentServlet: Error rescheduling appointment: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error rescheduling appointment: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        }
    }
}
