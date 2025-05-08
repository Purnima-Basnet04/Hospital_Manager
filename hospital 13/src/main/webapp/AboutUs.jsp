<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - LifeCare Medical Center</title>
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

        nav ul li a.active {
            color: #0275d8;
            font-weight: bold;
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

        /* About Section Styles */
        .about-section {
            padding: 80px 0;
            background-color: #fff;
        }

        .about-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
            margin-top: 50px;
            align-items: center;
        }

        .about-image {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .about-image img {
            width: 100%;
            height: auto;
            display: block;
        }

        .about-text h3 {
            font-size: 28px;
            margin-bottom: 20px;
            color: #333;
            position: relative;
            padding-bottom: 15px;
        }

        .about-text h3::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 60px;
            height: 3px;
            background: linear-gradient(to right, #0275d8, #0056b3);
            border-radius: 2px;
        }

        .about-text p {
            margin-bottom: 20px;
            color: #6c757d;
            line-height: 1.8;
        }

        /* Mission Vision Section */
        .mission-vision-section {
            padding: 80px 0;
            background-color: #f8f9fa;
            position: relative;
        }

        .mission-vision-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100px;
            background: linear-gradient(to bottom, #fff, #f8f9fa);
        }

        .mission-vision-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 50px;
            position: relative;
            z-index: 1;
        }

        .mission-card, .vision-card, .values-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            padding: 40px 30px;
            transition: transform 0.3s, box-shadow 0.3s;
            border: 1px solid rgba(0, 0, 0, 0.05);
            text-align: center;
        }

        .mission-card:hover, .vision-card:hover, .values-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
            border-color: rgba(2, 117, 216, 0.2);
        }

        .mission-icon, .vision-icon, .values-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #0275d8, #0056b3);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            box-shadow: 0 10px 20px rgba(2, 117, 216, 0.2);
        }

        .mission-icon i, .vision-icon i, .values-icon i {
            font-size: 32px;
            color: #fff;
        }

        .mission-card h3, .vision-card h3, .values-card h3 {
            font-size: 24px;
            margin-bottom: 15px;
            color: #333;
            font-weight: 600;
        }

        .mission-card p, .vision-card p, .values-card p {
            color: #6c757d;
            line-height: 1.6;
        }

        /* Team Section */
        .team-section {
            padding: 80px 0;
            background-color: #fff;
        }

        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 30px;
            margin-top: 50px;
        }

        .team-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .team-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
            border-color: rgba(2, 117, 216, 0.2);
        }

        .team-image {
            height: 250px;
            overflow: hidden;
            position: relative;
        }

        .team-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .team-card:hover .team-image img {
            transform: scale(1.05);
        }

        .team-info {
            padding: 20px;
            text-align: center;
        }

        .team-info h3 {
            font-size: 20px;
            margin-bottom: 5px;
            color: #333;
        }

        .team-info p {
            color: #0275d8;
            font-weight: 500;
            margin-bottom: 15px;
        }

        .team-social {
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        .team-social a {
            width: 35px;
            height: 35px;
            background-color: #f8f9fa;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #0275d8;
            transition: all 0.3s;
        }

        .team-social a:hover {
            background-color: #0275d8;
            color: #fff;
        }

        /* Section Title */
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

            .about-content {
                grid-template-columns: 1fr;
            }

            .mission-vision-container {
                grid-template-columns: 1fr;
            }

            .team-grid {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
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
                        <li><a href="AboutUs.jsp" class="active">About Us</a></li>
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
            <h1>About Us</h1>
            <p>Learn about our history, mission, and the dedicated team behind LifeCare Medical Center.</p>
        </div>
    </section>

    <!-- About Section -->
    <section class="about-section">
        <div class="container">
            <h2 class="section-title">Our Story</h2>
            <p class="section-description">Discover how we've been serving our community with excellence for over two decades.</p>

            <div class="about-content">
                <div class="about-image">
                    <img src="https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1453&q=80" alt="LifeCare Medical Center">
                </div>

                <div class="about-text">
                    <h3>Excellence in Healthcare Since 2000</h3>
                    <p>LifeCare Medical Center was founded in 2000 with a vision to provide accessible, high-quality healthcare to our community. What began as a small clinic with just five doctors has grown into a comprehensive medical center with state-of-the-art facilities and over 100 healthcare professionals.</p>

                    <p>Over the past two decades, we have continuously evolved to meet the changing healthcare needs of our patients. We've expanded our services, upgraded our technology, and enhanced our facilities, all while maintaining our commitment to personalized, compassionate care.</p>

                    <p>Today, LifeCare Medical Center stands as a beacon of healthcare excellence, serving thousands of patients each year. We take pride in our reputation for clinical expertise, patient satisfaction, and community involvement.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Mission, Vision, Values Section -->
    <section class="mission-vision-section">
        <div class="container">
            <h2 class="section-title">Our Mission, Vision & Values</h2>
            <p class="section-description">The principles that guide our work and define our commitment to healthcare excellence.</p>

            <div class="mission-vision-container">
                <div class="mission-card">
                    <div class="mission-icon">
                        <i class="fas fa-heartbeat"></i>
                    </div>
                    <h3>Our Mission</h3>
                    <p>To provide exceptional healthcare services that improve the health and wellbeing of our patients and communities through compassionate care, clinical excellence, and continuous innovation.</p>
                </div>

                <div class="vision-card">
                    <div class="vision-icon">
                        <i class="fas fa-eye"></i>
                    </div>
                    <h3>Our Vision</h3>
                    <p>To be the healthcare provider of choice, recognized for our clinical excellence, patient-centered approach, and positive impact on the communities we serve.</p>
                </div>

                <div class="values-card">
                    <div class="values-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <h3>Our Values</h3>
                    <p>Compassion, Excellence, Integrity, Respect, Teamwork, and Innovation guide everything we do at LifeCare Medical Center.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Team Section -->
    <section class="team-section">
        <div class="container">
            <h2 class="section-title">Our Leadership Team</h2>
            <p class="section-description">Meet the dedicated professionals who lead our organization.</p>

            <div class="team-grid">
                <div class="team-card">
                    <div class="team-image">
                        <img src="https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80" alt="Dr. Sarah Johnson">
                    </div>
                    <div class="team-info">
                        <h3>Dr. Sarah Johnson</h3>
                        <p>Chief Medical Officer</p>
                        <div class="team-social">
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fas fa-envelope"></i></a>
                        </div>
                    </div>
                </div>

                <div class="team-card">
                    <div class="team-image">
                        <img src="https://images.unsplash.com/photo-1622253692010-333f2da6031d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1528&q=80" alt="Dr. Michael Chen">
                    </div>
                    <div class="team-info">
                        <h3>Dr. Michael Chen</h3>
                        <p>Chief Executive Officer</p>
                        <div class="team-social">
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fas fa-envelope"></i></a>
                        </div>
                    </div>
                </div>

                <div class="team-card">
                    <div class="team-image">
                        <img src="https://images.unsplash.com/photo-1594824476967-48c8b964273f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1374&q=80" alt="Dr. Emily Rodriguez">
                    </div>
                    <div class="team-info">
                        <h3>Dr. Emily Rodriguez</h3>
                        <p>Director of Patient Services</p>
                        <div class="team-social">
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fas fa-envelope"></i></a>
                        </div>
                    </div>
                </div>

                <div class="team-card">
                    <div class="team-image">
                        <img src="https://images.unsplash.com/photo-1559839734-2b71ea197ec2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80" alt="Dr. James Wilson">
                    </div>
                    <div class="team-info">
                        <h3>Dr. James Wilson</h3>
                        <p>Head of Research</p>
                        <div class="team-social">
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fas fa-envelope"></i></a>
                        </div>
                    </div>
                </div>
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
