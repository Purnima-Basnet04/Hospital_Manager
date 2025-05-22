<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.Department" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
// Get attributes from both request and session
String username = (String) request.getAttribute("username");
if (username == null) {
    username = (String) session.getAttribute("username");
}

String name = (String) request.getAttribute("name");
if (name == null) {
    name = (String) session.getAttribute("name");
}

String role = (String) request.getAttribute("role");
if (role == null) {
    role = (String) session.getAttribute("role");
}

String displayName = (name != null && !name.isEmpty()) ? name : username;

// Format date
SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>Find a Doctor - Patient Dashboard</title>
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
            color: #0066cc;
            border: 1px solid #0066cc;
        }

        .btn-outline-primary:hover {
            background-color: #0066cc;
            color: white;
        }

        .btn-sm {
            padding: 8px 15px;
            font-size: 14px;
        }

        .btn-success {
            background-color: #28a745;
        }

        .btn-success:hover {
            background-color: #218838;
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

        /* Dashboard Layout */
        .dashboard-container {
            display: flex;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 250px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-right: 20px;
            height: fit-content;
        }

        .sidebar-header {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .sidebar-header h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 5px;
        }

        .sidebar-header p {
            color: #6c757d;
            font-size: 14px;
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
            color: #333;
            border-radius: 4px;
            transition: all 0.3s;
        }

        .sidebar-menu li a:hover {
            background-color: #f8f9fa;
            color: #0066cc;
        }

        .sidebar-menu li a.active {
            background-color: #0066cc;
            color: white;
        }

        .sidebar-menu li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
        }

        .welcome-header {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .welcome-header h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 10px;
        }

        .welcome-header p {
            color: #6c757d;
        }

        /* Search and Filter */
        .search-filter {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
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
            min-width: 150px;
        }

        /* Doctors Grid */
        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .doctor-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s;
        }

        .doctor-card:hover {
            transform: translateY(-5px);
        }

        .doctor-header {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .doctor-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            margin-right: 15px;
            object-fit: cover;
        }

        .doctor-name {
            font-size: 18px;
            color: #333;
            margin-bottom: 5px;
        }

        .doctor-specialization {
            color: #6c757d;
            font-size: 14px;
        }

        .doctor-details {
            padding: 15px;
        }

        .doctor-details p {
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }

        .doctor-details p i {
            width: 20px;
            margin-right: 10px;
            color: #0066cc;
        }

        .doctor-actions {
            padding: 15px;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                text-align: center;
            }

            nav ul {
                margin-top: 15px;
                justify-content: center;
            }

            nav ul li {
                margin: 0 10px;
            }

            .user-menu {
                margin-top: 15px;
            }

            .dashboard-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                margin-right: 0;
                margin-bottom: 20px;
            }

            .search-filter {
                flex-direction: column;
            }

            .search-filter input[type="text"],
            .search-filter select,
            .search-filter button {
                width: 100%;
            }

            .doctors-grid {
                grid-template-columns: 1fr;
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
                        <% if (session.getAttribute("username") != null) { %>
                            <% if ("patient".equals(session.getAttribute("role"))) { %>
                                <li><a href="dashboard" class="active">Patient Dashboard</a></li>
                            <% } else if ("doctor".equals(session.getAttribute("role"))) { %>
                                <li><a href="../doctor/dashboard">Doctor Dashboard</a></li>
                            <% } else if ("admin".equals(session.getAttribute("role"))) { %>
                                <li><a href="../admin/dashboard">Admin Dashboard</a></li>
                            <% } %>
                        <% } %>
                        <li><a href="../departments">Departments</a></li>
                        <li><a href="../Service.jsp">Services</a></li>
                        <li><a href="../appointments.jsp">Appointments</a></li>
                        <li><a href="../AboutUs.jsp">About Us</a></li>
                        <li><a href="../ContactUs.jsp">Contact Us</a></li>
                    </ul>
                </nav>
                <div class="user-menu">
                    <div class="user-menu-toggle">
                        <img src="https://via.placeholder.com/40x40" alt="User">
                        <span><%= displayName %></span>
                    </div>
                    <div class="user-menu-dropdown">
                        <ul>
                            <li><a href="profile"><i class="fas fa-user"></i> Profile</a></li>
                            <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
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
                <div class="sidebar-header">
                    <h3>Patient Portal</h3>
                    <p>Manage your healthcare</p>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="appointments"><i class="fas fa-calendar-check"></i> My Appointments</a></li>
                    <li><a href="book-appointment"><i class="fas fa-plus-circle"></i> Book Appointment</a></li>
                    <li><a href="find-doctor" class="active"><i class="fas fa-user-md"></i> Find Doctors</a></li>
                    <li><a href="medical-records"><i class="fas fa-file-medical"></i> Medical Records</a></li>
                    <li><a href="prescriptions"><i class="fas fa-prescription"></i> Prescriptions</a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> Profile</a></li>
                    <li><a href="settings"><i class="fas fa-cog"></i> Settings</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Welcome Header -->
                <div class="welcome-header">
                    <h1>Find a Doctor</h1>
                    <p>Browse our doctors and book an appointment.</p>
                </div>

                <!-- Search and Filter -->
                <form action="find-doctor" method="post" class="search-filter">
                    <input type="text" id="searchInput" name="search" placeholder="Search doctors..." value="${searchQuery}">
                    <select name="department" onchange="this.form.submit()">
                        <option value="0">All Departments</option>
                        <c:forEach var="department" items="${departments}">
                            <option value="${department.id}" ${departmentFilter eq department.id.toString() ? 'selected' : ''}>
                                ${department.name}
                            </option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn">Search</button>
                </form>

                <!-- Doctors Grid -->
                <div class="doctors-grid" id="doctorsGrid">
                    <c:choose>
                        <c:when test="${not empty doctors}">
                            <c:forEach var="doctor" items="${doctors}">
                                <div class="doctor-card" data-name="${doctor.name}" data-specialization="${doctor.specialization}">
                                    <div class="doctor-header">
                                        <img src="https://via.placeholder.com/60x60" alt="Doctor" class="doctor-avatar">
                                        <div>
                                            <h3 class="doctor-name">${doctor.name}</h3>
                                            <p class="doctor-specialization">${doctor.specialization}</p>
                                        </div>
                                    </div>
                                    <div class="doctor-details">
                                        <p><i class="fas fa-envelope"></i> ${not empty doctor.email ? doctor.email : 'Not provided'}</p>
                                        <p><i class="fas fa-phone"></i> ${not empty doctor.phone ? doctor.phone : 'Not provided'}</p>
                                        <p><i class="fas fa-venus-mars"></i> ${not empty doctor.gender ? doctor.gender : 'Not specified'}</p>
                                    </div>
                                    <div class="doctor-actions">
                                        <a href="view-doctor?id=${doctor.id}" class="btn btn-sm">View Profile</a>
                                        <a href="book-appointment?doctorId=${doctor.id}" class="btn btn-sm btn-success">Book Appointment</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="grid-column: 1 / -1; text-align: center; padding: 20px; background-color: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
                                <h3>No doctors found</h3>
                                <p>Try changing your search criteria or check back later.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
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

            // Client-side search filtering
            const searchInput = document.getElementById('searchInput');
            const doctorsGrid = document.getElementById('doctorsGrid');
            const doctorCards = doctorsGrid.querySelectorAll('.doctor-card');

            searchInput.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();

                doctorCards.forEach(function(card) {
                    const doctorName = card.getAttribute('data-name').toLowerCase();
                    const doctorSpecialization = card.getAttribute('data-specialization').toLowerCase();

                    if (doctorName.includes(searchTerm) || doctorSpecialization.includes(searchTerm)) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        });
    </script>
</body>
</html>
