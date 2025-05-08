package controller;

import dao.DepartmentDAO;
import dao.UserDAO;
import dao.AppointmentDAO;
import model.Department;
import model.User;
import model.Appointment;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@WebServlet({"/patient/book-appointment", "/book-appointment"})
public class BookAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check for any messages in the session and transfer them to request attributes
        HttpSession session = request.getSession(false);

        System.out.println("BookAppointmentServlet: doGet called");

        // Transfer session messages to request attributes
        if (session != null) {
            if (session.getAttribute("successMessage") != null) {
                request.setAttribute("successMessage", session.getAttribute("successMessage"));
                session.removeAttribute("successMessage");
            }
            if (session.getAttribute("errorMessage") != null) {
                request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
                session.removeAttribute("errorMessage");
            }
        }

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("BookAppointmentServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("BookAppointmentServlet: User is not a patient, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get patient's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("BookAppointmentServlet: userId from session: " + userId);

        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("BookAppointmentServlet: userId from user object: " + userId);

            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }

        if (userId == null) {
            System.out.println("BookAppointmentServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get all departments for the dropdown
        DepartmentDAO departmentDAO = new DepartmentDAO();
        List<Department> departments = departmentDAO.getAllDepartments();

        // Get selected department ID from request parameter
        String departmentIdParam = request.getParameter("departmentId");
        Integer departmentId = null;
        List<User> doctors = new ArrayList<>();

        if (departmentIdParam != null && !departmentIdParam.isEmpty()) {
            try {
                departmentId = Integer.parseInt(departmentIdParam);
                UserDAO userDAO = new UserDAO();
                doctors = userDAO.getDoctorsByDepartment(departmentId);
                System.out.println("BookAppointmentServlet: Found " + doctors.size() + " doctors for department ID " + departmentId);

                // Check if this is an AJAX request
                String isAjax = request.getParameter("ajax");
                if ("true".equals(isAjax)) {
                    // Return JSON response with doctors
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    StringBuilder jsonBuilder = new StringBuilder("[");
                    for (int i = 0; i < doctors.size(); i++) {
                        User doctor = doctors.get(i);
                        jsonBuilder.append("{\"id\":").append(doctor.getId())
                                  .append(",\"name\":\"")
                                  .append(doctor.getName().replace("\"", "\\\""))
                                  .append("\"}");

                        if (i < doctors.size() - 1) {
                            jsonBuilder.append(",");
                        }
                    }
                    jsonBuilder.append("]");

                    response.getWriter().write(jsonBuilder.toString());
                    return; // End the request here for AJAX calls
                }
            } catch (NumberFormatException e) {
                System.out.println("BookAppointmentServlet: Invalid department ID: " + departmentIdParam);
            }
        }

        // Get doctor ID from request parameter if provided (for direct booking from doctor profile)
        String doctorIdParam = request.getParameter("doctorId");
        Integer doctorId = null;
        User selectedDoctor = null;

        if (doctorIdParam != null && !doctorIdParam.isEmpty()) {
            try {
                doctorId = Integer.parseInt(doctorIdParam);
                UserDAO userDAO = new UserDAO();
                selectedDoctor = userDAO.getUserById(doctorId);
                System.out.println("BookAppointmentServlet: Doctor selected: " + (selectedDoctor != null ? selectedDoctor.getName() : "Not found"));

                // If we have a selected doctor but no department, get the doctor's department
                if (departmentId == null && selectedDoctor != null) {
                    // Get the doctor's department from the database using DoctorDepartmentDAO
                    dao.DoctorDepartmentDAO doctorDeptDAO = new dao.DoctorDepartmentDAO();
                    int deptId = doctorDeptDAO.getDepartmentIdForDoctor(selectedDoctor.getId());

                    if (deptId > 0) {
                        departmentId = deptId;
                        System.out.println("BookAppointmentServlet: Using doctor's department ID: " + departmentId);
                        doctors = userDAO.getDoctorsByDepartment(departmentId);
                    } else {
                        // If department ID is not available, use a default
                        departmentId = 1; // Default to first department
                        System.out.println("BookAppointmentServlet: Using default department ID: " + departmentId);
                        doctors = userDAO.getDoctorsByDepartment(departmentId);
                    }
                }
            } catch (NumberFormatException e) {
                System.out.println("BookAppointmentServlet: Invalid doctor ID: " + doctorIdParam);
            }
        }

        // Set attributes for the JSP
        request.setAttribute("departments", departments);
        request.setAttribute("selectedDepartmentId", departmentId);
        request.setAttribute("doctors", doctors);
        request.setAttribute("selectedDoctor", selectedDoctor);

        // If a doctor was selected, make sure we're on step 2
        if (selectedDoctor != null && departmentId != null) {
            // Force the form to show step 2 (doctor selection and appointment details)
            request.setAttribute("selectedDepartmentId", departmentId);
            System.out.println("BookAppointmentServlet: Showing step 2 with selected doctor: " + selectedDoctor.getName());
        }
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));
        request.setAttribute("userId", userId);

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/book-appointment.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is a patient
        if (session == null || session.getAttribute("username") == null || !"patient".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer patientId = (Integer) session.getAttribute("userId");
        if (patientId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            patientId = user.getId();
            session.setAttribute("userId", patientId);
        }

        if (patientId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form data
        String departmentIdStr = request.getParameter("department");
        String doctorIdStr = request.getParameter("doctor");
        String appointmentDateStr = request.getParameter("appointmentDate");
        String timeSlot = request.getParameter("timeSlot");
        String notes = request.getParameter("notes");

        System.out.println("BookAppointmentServlet: doPost called with department=" + departmentIdStr +
                           ", doctor=" + doctorIdStr + ", date=" + appointmentDateStr +
                           ", timeSlot=" + timeSlot + ", notes=" + notes);

        try {
            // Parse form data
            int departmentId = Integer.parseInt(departmentIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            Date appointmentDate = Date.valueOf(appointmentDateStr);

            // Create appointment
            Appointment appointment = new Appointment();
            appointment.setPatientId(patientId);
            appointment.setDoctorId(doctorId);
            appointment.setDepartmentId(departmentId);
            appointment.setAppointmentDate(appointmentDate);
            appointment.setTimeSlot(timeSlot);
            appointment.setStatus("Scheduled");
            appointment.setNotes(notes);

            // Save appointment to database
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            boolean success = appointmentDAO.createAppointment(appointment);

            if (success) {
                System.out.println("BookAppointmentServlet: Appointment created successfully");

                // Get doctor and department names for the success message
                String doctorName = "";
                String departmentName = "";
                try {
                    // Get doctor name
                    dao.UserDAO userDAO = new dao.UserDAO();
                    model.User doctor = userDAO.getUserById(doctorId);
                    if (doctor != null) {
                        doctorName = doctor.getName();
                    }

                    // Get department name
                    dao.DepartmentDAO deptDAO = new dao.DepartmentDAO();
                    model.Department department = deptDAO.getDepartmentById(departmentId);
                    if (department != null) {
                        departmentName = department.getName();
                    }
                } catch (Exception e) {
                    System.out.println("BookAppointmentServlet: Error getting doctor or department details: " + e.getMessage());
                }

                // Format the date for display
                java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("EEEE, MMMM d, yyyy");
                String formattedDate = dateFormat.format(appointmentDate);

                // Create a detailed success message
                StringBuilder successMsg = new StringBuilder();
                successMsg.append("Your appointment has been successfully booked! ");
                successMsg.append("You are scheduled to see Dr. ").append(doctorName).append(" ");
                successMsg.append("in the ").append(departmentName).append(" department on ");
                successMsg.append(formattedDate).append(" at ").append(timeSlot).append(".");

                session.setAttribute("successMessage", successMsg.toString());

                // Redirect to appointments page instead of dashboard
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            } else {
                System.out.println("BookAppointmentServlet: Failed to create appointment");
                session.setAttribute("errorMessage", "Failed to book appointment. Please try again.");

                // Redirect back to the booking page with the same department
                response.sendRedirect(request.getContextPath() + "/patient/book-appointment?departmentId=" + departmentId);
                return;
            }
        } catch (Exception e) {
            System.out.println("BookAppointmentServlet: Error processing form: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());

            // Redirect back to the booking page
            if (departmentIdStr != null && !departmentIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/patient/book-appointment?departmentId=" + departmentIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/patient/book-appointment");
            }
            return;
        }

        // This code is now unreachable because we always redirect in the try/catch blocks above
        // Keeping it commented out for reference
        /*
        DepartmentDAO departmentDAO = new DepartmentDAO();
        List<Department> departments = departmentDAO.getAllDepartments();

        request.setAttribute("departments", departments);
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));

        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/book-appointment.jsp");
        dispatcher.forward(request, response);
        */
    }
}
