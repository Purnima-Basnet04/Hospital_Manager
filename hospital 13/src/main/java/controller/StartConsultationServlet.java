package controller;

import dao.AppointmentDAO;
import dao.UserDAO;
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

@WebServlet({"/doctor/start-consultation", "/start-consultation"})
public class StartConsultationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("StartConsultationServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("StartConsultationServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a doctor
        String role = (String) session.getAttribute("role");
        if (!"doctor".equals(role)) {
            System.out.println("StartConsultationServlet: User is not a doctor, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get doctor's ID from session
        Integer doctorId = (Integer) session.getAttribute("userId");
        if (doctorId == null) {
            System.out.println("StartConsultationServlet: Doctor ID not found in session");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get appointment ID from request parameter
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            System.out.println("StartConsultationServlet: No appointment ID provided");
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);

            // Get appointment details
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

            if (appointment == null) {
                System.out.println("StartConsultationServlet: Appointment not found");
                session.setAttribute("errorMessage", "Appointment not found");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }

            // Check if the appointment belongs to the logged-in doctor
            if (appointment.getDoctorId() != doctorId) {
                System.out.println("StartConsultationServlet: Appointment does not belong to the logged-in doctor");
                session.setAttribute("errorMessage", "You do not have permission to access this appointment");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }

            // Check if the appointment is scheduled or in progress (not completed or cancelled)
            String appointmentStatus = appointment.getStatus().toLowerCase();
            if (!"scheduled".equalsIgnoreCase(appointmentStatus) && !"in progress".equalsIgnoreCase(appointmentStatus)) {
                System.out.println("StartConsultationServlet: Appointment is not scheduled or in progress");
                session.setAttribute("errorMessage", "This appointment is " + appointment.getStatus() + " and cannot be modified");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }

            // Get patient details
            UserDAO userDAO = new UserDAO();
            User patient = userDAO.getUserById(appointment.getPatientId());

            if (patient == null) {
                System.out.println("StartConsultationServlet: Patient not found");
                session.setAttribute("errorMessage", "Patient not found");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }

            // Set attributes for the JSP
            request.setAttribute("appointment", appointment);
            request.setAttribute("patient", patient);
            request.setAttribute("username", session.getAttribute("username"));
            request.setAttribute("name", session.getAttribute("name"));
            request.setAttribute("role", session.getAttribute("role"));

            // Forward to the JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/start-consultation.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("StartConsultationServlet: Invalid appointment ID format");
            session.setAttribute("errorMessage", "Invalid appointment ID format");
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
        } catch (Exception e) {
            System.out.println("StartConsultationServlet: Error retrieving appointment: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error retrieving appointment: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("StartConsultationServlet: doPost called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("StartConsultationServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a doctor
        String role = (String) session.getAttribute("role");
        if (!"doctor".equals(role)) {
            System.out.println("StartConsultationServlet: User is not a doctor, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get doctor's ID from session
        Integer doctorId = (Integer) session.getAttribute("userId");
        if (doctorId == null) {
            System.out.println("StartConsultationServlet: Doctor ID not found in session");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form data
        String appointmentIdStr = request.getParameter("appointmentId");
        String patientIdStr = request.getParameter("patientId");
        String notes = request.getParameter("notes");
        String diagnosis = request.getParameter("diagnosis");
        String treatment = request.getParameter("treatment");
        String prescription = request.getParameter("prescription");
        String status = request.getParameter("status");

        System.out.println("StartConsultationServlet: Form data - appointmentId=" + appointmentIdStr +
                           ", patientId=" + patientIdStr + ", status=" + status);

        // Debug all request parameters
        System.out.println("StartConsultationServlet: All request parameters:");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String[] paramValues = request.getParameterValues(paramName);
            for (String paramValue : paramValues) {
                System.out.println(paramName + " = " + paramValue);
            }
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            int patientId = Integer.parseInt(patientIdStr);

            // Validate status value
            if (status == null || status.trim().isEmpty()) {
                System.out.println("StartConsultationServlet: Status is empty");
                session.setAttribute("errorMessage", "Status cannot be empty");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }

            // Check if status is one of the allowed values
            String[] allowedStatuses = {"Scheduled", "In Progress", "Completed", "Cancelled"};
            boolean validStatus = false;
            for (String allowedStatus : allowedStatuses) {
                if (allowedStatus.equals(status)) {
                    validStatus = true;
                    break;
                }
            }

            if (!validStatus) {
                System.out.println("StartConsultationServlet: Invalid status value: " + status);
                session.setAttribute("errorMessage", "Invalid status value: " + status);
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }

            // Get appointment details
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

            if (appointment == null) {
                System.out.println("StartConsultationServlet: Appointment not found");
                session.setAttribute("errorMessage", "Appointment not found");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }

            // Check if the appointment belongs to the logged-in doctor
            if (appointment.getDoctorId() != doctorId) {
                System.out.println("StartConsultationServlet: Appointment does not belong to the logged-in doctor");
                session.setAttribute("errorMessage", "You do not have permission to access this appointment");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }

            // Update appointment status
            System.out.println("StartConsultationServlet: Attempting to update appointment status to " + status + " for appointment ID " + appointmentId);
            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, status);

            if (success) {
                System.out.println("StartConsultationServlet: Appointment status updated to " + status);

                // For now, we'll just log the consultation details
                // In a real implementation, you would create medical records and prescriptions
                System.out.println("StartConsultationServlet: Consultation details:");
                System.out.println("Diagnosis: " + diagnosis);
                System.out.println("Treatment: " + treatment);
                System.out.println("Prescription: " + prescription);
                System.out.println("Notes: " + notes);

                session.setAttribute("successMessage", "Consultation completed successfully. Appointment status updated to " + status);
            } else {
                System.out.println("StartConsultationServlet: Failed to update appointment status");
                session.setAttribute("errorMessage", "Failed to update appointment status");
            }

            // Redirect to appointments page
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");

        } catch (NumberFormatException e) {
            System.out.println("StartConsultationServlet: Invalid ID format");
            session.setAttribute("errorMessage", "Invalid ID format");
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
        } catch (Exception e) {
            System.out.println("StartConsultationServlet: Error processing consultation: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error processing consultation: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
        }
    }
}
