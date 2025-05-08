<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.Department" %>
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

// Print attributes to console for debugging
System.out.println("Attributes in patient/book-appointment.jsp:");
System.out.println("username: " + username);
System.out.println("name: " + name);
System.out.println("role: " + role);
System.out.println("displayName: " + displayName);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <!-- Force refresh: <%= System.currentTimeMillis() %> -->
    <title>Book Appointment - LifeCare Medical Center</title>
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

        /* Appointment Form Styles */
        .appointment-form {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .appointment-form h2 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }

        .form-group {
            margin-bottom: 15px;
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
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #0066cc;
            box-shadow: 0 0 0 0.2rem rgba(0, 102, 204, 0.25);
        }

        .form-row {
            display: flex;
            margin: 0 -10px;
        }

        .form-col {
            flex: 1;
            padding: 0 10px;
        }

        /* Department Cards */
        .departments-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .department-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.3s;
            cursor: pointer;
        }

        .department-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .department-card.selected {
            border: 2px solid #0066cc;
        }

        .department-image {
            height: 120px;
            overflow: hidden;
        }

        .department-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .department-info {
            padding: 15px;
        }

        .department-info h3 {
            font-size: 16px;
            color: #333;
            margin-bottom: 5px;
        }

        .department-info p {
            color: #6c757d;
            font-size: 14px;
            height: 60px;
            overflow: hidden;
        }

        /* Footer Styles */
        footer {
            background-color: #343a40;
            color: white;
            padding: 60px 0 30px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }

        .footer-section h3 {
            font-size: 18px;
            margin-bottom: 20px;
            color: white;
        }

        .footer-section p {
            margin-bottom: 15px;
            color: #adb5bd;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 10px;
        }

        .footer-section ul li a {
            color: #adb5bd;
            transition: color 0.3s;
        }

        .footer-section ul li a:hover {
            color: #0066cc;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #adb5bd;
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

            .form-row {
                flex-direction: column;
            }

            .form-col {
                margin-bottom: 15px;
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
                                <li><a href="dashboard">Patient Dashboard</a></li>
                            <% } else if ("doctor".equals(session.getAttribute("role"))) { %>
                                <!-- Doctor functionality removed -->
                            <% } else if ("admin".equals(session.getAttribute("role"))) { %>
                                <li><a href="../admin/dashboard.jsp">Admin Dashboard</a></li>
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
                    <p>Manage your health</p>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="appointments"><i class="fas fa-calendar-check"></i> My Appointments</a></li>
                    <li><a href="book-appointment" class="active"><i class="fas fa-plus-circle"></i> Book Appointment</a></li>
                    <li><a href="find-doctor"><i class="fas fa-user-md"></i> Find Doctors</a></li>
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
                    <h1>Book Appointment</h1>
                    <p>Schedule a new appointment with one of our specialists.</p>
                </div>

                <!-- Appointment Form -->
                <div class="appointment-form">
                    <h2>Appointment Details</h2>
                    <!-- Step 1: Select Department -->
                    <c:if test="${empty selectedDepartmentId}">
                        <form action="${pageContext.request.contextPath}/patient/book-appointment" method="get">
                            <c:if test="${not empty errorMessage}">
                                <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-bottom: 15px;">
                                    ${errorMessage}
                                </div>
                            </c:if>
                            <c:if test="${not empty successMessage}">
                                <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-bottom: 15px;">
                                    ${successMessage}
                                </div>
                            </c:if>

                            <div class="form-group">
                                <label for="departmentId">Select Department</label>
                                <select id="departmentId" name="departmentId" class="form-control" required>
                                    <option value="">-- Select Department --</option>
                                    <c:forEach var="department" items="${departments}">
                                        <option value="${department.id}">${department.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn">Next: Select Doctor</button>
                            </div>
                        </form>
                    </c:if>

                    <!-- Step 2: Select Doctor and Complete Booking -->
                    <c:if test="${not empty selectedDepartmentId}">
                        <form action="${pageContext.request.contextPath}/patient/book-appointment" method="post">
                            <c:if test="${not empty errorMessage}">
                                <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-bottom: 15px;">
                                    ${errorMessage}
                                </div>
                            </c:if>
                            <c:if test="${not empty successMessage}">
                                <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-bottom: 15px;">
                                    ${successMessage}
                                </div>
                            </c:if>

                            <div class="form-group">
                                <label for="department">Department</label>
                                <select id="department" name="department" class="form-control" required onchange="loadDoctors(this.value)">
                                    <c:forEach var="department" items="${departments}">
                                        <option value="${department.id}" ${department.id eq selectedDepartmentId ? 'selected' : ''}>${department.name}</option>
                                    </c:forEach>
                                </select>
                                <p><a href="book-appointment">Change Department</a></p>
                            </div>
                            <div class="form-group">
                                <label for="doctor">Select Doctor</label>
                                <select id="doctor" name="doctor" class="form-control" required>
                                    <option value="">-- Select Doctor --</option>
                                    <c:forEach var="doctor" items="${doctors}">
                                        <option value="${doctor.id}" ${(selectedDoctor != null && doctor.id eq selectedDoctor.id) ? 'selected' : ''}>${doctor.name}</option>
                                    </c:forEach>
                                </select>
                                <div id="doctorLoadingIndicator" style="display: none; margin-top: 5px;">
                                    <i class="fas fa-spinner fa-spin"></i> Loading doctors...
                                </div>

                                <!-- Doctor Information (shown when doctor is selected from Find Doctor page) -->
                                <c:if test="${selectedDoctor != null}">
                                    <div class="doctor-info" style="margin-top: 15px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; border-left: 4px solid #0066cc;">
                                        <h4 style="margin-top: 0; color: #0066cc;">Selected Doctor Information</h4>
                                        <p><strong>Name:</strong> ${selectedDoctor.name}</p>
                                        <p><strong>Specialization:</strong> ${selectedDoctor.specialization}</p>
                                        <c:if test="${not empty selectedDoctor.email}"><p><strong>Email:</strong> ${selectedDoctor.email}</p></c:if>
                                        <c:if test="${not empty selectedDoctor.phone}"><p><strong>Phone:</strong> ${selectedDoctor.phone}</p></c:if>
                                    </div>
                                </c:if>
                            </div>
                            <div class="form-row">
                                <div class="form-col">
                                    <div class="form-group">
                                        <label for="appointmentDate">Appointment Date</label>
                                        <input type="date" id="appointmentDate" name="appointmentDate" class="form-control" required>
                                    </div>
                                </div>
                                <div class="form-col">
                                    <div class="form-group">
                                        <label for="timeSlot">Appointment Time</label>
                                        <select id="timeSlot" name="timeSlot" class="form-control" required>
                                            <option value="">-- Select Time --</option>
                                            <option value="09:00 AM">09:00 AM</option>
                                            <option value="09:30 AM">09:30 AM</option>
                                            <option value="10:00 AM">10:00 AM</option>
                                            <option value="10:30 AM">10:30 AM</option>
                                            <option value="11:00 AM">11:00 AM</option>
                                            <option value="11:30 AM">11:30 AM</option>
                                            <option value="12:00 PM">12:00 PM</option>
                                            <option value="02:00 PM">02:00 PM</option>
                                            <option value="02:30 PM">02:30 PM</option>
                                            <option value="03:00 PM">03:00 PM</option>
                                            <option value="03:30 PM">03:30 PM</option>
                                            <option value="04:00 PM">04:00 PM</option>
                                            <option value="04:30 PM">04:30 PM</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="notes">Reason for Visit</label>
                                <textarea id="notes" name="notes" class="form-control" rows="4" required></textarea>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn">Book Appointment</button>
                            </div>
                        </form>
                    </c:if>
                </div>

                <!-- Department Selection (only show if no department selected) -->
                <c:if test="${empty selectedDepartmentId}">
                    <div class="appointment-form">
                        <h2>Browse Departments</h2>
                        <p style="margin-bottom: 15px;">Click on a department to see available specialists and services.</p>
                        <div class="departments-grid">
                            <c:forEach var="department" items="${departments}">
                                <div class="department-card" onclick="selectDepartment(${department.id})">
                                    <div class="department-image">
                                        <img src="../images/departments/${department.name.toLowerCase()}.jpg" alt="${department.name}" onerror="this.src='../images/departments/default.jpg'">
                                    </div>
                                    <div class="department-info">
                                        <h3>${department.name}</h3>
                                        <p>${department.description != null ? department.description : 'Specialized healthcare services'}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>About Us</h3>
                    <p>LifeCare Medical Center is dedicated to providing exceptional healthcare services with compassion and expertise.</p>
                </div>
                <div class="footer-section">
                    <h3>Quick Links</h3>
                    <ul>
                        <li><a href="../index.jsp">Home</a></li>
                        <li><a href="../departments">Departments</a></li>
                        <li><a href="../Service.jsp">Services</a></li>
                        <li><a href="../appointments.jsp">Appointments</a></li>
                        <li><a href="../AboutUs.jsp">About Us</a></li>
                        <li><a href="../ContactUs.jsp">Contact Us</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Contact Us</h3>
                    <p><i class="fas fa-map-marker-alt"></i> 123 Medical Drive, Health City, HC 12345</p>
                    <p><i class="fas fa-phone"></i> (123) 456-7890</p>
                    <p><i class="fas fa-envelope"></i> info@lifecaremedical.com</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2023 LifeCare Medical Center. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const userMenuToggle = document.querySelector('.user-menu-toggle');
            const userMenuDropdown = document.querySelector('.user-menu-dropdown');

            userMenuToggle.addEventListener('click', function() {
                userMenuDropdown.style.display = userMenuDropdown.style.display === 'block' ? 'none' : 'block';
            });

            // Close dropdown when clicking outside
            document.addEventListener('click', function(event) {
                if (!event.target.closest('.user-menu')) {
                    userMenuDropdown.style.display = 'none';
                }
            });

            // Set minimum date for appointment to today
            const dateInput = document.getElementById('appointmentDate');
            if (dateInput) {
                const today = new Date();
                const yyyy = today.getFullYear();
                const mm = String(today.getMonth() + 1).padStart(2, '0');
                const dd = String(today.getDate()).padStart(2, '0');
                const todayStr = `${yyyy}-${mm}-${dd}`;
                dateInput.min = todayStr;
                dateInput.value = todayStr; // Set default date to today
            }

            // If a doctor is selected, show the doctor info section
            const doctorSelect = document.getElementById('doctor');
            if (doctorSelect && doctorSelect.value) {
                // Show doctor info if it exists
                const doctorInfo = document.querySelector('.doctor-info');
                if (doctorInfo) {
                    doctorInfo.style.display = 'block';
                }
            }
        });

        function selectDepartment(departmentId) {
            // Update the department select dropdown
            document.getElementById('departmentId').value = departmentId;

            // Highlight the selected department card
            const departmentCards = document.querySelectorAll('.department-card');
            departmentCards.forEach(card => {
                card.classList.remove('selected');
            });
            event.currentTarget.classList.add('selected');

            // Submit the form to select the department
            document.querySelector('form').submit();
        }

        // Add event listener to doctor select dropdown
        function handleDoctorChange() {
            const doctorSelect = document.getElementById('doctor');
            if (doctorSelect) {
                doctorSelect.addEventListener('change', function() {
                    // If a doctor is selected, fetch their details and show them
                    if (this.value) {
                        // In a real implementation, you would fetch doctor details via AJAX
                        // For now, we'll just redirect to reload the page with the selected doctor
                        const departmentId = document.getElementById('department').value;
                        window.location.href = 'book-appointment?departmentId=' + departmentId + '&doctorId=' + this.value;
                    }
                });
            }
        }

        // Call the function when the DOM is loaded
        document.addEventListener('DOMContentLoaded', function() {
            handleDoctorChange();
        });

        function loadDoctors(departmentId) {
            if (!departmentId) return;

            // Show loading indicator
            const loadingIndicator = document.getElementById('doctorLoadingIndicator');
            if (loadingIndicator) loadingIndicator.style.display = 'block';

            // Clear current doctor options except the first one
            const doctorSelect = document.getElementById('doctor');
            while (doctorSelect.options.length > 1) {
                doctorSelect.remove(1);
            }

            // Create and send AJAX request
            const xhr = new XMLHttpRequest();
            xhr.open('GET', '${pageContext.request.contextPath}/patient/book-appointment?departmentId=' + departmentId + '&ajax=true', true);

            xhr.onload = function() {
                if (xhr.status === 200) {
                    try {
                        const doctors = JSON.parse(xhr.responseText);

                        // Add new options to the doctor dropdown
                        doctors.forEach(doctor => {
                            const option = document.createElement('option');
                            option.value = doctor.id;
                            option.textContent = doctor.name;
                            doctorSelect.appendChild(option);
                        });
                    } catch (e) {
                        console.error('Error parsing JSON response:', e);
                    }
                } else {
                    console.error('Request failed with status:', xhr.status);
                }

                // Hide loading indicator
                if (loadingIndicator) loadingIndicator.style.display = 'none';
            };

            xhr.onerror = function() {
                console.error('Request failed');
                // Hide loading indicator
                if (loadingIndicator) loadingIndicator.style.display = 'none';
            };

            xhr.send();
        }
    </script>
</body>
</html>
