package util;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseInitializer {

    public static void initializeDatabase() {
        System.out.println("DatabaseInitializer: Starting database initialization");
        try {
            System.out.println("DatabaseInitializer: Attempting to connect to database");
            Connection conn = DatabaseConnection.getConnection();
            System.out.println("DatabaseInitializer: Database connection successful");
            Statement stmt = conn.createStatement();

            // Create departments table if it doesn't exist
            String createDepartmentsTable = "CREATE TABLE IF NOT EXISTS departments (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY," +
                    "name VARCHAR(100) NOT NULL," +
                    "description TEXT," +
                    "image_url VARCHAR(255)," +
                    "building VARCHAR(50)," +
                    "floor INT," +
                    "specialists_count INT DEFAULT 0" +
                    ")";
            stmt.executeUpdate(createDepartmentsTable);

            // Create appointments table if it doesn't exist
            String createAppointmentsTable = "CREATE TABLE IF NOT EXISTS appointments (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY," +
                    "patient_id INT NOT NULL," +
                    "doctor_id INT NOT NULL," +
                    "department_id INT NOT NULL," +
                    "appointment_date DATE NOT NULL," +
                    "time_slot VARCHAR(20) NOT NULL," +
                    "status VARCHAR(20) NOT NULL DEFAULT 'Scheduled'," +
                    "notes TEXT," +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
                    ")";
            stmt.executeUpdate(createAppointmentsTable);
            System.out.println("DatabaseInitializer: Appointments table created or already exists");

            // Create prescriptions table if it doesn't exist
            String createPrescriptionsTable = "CREATE TABLE IF NOT EXISTS prescriptions (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY," +
                    "patient_id INT NOT NULL," +
                    "doctor_id INT NOT NULL," +
                    "medication VARCHAR(100) NOT NULL," +
                    "dosage VARCHAR(100) NOT NULL," +
                    "frequency VARCHAR(100) NOT NULL," +
                    "duration VARCHAR(100)," +
                    "notes TEXT," +
                    "status ENUM('Active', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Active'," +
                    "prescription_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
                    "FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE," +
                    "FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE" +
                    ")";
            stmt.executeUpdate(createPrescriptionsTable);
            System.out.println("DatabaseInitializer: Prescriptions table created or already exists");

            // Check if departments table is empty
            System.out.println("DatabaseInitializer: Checking if departments table is empty");
            java.sql.ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM departments");
            rs.next();
            int count = rs.getInt(1);
            System.out.println("DatabaseInitializer: Found " + count + " departments in the database");

            // Insert sample data only if the table is empty
            if (count == 0) {
                System.out.println("DatabaseInitializer: Inserting sample departments data");
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
                System.out.println("DatabaseInitializer: Sample departments data inserted successfully.");
            } else {
                System.out.println("DatabaseInitializer: Departments table already has data, skipping sample data insertion.");
            }

            // Check if appointments table is empty
            System.out.println("DatabaseInitializer: Checking if appointments table is empty");
            rs = stmt.executeQuery("SELECT COUNT(*) FROM appointments");
            rs.next();
            count = rs.getInt(1);
            System.out.println("DatabaseInitializer: Found " + count + " appointments in the database");

            // Insert sample appointment data only if the table is empty
            if (count == 0) {
                System.out.println("DatabaseInitializer: Inserting sample appointments data");

                // First, check if there are users in the database
                rs = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE LOWER(role) = 'patient'");
                rs.next();
                int patientCount = rs.getInt(1);

                rs = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE LOWER(role) = 'doctor'");
                rs.next();
                int doctorCount = rs.getInt(1);

                if (patientCount > 0 && doctorCount > 0) {
                    // Get a patient ID
                    rs = stmt.executeQuery("SELECT id FROM users WHERE LOWER(role) = 'patient' LIMIT 1");
                    rs.next();
                    int patientId = rs.getInt("id");

                    // Get a doctor ID
                    rs = stmt.executeQuery("SELECT id FROM users WHERE LOWER(role) = 'doctor' LIMIT 1");
                    rs.next();
                    int doctorId = rs.getInt("id");

                    // Get a department ID
                    rs = stmt.executeQuery("SELECT id FROM departments LIMIT 1");
                    rs.next();
                    int departmentId = rs.getInt("id");

                    // Insert sample appointments
                    String insertAppointments = "INSERT INTO appointments (patient_id, doctor_id, department_id, appointment_date, time_slot, status, notes) VALUES " +
                            "(" + patientId + ", " + doctorId + ", " + departmentId + ", DATE('now'), '09:00 AM', 'Scheduled', 'Regular checkup')," +
                            "(" + patientId + ", " + doctorId + ", " + departmentId + ", DATE('now', '+1 day'), '10:30 AM', 'Scheduled', 'Follow-up appointment')," +
                            "(" + patientId + ", " + doctorId + ", " + departmentId + ", DATE('now', '-1 day'), '02:00 PM', 'Completed', 'Initial consultation')," +
                            "(" + patientId + ", " + doctorId + ", " + departmentId + ", DATE('now', '+2 days'), '11:00 AM', 'Scheduled', 'Annual physical')," +
                            "(" + patientId + ", " + doctorId + ", " + departmentId + ", DATE('now', '-2 days'), '03:30 PM', 'Cancelled', 'Specialist consultation')";

                    stmt.executeUpdate(insertAppointments);
                    System.out.println("DatabaseInitializer: Sample appointments data inserted successfully.");
                } else {
                    System.out.println("DatabaseInitializer: No patients or doctors found in the database. Skipping sample appointments data.");
                }
            } else {
                System.out.println("DatabaseInitializer: Appointments table already has data, skipping sample data insertion.");
            }

            // Check if prescriptions table is empty
            System.out.println("DatabaseInitializer: Checking if prescriptions table is empty");
            rs = stmt.executeQuery("SELECT COUNT(*) FROM prescriptions");
            rs.next();
            count = rs.getInt(1);
            System.out.println("DatabaseInitializer: Found " + count + " prescriptions in the database");

            // Insert sample prescription data only if the table is empty
            if (count == 0) {
                System.out.println("DatabaseInitializer: Inserting sample prescriptions data");

                // First, check if there are users in the database
                rs = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE LOWER(role) = 'patient'");
                rs.next();
                int patientCount = rs.getInt(1);

                rs = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE LOWER(role) = 'doctor'");
                rs.next();
                int doctorCount = rs.getInt(1);

                if (patientCount > 0 && doctorCount > 0) {
                    // Get a patient ID
                    rs = stmt.executeQuery("SELECT id FROM users WHERE LOWER(role) = 'patient' LIMIT 1");
                    rs.next();
                    int patientId = rs.getInt("id");

                    // Get a doctor ID
                    rs = stmt.executeQuery("SELECT id FROM users WHERE LOWER(role) = 'doctor' LIMIT 1");
                    rs.next();
                    int doctorId = rs.getInt("id");

                    // Insert sample prescriptions
                    String insertPrescriptions = "INSERT INTO prescriptions (patient_id, doctor_id, medication, dosage, frequency, duration, notes, status, prescription_date) VALUES " +
                            "(" + patientId + ", " + doctorId + ", 'Amoxicillin', '500mg', 'Three times daily', '7 days', 'Take with food. Complete the full course even if you feel better.', 'Active', DATE_SUB(NOW(), INTERVAL 1 DAY))," +
                            "(" + patientId + ", " + doctorId + ", 'Lisinopril', '10mg', 'Once daily', '30 days', 'Take in the morning. Monitor blood pressure regularly.', 'Completed', DATE_SUB(NOW(), INTERVAL 2 DAY))," +
                            "(" + patientId + ", " + doctorId + ", 'Atorvastatin', '20mg', 'Once daily at bedtime', '30 days', 'Take at night. Avoid grapefruit juice.', 'Completed', DATE_SUB(NOW(), INTERVAL 3 DAY))," +
                            "(" + patientId + ", " + doctorId + ", 'Albuterol', '2 puffs', 'Every 4-6 hours as needed', '30 days', 'Use as needed for shortness of breath or wheezing.', 'Cancelled', DATE_SUB(NOW(), INTERVAL 4 DAY))";

                    stmt.executeUpdate(insertPrescriptions);
                    System.out.println("DatabaseInitializer: Sample prescriptions data inserted successfully.");
                } else {
                    System.out.println("DatabaseInitializer: No patients or doctors found in the database. Skipping sample prescriptions data.");
                }
            } else {
                System.out.println("DatabaseInitializer: Prescriptions table already has data, skipping sample data insertion.");
            }

            rs.close();
            stmt.close();
            conn.close();
            System.out.println("DatabaseInitializer: Database initialization completed successfully.");

        } catch (SQLException e) {
            System.out.println("DatabaseInitializer: Error during database initialization: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
