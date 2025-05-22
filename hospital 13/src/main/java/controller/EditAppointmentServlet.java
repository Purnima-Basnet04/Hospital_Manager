package controller;

import dao.AppointmentDAO;
import dao.DepartmentDAO;
import dao.UserDAO;
import model.Appointment;
import model.Department;
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
import java.util.List;

@WebServlet({"/admin/edit-appointment", "/doctor/edit-appointment", "/patient/edit-appointment", "/edit-appointment"})
public class EditAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("EditAppointmentServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("EditAppointmentServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user role
        String role = (String) session.getAttribute("role");
        System.out.println("EditAppointmentServlet: User role: " + role);

        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("EditAppointmentServlet: userId from session: " + userId);

        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("EditAppointmentServlet: userId from user object: " + userId);

            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }

        if (userId == null) {
            System.out.println("EditAppointmentServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get appointment ID from request parameter
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            System.out.println("EditAppointmentServlet: No appointment ID provided");
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
                System.out.println("EditAppointmentServlet: Appointment not found");
                session.setAttribute("errorMessage", "Appointment not found");
                redirectBasedOnRole(request, response, role);
                return;
            }

            // Check permissions based on role
            if (role.equals("patient") && appointment.getPatientId() != userId) {
                System.out.println("EditAppointmentServlet: Patient does not have permission to edit this appointment");
                session.setAttribute("errorMessage", "You do not have permission to edit this appointment");
                redirectBasedOnRole(request, response, role);
                return;
            } else if (role.equals("doctor") && appointment.getDoctorId() != userId) {
                System.out.println("EditAppointmentServlet: Doctor does not have permission to edit this appointment");
                session.setAttribute("errorMessage", "You do not have permission to edit this appointment");
                redirectBasedOnRole(request, response, role);
                return;
            }

            // Check if the appointment is already cancelled or completed
            if ("Cancelled".equalsIgnoreCase(appointment.getStatus()) || "Completed".equalsIgnoreCase(appointment.getStatus())) {
                System.out.println("EditAppointmentServlet: Appointment is already " + appointment.getStatus());
                session.setAttribute("errorMessage", "This appointment is already " + appointment.getStatus() + " and cannot be edited");
                response.sendRedirect(request.getContextPath() + "/" + role + "/view-appointment?id=" + appointmentId);
                return;
            }

            // Get departments for dropdown
            DepartmentDAO departmentDAO = new DepartmentDAO();
            List<Department> departments = departmentDAO.getAllDepartments();
            request.setAttribute("departments", departments);

            // Get doctors for dropdown
            UserDAO userDAO = new UserDAO();
            List<User> doctors = userDAO.getUsersByRole("doctor");
            request.setAttribute("doctors", doctors);

            // Set appointment as request attribute
            request.setAttribute("appointment", appointment);

            // Set request attributes for the JSP
            request.setAttribute("username", session.getAttribute("username"));
            request.setAttribute("name", session.getAttribute("name"));
            request.setAttribute("role", session.getAttribute("role"));
            request.setAttribute("userId", userId);

            // Set today's date for the form
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String today = sdf.format(new java.util.Date());
            request.setAttribute("today", today);

            // Forward to the JSP
            String jspPath = "/" + role + "/edit-appointment.jsp";
            RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("EditAppointmentServlet: Invalid appointment ID format");
            session.setAttribute("errorMessage", "Invalid appointment ID format");
            redirectBasedOnRole(request, response, role);
        } catch (Exception e) {
            System.out.println("EditAppointmentServlet: Error retrieving appointment: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error retrieving appointment: " + e.getMessage());
            redirectBasedOnRole(request, response, role);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("EditAppointmentServlet: doPost called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("EditAppointmentServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user role
        String role = (String) session.getAttribute("role");
        System.out.println("EditAppointmentServlet: User role: " + role);

        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("EditAppointmentServlet: userId from session: " + userId);

        // Get form parameters
        String appointmentIdStr = request.getParameter("id");
        String doctorIdStr = request.getParameter("doctorId");
        String departmentIdStr = request.getParameter("departmentId");
        String appointmentDateStr = request.getParameter("appointmentDate");
        String timeSlot = request.getParameter("timeSlot");
        String notes = request.getParameter("notes");

        System.out.println("EditAppointmentServlet: Received parameters - id=" + appointmentIdStr +
                ", doctorId=" + doctorIdStr + ", departmentId=" + departmentIdStr +
                ", date=" + appointmentDateStr + ", timeSlot=" + timeSlot);

        try {
            // Parse form data
            int appointmentId = Integer.parseInt(appointmentIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            int departmentId = Integer.parseInt(departmentIdStr);
            Date appointmentDate = Date.valueOf(appointmentDateStr);

            // Get appointment details
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

            if (appointment == null) {
                System.out.println("EditAppointmentServlet: Appointment not found");
                session.setAttribute("errorMessage", "Appointment not found");
                redirectBasedOnRole(request, response, role);
                return;
            }

            // Check permissions based on role
            if (role.equals("patient") && appointment.getPatientId() != userId) {
                System.out.println("EditAppointmentServlet: Patient does not have permission to edit this appointment");
                session.setAttribute("errorMessage", "You do not have permission to edit this appointment");
                redirectBasedOnRole(request, response, role);
                return;
            } else if (role.equals("doctor") && appointment.getDoctorId() != userId) {
                System.out.println("EditAppointmentServlet: Doctor does not have permission to edit this appointment");
                session.setAttribute("errorMessage", "You do not have permission to edit this appointment");
                redirectBasedOnRole(request, response, role);
                return;
            }

            // Check if the appointment is already cancelled or completed
            if ("Cancelled".equalsIgnoreCase(appointment.getStatus()) || "Completed".equalsIgnoreCase(appointment.getStatus())) {
                System.out.println("EditAppointmentServlet: Appointment is already " + appointment.getStatus());
                session.setAttribute("errorMessage", "This appointment is already " + appointment.getStatus() + " and cannot be edited");
                response.sendRedirect(request.getContextPath() + "/" + role + "/view-appointment?id=" + appointmentId);
                return;
            }

            // Update appointment object with new values
            appointment.setDoctorId(doctorId);
            appointment.setDepartmentId(departmentId);
            appointment.setAppointmentDate(appointmentDate);
            appointment.setTimeSlot(timeSlot);
            appointment.setNotes(notes);

            // Update the appointment in the database
            boolean success = appointmentDAO.updateAppointment(appointment);

            if (success) {
                System.out.println("EditAppointmentServlet: Appointment updated successfully");

                // Format the date for the success message
                SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
                String formattedDate = dateFormat.format(appointmentDate);

                // Create a detailed success message
                StringBuilder successMsg = new StringBuilder();
                successMsg.append("Appointment has been successfully updated to ");
                successMsg.append(formattedDate);
                successMsg.append(" at ").append(timeSlot);

                session.setAttribute("successMessage", successMsg.toString());
            } else {
                System.out.println("EditAppointmentServlet: Failed to update appointment");
                session.setAttribute("errorMessage", "Failed to update appointment. Please try again.");
            }

            // Redirect to view appointment page
            response.sendRedirect(request.getContextPath() + "/" + role + "/view-appointment?id=" + appointmentId);

        } catch (NumberFormatException e) {
            System.out.println("EditAppointmentServlet: Invalid number format: " + e.getMessage());
            session.setAttribute("errorMessage", "Invalid number format. Please check your input.");

            // If we have an appointment ID, redirect to view page
            if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
                try {
                    int appointmentId = Integer.parseInt(appointmentIdStr);
                    response.sendRedirect(request.getContextPath() + "/" + role + "/view-appointment?id=" + appointmentId);
                    return;
                } catch (NumberFormatException ex) {
                    // If parsing fails, use the default redirect
                    redirectBasedOnRole(request, response, role);
                }
            } else {
                redirectBasedOnRole(request, response, role);
            }
        } catch (IllegalArgumentException e) {
            System.out.println("EditAppointmentServlet: Invalid date format: " + e.getMessage());
            session.setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD format.");

            // If we have an appointment ID, redirect to view page
            if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
                try {
                    int appointmentId = Integer.parseInt(appointmentIdStr);
                    response.sendRedirect(request.getContextPath() + "/" + role + "/view-appointment?id=" + appointmentId);
                    return;
                } catch (NumberFormatException ex) {
                    // If parsing fails, use the default redirect
                    redirectBasedOnRole(request, response, role);
                }
            } else {
                redirectBasedOnRole(request, response, role);
            }
        } catch (Exception e) {
            System.out.println("EditAppointmentServlet: Error updating appointment: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error updating appointment: " + e.getMessage());

            // If we have an appointment ID, redirect to view page
            if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
                try {
                    int appointmentId = Integer.parseInt(appointmentIdStr);
                    response.sendRedirect(request.getContextPath() + "/" + role + "/view-appointment?id=" + appointmentId);
                    return;
                } catch (NumberFormatException ex) {
                    // If parsing fails, use the default redirect
                    redirectBasedOnRole(request, response, role);
                }
            } else {
                redirectBasedOnRole(request, response, role);
            }
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
