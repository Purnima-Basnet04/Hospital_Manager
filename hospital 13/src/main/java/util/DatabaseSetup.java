package util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.Statement;
import java.util.stream.Collectors;

/**
 * Utility class for setting up the database
 */
public class DatabaseSetup {
    
    /**
     * Executes the SQL script to create the doctor_departments table
     */
    public static void setupDoctorDepartmentsTable() {
        try {
            // Load the SQL script from resources
            InputStream inputStream = DatabaseSetup.class.getClassLoader().getResourceAsStream("sql/doctor_departments.sql");
            
            if (inputStream == null) {
                System.err.println("Could not find doctor_departments.sql in resources");
                return;
            }
            
            // Read the SQL script
            String sql = new BufferedReader(new InputStreamReader(inputStream))
                    .lines()
                    .collect(Collectors.joining("\n"));
            
            // Split the script into individual statements
            String[] statements = sql.split(";");
            
            // Execute each statement
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement()) {
                
                for (String statement : statements) {
                    if (!statement.trim().isEmpty()) {
                        stmt.execute(statement);
                    }
                }
                
                System.out.println("Doctor departments table setup completed successfully");
                
            } catch (Exception e) {
                System.err.println("Error executing SQL script: " + e.getMessage());
                e.printStackTrace();
            }
            
        } catch (Exception e) {
            System.err.println("Error setting up doctor departments table: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    public static void main(String[] args) {
        setupDoctorDepartmentsTable();
    }
}
