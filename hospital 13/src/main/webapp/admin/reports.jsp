<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Admin Dashboard</title>
    <!-- Using locally hosted Font Awesome instead of CDN -->
    <link rel="stylesheet" href="../css/fontawesome/all.min.css">
    <!-- Chart.js for data visualization -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

        /* Report Filters */
        .report-filters {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .report-filters select,
        .report-filters input[type="date"] {
            padding: 8px 15px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
            background-color: white;
        }

        /* Report Sections */
        .report-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e9ecef;
        }

        .report-section h2 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .report-section h2 i {
            margin-right: 10px;
            color: #0066cc;
        }

        /* Chart Containers */
        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: 20px;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .stat-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
            transition: transform 0.3s;
            border-left: 4px solid #0066cc;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card.patients {
            border-left-color: #28a745;
        }

        .stat-card.appointments {
            border-left-color: #ffc107;
        }

        .stat-card.doctors {
            border-left-color: #17a2b8;
        }

        .stat-card.revenue {
            border-left-color: #6f42c1;
        }

        .stat-card h3 {
            font-size: 24px;
            color: #333;
            margin-bottom: 5px;
        }

        .stat-card p {
            color: #6c757d;
            font-size: 14px;
        }

        /* Data Tables */
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        .data-table th,
        .data-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }

        .data-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #495057;
        }

        .data-table tr:hover {
            background-color: #f8f9fa;
        }

        /* Export Buttons */
        .export-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .export-btn {
            display: flex;
            align-items: center;
            background-color: #f8f9fa;
            color: #333;
            border: 1px solid #ced4da;
            padding: 8px 15px;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .export-btn:hover {
            background-color: #e9ecef;
        }

        .export-btn i {
            margin-right: 5px;
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

            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }

            .data-table {
                display: block;
                overflow-x: auto;
            }
        }

        @media (max-width: 576px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }

            .report-filters {
                flex-direction: column;
            }

            .report-filters select,
            .report-filters input[type="date"],
            .report-filters button {
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
                <li><a href="reports.jsp" class="active"><i class="fas fa-chart-bar"></i> Reports</a></li>
                <li><a href="settings.jsp"><i class="fas fa-cog"></i> Settings</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="admin-content">
            <div class="admin-header">
                <div class="admin-header-left">
                    <h1>Reports & Analytics</h1>
                    <p>View and analyze hospital performance metrics</p>
                </div>
                <div class="admin-header-right">
                    <button class="btn"><i class="fas fa-sync-alt"></i> Refresh Data</button>
                </div>
            </div>

            <!-- Report Filters -->
            <div class="report-filters">
                <select id="report-type">
                    <option value="overview">Overview</option>
                    <option value="appointments">Appointments</option>
                    <option value="patients">Patients</option>
                    <option value="departments">Departments</option>
                    <option value="revenue">Revenue</option>
                </select>
                <select id="time-period">
                    <option value="today">Today</option>
                    <option value="yesterday">Yesterday</option>
                    <option value="this-week">This Week</option>
                    <option value="last-week">Last Week</option>
                    <option value="this-month" selected>This Month</option>
                    <option value="last-month">Last Month</option>
                    <option value="this-year">This Year</option>
                    <option value="custom">Custom Range</option>
                </select>
                <input type="date" id="start-date" value="2025-05-01">
                <input type="date" id="end-date" value="2025-05-31">
                <button class="btn">Apply Filters</button>
            </div>

            <!-- Export Buttons -->
            <div class="export-buttons">
                <button class="export-btn"><i class="fas fa-file-pdf"></i> Export as PDF</button>
                <button class="export-btn"><i class="fas fa-file-excel"></i> Export as Excel</button>
                <button class="export-btn"><i class="fas fa-print"></i> Print Report</button>
            </div>

            <!-- Key Metrics -->
            <div class="report-section">
                <h2><i class="fas fa-chart-line"></i> Key Metrics (May 2025)</h2>
                <div class="stats-grid">
                    <div class="stat-card patients">
                        <h3>250</h3>
                        <p>Total Patients</p>
                    </div>
                    <div class="stat-card appointments">
                        <h3>128</h3>
                        <p>Appointments</p>
                    </div>
                    <div class="stat-card doctors">
                        <h3>32</h3>
                        <p>Active Doctors</p>
                    </div>
                    <div class="stat-card revenue">
                        <h3>$45,250</h3>
                        <p>Revenue</p>
                    </div>
                </div>
            </div>

            <!-- Appointments Trend -->
            <div class="report-section">
                <h2><i class="fas fa-calendar-check"></i> Appointments Trend</h2>
                <div class="chart-container">
                    <canvas id="appointmentsChart"></canvas>
                </div>
            </div>

            <!-- Department Performance -->
            <div class="report-section">
                <h2><i class="fas fa-hospital"></i> Department Performance</h2>
                <div class="chart-container">
                    <canvas id="departmentsChart"></canvas>
                </div>
            </div>

            <!-- Patient Demographics -->
            <div class="report-section">
                <h2><i class="fas fa-users"></i> Patient Demographics</h2>
                <div class="chart-container">
                    <canvas id="demographicsChart"></canvas>
                </div>
            </div>

            <!-- Revenue Analysis -->
            <div class="report-section">
                <h2><i class="fas fa-dollar-sign"></i> Revenue Analysis</h2>
                <div class="chart-container">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>

            <!-- Top Performing Doctors -->
            <div class="report-section">
                <h2><i class="fas fa-user-md"></i> Top Performing Doctors</h2>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Doctor</th>
                            <th>Department</th>
                            <th>Appointments</th>
                            <th>Patient Satisfaction</th>
                            <th>Revenue Generated</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Dr. Sarah Johnson</td>
                            <td>Cardiology</td>
                            <td>45</td>
                            <td>4.9/5.0</td>
                            <td>$12,450</td>
                        </tr>
                        <tr>
                            <td>Dr. Michael Lee</td>
                            <td>Neurology</td>
                            <td>38</td>
                            <td>4.8/5.0</td>
                            <td>$10,820</td>
                        </tr>
                        <tr>
                            <td>Dr. Lisa Chen</td>
                            <td>Orthopedics</td>
                            <td>32</td>
                            <td>4.7/5.0</td>
                            <td>$9,650</td>
                        </tr>
                        <tr>
                            <td>Dr. James Wilson</td>
                            <td>Pediatrics</td>
                            <td>29</td>
                            <td>4.9/5.0</td>
                            <td>$8,320</td>
                        </tr>
                        <tr>
                            <td>Dr. Emily Davis</td>
                            <td>Dermatology</td>
                            <td>26</td>
                            <td>4.6/5.0</td>
                            <td>$7,890</td>
                        </tr>
                    </tbody>
                </table>
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

            // Initialize charts
            // Appointments Trend Chart
            const appointmentsCtx = document.getElementById('appointmentsChart').getContext('2d');
            const appointmentsChart = new Chart(appointmentsCtx, {
                type: 'line',
                data: {
                    labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
                    datasets: [{
                        label: 'Scheduled',
                        data: [28, 35, 32, 33],
                        borderColor: '#0066cc',
                        backgroundColor: 'rgba(0, 102, 204, 0.1)',
                        tension: 0.4,
                        fill: true
                    }, {
                        label: 'Completed',
                        data: [25, 32, 30, 28],
                        borderColor: '#28a745',
                        backgroundColor: 'rgba(40, 167, 69, 0.1)',
                        tension: 0.4,
                        fill: true
                    }, {
                        label: 'Cancelled',
                        data: [3, 2, 4, 5],
                        borderColor: '#dc3545',
                        backgroundColor: 'rgba(220, 53, 69, 0.1)',
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                        },
                        title: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            // Department Performance Chart
            const departmentsCtx = document.getElementById('departmentsChart').getContext('2d');
            const departmentsChart = new Chart(departmentsCtx, {
                type: 'bar',
                data: {
                    labels: ['Cardiology', 'Neurology', 'Orthopedics', 'Pediatrics', 'Dermatology', 'Ophthalmology'],
                    datasets: [{
                        label: 'Appointments',
                        data: [45, 38, 32, 29, 26, 22],
                        backgroundColor: '#0066cc'
                    }, {
                        label: 'Revenue ($1000)',
                        data: [12.45, 10.82, 9.65, 8.32, 7.89, 6.54],
                        backgroundColor: '#28a745'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            // Patient Demographics Chart
            const demographicsCtx = document.getElementById('demographicsChart').getContext('2d');
            const demographicsChart = new Chart(demographicsCtx, {
                type: 'doughnut',
                data: {
                    labels: ['0-18', '19-35', '36-50', '51-65', '65+'],
                    datasets: [{
                        label: 'Age Groups',
                        data: [45, 65, 60, 50, 30],
                        backgroundColor: [
                            '#4dc9f6',
                            '#f67019',
                            '#f53794',
                            '#537bc4',
                            '#acc236'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right',
                        }
                    }
                }
            });

            // Revenue Analysis Chart
            const revenueCtx = document.getElementById('revenueChart').getContext('2d');
            const revenueChart = new Chart(revenueCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
                    datasets: [{
                        label: 'Revenue',
                        data: [38500, 42000, 40500, 42800, 45250],
                        borderColor: '#6f42c1',
                        backgroundColor: 'rgba(111, 66, 193, 0.1)',
                        tension: 0.4,
                        fill: true
                    }, {
                        label: 'Expenses',
                        data: [32000, 33500, 34000, 34500, 35000],
                        borderColor: '#fd7e14',
                        backgroundColor: 'rgba(253, 126, 20, 0.1)',
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>
