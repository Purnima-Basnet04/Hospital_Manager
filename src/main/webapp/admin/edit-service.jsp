<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Service" %>
<%
    Service service = (Service) request.getAttribute("service");
    if (service == null) {
        response.sendRedirect(request.getContextPath() + "/admin/services.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Service - Admin Dashboard</title>
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

        /* Form Styles */
        .form-container {
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 16px;
        }

        .form-control:focus {
            border-color: #0066cc;
            outline: none;
        }

        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }

        .form-row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -10px;
        }

        .form-col {
            flex: 1;
            min-width: 250px;
            padding: 0 10px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
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

        .btn + .btn {
            margin-left: 10px;
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

        /* Icon Preview */
        .icon-preview {
            display: flex;
            align-items: center;
            margin-top: 10px;
        }

        .icon-preview-box {
            width: 40px;
            height: 40px;
            background-color: #e6f2ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: #0066cc;
            margin-right: 10px;
        }

        .icon-preview-text {
            font-size: 14px;
            color: #6c757d;
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

            .form-row {
                flex-direction: column;
            }

            .form-col {
                width: 100%;
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
                        <h1>Edit Service</h1>
                        <p>Update service information</p>
                    </div>
                    <div>
                        <a href="services.jsp" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Back to Services</a>
                    </div>
                </div>

                <!-- Error Message -->
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>

                <!-- Edit Service Form -->
                <div class="form-container">
                    <form action="<%= request.getContextPath() %>/admin/services/*" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="<%= service.getId() %>">
                        
                        <div class="form-group">
                            <label for="name">Service Name *</label>
                            <input type="text" id="name" name="name" class="form-control" value="<%= service.getName() %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="description">Description *</label>
                            <textarea id="description" name="description" class="form-control" required><%= service.getDescription() %></textarea>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="icon">Icon (Font Awesome class)</label>
                                    <input type="text" id="icon" name="icon" class="form-control" value="<%= service.getIcon() != null ? service.getIcon() : "" %>" placeholder="fas fa-stethoscope">
                                    <div class="icon-preview">
                                        <div class="icon-preview-box">
                                            <i class="<%= service.getIcon() != null && !service.getIcon().isEmpty() ? service.getIcon() : "fas fa-stethoscope" %>" id="icon-preview-icon"></i>
                                        </div>
                                        <div class="icon-preview-text">Icon preview</div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="category">Category *</label>
                                    <select id="category" name="category" class="form-control" required>
                                        <option value="">Select Category</option>
                                        <option value="Emergency" <%= "Emergency".equals(service.getCategory()) ? "selected" : "" %>>Emergency</option>
                                        <option value="Special" <%= "Special".equals(service.getCategory()) ? "selected" : "" %>>Special</option>
                                        <option value="Diagnostic" <%= "Diagnostic".equals(service.getCategory()) ? "selected" : "" %>>Diagnostic</option>
                                        <option value="Rehabilitation" <%= "Rehabilitation".equals(service.getCategory()) ? "selected" : "" %>>Rehabilitation</option>
                                        <option value="General" <%= "General".equals(service.getCategory()) || service.getCategory() == null ? "selected" : "" %>>General</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <a href="services.jsp" class="btn btn-outline">Cancel</a>
                            <button type="submit" class="btn">Update Service</button>
                        </div>
                    </form>
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
        
        // Icon preview
        document.getElementById('icon').addEventListener('input', function() {
            const iconClass = this.value.trim();
            const iconPreviewIcon = document.getElementById('icon-preview-icon');
            
            // Remove all classes
            iconPreviewIcon.className = '';
            
            // Add new class if it's not empty
            if (iconClass) {
                iconPreviewIcon.className = iconClass;
            } else {
                iconPreviewIcon.className = 'fas fa-stethoscope';
            }
        });
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const name = document.getElementById('name').value.trim();
            const description = document.getElementById('description').value.trim();
            const category = document.getElementById('category').value;
            
            if (name === '') {
                alert('Service name is required');
                e.preventDefault();
                return;
            }
            
            if (description === '') {
                alert('Description is required');
                e.preventDefault();
                return;
            }
            
            if (category === '') {
                alert('Category is required');
                e.preventDefault();
                return;
            }
        });
    </script>
</body>
</html>
