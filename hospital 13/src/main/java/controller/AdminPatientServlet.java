package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import dao.UserDAO;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/admin/patients/*")
public class AdminPatientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // Default to list action
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/patients.jsp");
            return;
        }

        // Handle different actions based on path
        switch (pathInfo) {
            case "/view":
                viewPatient(request, response);
                break;
            case "/add":
                showAddForm(request, response);
                break;
            case "/edit":
                showEditForm(request, response);
                break;
            case "/delete":
                deletePatient(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/patients.jsp");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/patients.jsp");
            return;
        }

        switch (action) {
            case "add":
                addPatient(request, response);
                break;
            case "update":
                updatePatient(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/patients.jsp");
                break;
        }
    }

    private void viewPatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User patient = userDAO.getUserById(id);

        if (patient != null) {
            request.setAttribute("patient", patient);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/view-patient.jsp");
            dispatcher.forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Patient not found");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/patients.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-patient.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User patient = userDAO.getUserById(id);

        if (patient != null) {
            request.setAttribute("patient", patient);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-patient.jsp");
            dispatcher.forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Patient not found");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/patients.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void addPatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String bloodGroup = request.getParameter("bloodGroup");
        String emergencyContact = request.getParameter("emergencyContact");
        String address = request.getParameter("address");
        String medicalHistory = request.getParameter("medicalHistory");

        // Parse date of birth
        Date dateOfBirth = null;
        try {
            String dobStr = request.getParameter("dateOfBirth");
            if (dobStr != null && !dobStr.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                dateOfBirth = sdf.parse(dobStr);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }

        // Validate username and email
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("errorMessage", "Username already exists");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-patient.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (userDAO.isEmailExists(email)) {
            request.setAttribute("errorMessage", "Email already exists");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-patient.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Create user object
        User patient = new User();
        patient.setName(name);
        patient.setUsername(username);
        patient.setPassword(password);
        patient.setEmail(email);
        patient.setPhone(phone);
        patient.setRole("patient");
        patient.setGender(gender);
        patient.setDateOfBirth(dateOfBirth);
        patient.setBloodGroup(bloodGroup);
        patient.setEmergencyContact(emergencyContact);
        patient.setAddress(address);
        patient.setMedicalHistory(medicalHistory);

        // Register user
        boolean success = userDAO.registerUser(patient);

        if (success) {
            // Store success message in session for display after redirect
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Patient " + name + " was added successfully");
            response.sendRedirect(request.getContextPath() + "/admin/patients.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to add patient");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-patient.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void updatePatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String bloodGroup = request.getParameter("bloodGroup");
        String emergencyContact = request.getParameter("emergencyContact");
        String address = request.getParameter("address");
        String medicalHistory = request.getParameter("medicalHistory");

        // Parse date of birth
        Date dateOfBirth = null;
        try {
            String dobStr = request.getParameter("dateOfBirth");
            if (dobStr != null && !dobStr.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                dateOfBirth = sdf.parse(dobStr);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }

        // Get existing user
        User existingPatient = userDAO.getUserById(id);

        if (existingPatient == null) {
            request.setAttribute("errorMessage", "Patient not found");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/patients.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Check if username or email has changed and if they already exist
        if (!existingPatient.getUsername().equals(username) && userDAO.isUsernameExists(username)) {
            request.setAttribute("errorMessage", "Username already exists");
            request.setAttribute("patient", existingPatient);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-patient.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (!existingPatient.getEmail().equals(email) && userDAO.isEmailExists(email)) {
            request.setAttribute("errorMessage", "Email already exists");
            request.setAttribute("patient", existingPatient);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-patient.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Update user object
        existingPatient.setName(name);
        existingPatient.setUsername(username);
        existingPatient.setEmail(email);
        existingPatient.setPhone(phone);
        existingPatient.setGender(gender);
        existingPatient.setDateOfBirth(dateOfBirth);
        existingPatient.setBloodGroup(bloodGroup);
        existingPatient.setEmergencyContact(emergencyContact);
        existingPatient.setAddress(address);
        existingPatient.setMedicalHistory(medicalHistory);

        // Update user
        boolean success = userDAO.updateUser(existingPatient);

        if (success) {
            // Store success message in session for display after redirect
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Patient updated successfully");
            response.sendRedirect(request.getContextPath() + "/admin/patients.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to update patient");
            request.setAttribute("patient", existingPatient);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-patient.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void deletePatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        // Get patient name before deletion for better message
        User patient = userDAO.getUserById(id);
        String patientName = (patient != null && patient.getName() != null) ? patient.getName() : "Patient";

        boolean success = userDAO.deleteUser(id);

        // Store message in session for display after redirect
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("successMessage", patientName + " was deleted successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to delete " + patientName);
        }

        response.sendRedirect(request.getContextPath() + "/admin/patients.jsp");
    }
}
