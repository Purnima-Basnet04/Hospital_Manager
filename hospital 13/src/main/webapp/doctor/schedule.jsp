<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// Get attributes from session
String username = (String) session.getAttribute("username");
String name = (String) session.getAttribute("name");
String role = (String) session.getAttribute("role");

String displayName = (name != null && !name.isEmpty()) ? name : username;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>My Schedule - Doctor Dashboard</title>
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

        /* Dashboard Layout */
        .dashboard-container {
            display: flex;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 250px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-right: 20px;
            height: fit-content;
        }

        .sidebar-header {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .sidebar-header h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 5px;
        }

        .sidebar-header p {
            color: #6c757d;
            font-size: 14px;
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu li {
            margin-bottom: 10px;
        }

        .sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 10px;
            color: #333;
            border-radius: 4px;
            transition: all 0.3s;
        }

        .sidebar-menu li a:hover {
            background-color: #f8f9fa;
            color: #0066cc;
        }

        .sidebar-menu li a.active {
            background-color: #0066cc;
            color: white;
        }

        .sidebar-menu li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
        }

        .welcome-header {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .welcome-header h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 10px;
        }

        .welcome-header p {
            color: #6c757d;
        }

        /* Schedule Styles */
        .schedule-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 15px 20px;
        }

        .schedule-nav {
            display: flex;
            align-items: center;
        }

        .schedule-nav button {
            background: none;
            border: none;
            font-size: 16px;
            cursor: pointer;
            padding: 5px 10px;
            color: #0066cc;
        }

        .schedule-nav h2 {
            margin: 0 15px;
            font-size: 18px;
        }

        .schedule-actions {
            display: flex;
            gap: 10px;
        }

        /* Calendar Grid */
        .calendar-grid {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 20px;
        }

        .calendar-header {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            background-color: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        }

        .calendar-header .day-name {
            text-align: center;
            padding: 10px;
            font-weight: 600;
            color: #495057;
        }

        .calendar-body {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            grid-auto-rows: minmax(100px, auto);
        }

        .calendar-day {
            border: 1px solid #e9ecef;
            padding: 10px;
            min-height: 100px;
            position: relative;
        }

        .calendar-day.today {
            background-color: #e3f2fd;
        }

        .calendar-day.other-month {
            background-color: #f8f9fa;
            color: #adb5bd;
        }

        .day-number {
            font-weight: 600;
            margin-bottom: 5px;
        }

        .appointment {
            background-color: #0066cc;
            color: white;
            padding: 5px;
            border-radius: 4px;
            font-size: 12px;
            margin-bottom: 5px;
            cursor: pointer;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        /* Weekly Schedule */
        .weekly-schedule {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 20px;
        }

        .time-slots {
            display: grid;
            grid-template-columns: 80px repeat(7, 1fr);
            border-bottom: 1px solid #e9ecef;
        }

        .time-header {
            padding: 10px;
            text-align: center;
            font-weight: 600;
            background-color: #f8f9fa;
            border-right: 1px solid #e9ecef;
            border-bottom: 1px solid #e9ecef;
        }

        .time-slot {
            padding: 10px;
            border-right: 1px solid #e9ecef;
            border-bottom: 1px solid #e9ecef;
            min-height: 60px;
            position: relative;
        }

        .time-label {
            padding: 10px;
            text-align: right;
            font-size: 14px;
            color: #6c757d;
            border-right: 1px solid #e9ecef;
            border-bottom: 1px solid #e9ecef;
        }

        /* Appointment Modal */
        .appointment-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            padding: 20px;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .modal-header h3 {
            font-size: 18px;
            color: #333;
        }

        .close-modal {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: #6c757d;
        }

        .modal-body {
            margin-bottom: 20px;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                text-align: center;
            }

            nav ul {
                margin-top: 15px;
                justify-content: center;
            }

            nav ul li {
                margin: 0 10px;
            }

            .user-menu {
                margin-top: 15px;
            }

            .dashboard-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                margin-right: 0;
                margin-bottom: 20px;
            }

            .schedule-controls {
                flex-direction: column;
                gap: 10px;
            }

            .calendar-header,
            .calendar-body {
                grid-template-columns: repeat(7, 1fr);
            }

            .time-slots {
                grid-template-columns: 60px repeat(7, 1fr);
            }

            .calendar-day {
                min-height: 80px;
            }
        }

        @media (max-width: 576px) {
            .calendar-header,
            .calendar-body {
                grid-template-columns: repeat(1, 1fr);
            }

            .calendar-header .day-name:not(:first-child),
            .calendar-day:not(:nth-child(7n+1)) {
                display: none;
            }

            .time-slots {
                grid-template-columns: 60px 1fr;
            }

            .time-header:not(:first-child):not(:nth-child(2)),
            .time-slot:not(:nth-child(2n)) {
                display: none;
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
                        <% if (session.getAttribute("username") != null) { %>
                            <% if ("patient".equals(session.getAttribute("role"))) { %>
                                <li><a href="../patient/dashboard">Patient Dashboard</a></li>
                            <% } else if ("doctor".equals(session.getAttribute("role"))) { %>
                                <li><a href="dashboard">Doctor Dashboard</a></li>
                            <% } else if ("admin".equals(session.getAttribute("role"))) { %>
                                <li><a href="../admin/dashboard.jsp">Admin Dashboard</a></li>
                            <% } %>
                        <% } %>
                        <li><a href="../departments">Departments</a></li>
                        <li><a href="../Service.jsp">Services</a></li>
                        <li><a href="../appointments.jsp">Appointments</a></li>
                        <li><a href="../AboutUs.jsp">About Us</a></li>
                        <li><a href="../ContactUs.jsp">Contact Us</a></li>
                    </ul>
                </nav>
                <div class="user-menu">
                    <div class="user-menu-toggle">
                        <img src="https://via.placeholder.com/40x40" alt="User">
                        <span><%= displayName %></span>
                    </div>
                    <div class="user-menu-dropdown">
                        <ul>
                            <li><a href="profile"><i class="fas fa-user"></i> Profile</a></li>
                            <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
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
                <div class="sidebar-header">
                    <h3>Doctor Portal</h3>
                    <p>Manage your patients</p>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="appointments"><i class="fas fa-calendar-check"></i> My Appointments</a></li>
                    <li><a href="patients"><i class="fas fa-users"></i> My Patients</a></li>
                    <li><a href="prescriptions"><i class="fas fa-prescription"></i> Prescriptions</a></li>
                    <li><a href="medical-records"><i class="fas fa-file-medical"></i> Medical Records</a></li>
                    <li><a href="schedule" class="active"><i class="fas fa-clock"></i> My Schedule</a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> Profile</a></li>
                    <li><a href="settings"><i class="fas fa-cog"></i> Settings</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Welcome Header -->
                <div class="welcome-header">
                    <h1>My Schedule</h1>
                    <p>Manage your working hours and appointments.</p>
                </div>

                <!-- Schedule Controls -->
                <div class="schedule-controls">
                    <div class="schedule-nav">
                        <button onclick="previousMonth()"><i class="fas fa-chevron-left"></i></button>
                        <h2>May 2025</h2>
                        <button onclick="nextMonth()"><i class="fas fa-chevron-right"></i></button>
                    </div>
                    <div class="schedule-actions">
                        <button class="btn" onclick="showMonthView()">Month</button>
                        <button class="btn" onclick="showWeekView()">Week</button>
                        <button class="btn btn-success" onclick="showAddAvailabilityModal()">Add Availability</button>
                    </div>
                </div>

                <!-- Monthly Calendar View -->
                <div class="calendar-grid" id="month-view">
                    <div class="calendar-header">
                        <div class="day-name">Sunday</div>
                        <div class="day-name">Monday</div>
                        <div class="day-name">Tuesday</div>
                        <div class="day-name">Wednesday</div>
                        <div class="day-name">Thursday</div>
                        <div class="day-name">Friday</div>
                        <div class="day-name">Saturday</div>
                    </div>
                    <div class="calendar-body">
                        <!-- Week 1 -->
                        <div class="calendar-day other-month">
                            <div class="day-number">27</div>
                        </div>
                        <div class="calendar-day other-month">
                            <div class="day-number">28</div>
                        </div>
                        <div class="calendar-day other-month">
                            <div class="day-number">29</div>
                        </div>
                        <div class="calendar-day other-month">
                            <div class="day-number">30</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">1</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">2</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">3</div>
                        </div>

                        <!-- Week 2 -->
                        <div class="calendar-day">
                            <div class="day-number">4</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">5</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">6</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">7</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">8</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">9</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">10</div>
                        </div>

                        <!-- Week 3 -->
                        <div class="calendar-day">
                            <div class="day-number">11</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">12</div>
                        </div>
                        <div class="calendar-day today">
                            <div class="day-number">13</div>

                        </div>
                        <div class="calendar-day">
                            <div class="day-number">14</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">15</div>

                        </div>
                        <div class="calendar-day">
                            <div class="day-number">16</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">17</div>
                        </div>

                        <!-- Week 4 -->
                        <div class="calendar-day">
                            <div class="day-number">18</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">19</div>

                        </div>
                        <div class="calendar-day">
                            <div class="day-number">20</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">21</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">22</div>

                        </div>
                        <div class="calendar-day">
                            <div class="day-number">23</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">24</div>
                        </div>

                        <!-- Week 5 -->
                        <div class="calendar-day">
                            <div class="day-number">25</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">26</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">27</div>

                        </div>
                        <div class="calendar-day">
                            <div class="day-number">28</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">29</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">30</div>
                        </div>
                        <div class="calendar-day">
                            <div class="day-number">31</div>
                        </div>
                    </div>
                </div>

                <!-- Weekly Schedule View (Hidden by default) -->
                <div class="weekly-schedule" id="week-view" style="display: none;">
                    <div class="time-slots">
                        <div class="time-header"></div>
                        <div class="time-header">Sunday</div>
                        <div class="time-header">Monday</div>
                        <div class="time-header">Tuesday</div>
                        <div class="time-header">Wednesday</div>
                        <div class="time-header">Thursday</div>
                        <div class="time-header">Friday</div>
                        <div class="time-header">Saturday</div>

                        <!-- 9:00 AM Row -->
                        <div class="time-label">9:00 AM</div>
                        <div class="time-slot"></div>
                        <div class="time-slot">
                            <div class="appointment" onclick="showAppointmentDetails(1)">John Smith</div>
                        </div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>

                        <!-- 10:00 AM Row -->
                        <div class="time-label">10:00 AM</div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot">
                            <div class="appointment" onclick="showAppointmentDetails(7)">David Lee</div>
                        </div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>

                        <!-- 11:00 AM Row -->
                        <div class="time-label">11:00 AM</div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot">
                            <div class="appointment" onclick="showAppointmentDetails(4)">Emily Davis</div>
                        </div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>

                        <!-- 12:00 PM Row -->
                        <div class="time-label">12:00 PM</div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>

                        <!-- 1:00 PM Row -->
                        <div class="time-label">1:00 PM</div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot">
                            <div class="appointment" onclick="showAppointmentDetails(6)">Sarah Wilson</div>
                        </div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>

                        <!-- 2:00 PM Row -->
                        <div class="time-label">2:00 PM</div>
                        <div class="time-slot"></div>
                        <div class="time-slot">
                            <div class="appointment" onclick="showAppointmentDetails(3)">Robert Johnson</div>
                        </div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                        <div class="time-slot">
                            <div class="appointment" onclick="showAppointmentDetails(9)">Thomas Anderson</div>
                        </div>
                        <div class="time-slot"></div>
                        <div class="time-slot"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Appointment Details Modal -->
    <div class="appointment-modal" id="appointment-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Appointment Details</h3>
                <button class="close-modal" onclick="closeModal()">&times;</button>
            </div>
            <div class="modal-body" id="appointment-details">
                <!-- Appointment details will be populated here -->
            </div>
            <div class="modal-footer">
                <button class="btn" onclick="closeModal()">Close</button>
                <button class="btn btn-success" onclick="editAppointment()">Edit</button>
                <button class="btn btn-danger" onclick="cancelAppointment()">Cancel Appointment</button>
            </div>
        </div>
    </div>

    <!-- Add Availability Modal -->
    <div class="appointment-modal" id="availability-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Add Availability</h3>
                <button class="close-modal" onclick="closeAvailabilityModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="availability-form">
                    <div class="form-group">
                        <label for="availability-date">Date</label>
                        <input type="date" id="availability-date" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="start-time">Start Time</label>
                        <input type="time" id="start-time" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="end-time">End Time</label>
                        <input type="time" id="end-time" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="repeat-option">Repeat</label>
                        <select id="repeat-option" class="form-control">
                            <option value="none">None</option>
                            <option value="daily">Daily</option>
                            <option value="weekly">Weekly</option>
                            <option value="biweekly">Bi-weekly</option>
                            <option value="monthly">Monthly</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn" onclick="closeAvailabilityModal()">Cancel</button>
                <button class="btn btn-success" onclick="saveAvailability()">Save</button>
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

        // Calendar View Functions
        function showMonthView() {
            document.getElementById('month-view').style.display = 'block';
            document.getElementById('week-view').style.display = 'none';
        }

        function showWeekView() {
            document.getElementById('month-view').style.display = 'none';
            document.getElementById('week-view').style.display = 'block';
        }

        function previousMonth() {
            // In a real application, this would update the calendar to show the previous month
            alert('Navigate to previous month');
        }

        function nextMonth() {
            // In a real application, this would update the calendar to show the next month
            alert('Navigate to next month');
        }

        // Appointment Modal Functions
        function showAppointmentDetails(appointmentId) {
            const modal = document.getElementById('appointment-modal');
            const detailsContainer = document.getElementById('appointment-details');

            // In a real application, you would fetch appointment details from the server
            // For now, we'll use sample data
            let appointmentDetails = '';

            switch(appointmentId) {
                case 1:
                    appointmentDetails =
                        '<p><strong>Patient:</strong> John Smith</p>' +
                        '<p><strong>Date:</strong> May 1, 2025</p>' +
                        '<p><strong>Time:</strong> 9:00 AM - 9:30 AM</p>' +
                        '<p><strong>Reason:</strong> Annual check-up</p>' +
                        '<p><strong>Notes:</strong> Patient has a history of hypertension</p>';
                    break;
                case 2:
                    appointmentDetails =
                        '<p><strong>Patient:</strong> Jane Smith</p>' +
                        '<p><strong>Date:</strong> May 5, 2025</p>' +
                        '<p><strong>Time:</strong> 10:30 AM - 11:00 AM</p>' +
                        '<p><strong>Reason:</strong> Follow-up appointment</p>' +
                        '<p><strong>Notes:</strong> Review medication effectiveness</p>';
                    break;
                case 3:
                    appointmentDetails =
                        '<p><strong>Patient:</strong> Robert Johnson</p>' +
                        '<p><strong>Date:</strong> May 5, 2025</p>' +
                        '<p><strong>Time:</strong> 2:00 PM - 2:30 PM</p>' +
                        '<p><strong>Reason:</strong> Chest pain</p>' +
                        '<p><strong>Notes:</strong> Patient reports intermittent chest pain for the past week</p>';
                    break;
                default:
                    appointmentDetails =
                        '<p><strong>Patient:</strong> Patient #' + appointmentId + '</p>' +
                        '<p><strong>Date:</strong> May 2025</p>' +
                        '<p><strong>Time:</strong> Scheduled</p>' +
                        '<p><strong>Reason:</strong> Consultation</p>' +
                        '<p><strong>Notes:</strong> No additional notes</p>';
            }

            detailsContainer.innerHTML = appointmentDetails;
            modal.style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('appointment-modal').style.display = 'none';
        }

        function editAppointment() {
            // In a real application, this would open an edit form
            alert('Edit appointment functionality would be implemented here');
            closeModal();
        }

        function cancelAppointment() {
            if (confirm('Are you sure you want to cancel this appointment?')) {
                // In a real application, this would send a request to the server
                alert('Appointment cancelled successfully');
                closeModal();
            }
        }

        // Availability Modal Functions
        function showAddAvailabilityModal() {
            document.getElementById('availability-modal').style.display = 'flex';
        }

        function closeAvailabilityModal() {
            document.getElementById('availability-modal').style.display = 'none';
        }

        function saveAvailability() {
            const date = document.getElementById('availability-date').value;
            const startTime = document.getElementById('start-time').value;
            const endTime = document.getElementById('end-time').value;
            const repeatOption = document.getElementById('repeat-option').value;

            if (!date || !startTime || !endTime) {
                alert('Please fill in all required fields');
                return;
            }

            // In a real application, this would send the data to the server
            let message = 'Availability saved for ' + date + ' from ' + startTime + ' to ' + endTime;
            if (repeatOption != 'none') {
                message += ' with ' + repeatOption + ' repetition';
            }
            alert(message);
            closeAvailabilityModal();
        }

        // Close modals when clicking outside
        window.onclick = function(event) {
            const appointmentModal = document.getElementById('appointment-modal');
            const availabilityModal = document.getElementById('availability-modal');

            if (event.target === appointmentModal) {
                appointmentModal.style.display = 'none';
            }

            if (event.target === availabilityModal) {
                availabilityModal.style.display = 'none';
            }
        };
    </script>
</body>
</html>
