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

@WebServlet({"/doctor/complete-appointment"})
public class CompleteAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("CompleteAppointmentServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("CompleteAppointmentServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a doctor
        String role = (String) session.getAttribute("role");
        if (!"doctor".equals(role)) {
            System.out.println("CompleteAppointmentServlet: User is not a doctor, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get doctor's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("CompleteAppointmentServlet: userId from session: " + userId);
        
        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("CompleteAppointmentServlet: userId from user object: " + userId);
            
            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }
        
        if (userId == null) {
            System.out.println("CompleteAppointmentServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get appointment ID from request parameter
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            System.out.println("CompleteAppointmentServlet: No appointment ID provided");
            session.setAttribute("errorMessage", "No appointment ID provided");
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Get appointment details
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                System.out.println("CompleteAppointmentServlet: Appointment not found");
                session.setAttribute("errorMessage", "Appointment not found");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }
            
            // Check if the appointment belongs to the logged-in doctor
            if (appointment.getDoctorId() != userId) {
                System.out.println("CompleteAppointmentServlet: Appointment does not belong to the logged-in doctor");
                session.setAttribute("errorMessage", "You do not have permission to complete this appointment");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }
            
            // Check if the appointment is already cancelled or completed
            if ("Cancelled".equalsIgnoreCase(appointment.getStatus())) {
                System.out.println("CompleteAppointmentServlet: Appointment is already cancelled");
                session.setAttribute("errorMessage", "This appointment is already cancelled and cannot be completed");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }
            
            if ("Completed".equalsIgnoreCase(appointment.getStatus())) {
                System.out.println("CompleteAppointmentServlet: Appointment is already completed");
                session.setAttribute("errorMessage", "This appointment is already completed");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }
            
            // Complete the appointment
            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, "Completed");
            
            if (success) {
                System.out.println("CompleteAppointmentServlet: Appointment completed successfully");
                
                // Format the date for the success message
                SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
                String formattedDate = dateFormat.format(appointment.getAppointmentDate());
                
                // Create a detailed success message
                StringBuilder successMsg = new StringBuilder();
                successMsg.append("Appointment with patient ").append(appointment.getPatientName());
                successMsg.append(" on ").append(formattedDate);
                successMsg.append(" at ").append(appointment.getTimeSlot());
                successMsg.append(" has been marked as completed.");
                
                session.setAttribute("successMessage", successMsg.toString());
            } else {
                System.out.println("CompleteAppointmentServlet: Failed to complete appointment");
                session.setAttribute("errorMessage", "Failed to complete appointment. Please try again.");
            }
            
            // Redirect back to appointments page
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
            
        } catch (NumberFormatException e) {
            System.out.println("CompleteAppointmentServlet: Invalid appointment ID format");
            session.setAttribute("errorMessage", "Invalid appointment ID format");
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
        } catch (Exception e) {
            System.out.println("CompleteAppointmentServlet: Error completing appointment: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error completing appointment: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
        }
    }
}
