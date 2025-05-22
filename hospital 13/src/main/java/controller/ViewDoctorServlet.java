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

@WebServlet({"/patient/view-doctor", "/view-doctor"})
public class ViewDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("ViewDoctorServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("ViewDoctorServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get doctor ID from request parameter
        String doctorIdParam = request.getParameter("id");
        if (doctorIdParam == null || doctorIdParam.isEmpty()) {
            System.out.println("ViewDoctorServlet: No doctor ID provided");
            session.setAttribute("errorMessage", "No doctor ID provided");
            response.sendRedirect(request.getContextPath() + "/patient/find-doctor");
            return;
        }

        try {
            int doctorId = Integer.parseInt(doctorIdParam);
            
            // Get doctor details
            UserDAO userDAO = new UserDAO();
            User doctor = userDAO.getUserById(doctorId);
            
            if (doctor == null) {
                System.out.println("ViewDoctorServlet: Doctor not found");
                session.setAttribute("errorMessage", "Doctor not found");
                response.sendRedirect(request.getContextPath() + "/patient/find-doctor");
                return;
            }
            
            // Check if the user is a doctor
            if (!"doctor".equalsIgnoreCase(doctor.getRole())) {
                System.out.println("ViewDoctorServlet: User is not a doctor");
                session.setAttribute("errorMessage", "User is not a doctor");
                response.sendRedirect(request.getContextPath() + "/patient/find-doctor");
                return;
            }
            
            // Get doctor's departments
            List<Department> doctorDepartments = userDAO.getDoctorDepartments(doctorId);
            System.out.println("ViewDoctorServlet: Found " + (doctorDepartments != null ? doctorDepartments.size() : 0) + " departments for doctor ID " + doctorId);
            
            // Set attributes for the JSP
            request.setAttribute("doctor", doctor);
            request.setAttribute("doctorDepartments", doctorDepartments);
            request.setAttribute("username", session.getAttribute("username"));
            request.setAttribute("name", session.getAttribute("name"));
            request.setAttribute("role", session.getAttribute("role"));
            
            // Forward to the JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/view-doctor.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            System.out.println("ViewDoctorServlet: Invalid doctor ID format");
            session.setAttribute("errorMessage", "Invalid doctor ID format");
            response.sendRedirect(request.getContextPath() + "/patient/find-doctor");
        } catch (Exception e) {
            System.out.println("ViewDoctorServlet: Error retrieving doctor: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error retrieving doctor: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/find-doctor");
        }
    }
}
