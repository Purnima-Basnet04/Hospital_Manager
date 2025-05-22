package controller;

import util.DatabaseConnection;

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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/add-prescriptions")
public class AddPrescriptionsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Add Prescriptions</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println("h1, h2 { color: #333; }");
        out.println(".success { color: green; }");
        out.println(".error { color: red; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        out.println("<h1>Add Prescriptions</h1>");
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Check if prescriptions table exists
            boolean tableExists = false;
            try (ResultSet rs = conn.getMetaData().getTables(null, null, "prescriptions", null)) {
                tableExists = rs.next();
            }
            
            if (!tableExists) {
                out.println("<p class='error'>Prescriptions table does not exist. Please initialize the database first.</p>");
            } else {
                // Get doctor IDs
                List<Integer> doctorIds = new ArrayList<>();
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT id FROM users WHERE LOWER(role) = 'doctor'")) {
                    while (rs.next()) {
                        doctorIds.add(rs.getInt("id"));
                    }
                }
                
                if (doctorIds.isEmpty()) {
                    out.println("<p class='error'>No doctors found in the database.</p>");
                } else {
                    // Get patient IDs
                    List<Integer> patientIds = new ArrayList<>();
                    try (Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT id FROM users WHERE LOWER(role) = 'patient'")) {
                        while (rs.next()) {
                            patientIds.add(rs.getInt("id"));
                        }
                    }
                    
                    if (patientIds.isEmpty()) {
                        out.println("<p class='error'>No patients found in the database.</p>");
                    } else {
                        // Add sample prescriptions
                        String[] medications = {
                            "Amoxicillin", "Lisinopril", "Atorvastatin", "Albuterol", 
                            "Metformin", "Omeprazole", "Levothyroxine", "Amlodipine",
                            "Metoprolol", "Gabapentin", "Hydrochlorothiazide", "Sertraline"
                        };
                        
                        String[] dosages = {
                            "500mg", "10mg", "20mg", "2 puffs", 
                            "1000mg", "40mg", "100mcg", "5mg",
                            "50mg", "300mg", "25mg", "50mg"
                        };
                        
                        String[] frequencies = {
                            "Three times daily", "Once daily", "Once daily at bedtime", "Every 4-6 hours as needed",
                            "Twice daily with meals", "Once daily before breakfast", "Once daily in the morning", "Once daily",
                            "Twice daily", "Three times daily", "Once daily in the morning", "Once daily"
                        };
                        
                        String[] durations = {
                            "7 days", "30 days", "30 days", "30 days",
                            "90 days", "14 days", "30 days", "30 days",
                            "30 days", "14 days", "30 days", "30 days"
                        };
                        
                        String[] notes = {
                            "Take with food. Complete the full course even if you feel better.",
                            "Take in the morning. Monitor blood pressure regularly.",
                            "Take at night. Avoid grapefruit juice.",
                            "Use as needed for shortness of breath or wheezing.",
                            "Take with meals to reduce stomach upset.",
                            "Take on an empty stomach, 30 minutes before breakfast.",
                            "Take on an empty stomach, 30-60 minutes before breakfast.",
                            "May cause dizziness. Monitor blood pressure.",
                            "Do not stop taking suddenly. May cause drowsiness.",
                            "May cause drowsiness. Avoid alcohol.",
                            "May increase urination. Take in the morning.",
                            "May take 2-4 weeks to feel full effects. Do not stop suddenly."
                        };
                        
                        String[] statuses = {"Active", "Completed", "Active", "Cancelled", "Active", "Completed"};
                        
                        // Prepare the insert statement
                        String sql = "INSERT INTO prescriptions (patient_id, doctor_id, medication, dosage, frequency, duration, notes, status, prescription_date) " +
                                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, DATE_SUB(NOW(), INTERVAL ? DAY))";
                        
                        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                            int count = 0;
                            
                            // Add multiple prescriptions
                            for (int i = 0; i < 10; i++) {
                                int patientId = patientIds.get(i % patientIds.size());
                                int doctorId = doctorIds.get(i % doctorIds.size());
                                String medication = medications[i % medications.length];
                                String dosage = dosages[i % dosages.length];
                                String frequency = frequencies[i % frequencies.length];
                                String duration = durations[i % durations.length];
                                String note = notes[i % notes.length];
                                String status = statuses[i % statuses.length];
                                int days = i + 1;
                                
                                pstmt.setInt(1, patientId);
                                pstmt.setInt(2, doctorId);
                                pstmt.setString(3, medication);
                                pstmt.setString(4, dosage);
                                pstmt.setString(5, frequency);
                                pstmt.setString(6, duration);
                                pstmt.setString(7, note);
                                pstmt.setString(8, status);
                                pstmt.setInt(9, days);
                                
                                pstmt.addBatch();
                                count++;
                            }
                            
                            int[] results = pstmt.executeBatch();
                            int successCount = 0;
                            for (int result : results) {
                                if (result > 0) {
                                    successCount++;
                                }
                            }
                            
                            out.println("<p class='success'>Successfully added " + successCount + " out of " + count + " prescriptions.</p>");
                        }
                    }
                }
            }
        } catch (Exception e) {
            out.println("<h2 class='error'>Error adding prescriptions</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        
        out.println("<p><a href='view-database'>View Database</a></p>");
        out.println("<p><a href='index.jsp'>Back to Home</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
}
