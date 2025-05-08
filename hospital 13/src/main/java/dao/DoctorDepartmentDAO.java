package dao;

import util.DatabaseConnection;
import java.sql.*;

/**
 * Data Access Object for managing the relationship between doctors and departments
 */
public class DoctorDepartmentDAO {

    /**
     * Assigns a doctor to a department
     *
     * @param doctorId The ID of the user (doctor)
     * @param departmentId The ID of the department
     * @return true if the assignment was successful, false otherwise
     */
    public boolean assignDoctorToDepartment(int doctorId, int departmentId) {
        String sql = "INSERT INTO doctor_departments (doctor_id, department_id) VALUES (?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, doctorId);
            stmt.setInt(2, departmentId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error assigning doctor to department: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gets the department ID for a doctor
     *
     * @param doctorId The ID of the user (doctor)
     * @return The department ID, or -1 if not found
     */
    public int getDepartmentIdForDoctor(int doctorId) {
        String sql = "SELECT department_id FROM doctor_departments WHERE doctor_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, doctorId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("department_id");
            }

        } catch (SQLException e) {
            System.out.println("Error getting department for doctor: " + e.getMessage());
            e.printStackTrace();
        }

        return -1;
    }

    /**
     * Updates the department for a doctor
     *
     * @param doctorId The ID of the user (doctor)
     * @param departmentId The new department ID
     * @return true if the update was successful, false otherwise
     */
    public boolean updateDoctorDepartment(int doctorId, int departmentId) {
        String sql = "UPDATE doctor_departments SET department_id = ? WHERE doctor_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, departmentId);
            stmt.setInt(2, doctorId);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected == 0) {
                // No existing record, so insert a new one
                return assignDoctorToDepartment(doctorId, departmentId);
            }

            return true;

        } catch (SQLException e) {
            System.out.println("Error updating doctor department: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
