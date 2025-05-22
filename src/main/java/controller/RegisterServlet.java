package controller;

import dao.UserDAO;
import dao.DoctorDepartmentDAO;
import model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/Register.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm");
        String role = request.getParameter("role");
        String gender = request.getParameter("gender");
        String dobString = request.getParameter("dob");
        String bloodGroup = request.getParameter("blood");
        String emergencyContact = request.getParameter("emergency");
        String address = request.getParameter("address");
        String medicalHistory = request.getParameter("medical");

        // Validate form data
        if (name == null || name.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Required fields cannot be empty");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Validate that email ends with @gmail.com
        if (!email.toLowerCase().endsWith("@gmail.com")) {
            request.setAttribute("errorMessage", "Email must be a Gmail address (ending with @gmail.com)");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Check if username or email already exists
        UserDAO userDAO = new UserDAO();
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("errorMessage", "Username already in use. Please choose a different username.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (userDAO.isEmailExists(email)) {
            request.setAttribute("errorMessage", "Email address already in use. Please use a different email.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Parse date of birth
        Date dob = null;
        try {
            if (dobString != null && !dobString.trim().isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                dob = sdf.parse(dobString);
            }
        } catch (ParseException e) {
            request.setAttribute("errorMessage", "Invalid date format");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Create user object
        User user = new User();
        user.setName(name);
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRole(role != null ? role : "patient"); // Default to patient if not specified
        user.setGender(gender);
        user.setDateOfBirth(dob);
        user.setBloodGroup(bloodGroup);
        user.setEmergencyContact(emergencyContact);
        user.setAddress(address);
        user.setMedicalHistory(medicalHistory);

        // Get department ID if role is doctor
        String departmentIdStr = request.getParameter("department");
        int departmentId = -1;
        if ("doctor".equals(role) && departmentIdStr != null && !departmentIdStr.isEmpty()) {
            try {
                departmentId = Integer.parseInt(departmentIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid department selection");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/Register.jsp");
                dispatcher.forward(request, response);
                return;
            }
        }

        // Register user
        boolean success = userDAO.registerUser(user);

        // If registration successful and user is a doctor, assign to department
        if (success && "doctor".equals(role) && departmentId > 0) {
            DoctorDepartmentDAO doctorDeptDAO = new DoctorDepartmentDAO();
            int doctorId = userDAO.getUserIdByUsername(username);
            if (doctorId > 0) {
                doctorDeptDAO.assignDoctorToDepartment(doctorId, departmentId);
            }
        }

        if (success) {
            // Registration successful, redirect to login page
            request.setAttribute("successMessage", "Registration successful. Please login.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Login.jsp");
            dispatcher.forward(request, response);
        } else {
            // Registration failed
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Register.jsp");
            dispatcher.forward(request, response);
        }
    }
}