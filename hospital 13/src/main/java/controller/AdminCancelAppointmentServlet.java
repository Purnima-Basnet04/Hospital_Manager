package controller;

import dao.AppointmentDAO;
import model.Appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet({"/admin/cancel-appointment"})
public class AdminCancelAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("AdminCancelAppointmentServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("AdminCancelAppointmentServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is an admin
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            System.out.println("AdminCancelAppointmentServlet: User is not an admin, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get appointment ID from request parameter
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            System.out.println("AdminCancelAppointmentServlet: No appointment ID provided");
            session.setAttribute("errorMessage", "No appointment ID provided");
            response.sendRedirect(request.getContextPath() + "/admin/appointments");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Get appointment details
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                System.out.println("AdminCancelAppointmentServlet: Appointment not found");
                session.setAttribute("errorMessage", "Appointment not found");
                response.sendRedirect(request.getContextPath() + "/admin/appointments");
                return;
            }
            
            // Check if the appointment is already cancelled or completed
            if ("Cancelled".equalsIgnoreCase(appointment.getStatus()) || "Completed".equalsIgnoreCase(appointment.getStatus())) {
                System.out.println("AdminCancelAppointmentServlet: Appointment is already " + appointment.getStatus());
                session.setAttribute("errorMessage", "This appointment is already " + appointment.getStatus() + " and cannot be cancelled");
                response.sendRedirect(request.getContextPath() + "/admin/appointments");
                return;
            }
            
            // Cancel the appointment
            boolean success = appointmentDAO.cancelAppointment(appointmentId);
            
            if (success) {
                System.out.println("AdminCancelAppointmentServlet: Appointment cancelled successfully");
                
                // Format the date for the success message
                SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
                String formattedDate = dateFormat.format(appointment.getAppointmentDate());
                
                // Create a detailed success message
                StringBuilder successMsg = new StringBuilder();
                successMsg.append("Appointment for patient ").append(appointment.getPatientName());
                successMsg.append(" with Dr. ").append(appointment.getDoctorName());
                successMsg.append(" on ").append(formattedDate);
                successMsg.append(" at ").append(appointment.getTimeSlot());
                successMsg.append(" has been successfully cancelled.");
                
                session.setAttribute("successMessage", successMsg.toString());
            } else {
                System.out.println("AdminCancelAppointmentServlet: Failed to cancel appointment");
                session.setAttribute("errorMessage", "Failed to cancel appointment. Please try again.");
            }
            
            // Redirect back to appointments page
            response.sendRedirect(request.getContextPath() + "/admin/appointments");
            
        } catch (NumberFormatException e) {
            System.out.println("AdminCancelAppointmentServlet: Invalid appointment ID format");
            session.setAttribute("errorMessage", "Invalid appointment ID format");
            response.sendRedirect(request.getContextPath() + "/admin/appointments");
        } catch (Exception e) {
            System.out.println("AdminCancelAppointmentServlet: Error cancelling appointment: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error cancelling appointment: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/appointments");
        }
    }
}
