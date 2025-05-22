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
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/view-patients")
public class ViewPatientsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>All Patients</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println("h1, h2 { color: #333; }");
        out.println("table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }");
        out.println("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
        out.println("th { background-color: #f2f2f2; }");
        out.println("tr:nth-child(even) { background-color: #f9f9f9; }");
        out.println(".btn { display: inline-block; padding: 8px 15px; background-color: #007bff; color: #fff; text-decoration: none; border-radius: 4px; margin-right: 5px; }");
        out.println(".btn:hover { background-color: #0069d9; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        out.println("<h1>All Patients in Database</h1>");
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Get all patients
            String sql = "SELECT * FROM users WHERE LOWER(role) = 'patient'";
            ResultSet rs = stmt.executeQuery(sql);
            
            out.println("<table>");
            out.println("<tr>");
            out.println("<th>ID</th>");
            out.println("<th>Username</th>");
            out.println("<th>Name</th>");
            out.println("<th>Email</th>");
            out.println("<th>Phone</th>");
            out.println("<th>Gender</th>");
            out.println("<th>Date of Birth</th>");
            out.println("<th>Blood Group</th>");
            out.println("<th>Address</th>");
            out.println("<th>Actions</th>");
            out.println("</tr>");
            
            int count = 0;
            while (rs.next()) {
                count++;
                int id = rs.getInt("id");
                String username = rs.getString("username");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String phone = rs.getString("phone");
                String gender = rs.getString("gender");
                String dob = rs.getDate("date_of_birth") != null ? rs.getDate("date_of_birth").toString() : "N/A";
                String bloodGroup = rs.getString("blood_group");
                String address = rs.getString("address");
                
                out.println("<tr>");
                out.println("<td>" + id + "</td>");
                out.println("<td>" + (username != null ? username : "N/A") + "</td>");
                out.println("<td>" + (name != null ? name : "N/A") + "</td>");
                out.println("<td>" + (email != null ? email : "N/A") + "</td>");
                out.println("<td>" + (phone != null ? phone : "N/A") + "</td>");
                out.println("<td>" + (gender != null ? gender : "N/A") + "</td>");
                out.println("<td>" + dob + "</td>");
                out.println("<td>" + (bloodGroup != null ? bloodGroup : "N/A") + "</td>");
                out.println("<td>" + (address != null ? address : "N/A") + "</td>");
                out.println("<td>");
                out.println("<a href='doctor/view-patient?id=" + id + "' class='btn'>View</a>");
                out.println("<a href='doctor/prescriptions?patient=" + id + "&tab=new' class='btn'>Prescribe</a>");
                out.println("</td>");
                out.println("</tr>");
            }
            
            out.println("</table>");
            out.println("<p>Total patients: " + count + "</p>");
            
            // Now check prescriptions
            out.println("<h2>Prescriptions in Database</h2>");
            sql = "SELECT p.*, u1.name as patient_name, u2.name as doctor_name " +
                  "FROM prescriptions p " +
                  "LEFT JOIN users u1 ON p.patient_id = u1.id " +
                  "LEFT JOIN users u2 ON p.doctor_id = u2.id";
            rs = stmt.executeQuery(sql);
            
            out.println("<table>");
            out.println("<tr>");
            out.println("<th>ID</th>");
            out.println("<th>Patient ID</th>");
            out.println("<th>Patient Name</th>");
            out.println("<th>Doctor ID</th>");
            out.println("<th>Doctor Name</th>");
            out.println("<th>Medication</th>");
            out.println("<th>Status</th>");
            out.println("<th>Date</th>");
            out.println("<th>Actions</th>");
            out.println("</tr>");
            
            count = 0;
            while (rs.next()) {
                count++;
                int id = rs.getInt("id");
                int patientId = rs.getInt("patient_id");
                String patientName = rs.getString("patient_name");
                int doctorId = rs.getInt("doctor_id");
                String doctorName = rs.getString("doctor_name");
                String medication = rs.getString("medication");
                String status = rs.getString("status");
                String date = rs.getTimestamp("prescription_date") != null ? rs.getTimestamp("prescription_date").toString() : "N/A";
                
                out.println("<tr>");
                out.println("<td>" + id + "</td>");
                out.println("<td>" + patientId + "</td>");
                out.println("<td>" + (patientName != null ? patientName : "N/A") + "</td>");
                out.println("<td>" + doctorId + "</td>");
                out.println("<td>" + (doctorName != null ? doctorName : "N/A") + "</td>");
                out.println("<td>" + (medication != null ? medication : "N/A") + "</td>");
                out.println("<td>" + (status != null ? status : "N/A") + "</td>");
                out.println("<td>" + date + "</td>");
                out.println("<td>");
                out.println("<a href='doctor/view-prescription?id=" + id + "' class='btn'>View</a>");
                out.println("<a href='doctor/edit-prescription?id=" + id + "' class='btn'>Edit</a>");
                out.println("</td>");
                out.println("</tr>");
            }
            
            out.println("</table>");
            out.println("<p>Total prescriptions: " + count + "</p>");
            
        } catch (Exception e) {
            out.println("<h2>Error retrieving patients</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        
        out.println("<p><a href='index.jsp' class='btn'>Back to Home</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
}
