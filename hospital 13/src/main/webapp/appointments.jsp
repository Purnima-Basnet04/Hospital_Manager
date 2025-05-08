<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments - LifeCare Medical Center</title>
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
            border: 2px solid #0066cc;
            color: #0066cc;
        }

        .btn-outline-primary:hover {
            background-color: #0066cc;
            color: white;
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

        nav ul li a.active {
            color: #0066cc;
            font-weight: bold;
        }

        .auth-buttons a {
            margin-left: 15px;
        }

        /* Appointments Section */
        .appointments-section {
            padding: 120px 0 80px;
            background-color: #f8f9fa;
        }

        .page-title {
            font-size: 36px;
            color: #0066cc;
            margin-bottom: 30px;
            text-align: center;
        }

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

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .action-buttons {
            margin-bottom: 30px;
            text-align: right;
        }

        .appointments-list {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        .no-appointments {
            text-align: center;
            padding: 50px 0;
            color: #666;
        }

        .appointments-table {
            width: 100%;
            border-collapse: collapse;
        }

        .appointments-table th,
        .appointments-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .appointments-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
        }

        .appointments-table tr:hover {
            background-color: #f8f9fa;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-scheduled {
            background-color: #e6f2ff;
            color: #0066cc;
        }

        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }

        .actions {
            display: flex;
            gap: 5px;
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
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

        /* Footer */
        footer {
            background-color: #333;
            color: white;
            padding: 60px 0 20px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            margin-bottom: 40px;
        }

        .footer-column h3 {
            font-size: 20px;
            margin-bottom: 20px;
            color: #0066cc;
        }

        .footer-column ul {
            list-style: none;
        }

        .footer-column ul li {
            margin-bottom: 10px;
        }

        .footer-column ul li a {
            color: #ccc;
            transition: color 0.3s;
        }

        .footer-column ul li a:hover {
            color: white;
        }

        .contact-info p {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .contact-info i {
            margin-right: 10px;
            color: #0066cc;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid #444;
        }

        /* Responsive Styles */
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

            .auth-buttons {
                margin-top: 20px;
            }

            .appointments-table {
                display: block;
                overflow-x: auto;
            }
        }

        @media (max-width: 576px) {
            nav ul {
                flex-wrap: wrap;
                justify-content: center;
            }

            nav ul li {
                margin: 5px 10px;
            }

            .page-title {
                font-size: 28px;
            }

            .action-buttons {
                text-align: center;
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
                    <a href="index.jsp">LifeCare <span>Medical</span></a>
                </div>
                <nav>
                    <ul>
                        <li><a href="index.jsp">Home</a></li>
                        <% if (session.getAttribute("username") != null) { %>
                            <% if ("patient".equals(session.getAttribute("role"))) { %>
                                <li><a href="patient/dashboard">Patient Dashboard</a></li>
                            <% } else if ("doctor".equals(session.getAttribute("role"))) { %>
                                <li><a href="doctor/dashboard">Doctor Dashboard</a></li>
                            <% } else if ("admin".equals(session.getAttribute("role"))) { %>
                                <li><a href="admin/dashboard.jsp">Admin Dashboard</a></li>
                            <% } %>
                        <% } %>
                        <li><a href="departments">Departments</a></li>
                        <li><a href="Service.jsp">Services</a></li>
                        <li><a href="appointments.jsp" class="active">Appointments</a></li>
                        <li><a href="AboutUs.jsp">About Us</a></li>
                        <li><a href="ContactUs.jsp">Contact Us</a></li>
                    </ul>
                </nav>
                <% if (session.getAttribute("username") == null) { %>
                    <div class="auth-buttons">
                        <a href="Login.jsp" class="btn">Login</a>
                        <a href="Register.jsp" class="btn btn-outline-primary">Register</a>
                    </div>
                <% } else { %>
                    <div class="user-menu">
                        <div class="user-menu-toggle">
                            <img src="https://via.placeholder.com/40x40" alt="User">
                            <span>${sessionScope.name != null ? sessionScope.name : sessionScope.username}</span>
                        </div>
                        <div class="user-menu-dropdown">
                            <ul>
                                <% if ("patient".equals(session.getAttribute("role"))) { %>
                                    <li><a href="patient/profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                                    <li><a href="patient/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                                <% } else if ("doctor".equals(session.getAttribute("role"))) { %>
                                    <li><a href="doctor/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                                    <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                                <% } else if ("admin".equals(session.getAttribute("role"))) { %>
                                    <li><a href="admin/profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                                    <li><a href="admin/dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                                <% } %>
                                <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                            </ul>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </header>

    <section class="appointments-section">
        <div class="container">
            <h1 class="page-title">My Appointments</h1>

            <%
            String successMessage = (String) request.getAttribute("successMessage");
            if (successMessage != null && !successMessage.isEmpty()) {
            %>
                <div class="alert alert-success">
                    <%= successMessage %>
                </div>
            <% } %>

            <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
                <div class="alert alert-error">
                    <%= errorMessage %>
                </div>
            <% } %>

            <div class="action-buttons">
                <a href="appointments?action=new" class="btn btn-primary">Book New Appointment</a>
            </div>

            <div class="appointments-list">
                <%
                List appointments = (List) request.getAttribute("appointments");
                if (appointments == null || appointments.isEmpty()) {
                %>
                    <div class="no-appointments">
                        <p>You don't have any appointments yet.</p>
                        <p>Click the "Book New Appointment" button to schedule one.</p>
                    </div>
                <% } else { %>
                    <table class="appointments-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Doctor</th>
                                <th>Department</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Sample appointment data for demonstration -->
                            <tr>
                                <td>1001</td>
                                <td>Dr. John Smith</td>
                                <td>Cardiology</td>
                                <td>2025-05-15</td>
                                <td>10:30 AM</td>
                                <td>
                                    <span class="status-badge status-scheduled">SCHEDULED</span>
                                </td>
                                <td class="actions">
                                    <a href="appointments?action=view&id=1001" class="btn btn-sm btn-outline">View</a>
                                    <a href="appointments?action=reschedule&id=1001" class="btn btn-sm btn-primary">Reschedule</a>
                                    <a href="appointments?action=cancel&id=1001" class="btn btn-sm btn-danger">Cancel</a>
                                </td>
                            </tr>
                            <tr>
                                <td>1002</td>
                                <td>Dr. Sarah Johnson</td>
                                <td>Neurology</td>
                                <td>2025-05-10</td>
                                <td>2:15 PM</td>
                                <td>
                                    <span class="status-badge status-completed">COMPLETED</span>
                                </td>
                                <td class="actions">
                                    <a href="appointments?action=view&id=1002" class="btn btn-sm btn-outline">View</a>
                                </td>
                            </tr>

                            <tr>
                                <td>1003</td>
                                <td>Dr. Michael Lee</td>
                                <td>Pediatrics</td>
                                <td>2025-05-20</td>
                                <td>9:00 AM</td>
                                <td>
                                    <span class="status-badge status-scheduled">SCHEDULED</span>
                                </td>
                                <td class="actions">
                                    <a href="appointments?action=view&id=1003" class="btn btn-sm btn-outline">View</a>
                                    <a href="appointments?action=reschedule&id=1003" class="btn btn-sm btn-primary">Reschedule</a>
                                    <a href="appointments?action=cancel&id=1003" class="btn btn-sm btn-danger">Cancel</a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-column">
                    <h3>LifeCare Medical</h3>
                    <p>Providing quality healthcare services for over 20 years. Our mission is to improve the health and wellbeing of the communities we serve.</p>
                </div>
                <div class="footer-column">
                    <h3>Quick Links</h3>
                    <ul>
                        <li><a href="index.jsp">Home</a></li>
                        <li><a href="departments">Departments</a></li>
                        <li><a href="Service.jsp">Services</a></li>
                        <li><a href="appointments.jsp">Appointments</a></li>
                        <li><a href="AboutUs.jsp">About Us</a></li>
                        <li><a href="ContactUs.jsp">Contact Us</a></li>
                    </ul>
                </div>
                <div class="footer-column contact-info">
                    <h3>Contact Us</h3>
                    <p><i class="fas fa-map-marker-alt"></i> 123 Medical Drive, Healthcare City</p>
                    <p><i class="fas fa-phone"></i> (123) 456-7890</p>
                    <p><i class="fas fa-envelope"></i> info@lifecaremedical.com</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 LifeCare Medical Center. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script src="js/script.js"></script>
    <script src="js/cache-control.js"></script>
</body>
</html>
