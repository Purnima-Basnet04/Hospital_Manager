<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Prescription - LifeCare Medical Center</title>
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

        .logo {
            font-size: 24px;
            font-weight: 700;
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

        .user-menu-dropdown ul {
            list-style: none;
            padding: 10px 0;
        }

        .user-menu-dropdown ul li {
            padding: 0;
            margin: 0;
        }

        .user-menu-dropdown ul li a {
            display: block;
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

        /* Dashboard Layout */
        .dashboard-container {
            display: flex;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 250px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin-right: 30px;
        }

        .sidebar-menu {
            list-style: none;
            padding: 20px 0;
        }

        .sidebar-menu li {
            margin-bottom: 5px;
        }

        .sidebar-menu li a {
            display: block;
            padding: 10px 20px;
            color: #333;
            transition: background-color 0.3s;
            border-left: 3px solid transparent;
        }

        .sidebar-menu li a:hover, .sidebar-menu li a.active {
            background-color: #f8f9fa;
            border-left-color: #0275d8;
            color: #0275d8;
        }

        .sidebar-menu li a i {
            margin-right: 10px;
            color: #0275d8;
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
        }

        .page-title {
            margin-bottom: 20px;
        }

        .page-title h1 {
            font-size: 24px;
            color: #333;
        }

        /* Form Styles */
        .form-container {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        .form-section {
            margin-bottom: 30px;
        }

        .form-section h2 {
            font-size: 18px;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .form-group {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-field {
            margin-bottom: 15px;
        }

        .form-field label {
            display: block;
            font-size: 14px;
            color: #6c757d;
            margin-bottom: 5px;
        }

        .form-field input, .form-field select, .form-field textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 16px;
        }

        .form-field textarea {
            height: 100px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
            border: none;
        }

        .btn-primary {
            background-color: #0275d8;
            color: #fff;
        }

        .btn-primary:hover {
            background-color: #0069d9;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: #fff;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
        }

        /* Alert Styles */
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

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Patient Info Styles */
        .patient-info {
            background-color: #f8f9fa;
            border-radius: 5px;
            padding: 20px;
            margin-bottom: 20px;
            border-left: 4px solid #0275d8;
        }

        .patient-info h2 {
            font-size: 18px;
            color: #333;
            margin-bottom: 10px;
        }

        .patient-info p {
            margin-bottom: 5px;
        }

        .patient-info strong {
            font-weight: 600;
            color: #0275d8;
        }

        /* Alert Styles */
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

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-info {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                margin-right: 0;
                margin-bottom: 30px;
            }

            .form-group {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%
    // Check if user is logged in
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // Check if user is a doctor
    String role = (String) session.getAttribute("role");
    if (!"doctor".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // Get doctor information
    String username = (String) session.getAttribute("username");
    String name = (String) session.getAttribute("name");
    if (name == null) {
        name = username;
    }

    // Get patient ID from request parameter
    String patientIdStr = request.getParameter("patientId");
    int patientId = 0;
    User patient = null;

    if (patientIdStr != null && !patientIdStr.isEmpty()) {
        try {
            patientId = Integer.parseInt(patientIdStr);
            UserDAO userDAO = new UserDAO();
            patient = userDAO.getUserById(patientId);
        } catch (NumberFormatException e) {
            // Invalid patient ID
            System.out.println("Invalid patient ID: " + patientIdStr);
        }
    }

    // If patient not found, we'll show a dropdown to select a patient
    // No need to redirect
    %>

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
                        <li><a href="../departments">Departments</a></li>
                        <li><a href="../Service.jsp">Services</a></li>
                        <li><a href="../appointments.jsp">Appointments</a></li>
                        <li><a href="../AboutUs.jsp">About Us</a></li>
                        <li><a href="../ContactUs.jsp">Contact Us</a></li>
                    </ul>
                </nav>
                <div class="user-menu">
                    <div class="user-menu-toggle">
                        <img src="https://via.placeholder.com/40x40" alt="Doctor">
                        <span><%= name %></span>
                    </div>
                    <div class="user-menu-dropdown">
                        <ul>
                            <li><a href="profile"><i class="fas fa-user"></i> Profile</a></li>
                            <li><a href="settings"><i class="fas fa-cog"></i> Settings</a></li>
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
                <ul class="sidebar-menu">
                    <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="patients"><i class="fas fa-users"></i> My Patients</a></li>
                    <li><a href="prescriptions" class="active"><i class="fas fa-prescription"></i> Prescriptions</a></li>
                    <li><a href="medical-records"><i class="fas fa-file-medical"></i> Medical Records</a></li>
                    <li><a href="schedule"><i class="fas fa-clock"></i> My Schedule</a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> Profile</a></li>
                    <li><a href="settings"><i class="fas fa-cog"></i> Settings</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="page-title">
                    <h1>Add Prescription</h1>
                </div>

                <!-- Alert Messages -->
                <% if (session.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <%= session.getAttribute("errorMessage") %>
                    <% session.removeAttribute("errorMessage"); %>
                </div>
                <% } %>

                <% if (patient != null) { %>
                <!-- Patient Information -->
                <div class="patient-info">
                    <h2>Patient Information</h2>
                    <p><strong>Name:</strong> <%= patient.getName() %></p>
                    <p><strong>ID:</strong> <%= patient.getId() %></p>
                    <% if (patient.getDateOfBirth() != null) { %>
                    <p><strong>Date of Birth:</strong> <%= new java.text.SimpleDateFormat("MMMM d, yyyy").format(patient.getDateOfBirth()) %></p>
                    <% } %>
                    <% if (patient.getGender() != null && !patient.getGender().isEmpty()) { %>
                    <p><strong>Gender:</strong> <%= patient.getGender() %></p>
                    <% } %>
                    <% if (patient.getBloodGroup() != null && !patient.getBloodGroup().isEmpty()) { %>
                    <p><strong>Blood Group:</strong> <%= patient.getBloodGroup() %></p>
                    <% } %>
                </div>
                <% } else { %>
                <!-- No patient selected -->
                <div class="alert alert-info">
                    <p>Please select a patient to create a prescription.</p>
                </div>
                <% } %>

                <!-- Add Prescription Form -->
                <div class="form-container">
                    <form action="${pageContext.request.contextPath}/doctor/add-prescription" method="post">
                        <% if (patient != null) { %>
                        <!-- Hidden field for patient ID -->
                        <input type="hidden" name="patientId" value="<%= patient.getId() %>">
                        <% } else { %>
                        <!-- Patient Selection -->
                        <div class="form-section">
                            <h2>Select Patient</h2>
                            <div class="form-group">
                                <div class="form-field">
                                    <label for="patientId">Patient*</label>
                                    <select id="patientId" name="patientId" required>
                                        <option value="">-- Select Patient --</option>
                                        <%
                                        // Get all patients
                                        UserDAO userDAO = new UserDAO();
                                        List<User> patients = userDAO.getAllPatients();

                                        // Display patients in dropdown
                                        for (User p : patients) {
                                        %>
                                            <option value="<%= p.getId() %>"><%= p.getName() %></option>
                                        <% } %>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <% } %>

                        <!-- Prescription Information Section -->
                        <div class="form-section">
                            <h2>Prescription Details</h2>
                            <div class="form-group">
                                <div class="form-field">
                                    <label for="medication">Medication Name*</label>
                                    <input type="text" id="medication" name="medication" required>
                                </div>
                                <div class="form-field">
                                    <label for="dosage">Dosage*</label>
                                    <input type="text" id="dosage" name="dosage" placeholder="e.g., 500mg" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="form-field">
                                    <label for="frequency">Frequency*</label>
                                    <input type="text" id="frequency" name="frequency" placeholder="e.g., Twice daily" required>
                                </div>
                                <div class="form-field">
                                    <label for="duration">Duration*</label>
                                    <input type="text" id="duration" name="duration" placeholder="e.g., 7 days" required>
                                </div>
                            </div>
                            <div class="form-field">
                                <label for="instructions">Instructions</label>
                                <textarea id="instructions" name="instructions" placeholder="Special instructions for the patient"></textarea>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <a href="patients" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary">Save Prescription</button>
                            <% if (session.getAttribute("errorMessage") != null) { %>
                            <button type="button" id="debug-btn" class="btn" style="background-color: #6c757d; color: white; margin-left: 10px;">Debug Form</button>
                            <% } %>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Toggle user menu dropdown
        document.addEventListener('DOMContentLoaded', function() {
            const userMenuToggle = document.querySelector('.user-menu-toggle');
            const userMenuDropdown = document.querySelector('.user-menu-dropdown');

            userMenuToggle.addEventListener('click', function() {
                userMenuDropdown.style.display = userMenuDropdown.style.display === 'block' ? 'none' : 'block';
            });

            // Close dropdown when clicking outside
            document.addEventListener('click', function(event) {
                if (!userMenuToggle.contains(event.target) && !userMenuDropdown.contains(event.target)) {
                    userMenuDropdown.style.display = 'none';
                }
            });

            // Debug button functionality
            const debugBtn = document.getElementById('debug-btn');
            if (debugBtn) {
                debugBtn.addEventListener('click', function() {
                    const formData = new FormData(document.querySelector('form[action="${pageContext.request.contextPath}/doctor/add-prescription"]'));
                    let debugInfo = 'Form Data:\n';
                    for (let pair of formData.entries()) {
                        debugInfo += pair[0] + ': ' + pair[1] + '\n';
                    }
                    debugInfo += '\nSession Info:\n';
                    debugInfo += 'User ID: <%= session.getAttribute("userId") %>\n';
                    debugInfo += 'Username: <%= session.getAttribute("username") %>\n';
                    debugInfo += 'Role: <%= session.getAttribute("role") %>\n';

                    alert(debugInfo);
                    console.log(debugInfo);
                });
            }

            // Form validation
            const prescriptionForm = document.querySelector('form[action="${pageContext.request.contextPath}/doctor/add-prescription"]');
            if (prescriptionForm) {
                prescriptionForm.addEventListener('submit', function(e) {
                    let isValid = true;
                    let errorMessage = '';

                    // Get form fields
                    const patientId = document.getElementById('patientId');
                    const medication = document.getElementById('medication');
                    const dosage = document.getElementById('dosage');
                    const frequency = document.getElementById('frequency');
                    const duration = document.getElementById('duration');

                    // Validate patient selection
                    if (patientId && patientId.value === '') {
                        errorMessage += 'Please select a patient.\n';
                        isValid = false;
                    }

                    // Validate medication
                    if (medication.value.trim() === '') {
                        errorMessage += 'Please enter a medication name.\n';
                        isValid = false;
                    }

                    // Validate dosage
                    if (dosage.value.trim() === '') {
                        errorMessage += 'Please enter a dosage.\n';
                        isValid = false;
                    }

                    // Validate frequency
                    if (frequency.value.trim() === '') {
                        errorMessage += 'Please enter a frequency.\n';
                        isValid = false;
                    }

                    // Validate duration
                    if (duration.value.trim() === '') {
                        errorMessage += 'Please enter a duration.\n';
                        isValid = false;
                    }

                    // If validation fails, prevent form submission and show error
                    if (!isValid) {
                        e.preventDefault();
                        alert('Please correct the following errors:\n' + errorMessage);
                    } else {
                        console.log('Form is valid, submitting...');
                    }
                });
            }
        });
    </script>
</body>
</html>
