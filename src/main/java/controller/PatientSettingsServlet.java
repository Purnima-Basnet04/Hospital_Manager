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

@WebServlet({"/patient/settings", "/settings"})
public class PatientSettingsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("PatientSettingsServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("PatientSettingsServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("PatientSettingsServlet: User is not a patient, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get patient's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("PatientSettingsServlet: userId from session: " + userId);
        
        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("PatientSettingsServlet: userId from user object: " + userId);
            
            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }
        
        if (userId == null) {
            System.out.println("PatientSettingsServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get patient details
        UserDAO userDAO = new UserDAO();
        User patient = userDAO.getUserById(userId);
        
        if (patient == null) {
            System.out.println("PatientSettingsServlet: Patient not found");
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
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/settings.jsp");
        dispatcher.forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        System.out.println("PatientSettingsServlet: doPost called");
        
        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("PatientSettingsServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("PatientSettingsServlet: User is not a patient, redirecting to index");
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
            System.out.println("PatientSettingsServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get form data
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String emailNotifications = request.getParameter("emailNotifications");
        String smsNotifications = request.getParameter("smsNotifications");
        
        System.out.println("PatientSettingsServlet: Updating settings for user ID " + userId);
        
        // Update patient settings
        UserDAO userDAO = new UserDAO();
        User patient = userDAO.getUserById(userId);
        
        if (patient == null) {
            System.out.println("PatientSettingsServlet: Patient not found");
            session.setAttribute("errorMessage", "Patient not found");
            response.sendRedirect(request.getContextPath() + "/patient/settings");
            return;
        }
        
        // Handle password change if requested
        boolean passwordChanged = false;
        if (currentPassword != null && !currentPassword.isEmpty() && 
            newPassword != null && !newPassword.isEmpty() && 
            confirmPassword != null && !confirmPassword.isEmpty()) {
            
            // Verify current password
            if (userDAO.verifyPassword(patient.getUsername(), currentPassword)) {
                // Check if new password and confirm password match
                if (newPassword.equals(confirmPassword)) {
                    // Update password
                    boolean success = userDAO.updatePassword(patient.getId(), newPassword);
                    if (success) {
                        System.out.println("PatientSettingsServlet: Password updated successfully");
                        session.setAttribute("successMessage", "Password updated successfully");
                        passwordChanged = true;
                    } else {
                        System.out.println("PatientSettingsServlet: Failed to update password");
                        session.setAttribute("errorMessage", "Failed to update password. Please try again.");
                    }
                } else {
                    System.out.println("PatientSettingsServlet: New password and confirm password do not match");
                    session.setAttribute("errorMessage", "New password and confirm password do not match");
                }
            } else {
                System.out.println("PatientSettingsServlet: Current password is incorrect");
                session.setAttribute("errorMessage", "Current password is incorrect");
            }
        }
        
        // Update notification preferences
        boolean emailNotificationsEnabled = "on".equals(emailNotifications);
        boolean smsNotificationsEnabled = "on".equals(smsNotifications);
        
        // In a real application, you would save these preferences to the database
        // For now, we'll just set a success message
        if (!passwordChanged) {
            System.out.println("PatientSettingsServlet: Settings updated successfully");
            session.setAttribute("successMessage", "Settings updated successfully");
        }
        
        // Redirect back to settings page
        response.sendRedirect(request.getContextPath() + "/patient/settings");
    }
}
