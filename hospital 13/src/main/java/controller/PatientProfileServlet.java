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

@WebServlet({"/patient/profile", "/profile"})
public class PatientProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("PatientProfileServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("PatientProfileServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("PatientProfileServlet: User is not a patient, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get patient's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("PatientProfileServlet: userId from session: " + userId);
        
        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("PatientProfileServlet: userId from user object: " + userId);
            
            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }
        
        if (userId == null) {
            System.out.println("PatientProfileServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get patient details
        UserDAO userDAO = new UserDAO();
        User patient = userDAO.getUserById(userId);
        
        if (patient == null) {
            System.out.println("PatientProfileServlet: Patient not found");
            session.setAttribute("errorMessage", "Patient not found");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Set patient as request attribute
        request.setAttribute("patient", patient);
        
        // Set request attributes for the JSP
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));
        request.setAttribute("userId", userId);
        
        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/profile.jsp");
        dispatcher.forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        System.out.println("PatientProfileServlet: doPost called");
        
        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("PatientProfileServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("PatientProfileServlet: User is not a patient, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // Get patient's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            session.setAttribute("userId", userId);
        }
        
        if (userId == null) {
            System.out.println("PatientProfileServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String emergencyContact = request.getParameter("emergencyContact");
        
        System.out.println("PatientProfileServlet: Updating profile for user ID " + userId);
        
        // Update patient details
        UserDAO userDAO = new UserDAO();
        User patient = userDAO.getUserById(userId);
        
        if (patient == null) {
            System.out.println("PatientProfileServlet: Patient not found");
            session.setAttribute("errorMessage", "Patient not found");
            response.sendRedirect(request.getContextPath() + "/patient/profile");
            return;
        }
        
        // Update patient object with form data
        patient.setName(name);
        patient.setEmail(email);
        patient.setPhone(phone);
        patient.setAddress(address);
        patient.setEmergencyContact(emergencyContact);
        
        // Save updated patient to database
        boolean success = userDAO.updateUser(patient);
        
        if (success) {
            System.out.println("PatientProfileServlet: Profile updated successfully");
            session.setAttribute("successMessage", "Profile updated successfully");
            
            // Update session attributes
            session.setAttribute("name", name);
        } else {
            System.out.println("PatientProfileServlet: Failed to update profile");
            session.setAttribute("errorMessage", "Failed to update profile. Please try again.");
        }
        
        // Redirect back to profile page
        response.sendRedirect(request.getContextPath() + "/patient/profile");
    }
}
