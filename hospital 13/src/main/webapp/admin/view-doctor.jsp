<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Department" %>
<%@ page import="dao.DepartmentDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%
    User doctor = (User) request.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect(request.getContextPath() + "/admin/doctors.jsp");
        return;
    }
    
    // Get the department ID for this doctor
    Integer departmentId = (Integer) request.getAttribute("departmentId");
    
    // Get department name
    String departmentName = "Not Assigned";
    if (departmentId != null && departmentId > 0) {
        DepartmentDAO departmentDAO = new DepartmentDAO();
        Department department = departmentDAO.getDepartmentById(departmentId);
        if (department != null) {
            departmentName = department.getName();
        }
    }
    
    // Format for displaying dates
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
    String dateOfBirth = doctor.getDateOfBirth() != null ? dateFormat.format(doctor.getDateOfBirth()) : "Not specified";
    
    // Calculate age
    int age = 0;
    if (doctor.getDateOfBirth() != null) {
        Calendar birthDate = Calendar.getInstance();
        birthDate.setTime(doctor.getDateOfBirth());
        Calendar today = Calendar.getInstance();
        
        age = today.get(Calendar.YEAR) - birthDate.get(Calendar.YEAR);
        if (today.get(Calendar.DAY_OF_YEAR) < birthDate.get(Calendar.DAY_OF_YEAR)) {
            age--;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Doctor - Admin Dashboard</title>
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

        .admin-header h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 10px;
        }

        .admin-header p {
            color: #666;
        }

        /* Doctor Profile Styles */
        .doctor-profile {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .doctor-header {
            display: flex;
            align-items: center;
            padding: 30px;
            background-color: #f8f9fa;
            border-bottom: 1px solid #eee;
        }

        .doctor-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 30px;
            border: 4px solid white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .doctor-info h2 {
            font-size: 28px;
            color: #333;
            margin-bottom: 5px;
        }

        .doctor-info p {
            color: #666;
            margin-bottom: 10px;
        }

        .doctor-info .badge {
            display: inline-block;
            padding: 5px 15px;
            background-color: #0066cc;
            color: white;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }

        .doctor-content {
            padding: 30px;
        }

        .doctor-section {
            margin-bottom: 30px;
        }

        .doctor-section h3 {
            font-size: 20px;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .doctor-details {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .detail-item {
            margin-bottom: 15px;
        }

        .detail-label {
            font-weight: 600;
            color: #666;
            margin-bottom: 5px;
        }

        .detail-value {
            color: #333;
        }

        .doctor-actions {
            padding: 20px 30px;
            background-color: #f8f9fa;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
        }

        .btn {
            display: inline-block;
            background-color: #0066cc;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
            font-weight: 600;
        }

        .btn:hover {
            background-color: #0052a3;
        }

        .btn-outline {
            background-color: transparent;
            border: 2px solid #0066cc;
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
        @media (max-width: 992px) {
            .admin-sidebar {
                width: 200px;
            }

            .admin-content {
                margin-left: 200px;
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

            .doctor-header {
                flex-direction: column;
                text-align: center;
            }

            .doctor-avatar {
                margin-right: 0;
                margin-bottom: 20px;
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
                <div>
                    <h1>Doctor Profile</h1>
                    <p>View doctor information</p>
                </div>
                <div>
                    <a href="doctors.jsp" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Back to Doctors</a>
                </div>
            </div>

            <!-- Doctor Profile -->
            <div class="doctor-profile">
                <div class="doctor-header">
                    <img src="https://via.placeholder.com/120x120" alt="<%= doctor.getName() %>" class="doctor-avatar">
                    <div class="doctor-info">
                        <h2>Dr. <%= doctor.getName() != null ? doctor.getName() : doctor.getUsername() %></h2>
                        <p>
                            <i class="fas fa-hospital"></i> <%= departmentName %> &nbsp;|&nbsp;
                            <i class="fas fa-venus-mars"></i> <%= doctor.getGender() != null ? doctor.getGender().substring(0, 1).toUpperCase() + doctor.getGender().substring(1) : "Not specified" %> &nbsp;|&nbsp;
                            <i class="fas fa-birthday-cake"></i> <%= age > 0 ? age + " years" : "Age not specified" %>
                        </p>
                        <span class="badge">Active</span>
                    </div>
                </div>

                <div class="doctor-content">
                    <!-- Personal Information -->
                    <div class="doctor-section">
                        <h3>Personal Information</h3>
                        <div class="doctor-details">
                            <div class="detail-item">
                                <div class="detail-label">Full Name</div>
                                <div class="detail-value">Dr. <%= doctor.getName() != null ? doctor.getName() : "Not specified" %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Username</div>
                                <div class="detail-value"><%= doctor.getUsername() %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Email</div>
                                <div class="detail-value"><%= doctor.getEmail() != null ? doctor.getEmail() : "Not specified" %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Phone</div>
                                <div class="detail-value"><%= doctor.getPhone() != null ? doctor.getPhone() : "Not specified" %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Date of Birth</div>
                                <div class="detail-value"><%= dateOfBirth %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Gender</div>
                                <div class="detail-value"><%= doctor.getGender() != null ? doctor.getGender().substring(0, 1).toUpperCase() + doctor.getGender().substring(1) : "Not specified" %></div>
                            </div>
                        </div>
                    </div>

                    <!-- Professional Information -->
                    <div class="doctor-section">
                        <h3>Professional Information</h3>
                        <div class="doctor-details">
                            <div class="detail-item">
                                <div class="detail-label">Department</div>
                                <div class="detail-value"><%= departmentName %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Status</div>
                                <div class="detail-value">Active</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="doctor-actions">
                    <a href="<%= request.getContextPath() %>/admin/doctors/edit?id=<%= doctor.getId() %>" class="btn"><i class="fas fa-edit"></i> Edit Doctor</a>
                    <a href="#" onclick="confirmDelete(<%= doctor.getId() %>)" class="btn btn-danger"><i class="fas fa-trash"></i> Delete Doctor</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(id) {
            if (confirm('Are you sure you want to delete this doctor? This action cannot be undone.')) {
                window.location.href = '<%= request.getContextPath() %>/admin/doctors/delete?id=' + id;
            }
        }
    </script>
</body>
</html>
