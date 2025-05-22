<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Service" %>
<%
    Service service = (Service) request.getAttribute("service");
    if (service == null) {
        response.sendRedirect(request.getContextPath() + "/admin/services.jsp");
        return;
    }
    
    // Set default icon if not provided
    String icon = service.getIcon() != null && !service.getIcon().isEmpty() ? service.getIcon() : "fas fa-stethoscope";
    
    // Set default category if not provided
    String category = service.getCategory() != null ? service.getCategory() : "General";
    
    // Set category class for styling
    String categoryClass = "";
    switch (category) {
        case "Emergency":
            categoryClass = "category-emergency";
            break;
        case "Special":
            categoryClass = "category-special";
            break;
        case "Diagnostic":
            categoryClass = "category-diagnostic";
            break;
        case "Rehabilitation":
            categoryClass = "category-rehabilitation";
            break;
        default:
            categoryClass = "category-general";
            break;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= service.getName() %> - Admin Dashboard</title>
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

        /* Service Details */
        .service-details {
            display: flex;
            flex-direction: column;
            margin-bottom: 30px;
        }

        .service-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .service-icon {
            width: 80px;
            height: 80px;
            background-color: #e6f2ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: #0066cc;
            margin-right: 20px;
        }

        .service-title h2 {
            font-size: 28px;
            color: #333;
            margin-bottom: 5px;
        }

        .category-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }

        .category-emergency {
            background-color: #f8d7da;
            color: #721c24;
        }

        .category-special {
            background-color: #d4edda;
            color: #155724;
        }

        .category-diagnostic {
            background-color: #cce5ff;
            color: #004085;
        }

        .category-rehabilitation {
            background-color: #fff3cd;
            color: #856404;
        }

        .category-general {
            background-color: #e2e3e5;
            color: #383d41;
        }

        .service-description {
            margin-bottom: 30px;
            line-height: 1.8;
        }

        .service-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn {
            display: inline-block;
            background-color: #0066cc;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #0052a3;
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid #0066cc;
            color: #0066cc;
        }

        .btn-outline:hover {
            background-color: #0066cc;
            color: white;
        }

        .btn-danger {
            background-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .btn + .btn {
            margin-left: 10px;
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

            .service-header {
                flex-direction: column;
                text-align: center;
            }

            .service-icon {
                margin-right: 0;
                margin-bottom: 15px;
            }

            .service-actions {
                flex-direction: column;
            }

            .btn + .btn {
                margin-left: 0;
                margin-top: 10px;
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
    <div class="container">
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
                    <div>
                        <h1>Service Details</h1>
                        <p>View service information</p>
                    </div>
                    <div>
                        <a href="services.jsp" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Back to Services</a>
                    </div>
                </div>

                <!-- Service Details -->
                <div class="service-details">
                    <div class="service-header">
                        <div class="service-icon">
                            <i class="<%= icon %>"></i>
                        </div>
                        <div class="service-title">
                            <h2><%= service.getName() %></h2>
                            <span class="category-badge <%= categoryClass %>"><%= category %></span>
                        </div>
                    </div>
                    
                    <div class="service-description">
                        <p><%= service.getDescription() %></p>
                    </div>
                    
                    <div class="service-actions">
                        <a href="<%= request.getContextPath() %>/admin/services/edit?id=<%= service.getId() %>" class="btn"><i class="fas fa-edit"></i> Edit Service</a>
                        <a href="#" onclick="confirmDelete(<%= service.getId() %>)" class="btn btn-danger"><i class="fas fa-trash"></i> Delete Service</a>
                    </div>
                </div>
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
