package controller;

import dao.AppointmentDAO;
import dao.UserDAO;
import dao.DepartmentDAO;
import model.Appointment;
import model.User;
import model.Department;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import util.DatabaseConnection;

@WebServlet("/admin/insert-test-appointments")
public class InsertTestAppointmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Insert Test Appointments</title></head><body>");
        out.println("<h1>Insert Test Appointments</h1>");
        
        try {
            // First, check if the appointments table exists
            boolean tableExists = false;
            try (Connection conn = DatabaseConnection.getConnection()) {
                ResultSet tables = conn.getMetaData().getTables(null, null, "appointments", null);
                tableExists = tables.next();
            }
            
            if (!tableExists) {
                out.println("<p>Creating appointments table...</p>");
                try (Connection conn = DatabaseConnection.getConnection();
                     Statement stmt = conn.createStatement()) {
                    
                    String createTable = "CREATE TABLE IF NOT EXISTS appointments (" +
                                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                                        "patient_id INT NOT NULL, " +
                                        "doctor_id INT NOT NULL, " +
                                        "department_id INT NOT NULL, " +
                                        "appointment_date DATE NOT NULL, " +
                                        "time_slot VARCHAR(20) NOT NULL, " +
                                        "status VARCHAR(20) NOT NULL DEFAULT 'Scheduled', " +
                                        "notes TEXT, " +
                                        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                                        "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)";
                    
                    stmt.executeUpdate(createTable);
                    out.println("<p>Appointments table created successfully.</p>");
                }
            } else {
                out.println("<p>Appointments table already exists.</p>");
            }
            
            // Check if there are any appointments
            int appointmentCount = 0;
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM appointments")) {
                
                if (rs.next()) {
                    appointmentCount = rs.getInt(1);
                }
            }
            
            out.println("<p>Current appointment count: " + appointmentCount + "</p>");
            
            // Get patients and doctors
            UserDAO userDAO = new UserDAO();
            List<User> patients = userDAO.getUsersByRole("patient");
            List<User> doctors = userDAO.getUsersByRole("doctor");
            
            // Get departments
            DepartmentDAO departmentDAO = new DepartmentDAO();
            List<Department> departments = departmentDAO.getAllDepartments();
            
            out.println("<p>Found " + patients.size() + " patients, " + doctors.size() + " doctors, and " + departments.size() + " departments.</p>");
            
            if (patients.isEmpty() || doctors.isEmpty() || departments.isEmpty()) {
                out.println("<p>Cannot insert test appointments: Need at least one patient, one doctor, and one department.</p>");
                return;
            }
            
            // Insert test appointments
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                     "INSERT INTO appointments (patient_id, doctor_id, department_id, appointment_date, time_slot, status, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)"
                 )) {
                
                // Get IDs for test data
                int patientId = patients.get(0).getId();
                int doctorId = doctors.get(0).getId();
                int departmentId = departments.get(0).getId();
                
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
                
                int insertedCount = 0;
                
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
                    
                    int rowsAffected = pstmt.executeUpdate();
                    if (rowsAffected > 0) {
                        insertedCount++;
                    }
                }
                
                out.println("<p>Successfully inserted " + insertedCount + " test appointments.</p>");
            }
            
            // Verify the appointments were inserted
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM appointments")) {
                
                if (rs.next()) {
                    int newCount = rs.getInt(1);
                    out.println("<p>New appointment count: " + newCount + "</p>");
                }
            }
            
            // Show all appointments
            out.println("<h2>All Appointments</h2>");
            out.println("<table border='1'>");
            out.println("<tr><th>ID</th><th>Patient</th><th>Doctor</th><th>Department</th><th>Date</th><th>Time</th><th>Status</th><th>Notes</th></tr>");
            
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(
                     "SELECT a.*, p.name as patient_name, d.name as doctor_name, dept.name as department_name " +
                     "FROM appointments a " +
                     "LEFT JOIN users p ON a.patient_id = p.id " +
                     "LEFT JOIN users d ON a.doctor_id = d.id " +
                     "LEFT JOIN departments dept ON a.department_id = dept.id " +
                     "ORDER BY a.appointment_date DESC"
                 )) {
                
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("id") + "</td>");
                    out.println("<td>" + rs.getString("patient_name") + "</td>");
                    out.println("<td>" + rs.getString("doctor_name") + "</td>");
                    out.println("<td>" + rs.getString("department_name") + "</td>");
                    out.println("<td>" + rs.getDate("appointment_date") + "</td>");
                    out.println("<td>" + rs.getString("time_slot") + "</td>");
                    out.println("<td>" + rs.getString("status") + "</td>");
                    out.println("<td>" + rs.getString("notes") + "</td>");
                    out.println("</tr>");
                }
            }
            
            out.println("</table>");
            
            out.println("<p><a href='" + request.getContextPath() + "/admin/appointments'>Go to Appointments Page</a></p>");
            
        } catch (SQLException e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        
        out.println("</body></html>");
    }
}
