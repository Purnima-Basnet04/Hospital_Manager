<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - LifeCare Medical Center</title>
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

        /* Contact Section Styles */
        .contact-section {
            padding: 80px 0;
            background-color: #fff;
        }

        .contact-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
            margin-top: 50px;
        }

        .contact-info {
            background-color: #f8f9fa;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .contact-info h3 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
            position: relative;
            padding-bottom: 10px;
        }

        .contact-info h3::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 50px;
            height: 3px;
            background: linear-gradient(to right, #0275d8, #0056b3);
            border-radius: 2px;
        }

        .contact-details {
            margin-top: 30px;
        }

        .contact-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .contact-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #0275d8, #0056b3);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            flex-shrink: 0;
        }

        .contact-icon i {
            color: #fff;
            font-size: 18px;
        }

        .contact-text h4 {
            font-size: 18px;
            margin-bottom: 5px;
            color: #333;
        }

        .contact-text p {
            color: #6c757d;
            line-height: 1.5;
        }

        .contact-form {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            border: 1px solid #eaeaea;
        }

        .contact-form h3 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
            position: relative;
            padding-bottom: 10px;
        }

        .contact-form h3::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 50px;
            height: 3px;
            background: linear-gradient(to right, #0275d8, #0056b3);
            border-radius: 2px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            border-color: #0275d8;
            outline: none;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }

        .btn-submit {
            background: linear-gradient(135deg, #0275d8, #0056b3);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-block;
            text-align: center;
            width: 100%;
        }

        .btn-submit:hover {
            background: linear-gradient(135deg, #0056b3, #003d7a);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        /* Map Section */
        .map-section {
            padding: 50px 0;
            background-color: #f8f9fa;
        }

        .map-container {
            height: 400px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            margin-top: 30px;
        }

        .map-container iframe {
            width: 100%;
            height: 100%;
            border: 0;
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

            .contact-container {
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
                        <li><a href="ContactUs.jsp" class="active">Contact Us</a></li>
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
            <h1>Contact Us</h1>
            <p>We're here to help. Reach out to us with any questions or concerns about our services.</p>
        </div>
    </section>

    <!-- Contact Section -->
    <section class="contact-section">
        <div class="container">
            <h2 class="section-title">Get in Touch</h2>
            <p class="section-description">We value your feedback and are always ready to assist you with any inquiries.</p>

            <div class="contact-container">
                <div class="contact-info">
                    <h3>Contact Information</h3>
                    <div class="contact-details">
                        <div class="contact-item">
                            <div class="contact-icon">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <div class="contact-text">
                                <h4>Address</h4>
                                <p>123 Medical Drive, Healthcare City<br>New York, NY 10001</p>
                            </div>
                        </div>

                        <div class="contact-item">
                            <div class="contact-icon">
                                <i class="fas fa-phone-alt"></i>
                            </div>
                            <div class="contact-text">
                                <h4>Phone</h4>
                                <p>Main: (123) 456-7890<br>Emergency: (123) 456-7899</p>
                            </div>
                        </div>

                        <div class="contact-item">
                            <div class="contact-icon">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div class="contact-text">
                                <h4>Email</h4>
                                <p>info@lifecaremedical.com<br>appointments@lifecaremedical.com</p>
                            </div>
                        </div>

                        <div class="contact-item">
                            <div class="contact-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="contact-text">
                                <h4>Hours</h4>
                                <p>Monday - Friday: 8:00 AM - 8:00 PM<br>Saturday: 9:00 AM - 5:00 PM<br>Sunday: Closed (Emergency Only)</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="contact-form">
                    <h3>Send Us a Message</h3>
                    <form action="#" method="post">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" class="form-control">
                        </div>

                        <div class="form-group">
                            <label for="subject">Subject</label>
                            <input type="text" id="subject" name="subject" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="message">Message</label>
                            <textarea id="message" name="message" class="form-control" required></textarea>
                        </div>

                        <button type="submit" class="btn-submit">Send Message</button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Map Section -->
    <section class="map-section">
        <div class="container">
            <h2 class="section-title">Our Location</h2>
            <p class="section-description">Find us easily with the map below.</p>

            <div class="map-container">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d387193.3059353029!2d-74.25986548248684!3d40.69714941932609!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c24fa5d33f083b%3A0xc80b8f06e177fe62!2sNew%20York%2C%20NY%2C%20USA!5e0!3m2!1sen!2sin!4v1619427748465!5m2!1sen!2sin" allowfullscreen="" loading="lazy"></iframe>
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
