package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet({"/doctor/profile", "/doctor-profile"})
public class DoctorProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("DoctorProfileServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("DoctorProfileServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a doctor
        String role = (String) session.getAttribute("role");
        if (!"doctor".equals(role)) {
            System.out.println("DoctorProfileServlet: User is not a doctor, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get doctor's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            System.out.println("DoctorProfileServlet: User ID not found in session");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get doctor's profile from database
        UserDAO userDAO = new UserDAO();
        User doctor = userDAO.getUserById(userId);
        
        if (doctor == null) {
            System.out.println("DoctorProfileServlet: Doctor not found in database");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Set doctor as request attribute
        request.setAttribute("doctor", doctor);
        
        // Set request attributes for the JSP
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/profile.jsp");
        dispatcher.forward(request, response);
    }
}
