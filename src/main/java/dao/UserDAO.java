package dao;

import model.User;
import util.DatabaseConnection;
import util.PasswordHasher;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (name, username, password, email, phone, role, gender, date_of_birth, blood_group, emergency_contact, address, medical_history) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Hash the password before storing it
            String hashedPassword = PasswordHasher.hashPassword(user.getPassword());

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getUsername());
            stmt.setString(3, hashedPassword);  // Store the hashed password
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getPhone());
            stmt.setString(6, user.getRole());
            stmt.setString(7, user.getGender());
            stmt.setDate(8, new java.sql.Date(user.getDateOfBirth().getTime()));
            stmt.setString(9, user.getBloodGroup());
            stmt.setString(10, user.getEmergencyContact());
            stmt.setString(11, user.getAddress());
            stmt.setString(12, user.getMedicalHistory());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Verify a user's password
     *
     * @param username The username
     * @param password The password to verify
     * @return true if the password is correct, false otherwise
     */
    public boolean verifyPassword(String username, String password) {
        String sql = "SELECT password FROM users WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");
                return PasswordHasher.verifyPassword(password, storedHash);
            }

        } catch (SQLException e) {
            System.out.println("UserDAO: Error verifying password: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Update a user's password
     *
     * @param userId The ID of the user
     * @param newPassword The new password
     * @return true if the password was updated successfully, false otherwise
     */
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Hash the new password
            String hashedPassword = PasswordHasher.hashPassword(newPassword);

            stmt.setString(1, hashedPassword);
            stmt.setInt(2, userId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("UserDAO: Error updating password: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public User authenticateUser(String username, String password) {
        // First, get the user by username only
        String sql = "SELECT * FROM users WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Get the stored hashed password
                String storedHash = rs.getString("password");

                // Verify the provided password against the stored hash
                if (PasswordHasher.verifyPassword(password, storedHash)) {
                    // Password is correct, create and return the user object
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setRole(rs.getString("role"));
                    user.setGender(rs.getString("gender"));
                    user.setDateOfBirth(rs.getDate("date_of_birth"));
                    user.setBloodGroup(rs.getString("blood_group"));
                    user.setEmergencyContact(rs.getString("emergency_contact"));
                    user.setAddress(rs.getString("address"));
                    user.setMedicalHistory(rs.getString("medical_history"));

                    return user;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setGender(rs.getString("gender"));
                user.setDateOfBirth(rs.getDate("date_of_birth"));
                user.setBloodGroup(rs.getString("blood_group"));
                user.setEmergencyContact(rs.getString("emergency_contact"));
                user.setAddress(rs.getString("address"));
                user.setMedicalHistory(rs.getString("medical_history"));

                return user;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<User> getDoctorsByDepartment(int departmentId) {
        String sql = "SELECT u.* FROM users u " +
                     "JOIN doctor_departments dd ON u.id = dd.doctor_id " +
                     "WHERE dd.department_id = ? AND u.role = 'doctor'";

        List<User> doctors = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, departmentId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                User doctor = new User();
                doctor.setId(rs.getInt("id"));
                doctor.setName(rs.getString("name"));
                doctor.setUsername(rs.getString("username"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setRole(rs.getString("role"));
                doctor.setGender(rs.getString("gender"));

                doctors.add(doctor);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return doctors;
    }

    public List<User> getAllDoctors() {
        String sql = "SELECT u.*, d.name as department_name " +
                     "FROM users u " +
                     "LEFT JOIN doctor_departments dd ON u.id = dd.doctor_id " +
                     "LEFT JOIN departments d ON dd.department_id = d.id " +
                     "WHERE LOWER(u.role) = 'doctor' OR LOWER(u.role) = 'Doctor' " +
                     "ORDER BY u.name";

        List<User> doctors = new ArrayList<>();

        System.out.println("UserDAO: Getting all doctors");

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            int count = 0;
            while (rs.next()) {
                count++;
                User doctor = new User();
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String departmentName = rs.getString("department_name");

                doctor.setId(id);
                doctor.setName(name);
                doctor.setUsername(rs.getString("username"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setRole(rs.getString("role"));
                doctor.setGender(rs.getString("gender"));
                doctor.setDateOfBirth(rs.getDate("date_of_birth"));
                doctor.setSpecialization(departmentName != null ? departmentName : "General");

                System.out.println("UserDAO: Found doctor: ID=" + id + ", Name=" + name + ", Department=" + departmentName);
                doctors.add(doctor);
            }

            System.out.println("UserDAO: Total doctors found: " + count);

        } catch (SQLException e) {
            System.out.println("UserDAO: Error getting all doctors: " + e.getMessage());
            e.printStackTrace();
        }

        return doctors;
    }

    /**
     * Get user ID by username
     *
     * @param username The username to look up
     * @return The user ID, or -1 if not found
     */
    public int getUserIdByUsername(String username) {
        String sql = "SELECT id FROM users WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("id");
            }

        } catch (SQLException e) {
            System.out.println("Error getting user ID by username: " + e.getMessage());
            e.printStackTrace();
        }

        return -1;
    }

    /**
     * Check if an email already exists in the database
     *
     * @param email The email to check
     * @return true if the email exists, false otherwise
     */
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error checking if email exists: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Check if a username already exists in the database
     *
     * @param username The username to check
     * @return true if the username exists, false otherwise
     */
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error checking if username exists: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Get all patients from the database
     *
     * @return List of all patients
     */
    public List<User> getAllPatients() {
        String sql = "SELECT * FROM users WHERE LOWER(role) = 'patient' ORDER BY name";

        List<User> patients = new ArrayList<>();

        System.out.println("UserDAO: Getting all patients");

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            int count = 0;
            while (rs.next()) {
                count++;
                User patient = new User();
                int id = rs.getInt("id");
                String name = rs.getString("name");

                patient.setId(id);
                patient.setName(name);
                patient.setUsername(rs.getString("username"));
                patient.setEmail(rs.getString("email"));
                patient.setPhone(rs.getString("phone"));
                patient.setRole(rs.getString("role"));
                patient.setGender(rs.getString("gender"));
                patient.setDateOfBirth(rs.getDate("date_of_birth"));
                patient.setBloodGroup(rs.getString("blood_group"));
                patient.setEmergencyContact(rs.getString("emergency_contact"));
                patient.setAddress(rs.getString("address"));
                patient.setMedicalHistory(rs.getString("medical_history"));

                System.out.println("UserDAO: Found patient (all): ID=" + id + ", Name=" + name);
                patients.add(patient);
            }

            System.out.println("UserDAO: Total patients found (all): " + count);

        } catch (SQLException e) {
            System.out.println("UserDAO: Error getting all patients: " + e.getMessage());
            e.printStackTrace();
        }

        return patients;
    }

    /**
     * Update a user in the database
     *
     * @param user The user to update
     * @return true if the update was successful, false otherwise
     */
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET name = ?, username = ?, email = ?, phone = ?, "
                + "gender = ?, date_of_birth = ?, blood_group = ?, emergency_contact = ?, "
                + "address = ?, medical_history = ? WHERE id = ?";

        System.out.println("UserDAO: Updating user with ID " + user.getId());
        System.out.println("UserDAO: SQL = " + sql);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Set parameters for the update statement
            stmt.setString(1, user.getName());

            // Keep the existing username
            stmt.setString(2, user.getUsername() != null ? user.getUsername() : "");

            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getGender());
            stmt.setDate(6, user.getDateOfBirth() != null ? new java.sql.Date(user.getDateOfBirth().getTime()) : null);
            stmt.setString(7, user.getBloodGroup());
            stmt.setString(8, user.getEmergencyContact());
            stmt.setString(9, user.getAddress());
            stmt.setString(10, user.getMedicalHistory());
            stmt.setInt(11, user.getId());

            // Print parameter values for debugging
            System.out.println("UserDAO: Parameter values:");
            System.out.println("  1. Name = " + user.getName());
            System.out.println("  2. Username = " + (user.getUsername() != null ? user.getUsername() : ""));
            System.out.println("  3. Email = " + user.getEmail());
            System.out.println("  4. Phone = " + user.getPhone());
            System.out.println("  5. Gender = " + user.getGender());
            System.out.println("  6. Date of Birth = " + (user.getDateOfBirth() != null ? user.getDateOfBirth() : "null"));
            System.out.println("  7. Blood Group = " + user.getBloodGroup());
            System.out.println("  8. Emergency Contact = " + user.getEmergencyContact());
            System.out.println("  9. Address = " + user.getAddress());
            System.out.println(" 10. Medical History = " + user.getMedicalHistory());
            System.out.println(" 11. ID = " + user.getId());

            int rowsAffected = stmt.executeUpdate();
            System.out.println("UserDAO: Rows affected = " + rowsAffected);
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error updating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a user from the database
     *
     * @param id The ID of the user to delete
     * @return true if the deletion was successful, false otherwise
     */
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error deleting user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get patients for a specific doctor based on appointments
     *
     * @param doctorId The ID of the doctor
     * @return List of patients who have appointments with this doctor
     */
    public List<User> getPatientsByDoctorId(int doctorId) {
        List<User> patients = new ArrayList<>();

        System.out.println("UserDAO: Getting patients for doctor ID " + doctorId);

        // First, check if the doctor exists
        String doctorSql = "SELECT COUNT(*) FROM users WHERE id = ? AND LOWER(role) = 'doctor'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement doctorStmt = conn.prepareStatement(doctorSql)) {

            doctorStmt.setInt(1, doctorId);
            ResultSet doctorRs = doctorStmt.executeQuery();

            if (doctorRs.next()) {
                int doctorCount = doctorRs.getInt(1);
                System.out.println("UserDAO: Doctor exists check: " + (doctorCount > 0 ? "Yes" : "No"));

                if (doctorCount == 0) {
                    System.out.println("UserDAO: Warning - No doctor found with ID " + doctorId);
                }
            }
        } catch (SQLException e) {
            System.out.println("UserDAO: Error checking if doctor exists: " + e.getMessage());
            e.printStackTrace();
        }

        // Check if there are any appointments for this doctor
        String countSql = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement countStmt = conn.prepareStatement(countSql)) {

            countStmt.setInt(1, doctorId);
            ResultSet countRs = countStmt.executeQuery();

            if (countRs.next()) {
                int appointmentCount = countRs.getInt(1);
                System.out.println("UserDAO: Found " + appointmentCount + " appointments for doctor ID " + doctorId);

                if (appointmentCount == 0) {
                    System.out.println("UserDAO: No appointments found for doctor ID " + doctorId + ". Returning all patients.");
                    // If no appointments, return all patients
                    return getAllPatients();
                }
            }
        } catch (SQLException e) {
            System.out.println("UserDAO: Error counting appointments: " + e.getMessage());
            e.printStackTrace();
        }

        // Get patients who have appointments with this doctor
        String sql = "SELECT DISTINCT u.* FROM users u " +
                     "JOIN appointments a ON u.id = a.patient_id " +
                     "WHERE a.doctor_id = ? AND LOWER(u.role) = 'patient' " +
                     "ORDER BY u.name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, doctorId);
            System.out.println("UserDAO: Executing query: " + sql.replace("?", String.valueOf(doctorId)));

            ResultSet rs = stmt.executeQuery();
            int count = 0;

            while (rs.next()) {
                count++;
                User patient = new User();
                int id = rs.getInt("id");
                String name = rs.getString("name");

                patient.setId(id);
                patient.setName(name);
                patient.setUsername(rs.getString("username"));
                patient.setEmail(rs.getString("email"));
                patient.setPhone(rs.getString("phone"));
                patient.setRole(rs.getString("role"));
                patient.setGender(rs.getString("gender"));
                patient.setDateOfBirth(rs.getDate("date_of_birth"));
                patient.setBloodGroup(rs.getString("blood_group"));
                patient.setEmergencyContact(rs.getString("emergency_contact"));
                patient.setAddress(rs.getString("address"));
                patient.setMedicalHistory(rs.getString("medical_history"));

                System.out.println("UserDAO: Found patient: ID=" + id + ", Name=" + name);
                patients.add(patient);
            }

            System.out.println("UserDAO: Total patients found: " + count);

            // If no patients found, try to get all patients with role 'patient'
            if (count == 0) {
                System.out.println("UserDAO: No patients found with appointments. Getting all patients...");
                return getAllPatients();
            }

        } catch (SQLException e) {
            System.out.println("UserDAO: Error getting patients for doctor: " + e.getMessage());
            e.printStackTrace();

            // If there's an error, try to get all patients
            return getAllPatients();
        }

        return patients;
    }

    /**
     * Get the department ID for a doctor
     *
     * @param doctorId The ID of the doctor
     * @return The department ID, or 1 if not found
     */
    public Integer getDoctorDepartmentId(int doctorId) {
        String sql = "SELECT department_id FROM doctor_departments WHERE doctor_id = ? LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, doctorId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("department_id");
            }

        } catch (SQLException e) {
            System.out.println("UserDAO: Error getting department ID for doctor: " + e.getMessage());
            e.printStackTrace();
        }

        // Return a default department ID if not found
        return 1;
    }

    /**
     * Get all departments for a doctor
     *
     * @param doctorId The ID of the doctor
     * @return List of departments the doctor belongs to
     */
    public List<model.Department> getDoctorDepartments(int doctorId) {
        List<model.Department> departments = new ArrayList<>();

        String sql = "SELECT d.* FROM departments d " +
                     "JOIN doctor_departments dd ON d.id = dd.department_id " +
                     "WHERE dd.doctor_id = ? " +
                     "ORDER BY d.name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, doctorId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                model.Department department = new model.Department();
                department.setId(rs.getInt("id"));
                department.setName(rs.getString("name"));
                department.setDescription(rs.getString("description"));
                departments.add(department);
            }

            System.out.println("UserDAO: Found " + departments.size() + " departments for doctor ID " + doctorId);

        } catch (SQLException e) {
            System.out.println("UserDAO: Error getting departments for doctor: " + e.getMessage());
            e.printStackTrace();
        }

        return departments;
    }

    /**
     * Get users by role
     *
     * @param role The role to filter by (e.g., "patient", "doctor", "admin")
     * @return List of users with the specified role
     */
    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE LOWER(role) = LOWER(?) ORDER BY name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setGender(rs.getString("gender"));
                user.setDateOfBirth(rs.getDate("date_of_birth"));
                user.setBloodGroup(rs.getString("blood_group"));
                user.setEmergencyContact(rs.getString("emergency_contact"));
                user.setAddress(rs.getString("address"));
                user.setMedicalHistory(rs.getString("medical_history"));
                users.add(user);
            }

            System.out.println("UserDAO: Found " + users.size() + " users with role '" + role + "'");

        } catch (SQLException e) {
            System.out.println("UserDAO: Error getting users by role: " + e.getMessage());
            e.printStackTrace();
        }

        return users;
    }


}