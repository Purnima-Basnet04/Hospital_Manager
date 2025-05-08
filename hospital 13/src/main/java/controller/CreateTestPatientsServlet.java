package controller;

import dao.UserDAO;
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
import java.util.Date;
import java.util.List;

@WebServlet("/doctor/create-test-patients")
public class CreateTestPatientsServlet extends HttpServlet {
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

        try {
            // Check if there are already patients in the database
            boolean hasPatients = false;
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE LOWER(role) = 'patient'")) {

                if (rs.next()) {
                    int count = rs.getInt(1);
                    hasPatients = count > 0;
                    System.out.println("CreateTestPatientsServlet: Found " + count + " patients in the database");
                }
            }

            // If no patients, create test patients
            if (!hasPatients) {
                System.out.println("CreateTestPatientsServlet: Creating test patients");

                // Create test patients
                String[] patientNames = {"John Doe", "Jane Smith", "Robert Johnson", "Emily Davis", "Michael Wilson"};
                String[] patientUsernames = {"johndoe", "janesmith", "rjohnson", "edavis", "mwilson"};
                String[] patientEmails = {"john@example.com", "jane@example.com", "robert@example.com", "emily@example.com", "michael@example.com"};
                String[] patientPhones = {"123-456-7890", "123-456-7891", "123-456-7892", "123-456-7893", "123-456-7894"};
                String[] patientGenders = {"male", "female", "male", "female", "male"};
                String[] patientBloodGroups = {"O+", "A+", "B+", "AB+", "O-"};

                UserDAO userDAO = new UserDAO();

                for (int i = 0; i < patientNames.length; i++) {
                    User patient = new User();
                    patient.setName(patientNames[i]);
                    patient.setUsername(patientUsernames[i]);
                    patient.setPassword("patient123"); // Simple password for testing
                    patient.setEmail(patientEmails[i]);
                    patient.setPhone(patientPhones[i]);
                    patient.setRole("patient");
                    patient.setGender(patientGenders[i]);
                    patient.setDateOfBirth(new Date()); // Current date as placeholder
                    patient.setBloodGroup(patientBloodGroups[i]);

                    boolean success = userDAO.registerUser(patient);
                    System.out.println("CreateTestPatientsServlet: Created patient " + patientNames[i] + ": " + (success ? "Success" : "Failed"));
                }
            }

            // Now create test appointments
            response.sendRedirect(request.getContextPath() + "/doctor/create-test-appointments");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/patients?error=patient-creation-failed");
        }
    } */
    }
}
