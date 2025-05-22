package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.DatabaseConnection;

@WebListener
public class AppInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("AppInitializer: Application starting up");
        initializeDatabase();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("AppInitializer: Application shutting down");
    }

    private void initializeDatabase() {
        System.out.println("AppInitializer: Initializing database");
        Connection conn = null;
        Statement stmt = null;

        try {
            // Get database connection
            conn = DatabaseConnection.getConnection();
            stmt = conn.createStatement();

            // Create departments table if it doesn't exist
            String createTableSQL = "CREATE TABLE IF NOT EXISTS departments (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY," +
                    "name VARCHAR(100) NOT NULL," +
                    "description TEXT," +
                    "image_url VARCHAR(255)," +
                    "building VARCHAR(50)," +
                    "floor INT," +
                    "specialists_count INT DEFAULT 0" +
                    ")";
            stmt.executeUpdate(createTableSQL);
            System.out.println("AppInitializer: Departments table created or already exists");

            // Check if departments table is empty
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM departments");
            rs.next();
            int count = rs.getInt(1);
            System.out.println("AppInitializer: Found " + count + " departments in the database");

            // Insert sample data if table is empty
            if (count == 0) {
                System.out.println("AppInitializer: Inserting sample departments data");

                // Insert sample departments
                String insertDepartments = "INSERT INTO departments (name, description, image_url, building, floor, specialists_count) VALUES " +
                        "('Cardiology', 'Specialized in diagnosing and treating heart diseases and cardiovascular conditions.', 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80', 'Building A', 2, 5)," +
                        "('Neurology', 'Focused on disorders of the nervous system, including the brain, spinal cord, and nerves.', 'https://images.unsplash.com/photo-1559757175-5700dde675bc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1469&q=80', 'Building B', 1, 4)," +
                        "('Pediatrics', 'Dedicated to the health and medical care of infants, children, and adolescents.', 'https://images.unsplash.com/photo-1581594693702-fbdc51b2763b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80', 'Building C', 1, 6)," +
                        "('Orthopedics', 'Specializes in the diagnosis and treatment of conditions of the musculoskeletal system.', 'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80', 'Building A', 3, 5)," +
                        "('Dermatology', 'Focuses on the diagnosis and treatment of conditions related to skin, hair, and nails.', 'https://images.unsplash.com/photo-1571942676516-bcab84649e44?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80', 'Building B', 2, 3)," +
                        "('Ophthalmology', 'Specializes in the diagnosis and treatment of eye disorders.', 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1480&q=80', 'Building C', 2, 4)," +
                        "('Oncology', 'Dedicated to the diagnosis and treatment of cancer.', 'https://images.unsplash.com/photo-1631815588090-d4bfec5b1ccb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80', 'Building A', 4, 7)," +
                        "('Gynecology', 'Focuses on women\\'s health, particularly the female reproductive system.', 'https://images.unsplash.com/photo-1632053001332-2f0f3d1b3a0c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80', 'Building D', 1, 5)";

                stmt.executeUpdate(insertDepartments);
                System.out.println("AppInitializer: Sample departments data inserted successfully");

                // Verify departments were inserted
                rs = stmt.executeQuery("SELECT COUNT(*) FROM departments");
                rs.next();
                count = rs.getInt(1);
                System.out.println("AppInitializer: After insertion, found " + count + " departments in the database");
            } else {
                System.out.println("AppInitializer: Departments table already has data, skipping sample data insertion");
            }

            rs.close();

        } catch (SQLException e) {
            System.out.println("AppInitializer: Database error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
