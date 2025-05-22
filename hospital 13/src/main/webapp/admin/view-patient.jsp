<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%
    User patient = (User) request.getAttribute("patient");
    if (patient == null) {
        response.sendRedirect(request.getContextPath() + "/admin/patients.jsp");
        return;
    }
    
    // Format for displaying dates
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
    String dateOfBirth = patient.getDateOfBirth() != null ? dateFormat.format(patient.getDateOfBirth()) : "Not specified";
    
    // Calculate age
    int age = 0;
    if (patient.getDateOfBirth() != null) {
        Calendar birthDate = Calendar.getInstance();
        birthDate.setTime(patient.getDateOfBirth());
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
    <title>View Patient - Admin Dashboard</title>
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
            background-color: #fff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
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
            margin-right: 10px;
            font-weight: 500;
        }

        .user-menu-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
            width: 200px;
            display: none;
            z-index: 10;
        }

        .user-menu-dropdown ul {
            list-style: none;
        }

        .user-menu-dropdown ul li {
            padding: 10px 15px;
            border-bottom: 1px solid #f0f0f0;
        }

        .user-menu-dropdown ul li:last-child {
            border-bottom: none;
        }

        .user-menu-dropdown ul li a {
            color: #333;
            display: flex;
            align-items: center;
        }

        .user-menu-dropdown ul li a i {
            margin-right: 10px;
            color: #0066cc;
        }

        .user-menu-toggle:hover .user-menu-dropdown {
            display: block;
        }

        /* Admin Dashboard Styles */
        .admin-dashboard {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        .admin-sidebar {
            width: 250px;
            background-color: #2c3e50;
            color: #fff;
            padding: 20px 0;
        }

        .admin-sidebar-header {
            padding: 0 20px 20px;
            border-bottom: 1px solid #3d5166;
        }

        .admin-sidebar-header h3 {
            font-size: 20px;
            margin-bottom: 5px;
        }

        .admin-sidebar-header p {
            font-size: 14px;
            color: #b3c1d1;
        }

        .admin-sidebar-menu {
            list-style: none;
            margin-top: 20px;
        }

        .admin-sidebar-menu li {
            margin-bottom: 5px;
        }

        .admin-sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: #b3c1d1;
            transition: all 0.3s;
        }

        .admin-sidebar-menu li a i {
            margin-right: 10px;
            font-size: 18px;
        }

        .admin-sidebar-menu li a:hover,
        .admin-sidebar-menu li a.active {
            background-color: #3d5166;
            color: #fff;
        }

        .admin-content {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
        }

        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .admin-header h1 {
            font-size: 24px;
            color: #2c3e50;
        }

        .admin-header p {
            color: #7f8c8d;
        }

        /* Patient Profile Styles */
        .patient-profile {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .patient-header {
            display: flex;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
        }

        .patient-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin-right: 20px;
        }

        .patient-name {
            font-size: 24px;
            margin-bottom: 5px;
            color: #2c3e50;
        }

        .patient-info {
            color: #7f8c8d;
            margin-bottom: 10px;
        }

        .patient-status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        .patient-content {
            padding: 20px;
        }

        .patient-section {
            margin-bottom: 30px;
        }

        .patient-section h3 {
            font-size: 18px;
            color: #2c3e50;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #f0f0f0;
        }

        .patient-details {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .detail-item {
            margin-bottom: 15px;
        }

        .detail-label {
            font-weight: 500;
            color: #7f8c8d;
            margin-bottom: 5px;
        }

        .detail-value {
            color: #2c3e50;
        }

        .medical-history {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            white-space: pre-line;
        }

        .patient-actions {
            display: flex;
            justify-content: flex-end;
            padding: 20px;
            border-top: 1px solid #f0f0f0;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #0066cc;
            color: #fff;
            border: none;
            border-radius: 4px;
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
            color: #fff;
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
                <li><a href="patients.jsp" class="active"><i class="fas fa-users"></i> Patients</a></li>
                <li><a href="doctors.jsp"><i class="fas fa-user-md"></i> Doctors</a></li>
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
                    <h1>Patient Profile</h1>
                    <p>View detailed patient information</p>
                </div>
                <div>
                    <a href="patients.jsp" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Back to Patients</a>
                </div>
            </div>

            <!-- Patient Profile -->
            <div class="patient-profile">
                <div class="patient-header">
                    <img src="https://via.placeholder.com/100x100" alt="<%= patient.getName() %>" class="patient-avatar">
                    <div>
                        <h2 class="patient-name"><%= patient.getName() != null ? patient.getName() : patient.getUsername() %></h2>
                        <p class="patient-info">
                            <i class="fas fa-user"></i> <%= patient.getUsername() %> &nbsp;|&nbsp;
                            <i class="fas fa-venus-mars"></i> <%= patient.getGender() != null ? patient.getGender().substring(0, 1).toUpperCase() + patient.getGender().substring(1) : "Not specified" %> &nbsp;|&nbsp;
                            <i class="fas fa-birthday-cake"></i> <%= age > 0 ? age + " years" : "Age not specified" %>
                        </p>
                        <span class="patient-status status-active">Active</span>
                    </div>
                </div>

                <div class="patient-content">
                    <!-- Personal Information -->
                    <div class="patient-section">
                        <h3>Personal Information</h3>
                        <div class="patient-details">
                            <div class="detail-item">
                                <div class="detail-label">Full Name</div>
                                <div class="detail-value"><%= patient.getName() != null ? patient.getName() : "Not specified" %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Email</div>
                                <div class="detail-value"><%= patient.getEmail() != null ? patient.getEmail() : "Not specified" %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Phone</div>
                                <div class="detail-value"><%= patient.getPhone() != null ? patient.getPhone() : "Not specified" %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Date of Birth</div>
                                <div class="detail-value"><%= dateOfBirth %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Gender</div>
                                <div class="detail-value"><%= patient.getGender() != null ? patient.getGender().substring(0, 1).toUpperCase() + patient.getGender().substring(1) : "Not specified" %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Blood Group</div>
                                <div class="detail-value"><%= patient.getBloodGroup() != null ? patient.getBloodGroup() : "Not specified" %></div>
                            </div>
                        </div>
                    </div>

                    <!-- Contact Information -->
                    <div class="patient-section">
                        <h3>Contact Information</h3>
                        <div class="patient-details">
                            <div class="detail-item">
                                <div class="detail-label">Address</div>
                                <div class="detail-value"><%= patient.getAddress() != null ? patient.getAddress() : "Not specified" %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Emergency Contact</div>
                                <div class="detail-value"><%= patient.getEmergencyContact() != null ? patient.getEmergencyContact() : "Not specified" %></div>
                            </div>
                        </div>
                    </div>

                    <!-- Medical Information -->
                    <div class="patient-section">
                        <h3>Medical History</h3>
                        <div class="medical-history">
                            <%= patient.getMedicalHistory() != null && !patient.getMedicalHistory().isEmpty() ? patient.getMedicalHistory() : "No medical history recorded." %>
                        </div>
                    </div>
                </div>

                <div class="patient-actions">
                    <a href="edit-patient.jsp?id=<%= patient.getId() %>" class="btn"><i class="fas fa-edit"></i> Edit Patient</a>
                    <a href="#" onclick="confirmDelete(<%= patient.getId() %>)" class="btn btn-danger"><i class="fas fa-trash"></i> Delete Patient</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(id) {
            if (confirm('Are you sure you want to delete this patient? This action cannot be undone.')) {
                window.location.href = '<%= request.getContextPath() %>/admin/patients/delete?id=' + id;
            }
        }
    </script>
</body>
</html>
