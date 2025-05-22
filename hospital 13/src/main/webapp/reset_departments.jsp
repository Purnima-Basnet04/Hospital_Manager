<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reset Departments</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f8f9fa;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #0275d8;
            margin-bottom: 20px;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: #0275d8;
            color: white;
            border-radius: 4px;
            text-decoration: none;
            margin-top: 20px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        img {
            max-width: 100px;
            max-height: 60px;
            object-fit: cover;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Reset Departments</h1>

        <%
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            // Get database connection
            conn = DatabaseConnection.getConnection();
            stmt = conn.createStatement();

            // Drop the departments table if it exists
            stmt.executeUpdate("DROP TABLE IF EXISTS departments");

            // Create departments table
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

            // Insert sample departments with local images
            String contextPath = request.getContextPath();
            String insertDepartments = "INSERT INTO departments (name, description, image_url, building, floor, specialists_count) VALUES " +
                    "('Cardiology', 'Specialized in diagnosing and treating heart diseases and cardiovascular conditions.', '" + contextPath + "/images/departments/cardiology.jpg', 'Building A', 2, 5)," +
                    "('Neurology', 'Focused on disorders of the nervous system, including the brain, spinal cord, and nerves.', '" + contextPath + "/images/departments/neurology.jpg', 'Building B', 1, 4)," +
                    "('Pediatrics', 'Dedicated to the health and medical care of infants, children, and adolescents.', '" + contextPath + "/images/departments/pediatrics.jpg', 'Building C', 1, 6)," +
                    "('Orthopedics', 'Specializes in the diagnosis and treatment of conditions of the musculoskeletal system.', '" + contextPath + "/images/departments/orthopedics.jpg', 'Building A', 3, 5)," +
                    "('Dermatology', 'Focuses on the diagnosis and treatment of conditions related to skin, hair, and nails.', '" + contextPath + "/images/departments/dermatology.jpg', 'Building B', 2, 3)," +
                    "('Ophthalmology', 'Specializes in the diagnosis and treatment of eye disorders.', '" + contextPath + "/images/departments/ophthalmology.jpg', 'Building C', 2, 4)," +
                    "('Oncology', 'Dedicated to the diagnosis and treatment of cancer.', '" + contextPath + "/images/departments/oncology.jpg', 'Building A', 4, 7)," +
                    "('Gynecology', 'Focuses on women\\'s health, particularly the female reproductive system.', '" + contextPath + "/images/departments/gynecology.jpg', 'Building D', 1, 5)";

            stmt.executeUpdate(insertDepartments);

            // Display success message
        %>
            <div class="alert alert-success">
                <strong>Success!</strong> Departments table has been reset and populated with sample data.
            </div>

            <h2>Current Departments</h2>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Image</th>
                    <th>Building</th>
                    <th>Floor</th>
                    <th>Specialists</th>
                </tr>
                <%
                // Fetch all departments
                rs = stmt.executeQuery("SELECT * FROM departments");

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String imageUrl = rs.getString("image_url");
                    String building = rs.getString("building");
                    int floor = rs.getInt("floor");
                    int specialistsCount = rs.getInt("specialists_count");
                %>
                <tr>
                    <td><%= id %></td>
                    <td><%= name %></td>
                    <td><img src="<%= imageUrl %>" alt="<%= name %>"></td>
                    <td><%= building %></td>
                    <td><%= floor %></td>
                    <td><%= specialistsCount %></td>
                </tr>
                <%
                }
                %>
            </table>
        <%
        } catch (Exception e) {
            // Display error message
        %>
            <div class="alert alert-danger">
                <strong>Error!</strong> <%= e.getMessage() %>
            </div>
        <%
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        %>

        <a href="departments" class="btn">Go to Departments Page</a>
    </div>
</body>
</html>
