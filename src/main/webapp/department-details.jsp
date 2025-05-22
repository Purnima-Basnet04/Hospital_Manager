<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${department.name} - LifeCare Medical Center</title>
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

        .auth-buttons a {
            margin-left: 15px;
        }

        /* Department Banner */
        .department-banner {
            background-image: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1504439468489-c8920d796a29?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            height: 300px;
            display: flex;
            align-items: center;
            color: white;
            text-align: center;
            padding-top: 80px; /* Account for fixed header */
        }

        .department-banner h1 {
            font-size: 42px;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .department-banner p {
            font-size: 18px;
            max-width: 800px;
            margin: 0 auto;
        }

        /* Department Details */
        .department-details {
            padding: 80px 0;
            background-color: white;
        }

        .department-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 50px;
            align-items: center;
        }

        .department-image {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .department-image img {
            width: 100%;
            height: 400px;
            display: block;
            object-fit: cover;
        }

        .department-info h2 {
            font-size: 32px;
            color: #0066cc;
            margin-bottom: 20px;
        }

        .department-divider {
            width: 50px;
            height: 3px;
            background-color: #0066cc;
            margin-bottom: 20px;
        }

        .department-info p {
            margin-bottom: 20px;
            color: #666;
            font-size: 16px;
            line-height: 1.8;
        }

        .department-meta {
            margin-bottom: 30px;
        }

        .department-meta-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            color: #666;
        }

        .department-meta-item i {
            width: 30px;
            height: 30px;
            background-color: #e6f2ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: #0066cc;
        }

        .department-actions {
            display: flex;
            gap: 15px;
        }

        /* Doctors Section */
        .doctors-section {
            padding: 80px 0;
            background-color: #f8f9fa;
        }

        .section-title {
            font-size: 32px;
            color: #0066cc;
            margin-bottom: 40px;
            text-align: center;
        }

        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 30px;
        }

        .doctor-card {
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .doctor-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }

        .doctor-image {
            height: 250px;
            overflow: hidden;
        }

        .doctor-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .doctor-info {
            padding: 20px;
            text-align: center;
        }

        .doctor-info h3 {
            font-size: 18px;
            margin-bottom: 5px;
            color: #0066cc;
        }

        .doctor-info p {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .doctor-social {
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        .doctor-social a {
            width: 30px;
            height: 30px;
            background-color: #f0f0f0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            transition: all 0.3s;
        }

        .doctor-social a:hover {
            background-color: #0066cc;
            color: white;
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
        @media (max-width: 992px) {
            .department-content {
                grid-template-columns: 1fr;
            }

            .department-image {
                margin-bottom: 30px;
            }
        }

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

            .department-banner h1 {
                font-size: 32px;
            }

            .department-actions {
                flex-direction: column;
            }

            .doctors-grid {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
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

            .department-banner h1 {
                font-size: 28px;
            }

            .section-title {
                font-size: 28px;
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
                    <a href="index.jsp">LifeCare <span>Medical</span></a>
                </div>
                <nav>
                    <ul>
                        <li><a href="index.jsp">Home</a></li>
                        <li><a href="departments">Departments</a></li>
                        <li><a href="Service.jsp">Services</a></li>
                        <li><a href="appointments.jsp">Appointments</a></li>
                    </ul>
                </nav>
                <div class="auth-buttons">
                    <a href="Login.jsp" class="btn">Login</a>
                    <a href="Register.jsp" class="btn btn-outline-primary">Register</a>
                </div>
            </div>
        </div>
    </header>

    <!-- Department Banner -->
    <section class="department-banner">
        <div class="container">
            <h1>${department.name} Department</h1>
            <p>Specialized healthcare services for your needs</p>
        </div>
    </section>

    <!-- Department Details -->
    <section class="department-details">
        <div class="container">
            <div class="department-content">
                <div class="department-image">
                    <img src="${pageContext.request.contextPath}/images/departments/${fn:toLowerCase(fn:replace(department.name, ' ', '-'))}.jpg"
                         alt="${department.name} Department"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/departments/default-department.jpg';">
                </div>
                <div class="department-info">
                    <h2>${department.name}</h2>
                    <div class="department-divider"></div>
                    <p>${department.description}</p>
                    <div class="department-meta">
                        <div class="department-meta-item">
                            <i class="fas fa-user-md"></i>
                            <span>${department.specialistsCount} Specialists</span>
                        </div>
                        <div class="department-meta-item">
                            <i class="fas fa-building"></i>
                            <span>Location: ${department.building}</span>
                        </div>
                        <div class="department-meta-item">
                            <i class="fas fa-layer-group"></i>
                            <span>Floor: ${department.floor}</span>
                        </div>
                    </div>
                    <div class="department-actions">
                        <a href="appointments?action=new&dept=${department.id}" class="btn">Book Appointment</a>
                        <a href="departments" class="btn btn-outline-primary">Back to Departments</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Doctors Section -->
    <section class="doctors-section">
        <div class="container">
            <h2 class="section-title">Our Specialists</h2>
            <div class="doctors-grid">
                <!-- Sample Doctors -->
                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="https://via.placeholder.com/300x300?text=Doctor" alt="Doctor">
                    </div>
                    <div class="doctor-info">
                        <h3>Dr. John Smith</h3>
                        <p>Senior Specialist</p>
                        <div class="doctor-social">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                </div>

                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="https://via.placeholder.com/300x300?text=Doctor" alt="Doctor">
                    </div>
                    <div class="doctor-info">
                        <h3>Dr. Sarah Johnson</h3>
                        <p>Specialist</p>
                        <div class="doctor-social">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                </div>

                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="https://via.placeholder.com/300x300?text=Doctor" alt="Doctor">
                    </div>
                    <div class="doctor-info">
                        <h3>Dr. Michael Lee</h3>
                        <p>Specialist</p>
                        <div class="doctor-social">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                </div>

                <div class="doctor-card">
                    <div class="doctor-image">
                        <img src="https://via.placeholder.com/300x300?text=Doctor" alt="Doctor">
                    </div>
                    <div class="doctor-info">
                        <h3>Dr. Emily Chen</h3>
                        <p>Junior Specialist</p>
                        <div class="doctor-social">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
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
</body>
</html>
