package controller;

import dao.DepartmentDAO;
import dao.UserDAO;
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
import java.util.List;

@WebServlet({"/patient/doctor-appointment", "/doctor-appointment"})
public class DoctorAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("DoctorAppointmentServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("DoctorAppointmentServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("DoctorAppointmentServlet: User is not a patient, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get departments for filtering
        DepartmentDAO departmentDAO = new DepartmentDAO();
        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("departments", departments);

        // Get doctors (optionally filtered by department)
        String departmentId = request.getParameter("dept");
        UserDAO userDAO = new UserDAO();
        List<User> doctors;

        if (departmentId != null && !departmentId.trim().isEmpty()) {
            try {
                int deptId = Integer.parseInt(departmentId);
                doctors = userDAO.getDoctorsByDepartment(deptId);
                request.setAttribute("selectedDepartment", deptId);
            } catch (NumberFormatException e) {
                doctors = userDAO.getAllDoctors();
            }
        } else {
            doctors = userDAO.getAllDoctors();
        }

        request.setAttribute("doctors", doctors);

        // Set request attributes for the JSP
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/doctor-appointment.jsp");
        dispatcher.forward(request, response);
    }
}
