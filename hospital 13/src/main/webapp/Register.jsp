<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Department" %>
<%@ page import="dao.DepartmentDAO" %>
<%
    // Get all departments for the dropdown
    DepartmentDAO departmentDAO = new DepartmentDAO();
    List<Department> departments = departmentDAO.getAllDepartments();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - LifeCare Medical Center</title>
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
            background-image: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
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
            width: 100%;
        }

        .btn:hover {
            background-color: #0052a3;
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

        /* Register Form */
        .register-section {
            padding: 150px 0 80px;
            min-height: 100vh;
            display: flex;
            align-items: center;
        }

        .register-container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 40px;
        }

        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .register-header h2 {
            font-size: 28px;
            color: #0066cc;
            margin-bottom: 10px;
        }

        .register-header p {
            color: #666;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            border-color: #0066cc;
            outline: none;
        }

        .form-row {
            display: flex;
            gap: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .form-footer {
            text-align: center;
            margin-top: 20px;
        }

        .form-footer p {
            margin-bottom: 10px;
            color: #666;
        }

        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
                gap: 0;
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
                        <li><a href="AboutUs.jsp">About Us</a></li>
                        <li><a href="ContactUs.jsp">Contact Us</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </header>

    <!-- Register Section -->
    <section class="register-section">
        <div class="container">
            <div class="register-container">
                <div class="register-header">
                    <h2>Create an Account</h2>
                    <p>Join LifeCare Medical Center to access our services</p>
                </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    ${errorMessage}
                </div>
            </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" class="form-control" placeholder="Your name" required>
                        </div>
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" class="form-control" placeholder="Username" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" class="form-control" placeholder="Email address" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone</label>
                            <input type="tel" id="phone" name="phone" class="form-control" placeholder="Phone number" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" class="form-control" placeholder="Password" required>
                        </div>
                        <div class="form-group">
                            <label for="confirm">Confirm Password</label>
                            <input type="password" id="confirm" name="confirm" class="form-control" placeholder="Confirm password" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="role">Role</label>
                            <select id="role" name="role" class="form-control" required onchange="toggleDepartmentDropdown()">
                                <option value="patient">Patient</option>
                                <option value="doctor">Doctor</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select id="gender" name="gender" class="form-control" required>
                                <option value="">Select Gender</option>
                                <option value="male">Male</option>
                                <option value="female">Female</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                    </div>

                    <!-- Department dropdown (initially hidden) -->
                    <div class="form-group" id="department-group" style="display: none;">
                        <label for="department">Department</label>
                        <select id="department" name="department" class="form-control">
                            <option value="">Select Department</option>
                            <% for(Department dept : departments) { %>
                                <option value="<%= dept.getId() %>"><%= dept.getName() %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="dob">Date of Birth</label>
                        <input type="date" id="dob" name="dob" class="form-control" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="blood">Blood Group</label>
                            <select id="blood" name="blood" class="form-control">
                                <option value="">Select</option>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="emergency">Emergency Contact</label>
                            <input type="tel" id="emergency" name="emergency" class="form-control" placeholder="Emergency number">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="address">Address</label>
                        <input type="text" id="address" name="address" class="form-control" placeholder="Your address">
                    </div>

                    <div class="form-group">
                        <label for="medical">Medical History</label>
                        <textarea id="medical" name="medical" class="form-control" rows="4" placeholder="Medical history"></textarea>
                    </div>

                    <button type="submit" class="btn">Register</button>

                    <div class="form-footer">
                        <p>Already have an account? <a href="Login.jsp">Login here</a></p>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <script src="js/script.js"></script>
    <script src="js/cache-control.js"></script>

    <script>
        // Function to toggle department dropdown based on selected role
        function toggleDepartmentDropdown() {
            var roleSelect = document.getElementById('role');
            var departmentGroup = document.getElementById('department-group');
            var departmentSelect = document.getElementById('department');

            if (roleSelect.value === 'doctor') {
                departmentGroup.style.display = 'block';
                departmentSelect.setAttribute('required', 'required');
            } else {
                departmentGroup.style.display = 'none';
                departmentSelect.removeAttribute('required');
            }
        }

        // Call the function on page load to set initial state
        document.addEventListener('DOMContentLoaded', function() {
            toggleDepartmentDropdown();
        });
    </script>
</body>
</html>