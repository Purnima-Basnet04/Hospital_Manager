<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Service" %>
<%@ page import="dao.ServiceDAO" %>
<%
    // Get all services from the database
    ServiceDAO serviceDAO = new ServiceDAO();
    List<Service> services = serviceDAO.getAllServices();

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
    <title>Services - Admin Dashboard</title>
    <!-- Using locally hosted Font Awesome instead of CDN -->
    <link rel="stylesheet" href="../css/fontawesome/all.min.css">
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
            padding: 8px 15px;
            border-radius: 4px;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
            font-weight: 500;
        }

        .btn:hover {
            background-color: #0052a3;
        }

        .btn-sm {
            padding: 5px 10px;
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
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
        }

        .logo a {
            font-size: 24px;
            font-weight: 700;
            color: #333;
        }

        .logo span {
            color: #0066cc;
        }

        nav ul {
            display: flex;
            list-style: none;
        }

        nav ul li {
            margin-left: 20px;
        }

        nav ul li a {
            color: #333;
            font-weight: 500;
            transition: color 0.3s;
        }

        nav ul li a:hover {
            color: #0066cc;
        }

        nav ul li a.active {
            color: #0066cc;
            font-weight: bold;
        }

        /* User Menu Styles */
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
            font-weight: 500;
        }

        .user-menu-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 4px;
            width: 200px;
            display: none;
            z-index: 1000;
        }

        .user-menu-dropdown ul {
            display: block;
            padding: 10px 0;
        }

        .user-menu-dropdown ul li {
            margin: 0;
        }

        .user-menu-dropdown ul li a {
            display: flex;
            align-items: center;
            padding: 10px 15px;
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

        /* Admin Dashboard Layout */
        .admin-dashboard {
            display: flex;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        /* Admin Sidebar */
        .admin-sidebar {
            width: 250px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-right: 20px;
            height: fit-content;
        }

        .admin-sidebar-header {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .admin-sidebar-header h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 5px;
        }

        .admin-sidebar-header p {
            color: #6c757d;
            font-size: 14px;
        }

        .admin-sidebar-menu {
            list-style: none;
        }

        .admin-sidebar-menu li {
            margin-bottom: 10px;
        }

        .admin-sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 10px;
            color: #333;
            border-radius: 4px;
            transition: all 0.3s;
        }

        .admin-sidebar-menu li a:hover {
            background-color: #f8f9fa;
            color: #0066cc;
        }

        .admin-sidebar-menu li a.active {
            background-color: #0066cc;
            color: white;
        }

        .admin-sidebar-menu li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* Admin Content */
        .admin-content {
            flex: 1;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .admin-header h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 5px;
        }

        .admin-header p {
            color: #6c757d;
        }

        /* Search and Filter */
        .search-filter {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .search-filter input[type="text"] {
            flex: 1;
            padding: 8px 15px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }

        .search-filter select {
            padding: 8px 15px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
            background-color: white;
        }

        /* Services Table */
        .services-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        .services-table th,
        .services-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }

        .services-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #495057;
        }

        .services-table tr:hover {
            background-color: #f8f9fa;
        }

        .services-table .actions {
            display: flex;
            gap: 5px;
        }

        /* Service Icon */
        .service-icon {
            width: 40px;
            height: 40px;
            background-color: #e6f2ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: #0066cc;
        }

        /* Category Badge */
        .category-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .category-emergency {
            background-color: #f8d7da;
            color: #dc3545;
        }

        .category-special {
            background-color: #d1e7dd;
            color: #198754;
        }

        .category-diagnostic {
            background-color: #e3f2fd;
            color: #0d6efd;
        }

        .category-rehabilitation {
            background-color: #fff3cd;
            color: #ffc107;
        }

        .category-general {
            background-color: #e9ecef;
            color: #6c757d;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination a {
            display: inline-block;
            padding: 8px 12px;
            margin: 0 5px;
            border-radius: 4px;
            background-color: #f8f9fa;
            color: #333;
            transition: all 0.3s;
        }

        .pagination a:hover {
            background-color: #0066cc;
            color: white;
        }

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
        @media (max-width: 768px) {
            .admin-dashboard {
                flex-direction: column;
            }

            .admin-sidebar {
                width: 100%;
                margin-right: 0;
                margin-bottom: 20px;
            }

            .search-filter {
                flex-wrap: wrap;
            }

            .search-filter input[type="text"],
            .search-filter select {
                width: 100%;
            }

            .services-table {
                display: block;
                overflow-x: auto;
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
                <li><a href="doctors.jsp"><i class="fas fa-user-md"></i> Doctors</a></li>
                <li><a href="appointments.jsp"><i class="fas fa-calendar-check"></i> Appointments</a></li>
                <li><a href="departments.jsp"><i class="fas fa-hospital"></i> Departments</a></li>
                <li><a href="services.jsp" class="active"><i class="fas fa-stethoscope"></i> Services</a></li>
                <li><a href="reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a></li>
                <li><a href="settings.jsp"><i class="fas fa-cog"></i> Settings</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="admin-content">
            <div class="admin-header">
                <div class="admin-header-left">
                    <h1>Services</h1>
                    <p>Manage all medical services offered by the hospital</p>
                </div>
                <div class="admin-header-right">
                    <a href="<%= request.getContextPath() %>/admin/services/add" class="btn"><i class="fas fa-plus"></i> Add New Service</a>
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
                <input type="text" placeholder="Search services...">
                <select>
                    <option value="">All Categories</option>
                    <option value="Emergency">Emergency</option>
                    <option value="Special">Special</option>
                    <option value="Diagnostic">Diagnostic</option>
                    <option value="Rehabilitation">Rehabilitation</option>
                    <option value="General">General</option>
                </select>
                <button class="btn">Search</button>
            </div>

            <!-- Services Table -->
            <table class="services-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Icon</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Category</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (services != null && !services.isEmpty()) {
                        for (Service service : services) {
                            String categoryClass = "category-general";
                            if (service.getCategory() != null) {
                                if (service.getCategory().equalsIgnoreCase("Emergency")) {
                                    categoryClass = "category-emergency";
                                } else if (service.getCategory().equalsIgnoreCase("Special")) {
                                    categoryClass = "category-special";
                                } else if (service.getCategory().equalsIgnoreCase("Diagnostic")) {
                                    categoryClass = "category-diagnostic";
                                } else if (service.getCategory().equalsIgnoreCase("Rehabilitation")) {
                                    categoryClass = "category-rehabilitation";
                                }
                            }
                    %>
                    <tr>
                        <td><%= service.getId() %></td>
                        <td>
                            <div class="service-icon">
                                <% if (service.getIcon() != null && !service.getIcon().isEmpty()) { %>
                                    <i class="<%= service.getIcon().startsWith("fa") ? service.getIcon() : "fas fa-" + service.getIcon() %>"></i>
                                <% } else { %>
                                    <i class="fas fa-stethoscope"></i>
                                <% } %>
                            </div>
                        </td>
                        <td><%= service.getName() %></td>
                        <td><%= service.getDescription() %></td>
                        <td><span class="category-badge <%= categoryClass %>"><%= service.getCategory() != null ? service.getCategory() : "General" %></span></td>
                        <td class="actions">
                            <a href="<%= request.getContextPath() %>/admin/services/edit?id=<%= service.getId() %>" class="btn btn-sm btn-success">Edit</a>
                            <a href="<%= request.getContextPath() %>/admin/services/view?id=<%= service.getId() %>" class="btn btn-sm">View</a>
                            <a href="#" onclick="confirmDelete(<%= service.getId() %>)" class="btn btn-sm btn-danger">Delete</a>
                        </td>
                    </tr>
                    <% }
                    } else { %>
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 30px;">No services found. Please add a new service.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

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

        // Function to confirm service deletion
        function confirmDelete(id) {
            if (confirm('Are you sure you want to delete this service? This action cannot be undone.')) {
                window.location.href = '<%= request.getContextPath() %>/admin/services/delete?id=' + id;
            }
        }
    </script>
</body>
</html>
