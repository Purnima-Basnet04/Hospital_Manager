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
import dao.DoctorDepartmentDAO;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/admin/doctors/*")
public class AdminDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private DoctorDepartmentDAO doctorDepartmentDAO;

    public void init() {
        userDAO = new UserDAO();
        doctorDepartmentDAO = new DoctorDepartmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // Default to list action
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/doctors.jsp");
            return;
        }

        // Handle different actions based on path
        switch (pathInfo) {
            case "/view":
                viewDoctor(request, response);
                break;
            case "/add":
                showAddForm(request, response);
                break;
            case "/edit":
                showEditForm(request, response);
                break;
            case "/delete":
                deleteDoctor(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/doctors.jsp");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/doctors.jsp");
            return;
        }

        switch (action) {
            case "add":
                addDoctor(request, response);
                break;
            case "update":
                updateDoctor(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/doctors.jsp");
                break;
        }
    }

    private void viewDoctor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User doctor = userDAO.getUserById(id);

        if (doctor != null) {
            // Get department information
            int departmentId = doctorDepartmentDAO.getDepartmentIdForDoctor(doctor.getId());
            request.setAttribute("departmentId", departmentId);

            request.setAttribute("doctor", doctor);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/view-doctor.jsp");
            dispatcher.forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Doctor not found");
            response.sendRedirect(request.getContextPath() + "/admin/doctors.jsp");
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-doctor.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User doctor = userDAO.getUserById(id);

        if (doctor != null) {
            // Get department information
            int departmentId = doctorDepartmentDAO.getDepartmentIdForDoctor(doctor.getId());
            request.setAttribute("departmentId", departmentId);

            request.setAttribute("doctor", doctor);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-doctor.jsp");
            dispatcher.forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Doctor not found");
            response.sendRedirect(request.getContextPath() + "/admin/doctors.jsp");
        }
    }

    private void addDoctor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String departmentIdStr = request.getParameter("departmentId");
        int departmentId = -1;

        try {
            if (departmentIdStr != null && !departmentIdStr.isEmpty()) {
                departmentId = Integer.parseInt(departmentIdStr);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

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
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-doctor.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Validate that email ends with @gmail.com
        if (!email.toLowerCase().endsWith("@gmail.com")) {
            request.setAttribute("errorMessage", "Email must be a Gmail address (ending with @gmail.com)");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-doctor.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (userDAO.isEmailExists(email)) {
            request.setAttribute("errorMessage", "Email already exists");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-doctor.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Create user object
        User doctor = new User();
        doctor.setName(name);
        doctor.setUsername(username);
        doctor.setPassword(password);
        doctor.setEmail(email);
        doctor.setPhone(phone);
        doctor.setRole("doctor");
        doctor.setGender(gender);
        doctor.setDateOfBirth(dateOfBirth);

        // Register user
        boolean success = userDAO.registerUser(doctor);

        if (success) {
            // If department is selected, assign doctor to department
            if (departmentId > 0) {
                int doctorId = userDAO.getUserIdByUsername(username);
                if (doctorId > 0) {
                    doctorDepartmentDAO.assignDoctorToDepartment(doctorId, departmentId);
                }
            }

            // Store success message in session for display after redirect
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Dr. " + name + " was added successfully");
            response.sendRedirect(request.getContextPath() + "/admin/doctors.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to add doctor");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-doctor.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void updateDoctor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String departmentIdStr = request.getParameter("departmentId");
        int departmentId = -1;

        try {
            if (departmentIdStr != null && !departmentIdStr.isEmpty()) {
                departmentId = Integer.parseInt(departmentIdStr);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

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
        User existingDoctor = userDAO.getUserById(id);

        if (existingDoctor == null) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Doctor not found");
            response.sendRedirect(request.getContextPath() + "/admin/doctors.jsp");
            return;
        }

        // Check if username or email has changed and if they already exist
        if (!existingDoctor.getUsername().equals(username) && userDAO.isUsernameExists(username)) {
            request.setAttribute("errorMessage", "Username already exists");
            request.setAttribute("doctor", existingDoctor);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-doctor.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Validate that email ends with @gmail.com
        if (!email.toLowerCase().endsWith("@gmail.com")) {
            request.setAttribute("errorMessage", "Email must be a Gmail address (ending with @gmail.com)");
            request.setAttribute("doctor", existingDoctor);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-doctor.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (!existingDoctor.getEmail().equals(email) && userDAO.isEmailExists(email)) {
            request.setAttribute("errorMessage", "Email already exists");
            request.setAttribute("doctor", existingDoctor);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-doctor.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Update user object
        existingDoctor.setName(name);
        existingDoctor.setUsername(username);
        existingDoctor.setEmail(email);
        existingDoctor.setPhone(phone);
        existingDoctor.setGender(gender);
        existingDoctor.setDateOfBirth(dateOfBirth);

        // Update user
        boolean success = userDAO.updateUser(existingDoctor);

        if (success) {
            // Update department assignment if needed
            if (departmentId > 0) {
                doctorDepartmentDAO.updateDoctorDepartment(id, departmentId);
            }

            // Store success message in session for display after redirect
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Dr. " + name + " was updated successfully");
            response.sendRedirect(request.getContextPath() + "/admin/doctors.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to update doctor");
            request.setAttribute("doctor", existingDoctor);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-doctor.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void deleteDoctor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        // Get doctor name before deletion for better message
        User doctor = userDAO.getUserById(id);
        String doctorName = (doctor != null && doctor.getName() != null) ? "Dr. " + doctor.getName() : "Doctor";

        boolean success = userDAO.deleteUser(id);

        // Store message in session for display after redirect
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("successMessage", doctorName + " was deleted successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to delete " + doctorName);
        }

        response.sendRedirect(request.getContextPath() + "/admin/doctors.jsp");
    }
}
