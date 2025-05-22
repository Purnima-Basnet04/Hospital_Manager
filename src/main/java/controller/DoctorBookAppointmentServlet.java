package controller;

import dao.AppointmentDAO;
import dao.UserDAO;
import model.Appointment;
import model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet({"/doctor/book-appointment", "/doctor-book-appointment"})
public class DoctorBookAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("DoctorBookAppointmentServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("DoctorBookAppointmentServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a doctor
        String role = (String) session.getAttribute("role");
        if (!"doctor".equals(role)) {
            System.out.println("DoctorBookAppointmentServlet: User is not a doctor, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Doctors cannot book appointments - redirect to appointments page with message
        System.out.println("DoctorBookAppointmentServlet: Redirecting doctor to appointments page");
        response.sendRedirect(request.getContextPath() + "/doctor/appointments?message=doctors-cannot-book-appointments");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("username") == null || !"doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Doctors cannot book appointments - redirect to appointments page with message
        System.out.println("DoctorBookAppointmentServlet: Redirecting doctor to appointments page");
        response.sendRedirect(request.getContextPath() + "/doctor/appointments?message=doctors-cannot-book-appointments");
    }
}
