package dao;

import model.Prescription;
import util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PrescriptionDAO {

    /**
     * Get all prescriptions for a specific patient
     *
     * @param patientId The ID of the patient
     * @return List of prescriptions for the patient
     */
    public List<Prescription> getPrescriptionsByPatientId(int patientId) {
        System.out.println("PrescriptionDAO: Getting prescriptions for patient ID " + patientId);

        // Check if the prescriptions table exists
        if (!tableExists("prescriptions")) {
            System.out.println("PrescriptionDAO: prescriptions table does not exist, returning empty list");
            return new ArrayList<>();
        }

        String sql = "SELECT p.*, u.name as doctor_name " +
                     "FROM prescriptions p " +
                     "LEFT JOIN users u ON p.doctor_id = u.id " +
                     "WHERE p.patient_id = ? " +
                     "ORDER BY p.prescription_date DESC";
        List<Prescription> prescriptions = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, patientId);
            System.out.println("PrescriptionDAO: Executing query: " + sql.replace("?", String.valueOf(patientId)));

            ResultSet rs = stmt.executeQuery();
            int count = 0;

            while (rs.next()) {
                count++;
                Prescription prescription = new Prescription();
                int id = rs.getInt("id");
                int doctorId = rs.getInt("doctor_id");
                String doctorName = rs.getString("doctor_name");
                java.sql.Date prescriptionDate = rs.getDate("prescription_date");
                String medication = rs.getString("medication");

                prescription.setId(id);
                prescription.setPatientId(patientId);
                prescription.setDoctorId(doctorId);
                prescription.setDoctorName(doctorName != null ? doctorName : "Unknown Doctor");
                prescription.setMedication(medication);
                prescription.setDosage(rs.getString("dosage"));
                prescription.setFrequency(rs.getString("frequency"));
                prescription.setDuration(rs.getString("duration"));
                prescription.setNotes(rs.getString("notes"));
                prescription.setStatus(rs.getString("status"));
                prescription.setPrescriptionDate(prescriptionDate);

                System.out.println("PrescriptionDAO: Found prescription: ID=" + id + ", Doctor=" + doctorName +
                                   ", Date=" + prescriptionDate + ", Medication=" + medication);
                prescriptions.add(prescription);
            }

            System.out.println("PrescriptionDAO: Total prescriptions found for patient: " + count);

        } catch (SQLException e) {
            System.out.println("PrescriptionDAO: Error getting prescriptions for patient: " + e.getMessage());
            e.printStackTrace();
        }

        return prescriptions;
    }

    /**
     * Check if a table exists in the database
     *
     * @param tableName The name of the table to check
     * @return true if the table exists, false otherwise
     */
    private boolean tableExists(String tableName) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            ResultSet tables = conn.getMetaData().getTables(null, null, tableName, null);
            return tables.next();
        } catch (SQLException e) {
            System.out.println("PrescriptionDAO: Error checking if table exists: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }



    /**
     * Get all prescriptions for a specific doctor
     *
     * @param doctorId The ID of the doctor
     * @return List of prescriptions for the doctor
     */
    public List<Prescription> getPrescriptionsByDoctorId(int doctorId) {
        System.out.println("PrescriptionDAO: Getting prescriptions for doctor ID " + doctorId);

        // Check if the prescriptions table exists
        if (!tableExists("prescriptions")) {
            System.out.println("PrescriptionDAO: prescriptions table does not exist, returning empty list");
            return new ArrayList<>();
        }

        String sql = "SELECT p.*, u.name as patient_name " +
                     "FROM prescriptions p " +
                     "LEFT JOIN users u ON p.patient_id = u.id " +
                     "WHERE p.doctor_id = ? " +
                     "AND EXISTS (SELECT 1 FROM appointments a WHERE a.patient_id = p.patient_id AND a.doctor_id = p.doctor_id) " +
                     "ORDER BY p.prescription_date DESC";
        List<Prescription> prescriptions = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, doctorId);
            System.out.println("PrescriptionDAO: Executing query: " + sql.replace("?", String.valueOf(doctorId)));

            ResultSet rs = stmt.executeQuery();
            int count = 0;

            while (rs.next()) {
                count++;
                Prescription prescription = new Prescription();
                int id = rs.getInt("id");
                int patientId = rs.getInt("patient_id");
                String patientName = rs.getString("patient_name");
                java.sql.Date prescriptionDate = rs.getDate("prescription_date");
                String medication = rs.getString("medication");

                prescription.setId(id);
                prescription.setPatientId(patientId);
                prescription.setDoctorId(doctorId);
                prescription.setPatientName(patientName != null ? patientName : "Unknown Patient");
                prescription.setMedication(medication);
                prescription.setDosage(rs.getString("dosage"));
                prescription.setFrequency(rs.getString("frequency"));
                prescription.setDuration(rs.getString("duration"));
                prescription.setNotes(rs.getString("notes"));
                prescription.setStatus(rs.getString("status"));
                prescription.setPrescriptionDate(prescriptionDate);

                System.out.println("PrescriptionDAO: Found prescription: ID=" + id + ", Patient=" + patientName +
                                   ", Date=" + prescriptionDate + ", Medication=" + medication);
                prescriptions.add(prescription);
            }

            System.out.println("PrescriptionDAO: Total prescriptions found for doctor: " + count);

            // If no prescriptions found, return empty list
            if (count == 0) {
                System.out.println("PrescriptionDAO: No prescriptions found for doctor ID " + doctorId);
            }

        } catch (SQLException e) {
            System.out.println("PrescriptionDAO: Error getting prescriptions for doctor: " + e.getMessage());
            e.printStackTrace();

            // If there's an error, return empty list
            System.out.println("PrescriptionDAO: Returning empty list due to error");
        }

        return prescriptions;
    }



    /**
     * Create a new prescription
     *
     * @param prescription The prescription to create
     * @return true if successful, false otherwise
     */
    public boolean createPrescription(Prescription prescription) {
        // Check if the prescriptions table exists
        if (!tableExists("prescriptions")) {
            System.out.println("PrescriptionDAO: prescriptions table does not exist, creating it");
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement()) {

                String createTable = "CREATE TABLE IF NOT EXISTS prescriptions (" +
                                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                                    "patient_id INT NOT NULL, " +
                                    "doctor_id INT NOT NULL, " +
                                    "medication VARCHAR(100) NOT NULL, " +
                                    "dosage VARCHAR(100) NOT NULL, " +
                                    "frequency VARCHAR(100) NOT NULL, " +
                                    "duration VARCHAR(100), " +
                                    "notes TEXT, " +
                                    "status VARCHAR(20) NOT NULL DEFAULT 'Active', " +
                                    "prescription_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, " +
                                    "FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE, " +
                                    "FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE)";

                stmt.executeUpdate(createTable);
                System.out.println("PrescriptionDAO: prescriptions table created successfully");
            } catch (SQLException e) {
                System.out.println("PrescriptionDAO: Error creating prescriptions table: " + e.getMessage());
                e.printStackTrace();
                return false;
            }
        }

        // No longer validating that the patient has an appointment with the doctor
        System.out.println("PrescriptionDAO: Skipping appointment validation - allowing prescriptions for any patient");

        String sql = "INSERT INTO prescriptions (patient_id, doctor_id, medication, dosage, frequency, duration, notes, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        System.out.println("PrescriptionDAO: Creating prescription with SQL: " + sql);
        System.out.println("PrescriptionDAO: Patient ID: " + prescription.getPatientId());
        System.out.println("PrescriptionDAO: Doctor ID: " + prescription.getDoctorId());
        System.out.println("PrescriptionDAO: Medication: " + prescription.getMedication());
        System.out.println("PrescriptionDAO: Status: " + prescription.getStatus());

        try {
            // Get database connection
            Connection conn = util.DatabaseConnection.getConnection();
            if (conn == null) {
                System.out.println("PrescriptionDAO: Database connection is null");
                return false;
            }

            // Prepare statement
            PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            stmt.setInt(1, prescription.getPatientId());
            stmt.setInt(2, prescription.getDoctorId());
            stmt.setString(3, prescription.getMedication());
            stmt.setString(4, prescription.getDosage());
            stmt.setString(5, prescription.getFrequency());
            stmt.setString(6, prescription.getDuration());
            stmt.setString(7, prescription.getNotes());
            stmt.setString(8, prescription.getStatus() != null ? prescription.getStatus() : "Active");

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                // Get the generated ID
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    prescription.setId(rs.getInt(1));
                }
                return true;
            }

            // Close resources
            stmt.close();
            conn.close();

            return false; // No rows affected
        } catch (SQLException e) {
            System.out.println("PrescriptionDAO: Error creating prescription: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }


    }

    /**
     * Update an existing prescription
     *
     * @param prescription The prescription to update
     * @return true if successful, false otherwise
     */
    public boolean updatePrescription(Prescription prescription) {
        // Check if the prescriptions table exists
        if (!tableExists("prescriptions")) {
            System.out.println("PrescriptionDAO: prescriptions table does not exist, returning false");
            return false;
        }

        // No longer validating that the patient has an appointment with the doctor
        System.out.println("PrescriptionDAO: Skipping appointment validation for update - allowing prescriptions for any patient");

        String sql = "UPDATE prescriptions SET patient_id = ?, medication = ?, dosage = ?, " +
                     "frequency = ?, duration = ?, notes = ?, status = ? " +
                     "WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, prescription.getPatientId());
            stmt.setString(2, prescription.getMedication());
            stmt.setString(3, prescription.getDosage());
            stmt.setString(4, prescription.getFrequency());
            stmt.setString(5, prescription.getDuration());
            stmt.setString(6, prescription.getNotes());
            stmt.setString(7, prescription.getStatus());
            stmt.setInt(8, prescription.getId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("PrescriptionDAO: Error updating prescription: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Update a prescription's status
     *
     * @param prescriptionId The ID of the prescription
     * @param status The new status
     * @return true if successful, false otherwise
     */
    public boolean updatePrescriptionStatus(int prescriptionId, String status) {
        // Check if the prescriptions table exists
        if (!tableExists("prescriptions")) {
            System.out.println("PrescriptionDAO: prescriptions table does not exist, returning false");
            return false;
        }

        String sql = "UPDATE prescriptions SET status = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, prescriptionId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("PrescriptionDAO: Error updating prescription status: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Get a specific prescription by ID
     *
     * @param prescriptionId The ID of the prescription
     * @return The prescription, or null if not found
     */
    public Prescription getPrescriptionById(int prescriptionId) {
        // Check if the prescriptions table exists
        if (!tableExists("prescriptions")) {
            System.out.println("PrescriptionDAO: prescriptions table does not exist, returning null");
            return null;
        }

        String sql = "SELECT p.*, d.name as doctor_name, pt.name as patient_name " +
                     "FROM prescriptions p " +
                     "LEFT JOIN users d ON p.doctor_id = d.id " +
                     "LEFT JOIN users pt ON p.patient_id = pt.id " +
                     "WHERE p.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, prescriptionId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Prescription prescription = new Prescription();
                prescription.setId(rs.getInt("id"));
                prescription.setPatientId(rs.getInt("patient_id"));
                prescription.setDoctorId(rs.getInt("doctor_id"));
                prescription.setDoctorName(rs.getString("doctor_name") != null ? rs.getString("doctor_name") : "Unknown Doctor");
                prescription.setPatientName(rs.getString("patient_name") != null ? rs.getString("patient_name") : "Unknown Patient");
                prescription.setMedication(rs.getString("medication"));
                prescription.setDosage(rs.getString("dosage"));
                prescription.setFrequency(rs.getString("frequency"));
                prescription.setDuration(rs.getString("duration"));
                prescription.setNotes(rs.getString("notes"));
                prescription.setStatus(rs.getString("status"));
                prescription.setPrescriptionDate(rs.getDate("prescription_date"));

                return prescription;
            }

        } catch (SQLException e) {
            System.out.println("PrescriptionDAO: Error getting prescription by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
}
