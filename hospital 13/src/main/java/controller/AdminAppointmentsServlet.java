package controller;

import dao.AppointmentDAO;
import dao.DepartmentDAO;
import model.Appointment;
import model.Department;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/admin/appointments", "/admin-appointments"})
public class AdminAppointmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("AdminAppointmentsServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("AdminAppointmentsServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is an admin
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            System.out.println("AdminAppointmentsServlet: User is not an admin, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get all appointments
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        List<Appointment> appointments = appointmentDAO.getAllAppointments();

        System.out.println("AdminAppointmentsServlet: Retrieved " + (appointments != null ? appointments.size() : 0) + " appointments");

        // Print details of each appointment for debugging
        if (appointments != null && !appointments.isEmpty()) {
            System.out.println("AdminAppointmentsServlet: Appointments details:");
            for (Appointment appointment : appointments) {
                System.out.println("  - ID=" + appointment.getId() +
                                 ", Patient=" + appointment.getPatientName() +
                                 ", Doctor=" + appointment.getDoctorName() +
                                 ", Date=" + appointment.getAppointmentDate() +
                                 ", Status=" + appointment.getStatus());
            }
        } else {
            System.out.println("AdminAppointmentsServlet: No appointments found");
        }

        System.out.println("AdminAppointmentsServlet: Found " + (appointments != null ? appointments.size() : 0) + " appointments");

        // Get all departments for the filter dropdown
        DepartmentDAO departmentDAO = new DepartmentDAO();
        List<Department> departments = departmentDAO.getAllDepartments();

        // Set attributes for the JSP
        request.setAttribute("appointments", appointments);
        request.setAttribute("departments", departments);

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/appointments.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle search and filter functionality
        String searchQuery = request.getParameter("search");
        String departmentFilter = request.getParameter("department");
        String statusFilter = request.getParameter("status");

        System.out.println("AdminAppointmentsServlet: doPost called with search=" + searchQuery +
                           ", department=" + departmentFilter + ", status=" + statusFilter);

        // Get filtered appointments
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        List<Appointment> appointments = appointmentDAO.getFilteredAppointments(searchQuery, departmentFilter, statusFilter);

        System.out.println("AdminAppointmentsServlet: Found " + (appointments != null ? appointments.size() : 0) +
                           " appointments after filtering");

        // Get all departments for the filter dropdown
        DepartmentDAO departmentDAO = new DepartmentDAO();
        List<Department> departments = departmentDAO.getAllDepartments();

        // Set attributes for the JSP
        request.setAttribute("appointments", appointments);
        request.setAttribute("departments", departments);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("departmentFilter", departmentFilter);
        request.setAttribute("statusFilter", statusFilter);

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/appointments.jsp");
        dispatcher.forward(request, response);
    }
}
