<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LifeCare Medical Center</title>
    <!-- Using locally hosted Font Awesome instead of CDN -->
    <link rel="stylesheet" href="css/fontawesome/all.min.css">
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

        .text-center {
            text-align: center;
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

        .btn-lg {
            padding: 12px 24px;
            font-size: 18px;
            border-radius: 8px;
        }

        .view-all-container {
            margin-top: 40px;
        }

        .view-all-container .btn i {
            margin-left: 8px;
            transition: transform 0.3s;
        }

        .view-all-container .btn:hover i {
            transform: translateX(5px);
        }

        /* Section Title Styles */
        .section-title {
            font-size: 36px;
            text-align: center;
            margin-bottom: 20px;
            position: relative;
            color: #333;
            font-weight: 700;
        }

        .section-title::after {
            content: '';
            display: block;
            width: 80px;
            height: 4px;
            background: linear-gradient(to right, #0275d8, #0056b3);
            margin: 15px auto 0;
            border-radius: 2px;
        }

        .section-description {
            text-align: center;
            color: #6c757d;
            max-width: 700px;
            margin: 0 auto 40px;
            font-size: 18px;
            line-height: 1.6;
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

        /* Hero Section */
        .hero-section {
            background-image: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            height: 600px;
            display: flex;
            align-items: center;
            color: white;
            text-align: center;
            padding-top: 80px; /* Account for fixed header */
        }

        .hero-content {
            max-width: 800px;
            margin: 0 auto;
        }

        .hero-content h1 {
            font-size: 48px;
            margin-bottom: 20px;
            font-weight: 700;
        }

        .hero-content p {
            font-size: 18px;
            margin-bottom: 30px;
            line-height: 1.8;
        }

        .hero-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        /* Why Choose Us Section */
        .why-choose-us-section {
            padding: 100px 0;
            background-color: #f8f9fa;
            position: relative;
        }

        .why-choose-us-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('https://images.unsplash.com/photo-1504439468489-c8920d796a29?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80');
            background-size: cover;
            background-position: center;
            opacity: 0.05;
            z-index: 0;
        }

        .why-choose-us-section .container {
            position: relative;
            z-index: 1;
        }

        .why-choose-us-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-top: 50px;
        }

        .why-choose-us-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            padding: 40px 30px;
            transition: transform 0.3s, box-shadow 0.3s;
            border: 1px solid rgba(0, 0, 0, 0.05);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .why-choose-us-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
            border-color: rgba(2, 117, 216, 0.2);
        }

        .why-choose-us-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #0275d8, #0056b3);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 25px;
            box-shadow: 0 10px 20px rgba(2, 117, 216, 0.2);
        }

        .why-choose-us-icon i {
            font-size: 32px;
            color: #fff;
        }

        .why-choose-us-content h3 {
            font-size: 22px;
            margin-bottom: 15px;
            color: #333;
            font-weight: 600;
        }

        .why-choose-us-content p {
            color: #6c757d;
            line-height: 1.6;
            margin-bottom: 0;
        }

        /* Departments Section */
        .departments-section {
            padding: 100px 0;
            background-color: #ffffff;
            position: relative;
        }

        .departments-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100px;
            background: linear-gradient(to bottom, #f8f9fa, #ffffff);
        }

        .departments-section .container {
            position: relative;
            z-index: 1;
        }

        .departments-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
            margin: 50px 0 40px;
            max-width: 1400px;
            margin-left: auto;
            margin-right: auto;
        }

        .department-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            border: 1px solid rgba(0, 0, 0, 0.05);
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .department-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
            border-color: rgba(2, 117, 216, 0.2);
        }

        .department-image {
            height: 220px;
            overflow: hidden;
            position: relative;
        }

        .department-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .department-card:hover .department-image img {
            transform: scale(1.05);
        }

        .department-content {
            padding: 25px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .department-content h3 {
            font-size: 22px;
            margin-bottom: 12px;
            color: #333;
            font-weight: 600;
        }

        .department-divider {
            width: 50px;
            height: 3px;
            background: linear-gradient(to right, #0275d8, #0056b3);
            margin-bottom: 15px;
            border-radius: 2px;
        }

        .department-content p {
            color: #6c757d;
            margin-bottom: 20px;
            line-height: 1.6;
            flex: 1;
        }

        .department-meta {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            font-size: 14px;
            color: #6c757d;
            background-color: #f8f9fa;
            padding: 12px;
            border-radius: 6px;
        }

        .department-meta span {
            display: flex;
            align-items: center;
        }

        .department-meta i {
            margin-right: 8px;
            color: #0275d8;
            font-size: 16px;
        }

        .department-actions {
            display: flex;
            gap: 10px;
            margin-top: auto;
        }

        .department-actions a {
            flex: 1;
            text-align: center;
            padding: 10px 0;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .department-actions a.btn-outline-primary {
            border: 1px solid #0275d8;
            color: #0275d8;
        }

        .department-actions a.btn-outline-primary:hover {
            background-color: #0275d8;
            color: white;
        }

        .department-actions a.btn-primary {
            background-color: #0275d8;
            color: white;
        }

        .department-actions a.btn-primary:hover {
            background-color: #0056b3;
        }

        /* CTA Section */
        .cta-section {
            background-color: #0066cc;
            color: white;
            padding: 60px 0;
            text-align: center;
        }

        .cta-section h2 {
            font-size: 36px;
            margin-bottom: 20px;
        }

        .cta-section p {
            font-size: 18px;
            margin-bottom: 30px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }

        .btn-white {
            background-color: white;
            color: #0066cc;
        }

        .btn-white:hover {
            background-color: #f0f0f0;
        }

        .btn-outline-white {
            background-color: transparent;
            border: 2px solid white;
            color: white;
        }

        .btn-outline-white:hover {
            background-color: white;
            color: #0066cc;
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

            .hero-content h1 {
                font-size: 36px;
            }

            .hero-section {
                height: 500px;
            }

            .hero-buttons {
                flex-direction: column;
                align-items: center;
            }

            .hero-buttons a {
                width: 100%;
                margin-bottom: 10px;
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

            .hero-content h1 {
                font-size: 28px;
            }

            .hero-section {
                height: 400px;
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
                        <li><a href="index.jsp" class="active">Home</a></li>
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
                                    <li><a href="doctor/profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                                    <li><a href="doctor/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
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
    <section class="hero-section">
        <div class="container">
            <div class="hero-content">
                <h1>Your Health Is Our Priority</h1>
                <p>
                    LifeCare Medical Center provides comprehensive healthcare services with state-of-the-art facilities and experienced medical professionals. We are committed to delivering the highest quality care to our patients.
                </p>
                <div class="hero-buttons">
                    <a href="Department.jsp" class="btn">Explore Departments</a>
                    <a href="appointments.jsp" class="btn btn-outline">Book Appointment</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Why Choose Us -->
    <section class="why-choose-us-section">
        <div class="container">
            <h2 class="section-title">Why Choose Us</h2>
            <p class="section-description">We are committed to providing exceptional healthcare services with compassion and expertise.</p>
            <div class="why-choose-us-grid">
                <!-- Experienced Doctors -->
                <div class="why-choose-us-card">
                    <div class="why-choose-us-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="why-choose-us-content">
                        <h3>Experienced Doctors</h3>
                        <p>Our team consists of highly qualified and experienced medical professionals dedicated to providing the best care.</p>
                    </div>
                </div>

                <!-- Modern Technology -->
                <div class="why-choose-us-card">
                    <div class="why-choose-us-icon">
                        <i class="fas fa-microscope"></i>
                    </div>
                    <div class="why-choose-us-content">
                        <h3>Modern Technology</h3>
                        <p>We utilize the latest medical technology and equipment to ensure accurate diagnosis and effective treatment.</p>
                    </div>
                </div>

                <!-- Patient-Centered Care -->
                <div class="why-choose-us-card">
                    <div class="why-choose-us-icon">
                        <i class="fas fa-heart"></i>
                    </div>
                    <div class="why-choose-us-content">
                        <h3>Patient-Centered Care</h3>
                        <p>We prioritize your comfort and well-being, tailoring our services to meet your individual needs.</p>
                    </div>
                </div>

                <!-- 24/7 Support -->
                <div class="why-choose-us-card">
                    <div class="why-choose-us-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="why-choose-us-content">
                        <h3>24/7 Support</h3>
                        <p>Our medical staff is available round-the-clock to provide emergency care and support when you need it most.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Departments -->
    <section class="departments-section">
        <div class="container">
            <h2 class="section-title">Our Key Departments</h2>
            <p class="section-description">Explore our specialized medical departments staffed with experienced healthcare professionals.</p>
            <div class="departments-grid">
                <!-- Cardiology -->
                <div class="department-card">
                    <div class="department-image">
                        <img src="images/departments/cardiology.jpg" alt="Cardiology Department">
                    </div>
                    <div class="department-content">
                        <h3>Cardiology</h3>
                        <div class="department-divider"></div>
                        <p>Specialized in diagnosing and treating heart diseases and cardiovascular conditions.</p>
                        <div class="department-meta">
                            <span><i class="icon-user"></i> 5 Specialists</span>
                            <span><i class="icon-location"></i> Building A, Floor 2</span>
                        </div>
                        <div class="department-actions">
                            <a href="departments?action=view&id=1" class="btn btn-outline-primary">View Details</a>
                            <a href="appointments?action=new&dept=1" class="btn btn-primary">Book</a>
                        </div>
                    </div>
                </div>

                <!-- Neurology -->
                <div class="department-card">
                    <div class="department-image">
                        <img src="images/departments/neurology.jpg" alt="Neurology Department">
                    </div>
                    <div class="department-content">
                        <h3>Neurology</h3>
                        <div class="department-divider"></div>
                        <p>Focused on disorders of the nervous system, including the brain, spinal cord, and nerves.</p>
                        <div class="department-meta">
                            <span><i class="icon-user"></i> 4 Specialists</span>
                            <span><i class="icon-location"></i> Building B, Floor 1</span>
                        </div>
                        <div class="department-actions">
                            <a href="departments?action=view&id=2" class="btn btn-outline-primary">View Details</a>
                            <a href="appointments?action=new&dept=2" class="btn btn-primary">Book</a>
                        </div>
                    </div>
                </div>

                <!-- Pediatrics -->
                <div class="department-card">
                    <div class="department-image">
                        <img src="images/departments/pediatrics.jpg" alt="Pediatrics Department">
                    </div>
                    <div class="department-content">
                        <h3>Pediatrics</h3>
                        <div class="department-divider"></div>
                        <p>Dedicated to the health and medical care of infants, children, and adolescents.</p>
                        <div class="department-meta">
                            <span><i class="icon-user"></i> 6 Specialists</span>
                            <span><i class="icon-location"></i> Building C, Floor 1</span>
                        </div>
                        <div class="department-actions">
                            <a href="departments?action=view&id=3" class="btn btn-outline-primary">View Details</a>
                            <a href="appointments?action=new&dept=3" class="btn btn-primary">Book</a>
                        </div>
                    </div>
                </div>

                <!-- Orthopedics -->
                <div class="department-card">
                    <div class="department-image">
                        <img src="images/departments/orthopedics.jpg" alt="Orthopedics Department">
                    </div>
                    <div class="department-content">
                        <h3>Orthopedics</h3>
                        <div class="department-divider"></div>
                        <p>Specializes in the diagnosis and treatment of conditions of the musculoskeletal system.</p>
                        <div class="department-meta">
                            <span><i class="icon-user"></i> 5 Specialists</span>
                            <span><i class="icon-location"></i> Building A, Floor 3</span>
                        </div>
                        <div class="department-actions">
                            <a href="departments?action=view&id=4" class="btn btn-outline-primary">View Details</a>
                            <a href="appointments?action=new&dept=4" class="btn btn-primary">Book</a>
                        </div>
                    </div>
                </div>

                <!-- Dermatology -->
                <div class="department-card">
                    <div class="department-image">
                        <img src="images/departments/dermatology.jpg" alt="Dermatology Department">
                    </div>
                    <div class="department-content">
                        <h3>Dermatology</h3>
                        <div class="department-divider"></div>
                        <p>Focuses on the diagnosis and treatment of conditions related to skin, hair, and nails.</p>
                        <div class="department-meta">
                            <span><i class="icon-user"></i> 3 Specialists</span>
                            <span><i class="icon-location"></i> Building B, Floor 2</span>
                        </div>
                        <div class="department-actions">
                            <a href="departments?action=view&id=5" class="btn btn-outline-primary">View Details</a>
                            <a href="appointments?action=new&dept=5" class="btn btn-primary">Book</a>
                        </div>
                    </div>
                </div>

                <!-- Ophthalmology -->
                <div class="department-card">
                    <div class="department-image">
                        <img src="images/departments/ophthalmology.jpg" alt="Ophthalmology Department">
                    </div>
                    <div class="department-content">
                        <h3>Ophthalmology</h3>
                        <div class="department-divider"></div>
                        <p>Specializes in the diagnosis and treatment of eye disorders and vision problems.</p>
                        <div class="department-meta">
                            <span><i class="icon-user"></i> 4 Specialists</span>
                            <span><i class="icon-location"></i> Building C, Floor 2</span>
                        </div>
                        <div class="department-actions">
                            <a href="departments?action=view&id=6" class="btn btn-outline-primary">View Details</a>
                            <a href="appointments?action=new&dept=6" class="btn btn-primary">Book</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="text-center view-all-container">
                <a href="departments" class="btn btn-primary btn-lg">View All Departments <i class="fas fa-arrow-right"></i></a>
            </div>
        </div>
    </section>

    <!-- Call to Action -->
    <section class="cta-section">
        <div class="container">
            <h2>Need Medical Assistance?</h2>
            <p>Our team of medical professionals is ready to provide you with the best healthcare services.</p>
            <div class="cta-buttons">
                <a href="appointments?action=new" class="btn btn-white">Book an Appointment</a>
                <a href="contact" class="btn btn-outline-white">Contact Us</a>
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