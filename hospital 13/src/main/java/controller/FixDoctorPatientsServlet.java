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
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Date;
import java.util.List;

@WebServlet("/doctor/fix-patients")
public class FixDoctorPatientsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Fixing Doctor Patients</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println("h1, h2 { color: #333; }");
        out.println("pre { background-color: #f5f5f5; padding: 10px; border-radius: 5px; }");
        out.println(".success { color: green; }");
        out.println(".error { color: red; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        out.println("<h1>Fixing Doctor Patients</h1>");
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("username") == null) {
            out.println("<p class='error'>No active session found. Please log in first.</p>");
            out.println("<p><a href='" + request.getContextPath() + "/login'>Go to Login</a></p>");
            out.println("</body></html>");
            return;
        }
        
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");
        
        out.println("<h2>Session Information</h2>");
        out.println("<p>Username: " + username + "</p>");
        out.println("<p>Role: " + role + "</p>");
        
        if (!"doctor".equals(role)) {
            out.println("<p class='error'>This page is only for doctors. Your role is: " + role + "</p>");
            out.println("<p><a href='" + request.getContextPath() + "/index.jsp'>Go to Home</a></p>");
            out.println("</body></html>");
            return;
        }
        
        try {
            // Step 1: Get the doctor ID from the database
            int doctorId = -1;
            
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement("SELECT id FROM users WHERE username = ? AND LOWER(role) = 'doctor'")) {
                
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    doctorId = rs.getInt("id");
                    out.println("<p class='success'>Found doctor ID: " + doctorId + "</p>");
                    
                    // Store the doctor ID in the session
                    session.setAttribute("userId", doctorId);
                    out.println("<p class='success'>Stored doctor ID in session</p>");
                } else {
                    out.println("<p class='error'>No doctor found with username: " + username + "</p>");
                    out.println("</body></html>");
                    return;
                }
            }
            
            // Step 2: Check if there are patients in the database
            int patientCount = 0;
            
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE LOWER(role) = 'patient'")) {
                
                if (rs.next()) {
                    patientCount = rs.getInt(1);
                    out.println("<p>Found " + patientCount + " patients in the database</p>");
                }
            }
            
            // Step 3: Create test patients if needed
            if (patientCount == 0) {
                out.println("<h2>Creating Test Patients</h2>");
                
                // Create test patients
                String[] patientNames = {"John Doe", "Jane Smith", "Robert Johnson", "Emily Davis", "Michael Wilson"};
                String[] patientUsernames = {"johndoe", "janesmith", "rjohnson", "edavis", "mwilson"};
                String[] patientEmails = {"john@example.com", "jane@example.com", "robert@example.com", "emily@example.com", "michael@example.com"};
                String[] patientPhones = {"123-456-7890", "123-456-7891", "123-456-7892", "123-456-7893", "123-456-7894"};
                String[] patientGenders = {"male", "female", "male", "female", "male"};
                String[] patientBloodGroups = {"O+", "A+", "B+", "AB+", "O-"};
                
                try (Connection conn = DatabaseConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(
                         "INSERT INTO users (name, username, password, email, phone, role, gender, date_of_birth, blood_group) " +
                         "VALUES (?, ?, ?, ?, ?, 'patient', ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                    
                    for (int i = 0; i < patientNames.length; i++) {
                        stmt.setString(1, patientNames[i]);
                        stmt.setString(2, patientUsernames[i]);
                        stmt.setString(3, "patient123"); // Simple password for testing
                        stmt.setString(4, patientEmails[i]);
                        stmt.setString(5, patientPhones[i]);
                        stmt.setString(6, patientGenders[i]);
                        stmt.setDate(7, new java.sql.Date(System.currentTimeMillis())); // Current date
                        stmt.setString(8, patientBloodGroups[i]);
                        
                        int rowsAffected = stmt.executeUpdate();
                        if (rowsAffected > 0) {
                            out.println("<p class='success'>Created patient: " + patientNames[i] + "</p>");
                        }
                    }
                }
                
                // Get the updated patient count
                try (Connection conn = DatabaseConnection.getConnection();
                     Statement countStmt = conn.createStatement();
                     ResultSet rs = countStmt.executeQuery("SELECT COUNT(*) FROM users WHERE LOWER(role) = 'patient'")) {
                    
                    if (rs.next()) {
                        patientCount = rs.getInt(1);
                        out.println("<p>Now have " + patientCount + " patients in the database</p>");
                    }
                }
            }
            
            // Step 4: Get patient IDs
            int[] patientIds = new int[5];
            int patientIndex = 0;
            
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT id FROM users WHERE LOWER(role) = 'patient' LIMIT 5")) {
                
                while (rs.next() && patientIndex < 5) {
                    patientIds[patientIndex++] = rs.getInt("id");
                }
            }
            
            if (patientIndex == 0) {
                out.println("<p class='error'>Failed to retrieve patient IDs</p>");
                out.println("</body></html>");
                return;
            }
            
            // Step 5: Check if there are departments in the database
            int departmentId = 1; // Default department ID
            
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT id FROM departments LIMIT 1")) {
                
                if (rs.next()) {
                    departmentId = rs.getInt("id");
                    out.println("<p>Using department ID: " + departmentId + "</p>");
                } else {
                    // Create a default department if none exists
                    try (Statement createStmt = conn.createStatement()) {
                        createStmt.executeUpdate(
                            "INSERT INTO departments (name, description) VALUES ('General Medicine', 'General medical services')",
                            Statement.RETURN_GENERATED_KEYS);
                        
                        try (ResultSet keys = createStmt.getGeneratedKeys()) {
                            if (keys.next()) {
                                departmentId = keys.getInt(1);
                                out.println("<p class='success'>Created default department with ID: " + departmentId + "</p>");
                            }
                        }
                    }
                }
            }
            
            // Step 6: Create test appointments
            out.println("<h2>Creating Test Appointments</h2>");
            
            // Delete any existing appointments for this doctor to avoid duplicates
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement("DELETE FROM appointments WHERE doctor_id = ?")) {
                
                stmt.setInt(1, doctorId);
                int rowsDeleted = stmt.executeUpdate();
                out.println("<p>Deleted " + rowsDeleted + " existing appointments for doctor ID " + doctorId + "</p>");
            }
            
            // Create new appointments
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO appointments (patient_id, doctor_id, department_id, appointment_date, time_slot, status, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)")) {
                
                // Current date
                java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
                
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
                
                int appointmentsCreated = 0;
                
                for (int i = 0; i < Math.min(patientIndex, 5); i++) {
                    stmt.setInt(1, patientIds[i]);
                    stmt.setInt(2, doctorId);
                    stmt.setInt(3, departmentId);
                    
                    // Different dates: today, tomorrow, yesterday, day after tomorrow, two days ago
                    java.sql.Date appointmentDate = new java.sql.Date(today.getTime() + (i - 2) * 24 * 60 * 60 * 1000);
                    stmt.setDate(4, appointmentDate);
                    
                    stmt.setString(5, timeSlots[i]);
                    stmt.setString(6, statuses[i]);
                    stmt.setString(7, notes[i]);
                    
                    int rowsAffected = stmt.executeUpdate();
                    if (rowsAffected > 0) {
                        appointmentsCreated++;
                        out.println("<p class='success'>Created appointment for patient ID " + patientIds[i] + " on " + appointmentDate + "</p>");
                    }
                }
                
                out.println("<p>Successfully created " + appointmentsCreated + " appointments</p>");
            }
            
            // Step 7: Verify appointments were created
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM appointments WHERE doctor_id = ?")) {
                
                stmt.setInt(1, doctorId);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    int count = rs.getInt(1);
                    out.println("<p class='success'>Verified " + count + " appointments for doctor ID " + doctorId + "</p>");
                }
            }
            
            out.println("<h2>All Done!</h2>");
            out.println("<p>The system has been fixed. You should now see patients in your dashboard.</p>");
            out.println("<p><a href='" + request.getContextPath() + "/doctor/patients'>Go to My Patients</a></p>");
            
        } catch (Exception e) {
            out.println("<h2 class='error'>Error</h2>");
            out.println("<p class='error'>" + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
        
        out.println("</body>");
        out.println("</html>");
    }
}
