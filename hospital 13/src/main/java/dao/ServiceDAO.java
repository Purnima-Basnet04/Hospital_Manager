package dao;

import model.Service;
import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public List<Service> getAllServices() {
        String sql = "SELECT * FROM services";
        List<Service> services = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Service service = new Service();
                service.setId(rs.getInt("id"));
                service.setName(rs.getString("name"));
                service.setDescription(rs.getString("description"));
                service.setIcon(rs.getString("icon"));
                service.setCategory(rs.getString("category"));

                services.add(service);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return services;
    }

    public List<Service> getServicesByCategory(String category) {
        String sql = "SELECT * FROM services WHERE category = ?";
        List<Service> services = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, category);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Service service = new Service();
                service.setId(rs.getInt("id"));
                service.setName(rs.getString("name"));
                service.setDescription(rs.getString("description"));
                service.setIcon(rs.getString("icon"));
                service.setCategory(rs.getString("category"));

                services.add(service);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return services;
    }

    /**
     * Get a service by its ID
     *
     * @param id The ID of the service to retrieve
     * @return The service with the specified ID, or null if not found
     */
    public Service getServiceById(int id) {
        String sql = "SELECT * FROM services WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Service service = new Service();
                service.setId(rs.getInt("id"));
                service.setName(rs.getString("name"));
                service.setDescription(rs.getString("description"));
                service.setIcon(rs.getString("icon"));
                service.setCategory(rs.getString("category"));

                return service;
            }

        } catch (SQLException e) {
            System.out.println("Error getting service by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Add a new service to the database
     *
     * @param service The service to add
     * @return true if the addition was successful, false otherwise
     */
    public boolean addService(Service service) {
        String sql = "INSERT INTO services (name, description, icon, category) VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, service.getName());
            stmt.setString(2, service.getDescription());
            stmt.setString(3, service.getIcon());
            stmt.setString(4, service.getCategory());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    service.setId(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;

        } catch (SQLException e) {
            System.out.println("Error adding service: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update a service in the database
     *
     * @param service The service to update
     * @return true if the update was successful, false otherwise
     */
    public boolean updateService(Service service) {
        String sql = "UPDATE services SET name = ?, description = ?, icon = ?, category = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, service.getName());
            stmt.setString(2, service.getDescription());
            stmt.setString(3, service.getIcon());
            stmt.setString(4, service.getCategory());
            stmt.setInt(5, service.getId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error updating service: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a service from the database
     *
     * @param id The ID of the service to delete
     * @return true if the deletion was successful, false otherwise
     */
    public boolean deleteService(int id) {
        String sql = "DELETE FROM services WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error deleting service: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if a service name already exists
     *
     * @param name The service name to check
     * @return true if the name exists, false otherwise
     */
    public boolean isServiceNameExists(String name) {
        String sql = "SELECT COUNT(*) FROM services WHERE name = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error checking service name: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Check if a service name already exists (excluding the current service)
     *
     * @param name The service name to check
     * @param id The ID of the current service to exclude from the check
     * @return true if the name exists for another service, false otherwise
     */
    public boolean isServiceNameExists(String name, int id) {
        String sql = "SELECT COUNT(*) FROM services WHERE name = ? AND id != ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            stmt.setInt(2, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error checking service name: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }
}