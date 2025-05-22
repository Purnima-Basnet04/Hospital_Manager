<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.User" %>
<%@ page import="model.Department" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dao.DepartmentDAO" %>
<%@ page import="dao.DoctorDepartmentDAO" %>
<%
    // Get all doctors from the database
    UserDAO userDAO = new UserDAO();
    List<User> doctors = userDAO.getAllDoctors();

    // Get department information for each doctor
    DoctorDepartmentDAO doctorDeptDAO = new DoctorDepartmentDAO();
    DepartmentDAO departmentDAO = new DepartmentDAO();

    // Map to store department names for each doctor
    Map<Integer, String> doctorDepartments = new HashMap<>();

    // Get department for each doctor
    for (User doctor : doctors) {
        int departmentId = doctorDeptDAO.getDepartmentIdForDoctor(doctor.getId());
        if (departmentId > 0) {
            Department department = departmentDAO.getDepartmentById(departmentId);
            if (department != null) {
                doctorDepartments.put(doctor.getId(), department.getName());
            } else {
                doctorDepartments.put(doctor.getId(), "Not Assigned");
            }
        } else {
            doctorDepartments.put(doctor.getId(), "Not Assigned");
        }
    }

    // Get all departments for the dropdown filter
    List<Department> allDepartments = departmentDAO.getAllDepartments();

    // Get success or error messages from session
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    // Clear messages after displaying them
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctors - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Global Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f8f9fa;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        a {
            text-decoration: none;
            color: #0066cc;
        }

        .btn {
            display: inline-block;
            background-color: #0066cc;
            color: white;
            padding: 12px 24px;
            border-radius: 4px;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
            font-weight: 600;
        }

        .btn:hover {
            background-color: #0052a3;
        }

        .btn-outline-primary {
            background-color: transparent;
            border: 2px solid #0066cc;
            color: #0066cc;
        }

        .btn-outline-primary:hover {
            background-color: #0066cc;
            color: white;
        }

        .btn-sm {
            padding: 8px 16px;
            font-size: 14px;
        }

        .btn-success {
            background-color: #28a745;
        }

        .btn-success:hover {
            background-color: #218838;
        }

        .btn-danger {
            background-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        /* Header Styles */
        header {
            background-color: rgba(255, 255, 255, 0.9);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
        }

        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #0066cc;
        }

        .logo span {
            color: #28a745;
        }

        nav ul {
            display: flex;
            list-style: none;
        }

        nav ul li {
            margin-left: 30px;
        }

        nav ul li a {
            color: #333;
            font-weight: 500;
            transition: color 0.3s;
        }

        nav ul li a:hover {
            color: #0066cc;
        }

        .user-menu {
            position: relative;
        }

        .user-menu-toggle {
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .user-menu-toggle img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
        }

        .user-menu-toggle span {
            margin-right: 5px;
        }

        .user-menu-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: white;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-radius: 4px;
            width: 200px;
            z-index: 1000;
            display: none;
        }

        .user-menu:hover .user-menu-dropdown {
            display: block;
        }

        .user-menu-dropdown ul {
            display: block;
            padding: 10px 0;
        }

        .user-menu-dropdown ul li {
            margin: 0;
        }

        .user-menu-dropdown ul li a {
            display: block;
            padding: 10px 20px;
            color: #333;
            transition: background-color 0.3s;
        }

        .user-menu-dropdown ul li a:hover {
            background-color: #f8f9fa;
        }

        .user-menu-dropdown ul li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* Admin Dashboard */
        .admin-dashboard {
            display: flex;
            padding-top: 80px; /* Account for fixed header */
            min-height: 100vh;
        }

        .admin-sidebar {
            width: 250px;
            background-color: #333;
            color: white;
            padding: 30px 0;
            position: fixed;
            height: calc(100vh - 80px);
            overflow-y: auto;
        }

        .admin-sidebar-header {
            padding: 0 20px 20px;
            border-bottom: 1px solid #444;
            margin-bottom: 20px;
        }

        .admin-sidebar-header h3 {
            font-size: 20px;
            color: white;
        }

        .admin-sidebar-header p {
            font-size: 14px;
            color: #ccc;
        }

        .admin-sidebar-menu {
            list-style: none;
        }

        .admin-sidebar-menu li {
            margin-bottom: 5px;
        }

        .admin-sidebar-menu li a {
            display: block;
            padding: 12px 20px;
            color: #ccc;
            transition: all 0.3s;
            display: flex;
            align-items: center;
        }

        .admin-sidebar-menu li a:hover,
        .admin-sidebar-menu li a.active {
            background-color: #0066cc;
            color: white;
        }

        .admin-sidebar-menu li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .admin-content {
            flex: 1;
            margin-left: 250px;
            padding: 30px;
        }

        .admin-header {
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .admin-header-left h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 10px;
        }

        .admin-header-left p {
            color: #666;
        }

        .search-filter {
            display: flex;
            margin-bottom: 20px;
            gap: 10px;
        }

        .search-filter input {
            flex: 1;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }

        .search-filter select {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }

        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .doctor-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }

        .doctor-card-header {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }

        .doctor-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            margin: 0 auto 15px;
            border: 3px solid #0066cc;
        }

        .doctor-name {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .doctor-specialization {
            color: #0066cc;
            font-weight: 500;
            margin-bottom: 10px;
        }

        .doctor-department {
            color: #666;
            font-size: 14px;
        }

        .doctor-card-body {
            padding: 20px;
        }

        .doctor-info {
            margin-bottom: 15px;
        }

        .doctor-info-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            color: #666;
        }

        .doctor-info-item i {
            width: 20px;
            margin-right: 10px;
            color: #0066cc;
        }

        .doctor-card-footer {
            padding: 15px 20px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: space-between;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination a {
            display: inline-block;
            padding: 8px 16px;
            margin: 0 5px;
            border-radius: 4px;
            background-color: white;
            color: #333;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }

        .pagination a:hover,
        .pagination a.active {
            background-color: #0066cc;
            color: white;
        }

        /* Alert Styles */
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

        /* Responsive Styles */
        @media (max-width: 992px) {
            .admin-sidebar {
                width: 200px;
            }

            .admin-content {
                margin-left: 200px;
            }

            .doctors-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
            }

            nav ul {
                margin-top: 20px;
            }

            nav ul li {
                margin-left: 15px;
                margin-right: 15px;
            }

            .admin-dashboard {
                flex-direction: column;
            }

            .admin-sidebar {
                width: 100%;
                height: auto;
                position: static;
                margin-bottom: 20px;
            }

            .admin-content {
                margin-left: 0;
            }

            .admin-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .admin-header-right {
                margin-top: 20px;
            }

            .search-filter {
                flex-direction: column;
            }

            .doctors-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 576px) {
            nav ul {
                flex-wrap: wrap;
                justify-content: center;
            }

            nav ul li {
                margin: 5px 10px;
            }

            .admin-header-left h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <a href="../index.jsp">LifeCare <span>Medical</span></a>
                </div>
                <nav>
                    <ul>
                        <li><a href="../index.jsp">Home</a></li>
                        <li><a href="../departments">Departments</a></li>
                        <li><a href="../Service.jsp">Services</a></li>
                        <li><a href="../appointments.jsp">Appointments</a></li>
                    </ul>
                </nav>
                <div class="user-menu">
                    <div class="user-menu-toggle">
                        <img src="https://via.placeholder.com/40x40" alt="Admin">
                        <span>Admin</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="user-menu-dropdown">
                        <ul>
                            <li><a href="profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                            <li><a href="settings.jsp"><i class="fas fa-cog"></i> Settings</a></li>
                            <li><a href="../logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Admin Dashboard -->
    <div class="admin-dashboard">
        <!-- Sidebar -->
        <div class="admin-sidebar">
            <div class="admin-sidebar-header">
                <h3>Admin Panel</h3>
                <p>Manage your hospital</p>
            </div>
            <ul class="admin-sidebar-menu">
                <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                <li><a href="patients.jsp"><i class="fas fa-users"></i> Patients</a></li>
                <li><a href="doctors.jsp" class="active"><i class="fas fa-user-md"></i> Doctors</a></li>
                <li><a href="appointments.jsp"><i class="fas fa-calendar-check"></i> Appointments</a></li>
                <li><a href="departments.jsp"><i class="fas fa-hospital"></i> Departments</a></li>
                <li><a href="services.jsp"><i class="fas fa-stethoscope"></i> Services</a></li>
                <li><a href="reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a></li>
                <li><a href="settings.jsp"><i class="fas fa-cog"></i> Settings</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="admin-content">
            <div class="admin-header">
                <div class="admin-header-left">
                    <h1>Doctors</h1>
                    <p>Manage all doctors in the system</p>
                </div>
                <div class="admin-header-right">
                    <a href="<%= request.getContextPath() %>/admin/doctors/add" class="btn"><i class="fas fa-plus"></i> Add New Doctor</a>
                </div>
            </div>

            <!-- Success/Error Messages -->
            <% if (successMessage != null && !successMessage.isEmpty()) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= successMessage %>
                </div>
            <% } %>
            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
                </div>
            <% } %>

            <!-- Search and Filter -->
            <div class="search-filter">
                <input type="text" placeholder="Search doctors...">
                <select>
                    <option value="">All Departments</option>
                    <% for (Department dept : allDepartments) { %>
                        <option value="<%= dept.getId() %>"><%= dept.getName() %></option>
                    <% } %>
                </select>
                <select>
                    <option value="">All Status</option>
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                </select>
                <button class="btn">Search</button>
            </div>

            <!-- Doctors Grid -->
            <div class="doctors-grid">
                <% if (doctors != null && !doctors.isEmpty()) { %>
                    <% for (User doctor : doctors) { %>
                        <div class="doctor-card">
                            <div class="doctor-card-header">
                                <img src="https://via.placeholder.com/100x100" alt="Doctor" class="doctor-avatar">
                                <h3 class="doctor-name">Dr. <%= doctor.getName() != null ? doctor.getName() : doctor.getUsername() %></h3>
                                <p class="doctor-specialization"><%= doctor.getRole() %></p>
                                <p class="doctor-department"><%= doctorDepartments.get(doctor.getId()) %></p>
                            </div>
                            <div class="doctor-card-body">
                                <div class="doctor-info">
                                    <div class="doctor-info-item">
                                        <i class="fas fa-envelope"></i>
                                        <span><%= doctor.getEmail() != null ? doctor.getEmail() : "N/A" %></span>
                                    </div>
                                    <div class="doctor-info-item">
                                        <i class="fas fa-phone"></i>
                                        <span><%= doctor.getPhone() != null ? doctor.getPhone() : "N/A" %></span>
                                    </div>
                                    <div class="doctor-info-item">
                                        <i class="fas fa-user"></i>
                                        <span><%= doctor.getGender() != null ? doctor.getGender() : "N/A" %></span>
                                    </div>
                                </div>
                            </div>
                            <div class="doctor-card-footer">
                                <span class="status-badge status-active">Active</span>
                                <div class="actions">
                                    <a href="<%= request.getContextPath() %>/admin/doctors/view?id=<%= doctor.getId() %>" class="btn btn-sm">View</a>
                                    <a href="<%= request.getContextPath() %>/admin/doctors/edit?id=<%= doctor.getId() %>" class="btn btn-sm btn-success">Edit</a>
                                    <a href="#" onclick="confirmDelete(<%= doctor.getId() %>)" class="btn btn-sm btn-danger">Delete</a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <div class="no-data-message">
                        <p>No doctors found in the database.</p>
                    </div>
                <% } %>
            </div>

            <!-- Pagination -->
            <div class="pagination">
                <a href="#" class="active">1</a>
                <a href="#">2</a>
                <a href="#">3</a>
                <a href="#">Next</a>
            </div>
        </div>
    </div>

    <script>
        // Simple JavaScript for toggling the user menu
        document.addEventListener('DOMContentLoaded', function() {
            const userMenuToggle = document.querySelector('.user-menu-toggle');
            const userMenuDropdown = document.querySelector('.user-menu-dropdown');

            userMenuToggle.addEventListener('click', function() {
                userMenuDropdown.style.display = userMenuDropdown.style.display === 'block' ? 'none' : 'block';
            });

            // Close the dropdown when clicking outside
            document.addEventListener('click', function(event) {
                if (!userMenuToggle.contains(event.target) && !userMenuDropdown.contains(event.target)) {
                    userMenuDropdown.style.display = 'none';
                }
            });
        });

        // Function to confirm doctor deletion
        function confirmDelete(id) {
            if (confirm('Are you sure you want to delete this doctor? This action cannot be undone.')) {
                window.location.href = '<%= request.getContextPath() %>/admin/doctors/delete?id=' + id;
            }
        }
    </script>
</body>
</html>
