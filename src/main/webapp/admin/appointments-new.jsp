<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Appointment" %>
<%@ page import="model.Department" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <%@ include file="includes/admin-styles.jsp" %>
</head>
<body>
    <!-- Include Admin Header -->
    <%@ include file="includes/admin-header.jsp" %>

    <div class="container">
        <div class="admin-dashboard-container">
            <!-- Include Admin Sidebar -->
            <%@ include file="includes/admin-sidebar.jsp" %>

            <!-- Main Content -->
            <div class="admin-main-content">
                <!-- Page Header -->
                <div class="admin-page-header">
                    <div>
                        <h1>Appointments</h1>
                        <p>Manage all appointments in the system</p>
                    </div>
                    <a href="#" class="btn btn-sm"><i class="fas fa-plus"></i> Add New Appointment</a>
                </div>

                <!-- Appointments Table -->
                <div class="admin-table-container">
                    <div class="admin-table-header">
                        <div class="admin-table-filters">
                            <input type="text" placeholder="Search appointments..." class="search-input">
                            <select id="department-filter">
                                <option value="">All Departments</option>
                                <c:forEach var="department" items="${departments}">
                                    <option value="${department.id}">${department.name}</option>
                                </c:forEach>
                            </select>
                            <select id="status-filter">
                                <option value="">All Status</option>
                                <option value="Scheduled">Scheduled</option>
                                <option value="Completed">Completed</option>
                                <option value="Cancelled">Cancelled</option>
                                <option value="Pending">Pending</option>
                            </select>
                            <button class="btn btn-sm" id="search-btn">Search</button>
                        </div>
                    </div>

                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Patient</th>
                                <th>Doctor</th>
                                <th>Department</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty appointments}">
                                    <tr>
                                        <td colspan="8" style="text-align: center;">No appointments found</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="appointment" items="${appointments}">
                                        <tr>
                                            <td>A${appointment.id}</td>
                                            <td>${appointment.patientName}</td>
                                            <td>${appointment.doctorName}</td>
                                            <td>${appointment.departmentName}</td>
                                            <td>
                                                <c:set var="dateFormat" value="MMM d, yyyy" />
                                                <fmt:formatDate value="${appointment.appointmentDate}" pattern="${dateFormat}" />
                                            </td>
                                            <td>${appointment.timeSlot}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${appointment.status eq 'Scheduled'}">
                                                        <span class="status-badge status-scheduled">Scheduled</span>
                                                    </c:when>
                                                    <c:when test="${appointment.status eq 'Completed'}">
                                                        <span class="status-badge status-completed">Completed</span>
                                                    </c:when>
                                                    <c:when test="${appointment.status eq 'Cancelled'}">
                                                        <span class="status-badge status-cancelled">Cancelled</span>
                                                    </c:when>
                                                    <c:when test="${appointment.status eq 'Pending'}">
                                                        <span class="status-badge status-pending">Pending</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge">${appointment.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="actions">
                                                <a href="view-appointment?id=${appointment.id}" class="btn btn-sm btn-outline-primary" title="View"><i class="fas fa-eye"></i></a>
                                                <a href="edit-appointment?id=${appointment.id}" class="btn btn-sm btn-outline-primary" title="Edit"><i class="fas fa-edit"></i></a>
                                                <a href="cancel-appointment?id=${appointment.id}" class="btn btn-sm btn-danger" title="Cancel" onclick="return confirm('Are you sure you want to cancel this appointment?');"><i class="fas fa-times"></i></a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Search functionality
            const searchBtn = document.getElementById('search-btn');
            const searchInput = document.querySelector('.search-input');
            const departmentFilter = document.getElementById('department-filter');
            const statusFilter = document.getElementById('status-filter');

            searchBtn.addEventListener('click', function() {
                const searchQuery = searchInput.value.trim();
                const departmentId = departmentFilter.value;
                const status = statusFilter.value;

                // Redirect to the same page with search parameters
                window.location.href = 'appointments?search=' + encodeURIComponent(searchQuery) +
                                      '&department=' + encodeURIComponent(departmentId) +
                                      '&status=' + encodeURIComponent(status);
            });

            // Handle Enter key in search input
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchBtn.click();
                }
            });
        });
    </script>
</body>
</html>
