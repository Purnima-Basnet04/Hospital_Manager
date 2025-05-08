<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - LifeCare Medical Center</title>
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

        .logo {
            font-size: 24px;
            font-weight: 700;
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

        .user-menu-dropdown ul {
            list-style: none;
            padding: 10px 0;
        }

        .user-menu-dropdown ul li {
            padding: 0;
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
            color: #0275d8;
        }

        /* Dashboard Layout */
        .dashboard-container {
            display: flex;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 250px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin-right: 30px;
        }

        .sidebar-menu {
            list-style: none;
            padding: 20px 0;
        }

        .sidebar-menu li {
            margin-bottom: 5px;
        }

        .sidebar-menu li a {
            display: block;
            padding: 10px 20px;
            color: #333;
            transition: background-color 0.3s;
            border-left: 3px solid transparent;
        }

        .sidebar-menu li a:hover, .sidebar-menu li a.active {
            background-color: #f8f9fa;
            border-left-color: #0275d8;
            color: #0275d8;
        }

        .sidebar-menu li a i {
            margin-right: 10px;
            color: #0275d8;
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
        }

        .page-title {
            margin-bottom: 20px;
        }

        .page-title h1 {
            font-size: 24px;
            color: #333;
        }

        /* Form Styles */
        .form-container {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        .form-section {
            margin-bottom: 30px;
        }

        .form-section h2 {
            font-size: 18px;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .form-group {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-field {
            margin-bottom: 15px;
        }

        .form-field label {
            display: block;
            font-size: 14px;
            color: #6c757d;
            margin-bottom: 5px;
        }

        .form-field input, .form-field select, .form-field textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 16px;
        }

        .form-field textarea {
            height: 100px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
            border: none;
        }

        .btn-primary {
            background-color: #0275d8;
            color: #fff;
        }

        .btn-primary:hover {
            background-color: #0069d9;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: #fff;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
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
            .dashboard-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                margin-right: 0;
                margin-bottom: 30px;
            }

            .form-group {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%
    // Check if user is logged in
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // Get user information
    String username = (String) session.getAttribute("username");
    String name = (String) session.getAttribute("name");
    if (name == null) {
        name = username;
    }

    // Get patient from request attribute or session
    User patient = (User) request.getAttribute("patient");

    // Fallback to session if patient is null
    if (patient == null) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId != null) {
            UserDAO userDAO = new UserDAO();
            patient = userDAO.getUserById(userId);
        }
    }

    // Format date for date of birth field
    String dateOfBirthStr = "";
    if (patient != null && patient.getDateOfBirth() != null) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateOfBirthStr = dateFormat.format(patient.getDateOfBirth());
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

    <!-- Dashboard Container -->
    <div class="container">
        <div class="dashboard-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <ul class="sidebar-menu">
                    <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="appointments"><i class="fas fa-calendar-check"></i> My Appointments</a></li>
                    <li><a href="book-appointment"><i class="fas fa-plus-circle"></i> Book Appointment</a></li>
                    <li><a href="medical-records"><i class="fas fa-file-medical"></i> Medical Records</a></li>
                    <li><a href="prescriptions"><i class="fas fa-prescription"></i> Prescriptions</a></li>
                    <li><a href="profile.jsp" class="active"><i class="fas fa-user"></i> Profile</a></li>
                    <li><a href="settings.jsp"><i class="fas fa-cog"></i> Settings</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="page-title">
                    <h1>Edit Profile</h1>
                </div>

                <!-- Alert Messages -->
                <% if (session.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <%= session.getAttribute("errorMessage") %>
                    <% session.removeAttribute("errorMessage"); %>
                </div>
                <% } %>

                <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("errorMessage") %>
                </div>
                <% } %>

                <% if (session.getAttribute("successMessage") != null) { %>
                <div class="alert alert-success">
                    <%= session.getAttribute("successMessage") %>
                    <% session.removeAttribute("successMessage"); %>
                </div>
                <% } %>

                <% if (request.getAttribute("successMessage") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("successMessage") %>
                </div>
                <% } %>

                <!-- Edit Profile Form -->
                <div class="form-container">
                    <form action="${pageContext.request.contextPath}/patient/update-profile" method="post">
                        <!-- Hidden field for user ID -->
                        <input type="hidden" name="userId" value="<%= patient != null ? patient.getId() : "" %>">

                        <!-- Personal Information Section -->
                        <div class="form-section">
                            <h2>Personal Information</h2>
                            <div class="form-group">
                                <div class="form-field">
                                    <label for="name">Full Name</label>
                                    <input type="text" id="name" name="name" value="<%= patient != null ? patient.getName() : name %>" required>
                                </div>
                                <div class="form-field">
                                    <label for="dateOfBirth">Date of Birth</label>
                                    <input type="date" id="dateOfBirth" name="dateOfBirth" value="<%= dateOfBirthStr %>">
                                </div>
                                <div class="form-field">
                                    <label for="gender">Gender</label>
                                    <select id="gender" name="gender">
                                        <option value="">-- Select Gender --</option>
                                        <option value="Male" <%= patient != null && "Male".equals(patient.getGender()) ? "selected" : "" %>>Male</option>
                                        <option value="Female" <%= patient != null && "Female".equals(patient.getGender()) ? "selected" : "" %>>Female</option>
                                        <option value="Other" <%= patient != null && "Other".equals(patient.getGender()) ? "selected" : "" %>>Other</option>
                                    </select>
                                </div>
                                <div class="form-field">
                                    <label for="bloodGroup">Blood Type</label>
                                    <select id="bloodGroup" name="bloodGroup">
                                        <option value="">-- Select Blood Type --</option>
                                        <option value="A+" <%= patient != null && "A+".equals(patient.getBloodGroup()) ? "selected" : "" %>>A+</option>
                                        <option value="A-" <%= patient != null && "A-".equals(patient.getBloodGroup()) ? "selected" : "" %>>A-</option>
                                        <option value="B+" <%= patient != null && "B+".equals(patient.getBloodGroup()) ? "selected" : "" %>>B+</option>
                                        <option value="B-" <%= patient != null && "B-".equals(patient.getBloodGroup()) ? "selected" : "" %>>B-</option>
                                        <option value="AB+" <%= patient != null && "AB+".equals(patient.getBloodGroup()) ? "selected" : "" %>>AB+</option>
                                        <option value="AB-" <%= patient != null && "AB-".equals(patient.getBloodGroup()) ? "selected" : "" %>>AB-</option>
                                        <option value="O+" <%= patient != null && "O+".equals(patient.getBloodGroup()) ? "selected" : "" %>>O+</option>
                                        <option value="O-" <%= patient != null && "O-".equals(patient.getBloodGroup()) ? "selected" : "" %>>O-</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Contact Information Section -->
                        <div class="form-section">
                            <h2>Contact Information</h2>
                            <div class="form-group">
                                <div class="form-field">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" value="<%= patient != null && patient.getEmail() != null ? patient.getEmail() : "" %>">
                                </div>
                                <div class="form-field">
                                    <label for="phone">Phone</label>
                                    <input type="tel" id="phone" name="phone" value="<%= patient != null && patient.getPhone() != null ? patient.getPhone() : "" %>">
                                </div>
                                <div class="form-field">
                                    <label for="address">Address</label>
                                    <textarea id="address" name="address"><%= patient != null && patient.getAddress() != null ? patient.getAddress() : "" %></textarea>
                                </div>
                                <div class="form-field">
                                    <label for="emergencyContact">Emergency Contact</label>
                                    <input type="text" id="emergencyContact" name="emergencyContact" value="<%= patient != null && patient.getEmergencyContact() != null ? patient.getEmergencyContact() : "" %>">
                                </div>
                            </div>
                        </div>

                        <!-- Medical Information Section -->
                        <div class="form-section">
                            <h2>Medical Information</h2>
                            <div class="form-group">
                                <div class="form-field">
                                    <label for="medicalHistory">Medical History</label>
                                    <textarea id="medicalHistory" name="medicalHistory"><%= patient != null && patient.getMedicalHistory() != null ? patient.getMedicalHistory() : "" %></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <a href="profile.jsp" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

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
