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
import java.util.List;

@WebServlet({"/doctor/patients", "/doctor-patients"})
public class DoctorPatientsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("DoctorPatientsServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("DoctorPatientsServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a doctor
        String role = (String) session.getAttribute("role");
        if (!"doctor".equals(role)) {
            System.out.println("DoctorPatientsServlet: User is not a doctor, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get doctor's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("DoctorPatientsServlet: userId from session: " + userId);

        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("DoctorPatientsServlet: userId from user object: " + userId);

            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }

        // If still null, try to get it from the database using the username
        if (userId == null) {
            String username = (String) session.getAttribute("username");
            if (username != null) {
                UserDAO userDAO = new UserDAO();
                userId = userDAO.getUserIdByUsername(username);
                System.out.println("DoctorPatientsServlet: userId from database: " + userId);

                if (userId > 0) {
                    // Store the userId in the session for future use
                    session.setAttribute("userId", userId);
                }
            }
        }

        if (userId == null || userId <= 0) {
            System.out.println("DoctorPatientsServlet: User ID not found in session, user object, or database");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get doctor's patients
        UserDAO userDAO = new UserDAO();

        // Print session information for debugging
        System.out.println("DoctorPatientsServlet: Session information:");
        System.out.println("  userId: " + userId);
        System.out.println("  username: " + session.getAttribute("username"));
        System.out.println("  name: " + session.getAttribute("name"));
        System.out.println("  role: " + session.getAttribute("role"));

        // Get all patients instead of just patients for this doctor
        List<User> patients = userDAO.getAllPatients();

        System.out.println("DoctorPatientsServlet: Found " + (patients != null ? patients.size() : 0) + " patients in the system");

        // Set patients as request attribute
        request.setAttribute("patients", patients);

        // Add debug information to the request
        request.setAttribute("debug_userId", userId);
        request.setAttribute("debug_patientCount", patients != null ? patients.size() : 0);

        // Set request attributes for the JSP
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/patients.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle search functionality
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("username") == null || !"doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("DoctorPatientsServlet (doPost): userId from session: " + userId);

        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("DoctorPatientsServlet (doPost): userId from user object: " + userId);

            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }

        // If still null, try to get it from the database using the username
        if (userId == null) {
            String username = (String) session.getAttribute("username");
            if (username != null) {
                UserDAO userDAO = new UserDAO();
                userId = userDAO.getUserIdByUsername(username);
                System.out.println("DoctorPatientsServlet (doPost): userId from database: " + userId);

                if (userId > 0) {
                    // Store the userId in the session for future use
                    session.setAttribute("userId", userId);
                }
            }
        }

        if (userId == null || userId <= 0) {
            System.out.println("DoctorPatientsServlet (doPost): User ID not found in session, user object, or database");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String searchQuery = request.getParameter("search");
        String conditionFilter = request.getParameter("condition");

        System.out.println("DoctorPatientsServlet: doPost called with search=" + searchQuery + ", condition=" + conditionFilter);

        // Get all patients in the system
        UserDAO userDAO = new UserDAO();
        List<User> allPatients = userDAO.getAllPatients();

        // Filter patients based on search query and condition
        List<User> filteredPatients = allPatients;

        // TODO: Implement filtering logic based on search query and condition

        // Set attributes for the JSP
        request.setAttribute("patients", filteredPatients);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("conditionFilter", conditionFilter);
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/patients.jsp");
        dispatcher.forward(request, response);
    }
}
