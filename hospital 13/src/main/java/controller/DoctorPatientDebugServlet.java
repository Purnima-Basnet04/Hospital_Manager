package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.DatabaseConnection;
import dao.UserDAO;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/doctor/debug-patients")
public class DoctorPatientDebugServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Doctor Patient Debug</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println("h1, h2 { color: #333; }");
        out.println("table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }");
        out.println("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
        out.println("th { background-color: #f2f2f2; }");
        out.println("tr:nth-child(even) { background-color: #f9f9f9; }");
        out.println("pre { background-color: #f5f5f5; padding: 10px; border-radius: 5px; overflow-x: auto; }");
        out.println(".success { color: green; }");
        out.println(".error { color: red; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        out.println("<h1>Doctor Patient Debug</h1>");
        
        // Get session information
        HttpSession session = request.getSession(false);
        Integer userId = null;
        String username = null;
        String role = null;
        
        if (session != null) {
            userId = (Integer) session.getAttribute("userId");
            username = (String) session.getAttribute("username");
            role = (String) session.getAttribute("role");
            
            out.println("<h2>Session Information</h2>");
            out.println("<table>");
            out.println("<tr><th>Attribute</th><th>Value</th></tr>");
            out.println("<tr><td>userId</td><td>" + userId + "</td></tr>");
            out.println("<tr><td>username</td><td>" + username + "</td></tr>");
            out.println("<tr><td>role</td><td>" + role + "</td></tr>");
            out.println("</table>");
            
            // If userId is null, try to get it from the user object
            if (userId == null && session.getAttribute("user") != null) {
                User user = (User) session.getAttribute("user");
                userId = user.getId();
                out.println("<p>Retrieved userId from user object: " + userId + "</p>");
            }
        } else {
            out.println("<p class='error'>No active session found.</p>");
        }
        
        // Test database connection
        out.println("<h2>Database Connection Test</h2>");
        try {
            Connection conn = DatabaseConnection.getConnection();
            out.println("<p class='success'>Database connection successful!</p>");
            
            // Check if the doctor exists
            if (userId != null) {
                String doctorSql = "SELECT * FROM users WHERE id = ? AND LOWER(role) = 'doctor'";
                try (PreparedStatement stmt = conn.prepareStatement(doctorSql)) {
                    stmt.setInt(1, userId);
                    ResultSet rs = stmt.executeQuery();
                    
                    if (rs.next()) {
                        out.println("<p class='success'>Doctor found in database:</p>");
                        out.println("<table>");
                        out.println("<tr><th>ID</th><th>Name</th><th>Username</th><th>Email</th><th>Role</th></tr>");
                        out.println("<tr>");
                        out.println("<td>" + rs.getInt("id") + "</td>");
                        out.println("<td>" + rs.getString("name") + "</td>");
                        out.println("<td>" + rs.getString("username") + "</td>");
                        out.println("<td>" + rs.getString("email") + "</td>");
                        out.println("<td>" + rs.getString("role") + "</td>");
                        out.println("</tr>");
                        out.println("</table>");
                    } else {
                        out.println("<p class='error'>No doctor found with ID: " + userId + "</p>");
                    }
                }
            } else {
                out.println("<p class='error'>No user ID available to check.</p>");
            }
            
            // Check appointments table
            out.println("<h2>Appointments Table Check</h2>");
            try {
                String countSql = "SELECT COUNT(*) FROM appointments";
                try (PreparedStatement stmt = conn.prepareStatement(countSql)) {
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        out.println("<p>Total appointments in database: " + count + "</p>");
                    }
                }
                
                if (userId != null) {
                    String doctorAppointmentsSql = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(doctorAppointmentsSql)) {
                        stmt.setInt(1, userId);
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next()) {
                            int count = rs.getInt(1);
                            out.println("<p>Appointments for doctor ID " + userId + ": " + count + "</p>");
                            
                            if (count == 0) {
                                out.println("<p class='error'>No appointments found for this doctor. This is why no patients are showing up.</p>");
                            }
                        }
                    }
                    
                    // Show all appointments for this doctor
                    String appointmentsSql = "SELECT a.*, p.name as patient_name, d.name as doctor_name " +
                                            "FROM appointments a " +
                                            "JOIN users p ON a.patient_id = p.id " +
                                            "JOIN users d ON a.doctor_id = d.id " +
                                            "WHERE a.doctor_id = ? " +
                                            "ORDER BY a.appointment_date DESC";
                    try (PreparedStatement stmt = conn.prepareStatement(appointmentsSql)) {
                        stmt.setInt(1, userId);
                        ResultSet rs = stmt.executeQuery();
                        
                        out.println("<h3>Appointments for Doctor ID " + userId + "</h3>");
                        out.println("<table>");
                        out.println("<tr><th>ID</th><th>Patient</th><th>Date</th><th>Time</th><th>Status</th></tr>");
                        
                        boolean hasAppointments = false;
                        while (rs.next()) {
                            hasAppointments = true;
                            out.println("<tr>");
                            out.println("<td>" + rs.getInt("id") + "</td>");
                            out.println("<td>" + rs.getString("patient_name") + "</td>");
                            out.println("<td>" + rs.getDate("appointment_date") + "</td>");
                            out.println("<td>" + rs.getString("time_slot") + "</td>");
                            out.println("<td>" + rs.getString("status") + "</td>");
                            out.println("</tr>");
                        }
                        
                        if (!hasAppointments) {
                            out.println("<tr><td colspan='5'>No appointments found</td></tr>");
                        }
                        
                        out.println("</table>");
                    }
                }
            } catch (SQLException e) {
                out.println("<p class='error'>Error checking appointments: " + e.getMessage() + "</p>");
                out.println("<pre>");
                e.printStackTrace(out);
                out.println("</pre>");
            }
            
            // Check patients
            out.println("<h2>Patients Check</h2>");
            try {
                String countSql = "SELECT COUNT(*) FROM users WHERE LOWER(role) = 'patient'";
                try (PreparedStatement stmt = conn.prepareStatement(countSql)) {
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        out.println("<p>Total patients in database: " + count + "</p>");
                        
                        if (count == 0) {
                            out.println("<p class='error'>No patients found in the database. This is why no patients are showing up.</p>");
                        }
                    }
                }
                
                // Show all patients
                String patientsSql = "SELECT * FROM users WHERE LOWER(role) = 'patient' ORDER BY name LIMIT 10";
                try (PreparedStatement stmt = conn.prepareStatement(patientsSql)) {
                    ResultSet rs = stmt.executeQuery();
                    
                    out.println("<h3>Sample Patients (up to 10)</h3>");
                    out.println("<table>");
                    out.println("<tr><th>ID</th><th>Name</th><th>Username</th><th>Email</th></tr>");
                    
                    boolean hasPatients = false;
                    while (rs.next()) {
                        hasPatients = true;
                        out.println("<tr>");
                        out.println("<td>" + rs.getInt("id") + "</td>");
                        out.println("<td>" + rs.getString("name") + "</td>");
                        out.println("<td>" + rs.getString("username") + "</td>");
                        out.println("<td>" + rs.getString("email") + "</td>");
                        out.println("</tr>");
                    }
                    
                    if (!hasPatients) {
                        out.println("<tr><td colspan='4'>No patients found</td></tr>");
                    }
                    
                    out.println("</table>");
                }
            } catch (SQLException e) {
                out.println("<p class='error'>Error checking patients: " + e.getMessage() + "</p>");
                out.println("<pre>");
                e.printStackTrace(out);
                out.println("</pre>");
            }
            
            // Test UserDAO.getPatientsByDoctorId
            if (userId != null) {
                out.println("<h2>Testing UserDAO.getPatientsByDoctorId</h2>");
                UserDAO userDAO = new UserDAO();
                List<User> patients = userDAO.getPatientsByDoctorId(userId);
                
                out.println("<p>Found " + (patients != null ? patients.size() : 0) + " patients for doctor ID " + userId + "</p>");
                
                if (patients != null && !patients.isEmpty()) {
                    out.println("<table>");
                    out.println("<tr><th>ID</th><th>Name</th><th>Username</th><th>Email</th></tr>");
                    
                    for (User patient : patients) {
                        out.println("<tr>");
                        out.println("<td>" + patient.getId() + "</td>");
                        out.println("<td>" + patient.getName() + "</td>");
                        out.println("<td>" + patient.getUsername() + "</td>");
                        out.println("<td>" + patient.getEmail() + "</td>");
                        out.println("</tr>");
                    }
                    
                    out.println("</table>");
                } else {
                    out.println("<p class='error'>No patients returned from UserDAO.getPatientsByDoctorId</p>");
                }
            }
            
        } catch (SQLException e) {
            out.println("<p class='error'>Database connection error: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
        
        // Add a button to create test appointments
        out.println("<h2>Create Test Appointments</h2>");
        out.println("<p>If no appointments are found, you can create test appointments to establish doctor-patient relationships:</p>");
        out.println("<form action='create-test-appointments' method='post'>");
        out.println("<input type='submit' value='Create Test Appointments'>");
        out.println("</form>");
        
        out.println("<p><a href='dashboard'>Return to Dashboard</a></p>");
        
        out.println("</body>");
        out.println("</html>");
    }
}
