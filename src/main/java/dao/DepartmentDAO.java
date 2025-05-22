package dao;

import model.Department;
import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DepartmentImageMapper;

public class DepartmentDAO {

    public List<Department> getAllDepartments() {
        String sql = "SELECT * FROM departments";
        List<Department> departments = new ArrayList<>();

        try {
            System.out.println("Attempting to connect to database...");
            Connection conn = DatabaseConnection.getConnection();
            System.out.println("Database connection successful!");

            Statement stmt = conn.createStatement();
            System.out.println("Executing query: " + sql);
            ResultSet rs = stmt.executeQuery(sql);

            int count = 0;
            while (rs.next()) {
                count++;
                Department department = new Department();
                department.setId(rs.getInt("id"));
                department.setName(rs.getString("name"));
                department.setDescription(rs.getString("description"));
                department.setImageUrl(rs.getString("image_url"));
                department.setBuilding(rs.getString("building"));
                department.setFloor(rs.getInt("floor"));
                department.setSpecialistsCount(rs.getInt("specialists_count"));

                departments.add(department);
                System.out.println("Added department: " + department.getName());
            }

            System.out.println("Total departments found: " + count);

            rs.close();
            stmt.close();

        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage());
            e.printStackTrace();
        }

        return departments;
    }

    public Department getDepartmentById(int id) {
        String sql = "SELECT * FROM departments WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Department department = new Department();
                department.setId(rs.getInt("id"));
                department.setName(rs.getString("name"));
                department.setDescription(rs.getString("description"));
                department.setImageUrl(rs.getString("image_url"));
                department.setBuilding(rs.getString("building"));
                department.setFloor(rs.getInt("floor"));
                department.setSpecialistsCount(rs.getInt("specialists_count"));

                return department;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Add a new department to the database
     *
     * @param department The department to add
     * @return true if the addition was successful, false otherwise
     */
    public boolean addDepartment(Department department) {
        String sql = "INSERT INTO departments (name, description, image_url, building, floor, specialists_count) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, department.getName());
            stmt.setString(2, department.getDescription());
            // Handle image URL - use appropriate department image if not provided
            String imageUrl = department.getImageUrl();
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                imageUrl = DepartmentImageMapper.getImageUrl(department.getName());
            }
            stmt.setString(3, imageUrl);
            stmt.setString(4, department.getBuilding());
            stmt.setInt(5, department.getFloor());
            stmt.setInt(6, department.getSpecialistsCount());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    department.setId(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;

        } catch (SQLException e) {
            System.out.println("Error adding department: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update a department in the database
     *
     * @param department The department to update
     * @return true if the update was successful, false otherwise
     */
    public boolean updateDepartment(Department department) {
        String sql = "UPDATE departments SET name = ?, description = ?, image_url = ?, "
                + "building = ?, floor = ?, specialists_count = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, department.getName());
            stmt.setString(2, department.getDescription());
            stmt.setString(3, department.getImageUrl());
            stmt.setString(4, department.getBuilding());
            stmt.setInt(5, department.getFloor());
            stmt.setInt(6, department.getSpecialistsCount());
            stmt.setInt(7, department.getId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error updating department: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a department from the database
     *
     * @param id The ID of the department to delete
     * @return true if the deletion was successful, false otherwise
     */
    public boolean deleteDepartment(int id) {
        String sql = "DELETE FROM departments WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error deleting department: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if a department name already exists
     *
     * @param name The department name to check
     * @return true if the name exists, false otherwise
     */
    public boolean isDepartmentNameExists(String name) {
        String sql = "SELECT COUNT(*) FROM departments WHERE name = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error checking department name: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Check if a department name already exists (excluding the current department)
     *
     * @param name The department name to check
     * @param id The ID of the current department to exclude from the check
     * @return true if the name exists for another department, false otherwise
     */
    public boolean isDepartmentNameExists(String name, int id) {
        String sql = "SELECT COUNT(*) FROM departments WHERE name = ? AND id != ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            stmt.setInt(2, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error checking department name: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }
}