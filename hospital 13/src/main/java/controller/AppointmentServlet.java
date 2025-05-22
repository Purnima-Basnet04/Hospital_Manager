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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/appointments")
public class AppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // If user is a doctor, redirect to home page
        if ("doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (action == null || action.equals("list")) {
            // List appointments based on user role
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            List<Appointment> appointments;

            if (user.getRole().equals("patient")) {
                appointments = appointmentDAO.getAppointmentsByPatientId(user.getId());
            } else if (user.getRole().equals("doctor")) {
                // Doctor functionality removed - redirect to home page
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            } else {
                // Admin can see all appointments (not implemented here)
                appointments = null;
            }

            request.setAttribute("appointments", appointments);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/appointments.jsp");
            dispatcher.forward(request, response);
        } else if (action.equals("new")) {
            // Show appointment booking form
            DepartmentDAO departmentDAO = new DepartmentDAO();
            List<Department> departments = departmentDAO.getAllDepartments();

            request.setAttribute("departments", departments);

            // If department is selected, load doctors for that department
            String departmentId = request.getParameter("dept");
            if (departmentId != null && !departmentId.trim().isEmpty()) {
                try {
                    int deptId = Integer.parseInt(departmentId);
                    UserDAO userDAO = new UserDAO();
                    List<User> doctors = userDAO.getDoctorsByDepartment(deptId);
                    request.setAttribute("doctors", doctors);
                    request.setAttribute("selectedDepartment", deptId);
                } catch (NumberFormatException e) {
                    // Invalid department ID
                }
            }

            // Set today's date for the form
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String today = sdf.format(new Date());
            request.setAttribute("today", today);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/book-appointment.jsp");
            dispatcher.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // If user is a doctor, redirect to home page
        if ("doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (action != null && action.equals("book")) {
            // Book a new appointment
            String doctorIdParam = request.getParameter("doctorId");
            String departmentIdParam = request.getParameter("departmentId");
            String appointmentDateParam = request.getParameter("appointmentDate");
            String timeSlot = request.getParameter("timeSlot");
            String notes = request.getParameter("notes");

            // Validate form data
            if (doctorIdParam == null || doctorIdParam.trim().isEmpty() ||
                departmentIdParam == null || departmentIdParam.trim().isEmpty() ||
                appointmentDateParam == null || appointmentDateParam.trim().isEmpty() ||
                timeSlot == null || timeSlot.trim().isEmpty()) {

                request.setAttribute("errorMessage", "All fields are required");
                doGet(request, response);
                return;
            }

            try {
                int doctorId = Integer.parseInt(doctorIdParam);
                int departmentId = Integer.parseInt(departmentIdParam);

                // Parse appointment date
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date appointmentDate = sdf.parse(appointmentDateParam);

                // Create appointment
                Appointment appointment = new Appointment();
                appointment.setPatientId(user.getId());
                appointment.setDoctorId(doctorId);
                appointment.setDepartmentId(departmentId);
                appointment.setAppointmentDate(appointmentDate);
                appointment.setTimeSlot(timeSlot);
                appointment.setStatus("Scheduled");
                appointment.setNotes(notes);

                // Save appointment
                AppointmentDAO appointmentDAO = new AppointmentDAO();
                boolean success = appointmentDAO.createAppointment(appointment);

                if (success) {
                    // Set success message in session instead of request for redirect
                    request.getSession().setAttribute("successMessage", "Appointment booked successfully");
                    response.sendRedirect(request.getContextPath() + "/patient/appointments");
                } else {
                    request.setAttribute("errorMessage", "Failed to book appointment");
                    request.setAttribute("selectedDepartment", departmentId);
                    doGet(request, response);
                }

            } catch (NumberFormatException | ParseException e) {
                request.setAttribute("errorMessage", "Invalid input data");
                doGet(request, response);
            }
        } else if (action != null && action.equals("update")) {
            // Update appointment status (for doctors/admin)
            String appointmentIdParam = request.getParameter("appointmentId");
            String status = request.getParameter("status");

            if (appointmentIdParam != null && !appointmentIdParam.trim().isEmpty() &&
                status != null && !status.trim().isEmpty()) {

                try {
                    int appointmentId = Integer.parseInt(appointmentIdParam);

                    AppointmentDAO appointmentDAO = new AppointmentDAO();
                    boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, status);

                    if (success) {
                        request.setAttribute("successMessage", "Appointment status updated successfully");
                    } else {
                        request.setAttribute("errorMessage", "Failed to update appointment status");
                    }

                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid appointment ID");
                }
            }

            response.sendRedirect(request.getContextPath() + "/appointments");
        }
    }
}