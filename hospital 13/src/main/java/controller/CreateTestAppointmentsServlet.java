package controller;

import dao.DepartmentDAO;
import dao.UserDAO;
import model.Department;
import model.User;
import util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

@WebServlet("/doctor/create-test-appointments")
public class CreateTestAppointmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Disable this servlet to prevent creating hardcoded test data
        response.sendRedirect(request.getContextPath() + "/doctor/patients?error=test-data-creation-disabled");
        return;

        /* Original code disabled to prevent hardcoded data
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("username") == null || !"doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get doctor ID from session
        Integer doctorId = (Integer) session.getAttribute("userId");

        // If userId is null, try to get it from the user object
        if (doctorId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            doctorId = user.getId();
            session.setAttribute("userId", doctorId);
        }

        if (doctorId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get patients
            UserDAO userDAO = new UserDAO();
            List<User> patients = userDAO.getAllPatients();

            // If no patients, create a test patient
            if (patients == null || patients.isEmpty()) {
                User testPatient = new User();
                testPatient.setName("Test Patient");
                testPatient.setUsername("testpatient");
                testPatient.setPassword("patient123");
                testPatient.setEmail("testpatient@example.com");
                testPatient.setPhone("123-456-7890");
                testPatient.setRole("patient");
                testPatient.setGender("male");
                testPatient.setDateOfBirth(new java.util.Date());
                testPatient.setBloodGroup("O+");

                userDAO.registerUser(testPatient);

                // Get the newly created patient
                patients = userDAO.getAllPatients();
            }

            // Get departments
            DepartmentDAO departmentDAO = new DepartmentDAO();
            List<Department> departments = departmentDAO.getAllDepartments();

            // If no departments, use department ID 1 (assuming it exists from database initialization)
            int departmentId = departments != null && !departments.isEmpty() ? departments.get(0).getId() : 1;

            // Get a patient ID
            int patientId = patients.get(0).getId();

            // Current date
            java.sql.Date today = new java.sql.Date(System.currentTimeMillis());

            // Insert test appointments
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                     "INSERT INTO appointments (patient_id, doctor_id, department_id, appointment_date, time_slot, status, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)"
                 )) {

                // Insert 5 test appointments
                String[] timeSlots = {"09:00 AM", "10:30 AM", "01:00 PM", "02:30 PM", "04:00 PM"};
                String[] statuses = {"Scheduled", "Completed", "Cancelled", "Scheduled", "Pending"};
                String[] notes = {
                    "Regular checkup",
                    "Follow-up appointment",
                    "Cancelled by patient",
                    "Annual physical",
                    "Initial consultation"
                };

                for (int i = 0; i < 5; i++) {
                    pstmt.setInt(1, patientId);
                    pstmt.setInt(2, doctorId);
                    pstmt.setInt(3, departmentId);

                    // Different dates: today, tomorrow, yesterday, day after tomorrow, two days ago
                    java.sql.Date appointmentDate = new java.sql.Date(today.getTime() + (i - 2) * 24 * 60 * 60 * 1000);
                    pstmt.setDate(4, appointmentDate);

                    pstmt.setString(5, timeSlots[i]);
                    pstmt.setString(6, statuses[i]);
                    pstmt.setString(7, notes[i]);

                    pstmt.executeUpdate();
                }
            }

            // Redirect back to patients page
            response.sendRedirect(request.getContextPath() + "/doctor/patients");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard?error=appointment-creation-failed");
        }
    } */
    }
}
