<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.MedicalRecord" %>
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

// Print attributes to console for debugging
System.out.println("Attributes in patient/medical-records.jsp:");
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
    <title>Medical Records - LifeCare Medical Center</title>
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

        /* Medical Records Styles */
        .records-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .records-container h2 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }

        .record-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            transition: transform 0.3s;
        }

        .record-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .record-card h3 {
            font-size: 16px;
            color: #333;
            margin-bottom: 10px;
        }

        .record-card p {
            margin-bottom: 5px;
            color: #6c757d;
        }

        .record-card .record-date {
            display: flex;
            align-items: center;
            color: #0066cc;
            margin: 10px 0;
        }

        .record-card .record-date i {
            margin-right: 5px;
        }

        .record-actions {
            margin-top: 10px;
        }

        .record-filter {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .record-filter select {
            padding: 8px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }

        .record-search {
            display: flex;
        }

        .record-search input {
            padding: 8px;
            border: 1px solid #ced4da;
            border-radius: 4px 0 0 4px;
            font-size: 14px;
            width: 200px;
        }

        .record-search button {
            padding: 8px 15px;
            background-color: #0066cc;
            color: white;
            border: none;
            border-radius: 0 4px 4px 0;
            cursor: pointer;
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

            .record-filter {
                flex-direction: column;
                align-items: flex-start;
            }

            .record-search {
                margin-top: 10px;
                width: 100%;
            }

            .record-search input {
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
                        <% if (session.getAttribute("username") != null) { %>
                            <% if ("patient".equals(session.getAttribute("role"))) { %>
                                <li><a href="dashboard">Patient Dashboard</a></li>
                            <% } else if ("doctor".equals(session.getAttribute("role"))) { %>
                                <!-- Doctor has no dashboard -->
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
                    <li><a href="book-appointment"><i class="fas fa-plus-circle"></i> Book Appointment</a></li>
                    <li><a href="find-doctor"><i class="fas fa-user-md"></i> Find Doctors</a></li>
                    <li><a href="medical-records" class="active"><i class="fas fa-file-medical"></i> Medical Records</a></li>
                    <li><a href="prescriptions"><i class="fas fa-prescription"></i> Prescriptions</a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> Profile</a></li>
                    <li><a href="settings"><i class="fas fa-cog"></i> Settings</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Welcome Header -->
                <div class="welcome-header">
                    <h1>Medical Records</h1>
                    <p>View your complete medical history and records.</p>
                </div>

                <!-- Filter and Search -->
                <div class="records-container">
                    <form action="medical-records" method="post" class="record-filter">
                        <div>
                            <label for="record-type">Filter by: </label>
                            <select id="record-type" name="recordType">
                                <option value="all">All Records</option>
                                <option value="consultation">Consultations</option>
                                <option value="test">Test Results</option>
                                <option value="procedure">Procedures</option>
                                <option value="vaccination">Vaccinations</option>
                            </select>
                        </div>
                        <div class="record-search">
                            <input type="text" name="search" placeholder="Search records..." value="${searchQuery}">
                            <button type="submit"><i class="fas fa-search"></i></button>
                        </div>
                    </form>

                    <!-- Medical Records -->
                    <h2>My Medical Records</h2>

                    <c:choose>
                        <c:when test="${not empty medicalRecords}">
                            <c:forEach var="record" items="${medicalRecords}">
                                <div class="record-card">
                                    <h3>${record.diagnosis}</h3>
                                    <p>${record.doctorName}</p>
                                    <div class="record-date">
                                        <i class="fas fa-calendar-alt"></i>
                                        <span>
                                            <%
                                                SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
                                                MedicalRecord record = (MedicalRecord)pageContext.getAttribute("record");
                                                if (record.getRecordDate() != null) {
                                                    out.print(dateFormat.format(record.getRecordDate()));
                                                } else {
                                                    out.print("Date not available");
                                                }
                                            %>
                                        </span>
                                    </div>
                                    <p>${record.treatment}</p>
                                    <c:if test="${not empty record.prescription}">
                                        <p><strong>Prescription:</strong> ${record.prescription}</p>
                                    </c:if>
                                    <div class="record-actions">
                                        <a href="view-medical-record?id=${record.id}" class="btn btn-sm">View Details</a>
                                        <a href="download-medical-record?id=${record.id}" class="btn btn-sm btn-outline-primary">Download PDF</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 20px; background-color: #f8f9fa; border-radius: 8px; margin-top: 20px;">
                                <h3>No medical records found</h3>
                                <p>Your medical records will appear here after your appointments with doctors.</p>
                                <p>Please note that only actual medical records from the database will be displayed here.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
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

            // Filter functionality
            const recordTypeSelect = document.getElementById('record-type');
            const recordCards = document.querySelectorAll('.record-card');

            recordTypeSelect.addEventListener('change', function() {
                const selectedType = this.value;

                if (selectedType === 'all') {
                    recordCards.forEach(card => {
                        card.style.display = 'block';
                    });
                } else {
                    recordCards.forEach(card => {
                        const cardTitle = card.querySelector('h3').textContent.toLowerCase();
                        if (cardTitle.includes(selectedType)) {
                            card.style.display = 'block';
                        } else {
                            card.style.display = 'none';
                        }
                    });
                }
            });

            // Search functionality
            const searchInput = document.querySelector('.record-search input');
            const searchButton = document.querySelector('.record-search button');

            function performSearch() {
                const searchTerm = searchInput.value.toLowerCase();

                recordCards.forEach(card => {
                    const cardText = card.textContent.toLowerCase();
                    if (cardText.includes(searchTerm)) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            }

            searchButton.addEventListener('click', performSearch);
            searchInput.addEventListener('keyup', function(event) {
                if (event.key === 'Enter') {
                    performSearch();
                }
            });
        });
    </script>
</body>
</html>
