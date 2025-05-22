package dao;

import model.MedicalRecord;
import util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class MedicalRecordDAO {

    /**
     * Get all medical records for a specific patient
     *
     * @param patientId The ID of the patient
     * @return List of medical records for the patient
     */
    public List<MedicalRecord> getMedicalRecordsByPatientId(int patientId) {
        System.out.println("MedicalRecordDAO: Getting medical records for patient ID " + patientId);

        String sql = "SELECT mr.*, u.name as doctor_name, d.name as department_name " +
                     "FROM medical_records mr " +
                     "LEFT JOIN users u ON mr.doctor_id = u.id " +
                     "LEFT JOIN doctor_departments dd ON u.id = dd.doctor_id " +
                     "LEFT JOIN departments d ON dd.department_id = d.id " +
                     "WHERE mr.patient_id = ? " +
                     "ORDER BY mr.record_date DESC";
        List<MedicalRecord> medicalRecords = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, patientId);
            System.out.println("MedicalRecordDAO: Executing query: " + sql.replace("?", String.valueOf(patientId)));

            ResultSet rs = stmt.executeQuery();
            int count = 0;

            while (rs.next()) {
                count++;
                MedicalRecord medicalRecord = new MedicalRecord();
                int id = rs.getInt("id");
                int doctorId = rs.getInt("doctor_id");
                String doctorName = rs.getString("doctor_name");
                String departmentName = rs.getString("department_name");
                java.sql.Date recordDate = rs.getDate("record_date");
                String diagnosis = rs.getString("diagnosis");

                medicalRecord.setId(id);
                medicalRecord.setPatientId(patientId);
                medicalRecord.setDoctorId(doctorId);
                medicalRecord.setRecordDate(recordDate);
                medicalRecord.setDiagnosis(diagnosis);
                medicalRecord.setTreatment(rs.getString("treatment"));
                medicalRecord.setPrescription(rs.getString("prescription"));
                medicalRecord.setNotes(rs.getString("notes"));
                medicalRecord.setDoctorName(doctorName != null ? doctorName : "Unknown Doctor");
                medicalRecord.setDepartmentName(departmentName != null ? departmentName : "General");

                System.out.println("MedicalRecordDAO: Found medical record: ID=" + id + ", Doctor=" + doctorName + ", Date=" + recordDate + ", Diagnosis=" + diagnosis);
                medicalRecords.add(medicalRecord);
            }

            System.out.println("MedicalRecordDAO: Total medical records found for patient: " + count);

        } catch (SQLException e) {
            System.out.println("MedicalRecordDAO: Error getting medical records for patient: " + e.getMessage());
            e.printStackTrace();
        }

        return medicalRecords;
    }



    /**
     * Get a specific medical record by ID
     *
     * @param recordId The ID of the medical record
     * @return The medical record, or null if not found
     */
    public MedicalRecord getMedicalRecordById(int recordId) {
        String sql = "SELECT mr.*, u.name as doctor_name, d.name as department_name " +
                     "FROM medical_records mr " +
                     "LEFT JOIN users u ON mr.doctor_id = u.id " +
                     "LEFT JOIN doctor_departments dd ON u.id = dd.doctor_id " +
                     "LEFT JOIN departments d ON dd.department_id = d.id " +
                     "WHERE mr.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, recordId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                MedicalRecord medicalRecord = new MedicalRecord();
                medicalRecord.setId(rs.getInt("id"));
                medicalRecord.setPatientId(rs.getInt("patient_id"));
                medicalRecord.setDoctorId(rs.getInt("doctor_id"));
                medicalRecord.setRecordDate(rs.getDate("record_date"));
                medicalRecord.setDiagnosis(rs.getString("diagnosis"));
                medicalRecord.setTreatment(rs.getString("treatment"));
                medicalRecord.setPrescription(rs.getString("prescription"));
                medicalRecord.setNotes(rs.getString("notes"));
                medicalRecord.setDoctorName(rs.getString("doctor_name") != null ? rs.getString("doctor_name") : "Unknown Doctor");
                medicalRecord.setDepartmentName(rs.getString("department_name") != null ? rs.getString("department_name") : "General");

                return medicalRecord;
            }

        } catch (SQLException e) {
            System.out.println("MedicalRecordDAO: Error getting medical record by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Create a new medical record in the database
     *
     * @param medicalRecord The medical record to create
     * @return true if the record was created successfully, false otherwise
     */
    public boolean createMedicalRecord(MedicalRecord medicalRecord) {
        System.out.println("MedicalRecordDAO: createMedicalRecord method called");
        System.out.println("MedicalRecordDAO: Creating medical record with fields:");
        System.out.println("  - patientId: " + medicalRecord.getPatientId());
        System.out.println("  - doctorId: " + medicalRecord.getDoctorId());
        System.out.println("  - recordDate: " + medicalRecord.getRecordDate());
        System.out.println("  - diagnosis: " + medicalRecord.getDiagnosis());
        System.out.println("  - treatment: " + medicalRecord.getTreatment());
        System.out.println("  - prescription: " + medicalRecord.getPrescription());
        System.out.println("  - notes: " + medicalRecord.getNotes());
        System.out.println("  - recordType: " + medicalRecord.getRecordType());
        System.out.println("  - status: " + medicalRecord.getStatus());
        System.out.println("  - symptoms: " + medicalRecord.getSymptoms());

        // Check if the medical_records table exists, create it if it doesn't
        if (!tableExists("medical_records")) {
            System.out.println("MedicalRecordDAO: medical_records table does not exist, creating it");
            if (!createMedicalRecordsTable()) {
                System.out.println("MedicalRecordDAO: Failed to create medical_records table");
                return false;
            }
        }

        String sql = "INSERT INTO medical_records (patient_id, doctor_id, record_date, diagnosis, treatment, prescription, notes, record_type, status, symptoms) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, medicalRecord.getPatientId());
            stmt.setInt(2, medicalRecord.getDoctorId());
            stmt.setDate(3, new java.sql.Date(medicalRecord.getRecordDate().getTime()));
            stmt.setString(4, medicalRecord.getDiagnosis());
            stmt.setString(5, medicalRecord.getTreatment());
            stmt.setString(6, medicalRecord.getPrescription());
            stmt.setString(7, medicalRecord.getNotes());
            stmt.setString(8, medicalRecord.getRecordType());
            stmt.setString(9, medicalRecord.getStatus());
            stmt.setString(10, medicalRecord.getSymptoms());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                // Get the generated ID
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    medicalRecord.setId(generatedKeys.getInt(1));
                }
                System.out.println("MedicalRecordDAO: Medical record created successfully with ID: " + medicalRecord.getId());
                return true;
            }

        } catch (SQLException e) {
            System.out.println("MedicalRecordDAO: Error creating medical record: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Update an existing medical record in the database
     *
     * @param medicalRecord The medical record to update
     * @return true if the record was updated successfully, false otherwise
     */
    public boolean updateMedicalRecord(MedicalRecord medicalRecord) {
        System.out.println("MedicalRecordDAO: updateMedicalRecord method called for ID: " + medicalRecord.getId());
        String sql = "UPDATE medical_records SET patient_id = ?, doctor_id = ?, record_date = ?, " +
                     "diagnosis = ?, treatment = ?, prescription = ?, notes = ?, record_type = ?, " +
                     "status = ?, symptoms = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, medicalRecord.getPatientId());
            stmt.setInt(2, medicalRecord.getDoctorId());
            stmt.setDate(3, new java.sql.Date(medicalRecord.getRecordDate().getTime()));
            stmt.setString(4, medicalRecord.getDiagnosis());
            stmt.setString(5, medicalRecord.getTreatment());
            stmt.setString(6, medicalRecord.getPrescription());
            stmt.setString(7, medicalRecord.getNotes());
            stmt.setString(8, medicalRecord.getRecordType());
            stmt.setString(9, medicalRecord.getStatus());
            stmt.setString(10, medicalRecord.getSymptoms());
            stmt.setInt(11, medicalRecord.getId());

            System.out.println("MedicalRecordDAO: Executing SQL update with parameters:");
            System.out.println("  - patientId: " + medicalRecord.getPatientId());
            System.out.println("  - doctorId: " + medicalRecord.getDoctorId());
            System.out.println("  - recordDate: " + medicalRecord.getRecordDate());
            System.out.println("  - diagnosis: " + medicalRecord.getDiagnosis());
            System.out.println("  - treatment: " + medicalRecord.getTreatment());
            System.out.println("  - prescription: " + medicalRecord.getPrescription());
            System.out.println("  - notes: " + medicalRecord.getNotes());
            System.out.println("  - recordType: " + medicalRecord.getRecordType());
            System.out.println("  - status: " + medicalRecord.getStatus());
            System.out.println("  - symptoms: " + medicalRecord.getSymptoms());
            System.out.println("  - id: " + medicalRecord.getId());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                System.out.println("MedicalRecordDAO: Medical record updated successfully with ID: " + medicalRecord.getId());
                return true;
            }

        } catch (SQLException e) {
            System.out.println("MedicalRecordDAO: Error updating medical record: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }
    /**
     * Check if a table exists in the database
     *
     * @param tableName The name of the table to check
     * @return true if the table exists, false otherwise
     */
    private boolean tableExists(String tableName) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            java.sql.DatabaseMetaData meta = conn.getMetaData();
            ResultSet tables = meta.getTables(null, null, tableName, null);
            return tables.next();
        } catch (SQLException e) {
            System.out.println("MedicalRecordDAO: Error checking if table exists: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Create the medical_records table in the database
     *
     * @return true if the table was created successfully, false otherwise
     */
    private boolean createMedicalRecordsTable() {
        String sql = "CREATE TABLE medical_records (" +
                     "id INT AUTO_INCREMENT PRIMARY KEY, " +
                     "patient_id INT NOT NULL, " +
                     "doctor_id INT NOT NULL, " +
                     "record_date DATE NOT NULL, " +
                     "diagnosis VARCHAR(255), " +
                     "treatment VARCHAR(255), " +
                     "prescription VARCHAR(255), " +
                     "notes TEXT, " +
                     "record_type VARCHAR(50), " +
                     "status VARCHAR(20), " +
                     "symptoms VARCHAR(255), " +
                     "FOREIGN KEY (patient_id) REFERENCES users(id), " +
                     "FOREIGN KEY (doctor_id) REFERENCES users(id)" +
                     ")";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            stmt.executeUpdate(sql);
            System.out.println("MedicalRecordDAO: medical_records table created successfully");
            return true;

        } catch (SQLException e) {
            System.out.println("MedicalRecordDAO: Error creating medical_records table: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
