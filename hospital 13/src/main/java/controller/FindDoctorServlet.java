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

@WebServlet({"/patient/find-doctor", "/find-doctor"})
public class FindDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("FindDoctorServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("FindDoctorServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get all doctors
        UserDAO userDAO = new UserDAO();
        List<User> doctors = userDAO.getAllDoctors();
        
        System.out.println("FindDoctorServlet: Found " + (doctors != null ? doctors.size() : 0) + " doctors");
        
        // Get all departments for the filter dropdown
        DepartmentDAO departmentDAO = new DepartmentDAO();
        List<Department> departments = departmentDAO.getAllDepartments();
        
        // Set attributes for the JSP
        request.setAttribute("doctors", doctors);
        request.setAttribute("departments", departments);
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/find-doctor.jsp");
        dispatcher.forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String searchQuery = request.getParameter("search");
        String departmentFilter = request.getParameter("department");
        
        System.out.println("FindDoctorServlet: doPost called with search=" + searchQuery + ", department=" + departmentFilter);
        
        // Get filtered doctors
        UserDAO userDAO = new UserDAO();
        List<User> doctors;
        
        if (departmentFilter != null && !departmentFilter.isEmpty() && !departmentFilter.equals("0")) {
            // Filter by department
            int departmentId = Integer.parseInt(departmentFilter);
            doctors = userDAO.getDoctorsByDepartment(departmentId);
            System.out.println("FindDoctorServlet: Filtered by department ID " + departmentId);
        } else {
            // Get all doctors
            doctors = userDAO.getAllDoctors();
        }
        
        // Further filter by search query if provided
        if (searchQuery != null && !searchQuery.isEmpty()) {
            // This is a simple client-side filtering that will be handled by JavaScript
            System.out.println("FindDoctorServlet: Search query will be handled by client-side filtering");
        }
        
        System.out.println("FindDoctorServlet: Found " + (doctors != null ? doctors.size() : 0) + " doctors after filtering");
        
        // Get all departments for the filter dropdown
        DepartmentDAO departmentDAO = new DepartmentDAO();
        List<Department> departments = departmentDAO.getAllDepartments();
        
        // Set attributes for the JSP
        request.setAttribute("doctors", doctors);
        request.setAttribute("departments", departments);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("departmentFilter", departmentFilter);
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));
        
        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/find-doctor.jsp");
        dispatcher.forward(request, response);
    }
}
