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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // User is already logged in, redirect based on role
            User user = (User) session.getAttribute("user");
            redirectBasedOnRole(user.getRole(), request, response);
            return;
        }

        // Check if this is a direct request for the patient dashboard
        String directAccess = request.getParameter("direct");
        if (directAccess != null && directAccess.equals("patient")) {
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            return;
        }

        // Forward to login page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/Login.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String roleParam = request.getParameter("role");

        // Basic validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
            dispatcher.forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.authenticateUser(username, password);

        // If role is specified, verify that the user has that role
        if (user != null && roleParam != null && !roleParam.trim().isEmpty()) {
            if (!roleParam.equals(user.getRole())) {
                request.setAttribute("errorMessage", "You don't have access with the selected role.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/Login.jsp");
                dispatcher.forward(request, response);
                return;
            }
        }

        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("name", user.getName());
            session.setAttribute("role", user.getRole());

            // Debug session attributes
            System.out.println("LoginServlet: Setting session attributes");
            System.out.println("username: " + user.getUsername());
            System.out.println("name: " + user.getName());
            System.out.println("role: " + user.getRole());

            // Set session timeout to 30 minutes
            session.setMaxInactiveInterval(30 * 60);

            // Redirect based on role
            redirectBasedOnRole(user.getRole(), request, response);
        } else {
            // Authentication failed
            request.setAttribute("errorMessage", "Invalid username or password");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Login.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void redirectBasedOnRole(String role, HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Redirect users based on their role
        switch (role) {
            case "admin":
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
            case "doctor":
                // Redirect doctors to their dashboard
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                break;
            case "patient":
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/appointments");
                break;
        }
    }
}