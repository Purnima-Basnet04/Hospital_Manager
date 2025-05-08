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

@WebServlet({"/doctor/view-patient", "/admin/view-patient", "/view-patient"})
public class ViewPatientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("ViewPatientServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("ViewPatientServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a doctor or admin
        String role = (String) session.getAttribute("role");
        if (!"doctor".equals(role) && !"admin".equals(role)) {
            System.out.println("ViewPatientServlet: User is not a doctor or admin, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get patient ID from request parameter
        String patientIdStr = request.getParameter("id");
        if (patientIdStr == null || patientIdStr.isEmpty()) {
            System.out.println("ViewPatientServlet: No patient ID provided");

            // Redirect based on role
            if ("doctor".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/doctor/patients");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/patients");
            }
            return;
        }

        try {
            int patientId = Integer.parseInt(patientIdStr);

            // Get patient details
            UserDAO userDAO = new UserDAO();
            User patient = userDAO.getUserById(patientId);

            if (patient == null) {
                System.out.println("ViewPatientServlet: Patient not found");

                // Redirect based on role
                if ("doctor".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/doctor/patients");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/patients");
                }
                return;
            }

            // Check if the user is a patient
            if (!"patient".equals(patient.getRole())) {
                System.out.println("ViewPatientServlet: User is not a patient");

                // Redirect based on role
                if ("doctor".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/doctor/patients");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/patients");
                }
                return;
            }

            // Set patient as request attribute
            request.setAttribute("patient", patient);

            // Set request attributes for the JSP
            request.setAttribute("username", session.getAttribute("username"));
            request.setAttribute("name", session.getAttribute("name"));
            request.setAttribute("role", session.getAttribute("role"));

            // Forward to the appropriate JSP based on role
            String jspPath = "/doctor/view-patient.jsp";
            if ("admin".equals(role)) {
                jspPath = "/admin/view-patient.jsp";
            }

            RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("ViewPatientServlet: Invalid patient ID format");

            // Redirect based on role
            if ("doctor".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/doctor/patients");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/patients");
            }
        } catch (Exception e) {
            System.out.println("ViewPatientServlet: Error retrieving patient: " + e.getMessage());
            e.printStackTrace();

            // Redirect based on role
            if ("doctor".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/doctor/patients");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/patients");
            }
        }
    }
}
