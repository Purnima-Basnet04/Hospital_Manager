<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Appointment" %>
<%@ page import="model.Department" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="dao.AppointmentDAO" %>
<%@ page import="dao.DepartmentDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
// Check if appointments attribute is already set (by servlet)
if (request.getAttribute("appointments") == null) {
    // If not, fetch appointments directly from the database
    System.out.println("Direct JSP access: Fetching appointments from database");
    AppointmentDAO appointmentDAO = new AppointmentDAO();
    List<Appointment> appointments = appointmentDAO.getAllAppointments();
    request.setAttribute("appointments", appointments);
    System.out.println("Direct JSP access: Found " + appointments.size() + " appointments");

    // Also fetch departments for the filter dropdown
    DepartmentDAO departmentDAO = new DepartmentDAO();
    List<Department> departments = departmentDAO.getAllDepartments();
    request.setAttribute("departments", departments);
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <%@ include file="includes/admin-styles-doctor.jsp" %>
</head>
<body>
    <!-- Include Admin Header -->
    <%@ include file="includes/admin-header.jsp" %>

    <div class="container">
        <div class="dashboard-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="sidebar-header">
                    <h3>Admin Panel</h3>
                    <p>Manage your hospital</p>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="dashboard" ${pageName eq 'dashboard' ? 'class="active"' : ''}><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="patients" ${pageName eq 'patients' ? 'class="active"' : ''}><i class="fas fa-user-injured"></i> Patients</a></li>
                    <li><a href="doctors" ${pageName eq 'doctors' ? 'class="active"' : ''}><i class="fas fa-user-md"></i> Doctors</a></li>
                    <li><a href="appointments" ${pageName eq 'appointments' ? 'class="active"' : ''}><i class="fas fa-calendar-check"></i> Appointments</a></li>
                    <li><a href="departments" ${pageName eq 'departments' ? 'class="active"' : ''}><i class="fas fa-hospital"></i> Departments</a></li>
                    <li><a href="services" ${pageName eq 'services' ? 'class="active"' : ''}><i class="fas fa-stethoscope"></i> Services</a></li>
                    <li><a href="reports" ${pageName eq 'reports' ? 'class="active"' : ''}><i class="fas fa-chart-bar"></i> Reports</a></li>
                    <li><a href="settings" ${pageName eq 'settings' ? 'class="active"' : ''}><i class="fas fa-cog"></i> Settings</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Welcome Header -->
                <div class="welcome-header">
                    <h1>Appointments</h1>
                    <p>Manage all appointments in the system</p>
                    <a href="add-appointment" class="btn btn-sm" style="margin-top: 10px;"><i class="fas fa-plus"></i> Add New Appointment</a>
                </div>

                <!-- Appointments Table -->
                <div class="admin-table-container">
                    <div class="admin-table-header">
                        <div class="admin-table-filters">
                            <form action="appointments" method="post" class="search-filter">
                                <input type="text" name="search" placeholder="Search appointments..." value="${searchQuery}">
                                <select name="department">
                                    <option value="0">All Departments</option>
                                    <c:forEach var="department" items="${departments}">
                                        <option value="${department.id}" ${departmentFilter eq department.id.toString() ? 'selected' : ''}>
                                            ${department.name}
                                        </option>
                                    </c:forEach>
                                </select>
                                <select name="status">
                                    <option value="all" ${statusFilter eq 'all' ? 'selected' : ''}>All Status</option>
                                    <option value="scheduled" ${statusFilter eq 'scheduled' ? 'selected' : ''}>Scheduled</option>
                                    <option value="completed" ${statusFilter eq 'completed' ? 'selected' : ''}>Completed</option>
                                    <option value="cancelled" ${statusFilter eq 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                    <option value="pending" ${statusFilter eq 'pending' ? 'selected' : ''}>Pending</option>
                                </select>
                                <button type="submit" class="btn btn-sm">Search</button>
                            </form>
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
                                <c:when test="${not empty appointments}">
                                    <c:forEach var="appointment" items="${appointments}">
                                        <tr>
                                            <td>A${appointment.id}</td>
                                            <td>${appointment.patientName}</td>
                                            <td>${appointment.doctorName}</td>
                                            <td>${appointment.departmentName}</td>
                                            <td>
                                                <fmt:formatDate value="${appointment.appointmentDate}" pattern="MMM d, yyyy" />
                                            </td>
                                            <td>${appointment.timeSlot}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${appointment.status eq 'scheduled' or appointment.status eq 'Scheduled'}"><span class="status-badge status-scheduled">Scheduled</span></c:when>
                                                    <c:when test="${appointment.status eq 'completed' or appointment.status eq 'Completed'}"><span class="status-badge status-completed">Completed</span></c:when>
                                                    <c:when test="${appointment.status eq 'cancelled' or appointment.status eq 'Cancelled'}"><span class="status-badge status-cancelled">Cancelled</span></c:when>
                                                    <c:when test="${appointment.status eq 'pending' or appointment.status eq 'Pending'}"><span class="status-badge status-pending">Pending</span></c:when>
                                                    <c:otherwise><span class="status-badge status-scheduled">${appointment.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="actions">
                                                <a href="view-appointment?id=${appointment.id}" class="btn btn-sm btn-outline-primary" title="View"><i class="fas fa-eye"></i></a>
                                                <a href="edit-appointment?id=${appointment.id}" class="btn btn-sm btn-outline-primary" title="Edit"><i class="fas fa-edit"></i></a>
                                                <a href="cancel-appointment?id=${appointment.id}" class="btn btn-sm btn-danger" title="Cancel" onclick="return confirm('Are you sure you want to cancel this appointment?');"><i class="fas fa-times"></i></a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" style="text-align: center;">No appointments found</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="admin-pagination">
                    <!-- Simple pagination for now - can be enhanced with actual pagination logic -->
                    <c:if test="${not empty appointments}">
                        <a href="#" class="active">1</a>
                        <c:if test="${appointments.size() > 10}">
                            <a href="#">2</a>
                        </c:if>
                        <c:if test="${appointments.size() > 20}">
                            <a href="#">3</a>
                        </c:if>
                        <c:if test="${appointments.size() > 30}">
                            <a href="#">4</a>
                        </c:if>
                        <c:if test="${appointments.size() > 40}">
                            <a href="#">5</a>
                        </c:if>
                        <c:if test="${appointments.size() > 10}">
                            <a href="#">Next</a>
                        </c:if>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // User menu dropdown
            const userMenuToggle = document.querySelector('.admin-user-toggle');
            const userMenuDropdown = document.querySelector('.admin-user-dropdown');

            if (userMenuToggle && userMenuDropdown) {
                userMenuToggle.addEventListener('click', function() {
                    userMenuDropdown.style.display = userMenuDropdown.style.display === 'block' ? 'none' : 'block';
                });

                // Close dropdown when clicking outside
                document.addEventListener('click', function(event) {
                    if (!event.target.closest('.admin-user-menu')) {
                        userMenuDropdown.style.display = 'none';
                    }
                });
            }
        });
    </script>
</body>
</html>
