package dao;

import model.Appointment;
import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    public boolean createAppointment(Appointment appointment) {
        String sql = "INSERT INTO appointments (patient_id, doctor_id, department_id, appointment_date, time_slot, status, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        System.out.println("AppointmentDAO: Creating appointment for patient ID " + appointment.getPatientId() +
                           " with doctor ID " + appointment.getDoctorId());

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, appointment.getPatientId());
            stmt.setInt(2, appointment.getDoctorId());
            stmt.setInt(3, appointment.getDepartmentId());
            stmt.setDate(4, new java.sql.Date(appointment.getAppointmentDate().getTime()));
            stmt.setString(5, appointment.getTimeSlot());
            stmt.setString(6, appointment.getStatus());
            stmt.setString(7, appointment.getNotes());

            System.out.println("AppointmentDAO: Executing insert with date=" + appointment.getAppointmentDate() +
                               ", time=" + appointment.getTimeSlot() + ", status=" + appointment.getStatus());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                // Get the generated ID
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    int id = rs.getInt(1);
                    appointment.setId(id);
                    System.out.println("AppointmentDAO: Appointment created with ID " + id);
                }
                return true;
            }

        } catch (SQLException e) {
            System.out.println("AppointmentDAO: Error creating appointment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }

        return false;
    }

    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        System.out.println("AppointmentDAO: Getting appointments for patient ID " + patientId);

        String sql = "SELECT a.*, u.name as doctor_name, d.name as department_name " +
                     "FROM appointments a " +
                     "LEFT JOIN users u ON a.doctor_id = u.id " +
                     "LEFT JOIN departments d ON a.department_id = d.id " +
                     "WHERE a.patient_id = ? " +
                     "ORDER BY a.appointment_date DESC";
        List<Appointment> appointments = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, patientId);
            System.out.println("AppointmentDAO: Executing query: " + sql.replace("?", String.valueOf(patientId)));

            ResultSet rs = stmt.executeQuery();
            int count = 0;

            while (rs.next()) {
                count++;
                Appointment appointment = new Appointment();
                int id = rs.getInt("id");
                int doctorId = rs.getInt("doctor_id");
                String doctorName = rs.getString("doctor_name");
                String departmentName = rs.getString("department_name");
                java.sql.Date appointmentDate = rs.getDate("appointment_date");
                String timeSlot = rs.getString("time_slot");
                String status = rs.getString("status");

                appointment.setId(id);
                appointment.setPatientId(patientId);
                appointment.setDoctorId(doctorId);
                appointment.setDepartmentId(rs.getInt("department_id"));
                appointment.setAppointmentDate(appointmentDate);
                appointment.setTimeSlot(timeSlot);
                appointment.setStatus(status);
                appointment.setNotes(rs.getString("notes"));
                appointment.setDoctorName(doctorName != null ? doctorName : "Unknown Doctor");
                appointment.setDepartmentName(departmentName != null ? departmentName : "General");

                System.out.println("AppointmentDAO: Found appointment: ID=" + id + ", Doctor=" + doctorName + ", Date=" + appointmentDate + ", Status=" + status);
                appointments.add(appointment);
            }

            System.out.println("AppointmentDAO: Total appointments found for patient: " + count);

        } catch (SQLException e) {
            System.out.println("AppointmentDAO: Error getting appointments for patient: " + e.getMessage());
            e.printStackTrace();
        }

        return appointments;
    }

    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        System.out.println("AppointmentDAO: Getting appointments for doctor ID " + doctorId);

        String sql = "SELECT a.*, u.name as patient_name, d.name as department_name " +
                     "FROM appointments a " +
                     "LEFT JOIN users u ON a.patient_id = u.id " +
                     "LEFT JOIN departments d ON a.department_id = d.id " +
                     "WHERE a.doctor_id = ? " +
                     "ORDER BY a.appointment_date DESC";
        List<Appointment> appointments = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, doctorId);
            System.out.println("AppointmentDAO: Executing query: " + sql.replace("?", String.valueOf(doctorId)));

            ResultSet rs = stmt.executeQuery();
            int count = 0;

            while (rs.next()) {
                count++;
                Appointment appointment = new Appointment();
                int id = rs.getInt("id");
                int patientId = rs.getInt("patient_id");
                String patientName = rs.getString("patient_name");
                String departmentName = rs.getString("department_name");
                java.sql.Date appointmentDate = rs.getDate("appointment_date");
                String timeSlot = rs.getString("time_slot");
                String status = rs.getString("status");

                appointment.setId(id);
                appointment.setPatientId(patientId);
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setDepartmentId(rs.getInt("department_id"));
                appointment.setAppointmentDate(appointmentDate);
                appointment.setTimeSlot(timeSlot);
                appointment.setStatus(status);
                appointment.setNotes(rs.getString("notes"));
                appointment.setPatientName(patientName != null ? patientName : "Unknown Patient");
                appointment.setDepartmentName(departmentName != null ? departmentName : "General");

                System.out.println("AppointmentDAO: Found appointment: ID=" + id + ", Patient=" + patientName + ", Date=" + appointmentDate + ", Status=" + status);
                appointments.add(appointment);
            }

            System.out.println("AppointmentDAO: Total appointments found: " + count);

        } catch (SQLException e) {
            System.out.println("AppointmentDAO: Error getting appointments: " + e.getMessage());
            e.printStackTrace();
        }

        return appointments;
    }

    public boolean updateAppointmentStatus(int appointmentId, String status) {
        System.out.println("AppointmentDAO: Updating appointment status for ID " + appointmentId + " to " + status);

        // Debug the status value
        System.out.println("AppointmentDAO: Status value details - length: " + status.length() +
                           ", bytes: " + bytesToHex(status.getBytes()) +
                           ", contains spaces: " + status.contains(" ") +
                           ", trimmed equals original: " + status.trim().equals(status));

        // Try first with updated_at column
        String sql = "UPDATE appointments SET status = ?, updated_at = NOW() WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, status);
                stmt.setInt(2, appointmentId);

                int rowsAffected = stmt.executeUpdate();
                boolean success = rowsAffected > 0;

                System.out.println("AppointmentDAO: Appointment status update " + (success ? "successful" : "failed") +
                                   ". Rows affected: " + rowsAffected);

                return success;
            } catch (SQLException e) {
                // If the first query fails (possibly due to missing updated_at column),
                // try a simpler query without the updated_at column
                System.out.println("AppointmentDAO: First update attempt failed, trying without updated_at: " + e.getMessage());

                String simpleSql = "UPDATE appointments SET status = ? WHERE id = ?";
                try (PreparedStatement simpleStmt = conn.prepareStatement(simpleSql)) {
                    simpleStmt.setString(1, status);
                    simpleStmt.setInt(2, appointmentId);

                    int rowsAffected = simpleStmt.executeUpdate();
                    boolean success = rowsAffected > 0;

                    System.out.println("AppointmentDAO: Simple appointment status update " + (success ? "successful" : "failed") +
                                       ". Rows affected: " + rowsAffected);

                    return success;
                }
            }
        } catch (SQLException e) {
            System.out.println("AppointmentDAO: Error updating appointment status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get all appointments from the database
     *
     * @return List of all appointments
     */
    public List<Appointment> getAllAppointments() {
        System.out.println("AppointmentDAO: Getting all appointments");

        // First, check if the appointments table exists
        try (Connection conn = DatabaseConnection.getConnection();
             Statement checkStmt = conn.createStatement()) {

            // Check if the appointments table exists
            ResultSet tables = conn.getMetaData().getTables(null, null, "appointments", null);
            if (!tables.next()) {
                System.out.println("AppointmentDAO: Appointments table does not exist");
                return new ArrayList<>();
            }

            // Check how many appointments are in the table
            ResultSet countRs = checkStmt.executeQuery("SELECT COUNT(*) FROM appointments");
            if (countRs.next()) {
                int totalCount = countRs.getInt(1);
                System.out.println("AppointmentDAO: Found " + totalCount + " appointments in the database");
            }

        } catch (SQLException e) {
            System.out.println("AppointmentDAO: Error checking appointments table: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }

        String sql = "SELECT a.*, p.name as patient_name, d.name as doctor_name, dept.name as department_name " +
                     "FROM appointments a " +
                     "LEFT JOIN users p ON a.patient_id = p.id " +
                     "LEFT JOIN users d ON a.doctor_id = d.id " +
                     "LEFT JOIN departments dept ON a.department_id = dept.id " +
                     "ORDER BY a.appointment_date DESC";
        List<Appointment> appointments = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            int count = 0;
            while (rs.next()) {
                count++;
                Appointment appointment = new Appointment();
                int id = rs.getInt("id");
                int patientId = rs.getInt("patient_id");
                int doctorId = rs.getInt("doctor_id");
                String patientName = rs.getString("patient_name");
                String doctorName = rs.getString("doctor_name");
                String departmentName = rs.getString("department_name");
                java.sql.Date appointmentDate = rs.getDate("appointment_date");
                String timeSlot = rs.getString("time_slot");
                String status = rs.getString("status");

                appointment.setId(id);
                appointment.setPatientId(patientId);
                appointment.setDoctorId(doctorId);
                appointment.setDepartmentId(rs.getInt("department_id"));
                appointment.setAppointmentDate(appointmentDate);
                appointment.setTimeSlot(timeSlot);
                appointment.setStatus(status);
                appointment.setNotes(rs.getString("notes"));
                appointment.setPatientName(patientName != null ? patientName : "Unknown Patient");
                appointment.setDoctorName(doctorName != null ? doctorName : "Unknown Doctor");
                appointment.setDepartmentName(departmentName != null ? departmentName : "General");

                System.out.println("AppointmentDAO: Found appointment: ID=" + id + ", Patient=" + patientName + ", Doctor=" + doctorName + ", Date=" + appointmentDate);
                appointments.add(appointment);
            }

            System.out.println("AppointmentDAO: Total appointments found: " + count);

            // Print a summary of all appointments for debugging
            if (count > 0) {
                System.out.println("AppointmentDAO: Appointments summary:");
                for (Appointment appointment : appointments) {
                    System.out.println("  - ID=" + appointment.getId() +
                                     ", Patient=" + appointment.getPatientName() +
                                     ", Doctor=" + appointment.getDoctorName() +
                                     ", Date=" + appointment.getAppointmentDate() +
                                     ", Status=" + appointment.getStatus());
                }
            } else {
                System.out.println("AppointmentDAO: No appointments found in the database");
            }

        } catch (SQLException e) {
            System.out.println("AppointmentDAO: Error getting all appointments: " + e.getMessage());
            e.printStackTrace();
        }

        return appointments;
    }

    /**
     * Get an appointment by its ID
     *
     * @param id The ID of the appointment to retrieve
     * @return The appointment, or null if not found
     */
    public Appointment getAppointmentById(int id) {
        System.out.println("AppointmentDAO: Getting appointment with ID " + id);

        String sql = "SELECT a.*, p.name as patient_name, d.name as doctor_name, dept.name as department_name " +
                     "FROM appointments a " +
                     "LEFT JOIN users p ON a.patient_id = p.id " +
                     "LEFT JOIN users d ON a.doctor_id = d.id " +
                     "LEFT JOIN departments dept ON a.department_id = dept.id " +
                     "WHERE a.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setDepartmentId(rs.getInt("department_id"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setTimeSlot(rs.getString("time_slot"));
                appointment.setStatus(rs.getString("status"));
                appointment.setNotes(rs.getString("notes"));
                appointment.setPatientName(rs.getString("patient_name") != null ? rs.getString("patient_name") : "Unknown Patient");
                appointment.setDoctorName(rs.getString("doctor_name") != null ? rs.getString("doctor_name") : "Unknown Doctor");
                appointment.setDepartmentName(rs.getString("department_name") != null ? rs.getString("department_name") : "General");
                appointment.setCreatedAt(rs.getTimestamp("created_at"));
                appointment.setUpdatedAt(rs.getTimestamp("updated_at"));

                System.out.println("AppointmentDAO: Found appointment with ID " + id);
                return appointment;
            }

            System.out.println("AppointmentDAO: No appointment found with ID " + id);
            return null;

        } catch (SQLException e) {
            System.out.println("AppointmentDAO: Error getting appointment by ID: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Cancel an appointment
     *
     * @param id The ID of the appointment to cancel
     * @return true if the cancellation was successful, false otherwise
     */
    public boolean cancelAppointment(int id) {
        System.out.println("AppointmentDAO: Cancelling appointment with ID " + id);

        String sql = "UPDATE appointments SET status = 'Cancelled', updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            int rowsAffected = stmt.executeUpdate();

            boolean success = rowsAffected > 0;
            System.out.println("AppointmentDAO: Appointment cancellation " + (success ? "successful" : "failed"));
            return success;

        } catch (SQLException e) {
            System.out.println("AppointmentDAO: Error cancelling appointment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }



    /**
     * Reschedule an appointment
     *
     * @param id The ID of the appointment to reschedule
     * @param newDate The new date for the appointment
     * @param newTimeSlot The new time slot for the appointment
     * @return true if the rescheduling was successful, false otherwise
     */
    public boolean rescheduleAppointment(int id, java.sql.Date newDate, String newTimeSlot) {
        System.out.println("AppointmentDAO: Rescheduling appointment with ID " + id +
                           " to date " + newDate + " and time slot " + newTimeSlot);

        String sql = "UPDATE appointments SET appointment_date = ?, time_slot = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, newDate);
            stmt.setString(2, newTimeSlot);
            stmt.setInt(3, id);

            int rowsAffected = stmt.executeUpdate();

            boolean success = rowsAffected > 0;
            System.out.println("AppointmentDAO: Appointment rescheduling " + (success ? "successful" : "failed"));
            return success;

        } catch (SQLException e) {
            System.out.println("AppointmentDAO: Error rescheduling appointment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get filtered appointments based on search query, department, and status
     *
     * @param searchQuery The search query to filter by (patient or doctor name)
     * @param departmentFilter The department ID to filter by
     * @param statusFilter The status to filter by
     * @return List of filtered appointments
     */
    public List<Appointment> getFilteredAppointments(String searchQuery, String departmentFilter, String statusFilter) {
        System.out.println("AppointmentDAO: Getting filtered appointments with search=" + searchQuery +
                           ", department=" + departmentFilter + ", status=" + statusFilter);

        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT a.*, p.name as patient_name, d.name as doctor_name, dept.name as department_name ")
                  .append("FROM appointments a ")
                  .append("LEFT JOIN users p ON a.patient_id = p.id ")
                  .append("LEFT JOIN users d ON a.doctor_id = d.id ")
                  .append("LEFT JOIN departments dept ON a.department_id = dept.id ")
                  .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Add search condition if provided
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sqlBuilder.append("AND (LOWER(p.name) LIKE ? OR LOWER(d.name) LIKE ?) ");
            String searchParam = "%" + searchQuery.toLowerCase() + "%";
            params.add(searchParam);
            params.add(searchParam);
        }

        // Add department filter if provided
        if (departmentFilter != null && !departmentFilter.trim().isEmpty() && !departmentFilter.equals("0")) {
            sqlBuilder.append("AND a.department_id = ? ");
            params.add(Integer.parseInt(departmentFilter));
        }

        // Add status filter if provided
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("all")) {
            sqlBuilder.append("AND LOWER(a.status) = ? ");
            params.add(statusFilter.toLowerCase());
        }

        sqlBuilder.append("ORDER BY a.appointment_date DESC");

        String sql = sqlBuilder.toString();
        System.out.println("AppointmentDAO: Executing query: " + sql);

        List<Appointment> appointments = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            int count = 0;

            while (rs.next()) {
                count++;
                Appointment appointment = new Appointment();
                int id = rs.getInt("id");
                int patientId = rs.getInt("patient_id");
                int doctorId = rs.getInt("doctor_id");
                String patientName = rs.getString("patient_name");
                String doctorName = rs.getString("doctor_name");
                String departmentName = rs.getString("department_name");
                java.sql.Date appointmentDate = rs.getDate("appointment_date");
                String timeSlot = rs.getString("time_slot");
                String status = rs.getString("status");

                appointment.setId(id);
                appointment.setPatientId(patientId);
                appointment.setDoctorId(doctorId);
                appointment.setDepartmentId(rs.getInt("department_id"));
                appointment.setAppointmentDate(appointmentDate);
                appointment.setTimeSlot(timeSlot);
                appointment.setStatus(status);
                appointment.setNotes(rs.getString("notes"));
                appointment.setPatientName(patientName != null ? patientName : "Unknown Patient");
                appointment.setDoctorName(doctorName != null ? doctorName : "Unknown Doctor");
                appointment.setDepartmentName(departmentName != null ? departmentName : "General");

                appointments.add(appointment);
            }

            System.out.println("AppointmentDAO: Total filtered appointments found: " + count);

        } catch (SQLException e) {
            System.out.println("AppointmentDAO: Error getting filtered appointments: " + e.getMessage());
            e.printStackTrace();
        }

        return appointments;
    }

    /**
     * Update an appointment in the database
     *
     * @param appointment The appointment to update
     * @return true if the update was successful, false otherwise
     */
    public boolean updateAppointment(Appointment appointment) {
        System.out.println("AppointmentDAO: Updating appointment with ID " + appointment.getId());

        String sql = "UPDATE appointments SET doctor_id = ?, department_id = ?, appointment_date = ?, " +
                     "time_slot = ?, notes = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, appointment.getDoctorId());
            stmt.setInt(2, appointment.getDepartmentId());
            stmt.setDate(3, new java.sql.Date(appointment.getAppointmentDate().getTime()));
            stmt.setString(4, appointment.getTimeSlot());
            stmt.setString(5, appointment.getNotes());
            stmt.setInt(6, appointment.getId());

            int rowsAffected = stmt.executeUpdate();

            boolean success = rowsAffected > 0;
            System.out.println("AppointmentDAO: Appointment update " + (success ? "successful" : "failed"));
            return success;

        } catch (SQLException e) {
            System.out.println("AppointmentDAO: Error updating appointment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Helper method to convert bytes to hex for debugging
    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02X ", b));
        }
        return sb.toString();
    }
}