package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.Department;
import dao.UserDAO;
import dao.DepartmentDAO;
import dao.DoctorDepartmentDAO;
import dao.AppointmentDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import util.DatabaseConnection;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is an admin
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if ("admin".equals(user.getRole())) {
                // Get counts from database
                int patientCount = getPatientCount();
                int doctorCount = getDoctorCount();
                int appointmentCount = getAppointmentCount();
                int departmentCount = getDepartmentCount();

                // Get recent data from database
                List<Map<String, Object>> recentDoctors = getRecentDoctors();
                List<Map<String, Object>> recentAppointments = getRecentAppointments();

                // Set counts as request attributes
                request.setAttribute("patientCount", patientCount);
                request.setAttribute("doctorCount", doctorCount);
                request.setAttribute("appointmentCount", appointmentCount);
                request.setAttribute("departmentCount", departmentCount);
                request.setAttribute("recentDoctors", recentDoctors);
                request.setAttribute("recentAppointments", recentAppointments);

                // Forward to admin dashboard
                RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/dashboard.jsp");
                dispatcher.forward(request, response);
                return;
            }
        }

        // If not logged in or not an admin, redirect to login
        response.sendRedirect(request.getContextPath() + "/login");
    }

    private int getPatientCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'patient'";
        return getCountFromDatabase(sql);
    }

    private int getDoctorCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE LOWER(role) = 'doctor' OR LOWER(role) = 'Doctor'";
        int count = getCountFromDatabase(sql);
        System.out.println("Doctor count from getDoctorCount(): " + count);

        // Double-check by directly querying and printing all doctors
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT id, name, role FROM users WHERE LOWER(role) = 'doctor' OR LOWER(role) = 'Doctor'")) {

            System.out.println("Listing all doctors in the database:");
            int directCount = 0;
            while (rs.next()) {
                directCount++;
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String role = rs.getString("role");
                System.out.println("Doctor #" + directCount + ": ID=" + id + ", Name=" + name + ", Role=" + role);
            }
            System.out.println("Total doctors found (direct query): " + directCount);

        } catch (SQLException e) {
            System.out.println("Error listing all doctors: " + e.getMessage());
            e.printStackTrace();
        }

        return count;
    }

    private int getAppointmentCount() {
        String sql = "SELECT COUNT(*) FROM appointments";
        return getCountFromDatabase(sql);
    }

    private int getDepartmentCount() {
        String sql = "SELECT COUNT(*) FROM departments";
        return getCountFromDatabase(sql);
    }

    private int getCountFromDatabase(String sql) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.out.println("Error getting count from database: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    private List<Map<String, Object>> getRecentDoctors() {
        List<Map<String, Object>> doctors = new ArrayList<>();
        DoctorDepartmentDAO doctorDepartmentDAO = new DoctorDepartmentDAO();
        DepartmentDAO departmentDAO = new DepartmentDAO();

        // Use a direct query to the users table to get all doctors
        String sql = "SELECT id, name, role FROM users WHERE LOWER(role) = 'doctor' OR LOWER(role) = 'Doctor' ORDER BY id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            System.out.println("Executing direct query for doctors: " + sql);

            int count = 0;
            while (rs.next() && count < 5) { // Limit to 5 doctors
                count++;
                Map<String, Object> doctor = new HashMap<>();
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String role = rs.getString("role");

                // Get the department for this doctor
                int departmentId = doctorDepartmentDAO.getDepartmentIdForDoctor(id);
                String departmentName = "General";

                if (departmentId > 0) {
                    Department department = departmentDAO.getDepartmentById(departmentId);
                    if (department != null) {
                        departmentName = department.getName();
                    }
                }

                doctor.put("id", id);
                doctor.put("name", name);
                doctor.put("department", departmentName);
                doctor.put("status", "Active");

                System.out.println("Adding doctor: ID=" + id + ", Name=" + name + ", Department=" + departmentName);
                doctors.add(doctor);
            }

            System.out.println("Total doctors added: " + count);

            // If no doctors found, try the fallback method
            if (count == 0) {
                System.out.println("No doctors found with direct query. Trying fallback method...");
                doctors = getRecentDoctorsWithJoin();
            }

        } catch (SQLException e) {
            System.out.println("Error in direct doctor query: " + e.getMessage());
            e.printStackTrace();

            // Fallback to the join method if there's an error
            doctors = getRecentDoctorsWithJoin();
        }

        return doctors;
    }

    private List<Map<String, Object>> getRecentDoctorsWithJoin() {
        List<Map<String, Object>> doctors = new ArrayList<>();

        // Join with doctor_departments and departments to get department names
        String sql = "SELECT u.id, u.name, d.name as department_name " +
                     "FROM users u " +
                     "LEFT JOIN doctor_departments dd ON u.id = dd.doctor_id " +
                     "LEFT JOIN departments d ON dd.department_id = d.id " +
                     "WHERE LOWER(u.role) = 'doctor' OR LOWER(u.role) = 'Doctor' " +
                     "ORDER BY u.id DESC LIMIT 5";

        System.out.println("Executing SQL with JOIN for doctors: " + sql);

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            int count = 0;
            while (rs.next()) {
                count++;
                Map<String, Object> doctor = new HashMap<>();
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String departmentName = rs.getString("department_name");

                doctor.put("id", id);
                doctor.put("name", name);
                doctor.put("department", departmentName != null ? departmentName : "General");
                doctor.put("status", "Active");

                System.out.println("Added doctor from JOIN: ID=" + id + ", Name=" + name + ", Department=" + departmentName);
                doctors.add(doctor);
            }

            System.out.println("Total doctors added from JOIN: " + count);

        } catch (SQLException e) {
            System.out.println("Error getting doctors with JOIN: " + e.getMessage());
            e.printStackTrace();

            // Last resort fallback - just add doctors without department info
            doctors = getRecentDoctorsSimple();
        }

        return doctors;
    }

    private List<Map<String, Object>> getRecentDoctorsSimple() {
        List<Map<String, Object>> doctors = new ArrayList<>();

        // Simple query to get doctors without department info
        String sql = "SELECT id, name FROM users WHERE LOWER(role) = 'doctor' OR LOWER(role) = 'Doctor' ORDER BY id DESC LIMIT 5";

        System.out.println("Executing simple SQL for doctors: " + sql);

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            int count = 0;
            while (rs.next()) {
                count++;
                Map<String, Object> doctor = new HashMap<>();
                int id = rs.getInt("id");
                String name = rs.getString("name");

                doctor.put("id", id);
                doctor.put("name", name);
                doctor.put("department", "Not Available"); // Indicate that department info is not available
                doctor.put("status", "Active");

                System.out.println("Added doctor (simple query): ID=" + id + ", Name=" + name);
                doctors.add(doctor);
            }

            System.out.println("Total doctors added (simple query): " + count);

        } catch (SQLException e) {
            System.out.println("Error getting doctors with simple query: " + e.getMessage());
            e.printStackTrace();
        }

        return doctors;
    }

    private List<Map<String, Object>> getRecentAppointments() {
        List<Map<String, Object>> appointments = new ArrayList<>();
        String sql = "SELECT a.id, p.name as patient_name, d.name as doctor_name, dept.name as department_name, " +
                     "a.appointment_date, a.status " +
                     "FROM appointments a " +
                     "LEFT JOIN users p ON a.patient_id = p.id " +
                     "LEFT JOIN users d ON a.doctor_id = d.id " +
                     "LEFT JOIN departments dept ON a.department_id = dept.id " +
                     "ORDER BY a.appointment_date DESC LIMIT 5";

        System.out.println("Executing SQL for recent appointments: " + sql);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            int count = 0;
            while (rs.next()) {
                count++;
                Map<String, Object> appointment = new HashMap<>();
                int id = rs.getInt("id");
                String patient = rs.getString("patient_name");
                String doctor = rs.getString("doctor_name");
                String department = rs.getString("department_name");
                java.sql.Date date = rs.getDate("appointment_date");
                String status = rs.getString("status");

                appointment.put("id", id);
                appointment.put("patient", patient != null ? patient : "Unknown");
                appointment.put("doctor", doctor != null ? doctor : "Unknown");
                appointment.put("department", department != null ? department : "Unknown");
                appointment.put("date", date);
                appointment.put("status", status != null ? status : "scheduled");

                System.out.println("Found appointment: ID=" + id + ", Patient=" + patient + ", Doctor=" + doctor + ", Date=" + date);
                appointments.add(appointment);
            }

            System.out.println("Total appointments found: " + count);

            // If no appointments found with the join, try a simpler query
            if (count == 0) {
                System.out.println("No appointments found. Trying simpler query...");
                appointments = getRecentAppointmentsSimple();
            }

        } catch (SQLException e) {
            System.out.println("Error getting recent appointments: " + e.getMessage());
            e.printStackTrace();
            // Try the simpler query as fallback
            appointments = getRecentAppointmentsSimple();
        }

        return appointments;
    }

    private List<Map<String, Object>> getRecentAppointmentsSimple() {
        List<Map<String, Object>> appointments = new ArrayList<>();
        String sql = "SELECT id, appointment_date, status FROM appointments ORDER BY appointment_date DESC LIMIT 5";

        System.out.println("Executing simple SQL for recent appointments: " + sql);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            int count = 0;
            while (rs.next()) {
                count++;
                Map<String, Object> appointment = new HashMap<>();
                int id = rs.getInt("id");
                java.sql.Date date = rs.getDate("appointment_date");
                String status = rs.getString("status");

                appointment.put("id", id);
                appointment.put("patient", "Not Available");
                appointment.put("doctor", "Not Available");
                appointment.put("department", "Not Available");
                appointment.put("date", date);
                appointment.put("status", status != null ? status : "scheduled");

                System.out.println("Found appointment (simple query): ID=" + id + ", Date=" + date);
                appointments.add(appointment);
            }

            System.out.println("Total appointments found (simple query): " + count);

        } catch (SQLException e) {
            System.out.println("Error getting recent appointments with simple query: " + e.getMessage());
            e.printStackTrace();
        }

        return appointments;
    }
}
