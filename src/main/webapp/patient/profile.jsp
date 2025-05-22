<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="dao.UserDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Profile - LifeCare Medical Center</title>
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
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }

        a {
            text-decoration: none;
            color: #0275d8;
        }

        a:hover {
            color: #014c8c;
        }

        /* Header Styles */
        header {
            background-color: #fff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
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
            color: #0275d8;
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
        }

        nav ul li a:hover {
            color: #0275d8;
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
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
            width: 200px;
            display: none;
            z-index: 1000;
        }

        .user-menu:hover .user-menu-dropdown {
            display: block;
        }

        .user-menu-dropdown ul {
            list-style: none;
            padding: 10px 0;
        }

        .user-menu-dropdown ul li {
            margin: 0;
        }

        .user-menu-dropdown ul li a {
            display: flex;
            align-items: center;
            padding: 10px 20px;
            color: #333;
            transition: background-color 0.3s;
        }

        .user-menu-dropdown ul li a:hover {
            background-color: #f8f9fa;
        }

        .user-menu-dropdown ul li a i {
            margin-right: 10px;
            color: #0275d8;
        }

        /* Dashboard Layout */
        .dashboard {
            display: flex;
            margin-top: 20px;
        }

        .sidebar {
            width: 250px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-right: 20px;
        }

        .main-content {
            flex: 1;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        /* Sidebar Styles */
        .patient-sidebar-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .patient-sidebar-header img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 10px;
        }

        .patient-sidebar-header .patient-info h3 {
            font-size: 16px;
            margin-bottom: 5px;
        }

        .patient-sidebar-header .patient-info p {
            font-size: 14px;
            color: #6c757d;
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu li {
            margin-bottom: 10px;
        }

        .sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 10px;
            border-radius: 5px;
            color: #333;
            transition: background-color 0.3s;
        }

        .sidebar-menu li a:hover, .sidebar-menu li a.active {
            background-color: #f8f9fa;
        }

        .sidebar-menu li a i {
            margin-right: 10px;
            color: #0275d8;
        }

        /* Profile Styles */
        .profile-section {
            margin-bottom: 30px;
        }

        .profile-section h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
            position: relative;
            padding-bottom: 10px;
        }

        .profile-section h2::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 50px;
            height: 3px;
            background: linear-gradient(to right, #0275d8, #0056b3);
            border-radius: 2px;
        }

        .profile-card {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }

        .profile-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            overflow: hidden;
            margin-right: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-details h3 {
            font-size: 24px;
            margin-bottom: 10px;
            color: #333;
        }

        .profile-details p {
            color: #6c757d;
            margin-bottom: 5px;
        }

        .profile-details .profile-actions {
            margin-top: 15px;
        }

        .profile-details .profile-actions .btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: #0275d8;
            color: white;
            border-radius: 4px;
            text-align: center;
            font-weight: 500;
            transition: background-color 0.3s;
            margin-right: 10px;
        }

        .profile-details .profile-actions .btn:hover {
            background-color: #014c8c;
        }

        .profile-details .profile-actions .btn-outline {
            background-color: transparent;
            border: 1px solid #0275d8;
            color: #0275d8;
        }

        .profile-details .profile-actions .btn-outline:hover {
            background-color: #0275d8;
            color: white;
        }

        .profile-info {
            background-color: #f8f9fa;
            border-radius: 5px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .profile-info h3 {
            font-size: 18px;
            margin-bottom: 15px;
            color: #333;
        }

        .info-group {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .info-item {
            margin-bottom: 15px;
        }

        .info-item label {
            display: block;
            font-size: 14px;
            color: #6c757d;
            margin-bottom: 5px;
        }

        .info-item p {
            font-size: 16px;
            color: #333;
            font-weight: 500;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                align-items: flex-start;
            }

            nav ul {
                margin-top: 15px;
            }

            nav ul li {
                margin-left: 0;
                margin-right: 20px;
            }

            .user-menu {
                margin-top: 15px;
            }

            .dashboard {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                margin-right: 0;
                margin-bottom: 20px;
            }

            .profile-card {
                flex-direction: column;
                text-align: center;
            }

            .profile-image {
                margin-right: 0;
                margin-bottom: 20px;
            }

            .info-group {
                grid-template-columns: 1fr;
            }
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
    </style>
</head>
<body>
    <%
    // Check if user is logged in
    if (session.getAttribute("username") == null) {
        response.sendRedirect("../Login.jsp");
        return;
    }

    // Get user information
    String username = (String) session.getAttribute("username");
    String name = (String) session.getAttribute("name");
    if (name == null) {
        name = username;
    }

    // Get patient from request attribute (set by PatientProfileServlet)
    User patient = (User) request.getAttribute("patient");

    // Fallback to session if patient is null
    if (patient == null) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId != null) {
            UserDAO userDAO = new UserDAO();
            patient = userDAO.getUserById(userId);
        }
    }
    %>

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
                        <li><a href="../AboutUs.jsp">About Us</a></li>
                        <li><a href="../ContactUs.jsp">Contact Us</a></li>
                    </ul>
                </nav>
                <div class="user-menu">
                    <div class="user-menu-toggle">
                        <img src="https://via.placeholder.com/40x40" alt="Patient">
                        <span><%= name %></span>
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

    <!-- Dashboard -->
    <div class="container">
        <div class="dashboard">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="patient-sidebar-header">
                    <img src="https://via.placeholder.com/50x50" alt="Patient">
                    <div class="patient-info">
                        <h3><%= name %></h3>
                        <p>Patient</p>
                    </div>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="appointments"><i class="fas fa-calendar-check"></i> My Appointments</a></li>
                    <li><a href="book-appointment"><i class="fas fa-plus-circle"></i> Book Appointment</a></li>
                    <li><a href="find-doctor"><i class="fas fa-user-md"></i> Find Doctors</a></li>
                    <li><a href="medical-records"><i class="fas fa-file-medical"></i> Medical Records</a></li>
                    <li><a href="prescriptions"><i class="fas fa-prescription"></i> Prescriptions</a></li>
                    <li><a href="profile" class="active"><i class="fas fa-user"></i> Profile</a></li>
                    <li><a href="settings"><i class="fas fa-cog"></i> Settings</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="profile-section">
                    <h2>My Profile</h2>

                    <!-- Alert Messages -->
                    <% if (session.getAttribute("successMessage") != null) { %>
                    <div class="alert alert-success">
                        <%= session.getAttribute("successMessage") %>
                        <% session.removeAttribute("successMessage"); %>
                    </div>
                    <% } %>

                    <% if (session.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger">
                        <%= session.getAttribute("errorMessage") %>
                        <% session.removeAttribute("errorMessage"); %>
                    </div>
                    <% } %>

                    <div class="profile-card">
                        <div class="profile-image">
                            <img src="https://via.placeholder.com/120x120" alt="<%= name %>">
                        </div>
                        <div class="profile-details">
                            <h3><%= name %></h3>
                            <p><i class="fas fa-envelope"></i> <%= patient != null && patient.getEmail() != null ? patient.getEmail() : username + "@example.com" %></p>
                            <p><i class="fas fa-phone"></i> <%= patient != null && patient.getPhone() != null ? patient.getPhone() : "Not specified" %></p>
                            <div class="profile-actions">
                                <a href="edit-profile.jsp" class="btn">Edit Profile</a>
                                <a href="change-password.jsp" class="btn btn-outline">Change Password</a>
                            </div>
                        </div>
                    </div>

                    <div class="profile-info">
                        <h3>Personal Information</h3>
                        <div class="info-group">
                            <div class="info-item">
                                <label>Full Name</label>
                                <p><%= patient != null ? patient.getName() : name %></p>
                            </div>
                            <div class="info-item">
                                <label>Date of Birth</label>
                                <p><%= patient != null && patient.getDateOfBirth() != null ? patient.getDateOfBirth().toString() : "Not specified" %></p>
                            </div>
                            <div class="info-item">
                                <label>Gender</label>
                                <p><%= patient != null && patient.getGender() != null ? patient.getGender() : "Not specified" %></p>
                            </div>
                            <div class="info-item">
                                <label>Blood Type</label>
                                <p><%= patient != null && patient.getBloodGroup() != null ? patient.getBloodGroup() : "Not specified" %></p>
                            </div>
                        </div>

                        <h3>Contact Information</h3>
                        <div class="info-group">
                            <div class="info-item">
                                <label>Email</label>
                                <p><%= patient != null && patient.getEmail() != null ? patient.getEmail() : username + "@example.com" %></p>
                            </div>
                            <div class="info-item">
                                <label>Phone</label>
                                <p><%= patient != null && patient.getPhone() != null ? patient.getPhone() : "Not specified" %></p>
                            </div>
                            <div class="info-item">
                                <label>Address</label>
                                <p><%= patient != null && patient.getAddress() != null ? patient.getAddress() : "Not specified" %></p>
                            </div>
                            <div class="info-item">
                                <label>Emergency Contact</label>
                                <p><%= patient != null && patient.getEmergencyContact() != null ? patient.getEmergencyContact() : "Not specified" %></p>
                            </div>
                        </div>

                        <h3>Medical Information</h3>
                        <div class="info-group">
                            <div class="info-item">
                                <label>Medical History</label>
                                <p><%= patient != null && patient.getMedicalHistory() != null ? patient.getMedicalHistory() : "No medical history recorded" %></p>
                            </div>
                            <div class="info-item">
                                <label>Primary Physician</label>
                                <p>Dr. Available Doctor</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="../js/cache-control.js"></script>
    <script>
        // Toggle user menu dropdown
        document.addEventListener('DOMContentLoaded', function() {
            const userMenuToggle = document.querySelector('.user-menu-toggle');
            const userMenuDropdown = document.querySelector('.user-menu-dropdown');

            userMenuToggle.addEventListener('click', function() {
                userMenuDropdown.style.display = userMenuDropdown.style.display === 'block' ? 'none' : 'block';
            });

            // Close dropdown when clicking outside
            document.addEventListener('click', function(event) {
                if (!userMenuToggle.contains(event.target) && !userMenuDropdown.contains(event.target)) {
                    userMenuDropdown.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
