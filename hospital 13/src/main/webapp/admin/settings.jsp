<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - Admin Dashboard</title>
    <!-- Using locally hosted Font Awesome instead of CDN -->
    <link rel="stylesheet" href="../css/fontawesome/all.min.css">
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
            padding: 8px 15px;
            border-radius: 4px;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
            font-weight: 500;
        }

        .btn:hover {
            background-color: #0052a3;
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 14px;
        }

        .btn-danger {
            background-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
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

        /* Admin Dashboard Layout */
        .admin-dashboard {
            display: flex;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        /* Admin Sidebar */
        .admin-sidebar {
            width: 250px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-right: 20px;
            height: fit-content;
        }

        .admin-sidebar-header {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .admin-sidebar-header h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 5px;
        }

        .admin-sidebar-header p {
            color: #6c757d;
            font-size: 14px;
        }

        .admin-sidebar-menu {
            list-style: none;
        }

        .admin-sidebar-menu li {
            margin-bottom: 10px;
        }

        .admin-sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 10px;
            color: #333;
            border-radius: 4px;
            transition: all 0.3s;
        }

        .admin-sidebar-menu li a:hover {
            background-color: #f8f9fa;
            color: #0066cc;
        }

        .admin-sidebar-menu li a.active {
            background-color: #0066cc;
            color: white;
        }

        .admin-sidebar-menu li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* Admin Content */
        .admin-content {
            flex: 1;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .admin-header h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 5px;
        }

        .admin-header p {
            color: #6c757d;
        }

        /* Settings Styles */
        .settings-container {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }

        .settings-container h2 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }

        .settings-section {
            margin-bottom: 20px;
        }

        .settings-section h3 {
            font-size: 16px;
            color: #333;
            margin-bottom: 10px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-check {
            margin-bottom: 10px;
        }

        .form-check input[type="checkbox"] {
            margin-right: 10px;
        }

        .settings-actions {
            margin-top: 20px;
        }

        .settings-actions .btn {
            margin-right: 10px;
        }

        /* Database Settings */
        .database-settings table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }

        .database-settings table th,
        .database-settings table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }

        .database-settings table th {
            font-weight: 600;
            background-color: #f8f9fa;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .admin-dashboard {
                flex-direction: column;
            }

            .admin-sidebar {
                width: 100%;
                margin-right: 0;
                margin-bottom: 20px;
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
                        <li><a href="../departments">Departments</a></li>
                        <li><a href="../Service.jsp">Services</a></li>
                        <li><a href="../appointments.jsp">Appointments</a></li>
                    </ul>
                </nav>
                <div class="user-menu">
                    <div class="user-menu-toggle">
                        <img src="https://via.placeholder.com/40x40" alt="Admin">
                        <span>Admin</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="user-menu-dropdown">
                        <ul>
                            <li><a href="profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                            <li><a href="settings.jsp"><i class="fas fa-cog"></i> Settings</a></li>
                            <li><a href="../logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Admin Dashboard -->
    <div class="admin-dashboard">
        <!-- Sidebar -->
        <div class="admin-sidebar">
            <div class="admin-sidebar-header">
                <h3>Admin Panel</h3>
                <p>Manage your hospital</p>
            </div>
            <ul class="admin-sidebar-menu">
                <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                <li><a href="patients.jsp"><i class="fas fa-users"></i> Patients</a></li>
                <li><a href="doctors.jsp"><i class="fas fa-user-md"></i> Doctors</a></li>
                <li><a href="appointments.jsp"><i class="fas fa-calendar-check"></i> Appointments</a></li>
                <li><a href="departments.jsp"><i class="fas fa-hospital"></i> Departments</a></li>
                <li><a href="services.jsp"><i class="fas fa-stethoscope"></i> Services</a></li>
                <li><a href="reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a></li>
                <li><a href="settings.jsp" class="active"><i class="fas fa-cog"></i> Settings</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="admin-content">
            <div class="admin-header">
                <div class="admin-header-left">
                    <h1>System Settings</h1>
                    <p>Configure system settings and preferences</p>
                </div>
            </div>

            <!-- General Settings -->
            <div class="settings-container">
                <h2><i class="fas fa-sliders-h"></i> General Settings</h2>
                <form action="#" method="post">
                    <div class="form-group">
                        <label for="hospital-name">Hospital Name</label>
                        <input type="text" id="hospital-name" name="hospital-name" class="form-control" value="LifeCare Medical Center">
                    </div>
                    <div class="form-group">
                        <label for="hospital-email">Contact Email</label>
                        <input type="email" id="hospital-email" name="hospital-email" class="form-control" value="info@lifecaremedical.com">
                    </div>
                    <div class="form-group">
                        <label for="hospital-phone">Contact Phone</label>
                        <input type="tel" id="hospital-phone" name="hospital-phone" class="form-control" value="(123) 456-7890">
                    </div>
                    <div class="form-group">
                        <label for="hospital-address">Address</label>
                        <textarea id="hospital-address" name="hospital-address" class="form-control" rows="3">123 Medical Drive, Health City, HC 12345</textarea>
                    </div>
                    <div class="settings-actions">
                        <button type="submit" class="btn">Save Changes</button>
                    </div>
                </form>
            </div>

            <!-- Database Settings -->
            <div class="settings-container database-settings">
                <h2><i class="fas fa-database"></i> Database Configuration</h2>
                <table>
                    <tr>
                        <th>Parameter</th>
                        <th>Value</th>
                    </tr>
                    <tr>
                        <td>Database URL</td>
                        <td>jdbc:mysql://localhost:3306/lifecare_db</td>
                    </tr>
                    <tr>
                        <td>Database User</td>
                        <td>root</td>
                    </tr>
                    <tr>
                        <td>Connection Status</td>
                        <td><span style="color: #28a745;"><i class="fas fa-check-circle"></i> Connected</span></td>
                    </tr>
                </table>
                <div class="settings-actions">
                    <button type="button" class="btn">Test Connection</button>
                    <button type="button" class="btn">Update Configuration</button>
                </div>
            </div>

            <!-- Email Settings -->
            <div class="settings-container">
                <h2><i class="fas fa-envelope"></i> Email Configuration</h2>
                <form action="#" method="post">
                    <div class="form-group">
                        <label for="smtp-server">SMTP Server</label>
                        <input type="text" id="smtp-server" name="smtp-server" class="form-control" value="smtp.lifecaremedical.com">
                    </div>
                    <div class="form-group">
                        <label for="smtp-port">SMTP Port</label>
                        <input type="text" id="smtp-port" name="smtp-port" class="form-control" value="587">
                    </div>
                    <div class="form-group">
                        <label for="smtp-username">SMTP Username</label>
                        <input type="text" id="smtp-username" name="smtp-username" class="form-control" value="notifications@lifecaremedical.com">
                    </div>
                    <div class="form-group">
                        <label for="smtp-password">SMTP Password</label>
                        <input type="password" id="smtp-password" name="smtp-password" class="form-control" value="********">
                    </div>
                    <div class="form-check">
                        <input type="checkbox" id="smtp-ssl" name="smtp-ssl" checked>
                        <label for="smtp-ssl">Use SSL/TLS</label>
                    </div>
                    <div class="settings-actions">
                        <button type="button" class="btn">Test Email</button>
                        <button type="submit" class="btn">Save Configuration</button>
                    </div>
                </form>
            </div>

            <!-- System Maintenance -->
            <div class="settings-container">
                <h2><i class="fas fa-tools"></i> System Maintenance</h2>
                <div class="settings-section">
                    <h3>Backup & Restore</h3>
                    <p>Create and manage database backups</p>
                    <div class="settings-actions">
                        <button type="button" class="btn">Create Backup</button>
                        <button type="button" class="btn">Restore from Backup</button>
                    </div>
                </div>
                <div class="settings-section">
                    <h3>Cache Management</h3>
                    <p>Clear system cache to improve performance</p>
                    <div class="settings-actions">
                        <button type="button" class="btn">Clear Cache</button>
                    </div>
                </div>
                <div class="settings-section">
                    <h3>System Logs</h3>
                    <p>View and download system logs</p>
                    <div class="settings-actions">
                        <button type="button" class="btn">View Logs</button>
                        <button type="button" class="btn">Download Logs</button>
                    </div>
                </div>
            </div>

            <!-- Security Settings -->
            <div class="settings-container">
                <h2><i class="fas fa-shield-alt"></i> Security Settings</h2>
                <div class="settings-section">
                    <h3>Password Policy</h3>
                    <div class="form-check">
                        <input type="checkbox" id="require-uppercase" name="require-uppercase" checked>
                        <label for="require-uppercase">Require uppercase letters</label>
                    </div>
                    <div class="form-check">
                        <input type="checkbox" id="require-numbers" name="require-numbers" checked>
                        <label for="require-numbers">Require numbers</label>
                    </div>
                    <div class="form-check">
                        <input type="checkbox" id="require-special" name="require-special" checked>
                        <label for="require-special">Require special characters</label>
                    </div>
                    <div class="form-group">
                        <label for="min-length">Minimum password length</label>
                        <input type="number" id="min-length" name="min-length" class="form-control" value="8" min="6" max="20">
                    </div>
                </div>
                <div class="settings-section">
                    <h3>Session Settings</h3>
                    <div class="form-group">
                        <label for="session-timeout">Session timeout (minutes)</label>
                        <input type="number" id="session-timeout" name="session-timeout" class="form-control" value="30" min="5" max="120">
                    </div>
                    <div class="form-check">
                        <input type="checkbox" id="force-logout" name="force-logout" checked>
                        <label for="force-logout">Force logout after timeout</label>
                    </div>
                </div>
                <div class="settings-actions">
                    <button type="submit" class="btn">Save Security Settings</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Simple JavaScript for toggling the user menu
        document.addEventListener('DOMContentLoaded', function() {
            const userMenuToggle = document.querySelector('.user-menu-toggle');
            const userMenuDropdown = document.querySelector('.user-menu-dropdown');

            userMenuToggle.addEventListener('click', function() {
                userMenuDropdown.style.display = userMenuDropdown.style.display === 'block' ? 'none' : 'block';
            });

            // Close the dropdown when clicking outside
            document.addEventListener('click', function(event) {
                if (!userMenuToggle.contains(event.target) && !userMenuDropdown.contains(event.target)) {
                    userMenuDropdown.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
