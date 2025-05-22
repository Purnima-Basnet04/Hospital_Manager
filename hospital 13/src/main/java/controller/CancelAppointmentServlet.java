package controller;

import dao.AppointmentDAO;
import model.Appointment;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet({"/patient/cancel-appointment", "/cancel-appointment"})
public class CancelAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("CancelAppointmentServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("CancelAppointmentServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("CancelAppointmentServlet: User is not a patient, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get patient's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("CancelAppointmentServlet: userId from session: " + userId);
        
        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("CancelAppointmentServlet: userId from user object: " + userId);
            
            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }
        
        if (userId == null) {
            System.out.println("CancelAppointmentServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get appointment ID from request parameter
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            System.out.println("CancelAppointmentServlet: No appointment ID provided");
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
                System.out.println("CancelAppointmentServlet: Appointment not found");
                session.setAttribute("errorMessage", "Appointment not found");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            // Check if the appointment belongs to the logged-in patient
            if (appointment.getPatientId() != userId) {
                System.out.println("CancelAppointmentServlet: Appointment does not belong to the logged-in patient");
                session.setAttribute("errorMessage", "You do not have permission to cancel this appointment");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            // Check if the appointment is already cancelled or completed
            if ("Cancelled".equalsIgnoreCase(appointment.getStatus()) || "Completed".equalsIgnoreCase(appointment.getStatus())) {
                System.out.println("CancelAppointmentServlet: Appointment is already " + appointment.getStatus());
                session.setAttribute("errorMessage", "This appointment is already " + appointment.getStatus() + " and cannot be cancelled");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            // Cancel the appointment
            boolean success = appointmentDAO.cancelAppointment(appointmentId);
            
            if (success) {
                System.out.println("CancelAppointmentServlet: Appointment cancelled successfully");
                
                // Format the date for the success message
                SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
                String formattedDate = dateFormat.format(appointment.getAppointmentDate());
                
                // Create a detailed success message
                StringBuilder successMsg = new StringBuilder();
                successMsg.append("Your appointment with Dr. ").append(appointment.getDoctorName());
                successMsg.append(" on ").append(formattedDate);
                successMsg.append(" at ").append(appointment.getTimeSlot());
                successMsg.append(" has been successfully cancelled.");
                
                session.setAttribute("successMessage", successMsg.toString());
            } else {
                System.out.println("CancelAppointmentServlet: Failed to cancel appointment");
                session.setAttribute("errorMessage", "Failed to cancel appointment. Please try again.");
            }
            
            // Redirect back to appointments page
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
            
        } catch (NumberFormatException e) {
            System.out.println("CancelAppointmentServlet: Invalid appointment ID format");
            session.setAttribute("errorMessage", "Invalid appointment ID format");
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        } catch (Exception e) {
            System.out.println("CancelAppointmentServlet: Error cancelling appointment: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error cancelling appointment: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        }
    }
}
