package controller;

import dao.DepartmentDAO;
import model.Department;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/departments")
public class DepartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("DepartmentServlet: Initializing servlet");
        try {
            // Initialize the database when the servlet is loaded
            util.DatabaseInitializer.initializeDatabase();
            System.out.println("DepartmentServlet: Database initialized successfully");

            // Pre-load departments to ensure they're in the database
            DepartmentDAO departmentDAO = new DepartmentDAO();
            List<Department> departments = departmentDAO.getAllDepartments();
            System.out.println("DepartmentServlet init: Found " + (departments != null ? departments.size() : 0) + " departments");
        } catch (Exception e) {
            System.out.println("DepartmentServlet: Error initializing database: " + e.getMessage());
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            System.out.println("DepartmentServlet: Fetching all departments");

            // Use direct JDBC to fetch departments
            List<Department> departments = new ArrayList<>();
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                conn = util.DatabaseConnection.getConnection();
                stmt = conn.createStatement();

                // First, make sure the table exists
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

                // Check if departments table is empty
                rs = stmt.executeQuery("SELECT COUNT(*) FROM departments");
                rs.next();
                int count = rs.getInt(1);
                System.out.println("DepartmentServlet: Found " + count + " departments in the database");

                // Insert sample data if table is empty
                if (count == 0) {
                    System.out.println("DepartmentServlet: Inserting sample departments data");

                    // Insert sample departments
                    String insertDepartments = "INSERT INTO departments (name, description, image_url, building, floor, specialists_count) VALUES " +
                            "('Cardiology', 'Specialized in diagnosing and treating heart diseases and cardiovascular conditions.', '/images/departments/cardiology.jpg', 'Building A', 2, 5)," +
                            "('Neurology', 'Focused on disorders of the nervous system, including the brain, spinal cord, and nerves.', '/images/departments/neurology.jpg', 'Building B', 1, 4)," +
                            "('Pediatrics', 'Dedicated to the health and medical care of infants, children, and adolescents.', '/images/departments/pediatrics.jpg', 'Building C', 1, 6)," +
                            "('Orthopedics', 'Specializes in the diagnosis and treatment of conditions of the musculoskeletal system.', '/images/departments/orthopedics.jpg', 'Building A', 3, 5)," +
                            "('Dermatology', 'Focuses on the diagnosis and treatment of conditions related to skin, hair, and nails.', '/images/departments/dermatology.jpg', 'Building B', 2, 3)," +
                            "('Ophthalmology', 'Specializes in the diagnosis and treatment of eye disorders.', '/images/departments/ophthalmology.jpg', 'Building C', 2, 4)," +
                            "('Oncology', 'Dedicated to the diagnosis and treatment of cancer.', '/images/departments/oncology.jpg', 'Building A', 4, 7)," +
                            "('Gynecology', 'Focuses on women\\'s health, particularly the female reproductive system.', '/images/departments/gynecology.jpg', 'Building D', 1, 5)";

                    stmt.executeUpdate(insertDepartments);
                    System.out.println("DepartmentServlet: Sample departments data inserted successfully");
                }

                // Fetch all departments
                rs = stmt.executeQuery("SELECT * FROM departments");
                while (rs.next()) {
                    Department department = new Department();
                    department.setId(rs.getInt("id"));
                    department.setName(rs.getString("name"));
                    department.setDescription(rs.getString("description"));
                    department.setImageUrl(rs.getString("image_url"));
                    department.setBuilding(rs.getString("building"));
                    department.setFloor(rs.getInt("floor"));
                    department.setSpecialistsCount(rs.getInt("specialists_count"));

                    departments.add(department);
                }

                System.out.println("DepartmentServlet: Retrieved " + departments.size() + " departments from database");

            } catch (Exception e) {
                System.out.println("DepartmentServlet: Error accessing database: " + e.getMessage());
                e.printStackTrace();

                // If database access fails, create sample data
                System.out.println("DepartmentServlet: Creating sample data as fallback");
                departments = createSampleDepartments();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            request.setAttribute("departments", departments);
            System.out.println("DepartmentServlet: Setting departments attribute with " + departments.size() + " departments");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Department.jsp");
            System.out.println("DepartmentServlet: Forwarding to /Department.jsp");
            dispatcher.forward(request, response);
        } else if (action.equals("view")) {
            // View specific department
            String idParam = request.getParameter("id");

            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int departmentId = Integer.parseInt(idParam);

                    // Fetch department from the database
                    DepartmentDAO departmentDAO = new DepartmentDAO();
                    Department department = departmentDAO.getDepartmentById(departmentId);

                    // If department not found in the database, create a default one
                    if (department == null) {
                        department = new Department();
                        department.setId(departmentId);
                        department.setName("Unknown Department");
                        department.setDescription("Department details not available.");
                        department.setBuilding("Unknown");
                        department.setFloor(0);
                        department.setSpecialistsCount(0);
                    }

                    request.setAttribute("department", department);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/department-details.jsp");
                    dispatcher.forward(request, response);
                    return;
                } catch (NumberFormatException e) {
                    // Invalid ID format
                }
            }

            // Department not found or invalid ID, redirect to departments list
            response.sendRedirect(request.getContextPath() + "/departments");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    private List<Department> createSampleDepartments() {
        List<Department> departments = new ArrayList<>();

        Department cardiology = new Department();
        cardiology.setId(1);
        cardiology.setName("Cardiology");
        cardiology.setDescription("Specialized in diagnosing and treating heart diseases and cardiovascular conditions.");
        cardiology.setImageUrl("/images/departments/cardiology.jpg");
        cardiology.setBuilding("Building A");
        cardiology.setFloor(2);
        cardiology.setSpecialistsCount(5);
        departments.add(cardiology);

        Department neurology = new Department();
        neurology.setId(2);
        neurology.setName("Neurology");
        neurology.setDescription("Focused on disorders of the nervous system, including the brain, spinal cord, and nerves.");
        neurology.setImageUrl("/images/departments/neurology.jpg");
        neurology.setBuilding("Building B");
        neurology.setFloor(1);
        neurology.setSpecialistsCount(4);
        departments.add(neurology);

        Department pediatrics = new Department();
        pediatrics.setId(3);
        pediatrics.setName("Pediatrics");
        pediatrics.setDescription("Dedicated to the health and medical care of infants, children, and adolescents.");
        pediatrics.setImageUrl("/images/departments/pediatrics.jpg");
        pediatrics.setBuilding("Building C");
        pediatrics.setFloor(1);
        pediatrics.setSpecialistsCount(6);
        departments.add(pediatrics);

        Department orthopedics = new Department();
        orthopedics.setId(4);
        orthopedics.setName("Orthopedics");
        orthopedics.setDescription("Specializes in the diagnosis and treatment of conditions of the musculoskeletal system.");
        orthopedics.setImageUrl("/images/departments/orthopedics.jpg");
        orthopedics.setBuilding("Building A");
        orthopedics.setFloor(3);
        orthopedics.setSpecialistsCount(5);
        departments.add(orthopedics);

        return departments;
    }
}