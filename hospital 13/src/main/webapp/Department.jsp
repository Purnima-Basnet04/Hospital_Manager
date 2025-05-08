<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Department" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Departments - LifeCare Medical Center</title>
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

        .auth-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: #0275d8;
            color: white;
            border-radius: 4px;
            text-align: center;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #014c8c;
            color: white;
        }

        .btn-outline-primary {
            background-color: transparent;
            border: 1px solid #0275d8;
            color: #0275d8;
        }

        .btn-outline-primary:hover {
            background-color: #0275d8;
            color: white;
        }

        /* Hero Section Styles */
        .hero {
            background: linear-gradient(135deg, #0275d8, #0056b3);
            color: white;
            padding: 80px 0;
            text-align: center;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('https://images.unsplash.com/photo-1504439468489-c8920d796a29?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80');
            background-size: cover;
            background-position: center;
            opacity: 0.15;
            z-index: 0;
        }

        .hero .container {
            position: relative;
            z-index: 1;
        }

        .hero h1 {
            font-size: 42px;
            margin-bottom: 20px;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        .hero p {
            font-size: 18px;
            max-width: 800px;
            margin: 0 auto;
            line-height: 1.6;
            opacity: 0.9;
        }

        /* Departments List Styles */
        .departments-list {
            padding: 80px 0;
            background-color: #f9f9f9;
            position: relative;
        }

        .departments-list::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100px;
            background: linear-gradient(to bottom, #fff, #f9f9f9);
        }

        .departments-list .container {
            position: relative;
            z-index: 1;
        }

        .departments-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .department-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            border: 1px solid #eaeaea;
        }

        .department-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
            border-color: #d1d1d1;
        }

        .department-image {
            height: 220px;
            overflow: hidden;
            position: relative;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .department-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
            display: block;
        }

        .department-card:hover .department-image img {
            transform: scale(1.05);
        }

        .department-image i {
            font-size: 80px;
            color: #0275d8;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
            background-color: #f8f9fa;
        }

        .department-info {
            padding: 20px;
            position: relative;
        }

        .department-info h3 {
            font-size: 20px;
            margin-bottom: 10px;
            color: #0275d8;
            font-weight: 600;
        }

        .department-info p {
            color: #6c757d;
            margin-bottom: 15px;
            line-height: 1.5;
            font-size: 14px;
        }

        .department-details {
            display: flex;
            justify-content: space-between;
            border-top: 1px solid #f1f1f1;
            padding-top: 15px;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .department-detail {
            display: flex;
            align-items: center;
            font-size: 13px;
            color: #555;
        }

        .department-detail i {
            margin-right: 5px;
            color: #0275d8;
            font-size: 14px;
        }

        .department-actions {
            margin-top: 15px;
            text-align: center;
        }

        .department-actions a {
            display: inline-block;
            padding: 10px 20px;
            background-color: #0275d8;
            color: white;
            border-radius: 30px;
            text-align: center;
            font-weight: 500;
            transition: all 0.3s;
            box-shadow: 0 2px 5px rgba(2, 117, 216, 0.2);
            width: 100%;
        }

        .department-actions a:hover {
            background-color: #014c8c;
            box-shadow: 0 4px 8px rgba(1, 76, 140, 0.3);
            transform: translateY(-2px);
        }

        .no-departments {
            text-align: center;
            padding: 50px 0;
        }

        .no-departments p {
            font-size: 18px;
            color: #6c757d;
            margin-bottom: 20px;
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

        /* Footer Styles */
        footer {
            background-color: #343a40;
            color: #fff;
            padding: 60px 0 20px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }

        .footer-section h3 {
            font-size: 18px;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 10px;
        }

        .footer-section h3::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 50px;
            height: 2px;
            background-color: #0275d8;
        }

        .footer-section p {
            margin-bottom: 15px;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 10px;
        }

        .footer-section ul li a {
            color: #fff;
            transition: color 0.3s;
        }

        .footer-section ul li a:hover {
            color: #0275d8;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
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

            .auth-buttons {
                margin-top: 15px;
            }

            .hero h1 {
                font-size: 28px;
            }

            .hero p {
                font-size: 16px;
            }

            .departments-grid {
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
                        <li><a href="appointments.jsp">Appointments</a></li>
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

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>Medical Departments</h1>
            <p>Explore our specialized medical departments and the services they offer.</p>
        </div>
    </section>

    <!-- Departments List -->
    <section class="departments-list">
        <div class="container">
            <div class="departments-grid">
                <%
                // Get departments from request attribute (set by the servlet)
                List<Department> departments = (List<Department>) request.getAttribute("departments");

                if (departments != null && !departments.isEmpty()) {
                    for (Department dept : departments) {
                %>
                    <div class="department-card">
                        <div class="department-image">
                            <% if (dept.getImageUrl() != null && !dept.getImageUrl().isEmpty()) { %>
                                <img src="<%= dept.getImageUrl() %>" alt="<%= dept.getName() %>">
                            <% } else { %>
                                <i class="fas fa-hospital-user"></i>
                            <% } %>
                        </div>
                        <div class="department-info">
                            <h3><%= dept.getName() %></h3>
                            <p><%= dept.getDescription() %></p>
                            <div class="department-details">
                                <div class="department-detail">
                                    <i class="fas fa-building"></i>
                                    <span><%= dept.getBuilding() %></span>
                                </div>
                                <div class="department-detail">
                                    <i class="fas fa-level-up-alt"></i>
                                    <span>Floor <%= dept.getFloor() %></span>
                                </div>
                                <div class="department-detail">
                                    <i class="fas fa-user-md"></i>
                                    <span><%= dept.getSpecialistsCount() %> Specialists</span>
                                </div>
                            </div>
                            <div class="department-actions">
                                <a href="departments?action=view&id=<%= dept.getId() %>">View Details</a>
                            </div>
                        </div>
                    </div>
                <%
                    }
                } else {
                %>
                    <div class="no-departments">
                        <p>No departments found. Please try again later.</p>
                    </div>
                <%
                }
                %>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>LifeCare Medical</h3>
                    <p>Providing quality healthcare services for over 20 years. Our mission is to improve the health and wellbeing of the communities we serve.</p>
                </div>
                <div class="footer-section">
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
                <div class="footer-section">
                    <h3>Contact Us</h3>
                    <p>123 Medical Drive, Healthcare City</p>
                    <p>(123) 456-7890</p>
                    <p>info@lifecaremedical.com</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 LifeCare Medical Center. All rights reserved.</p>
            </div>
        </div>
    </footer>
    <script src="js/cache-control.js"></script>
</body>
</html>
