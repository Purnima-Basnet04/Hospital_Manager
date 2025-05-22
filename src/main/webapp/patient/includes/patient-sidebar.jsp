<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-header">
        <h3>Patient Portal</h3>
        <p>Manage your health</p>
    </div>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/patient/dashboard" id="menu-dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/patient/appointments" id="menu-appointments"><i class="fas fa-calendar-check"></i> My Appointments</a></li>
        <li><a href="${pageContext.request.contextPath}/patient/book-appointment" id="menu-book-appointment"><i class="fas fa-plus-circle"></i> Book Appointment</a></li>
        <li><a href="${pageContext.request.contextPath}/patient/find-doctor" id="menu-find-doctor"><i class="fas fa-user-md"></i> Find Doctors</a></li>
        <li><a href="${pageContext.request.contextPath}/patient/medical-records" id="menu-medical-records"><i class="fas fa-file-medical"></i> Medical Records</a></li>
        <li><a href="${pageContext.request.contextPath}/patient/prescriptions" id="menu-prescriptions"><i class="fas fa-prescription"></i> Prescriptions</a></li>
        <li><a href="${pageContext.request.contextPath}/patient/profile" id="menu-profile"><i class="fas fa-user"></i> My Profile</a></li>
        <li><a href="${pageContext.request.contextPath}/logout" id="menu-logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

<script>
    // Set active menu item based on current page
    document.addEventListener('DOMContentLoaded', function() {
        // Get current page URL
        var currentUrl = window.location.pathname;

        // Check which menu item should be active
        if (currentUrl.includes('/dashboard')) {
            document.getElementById('menu-dashboard').classList.add('active');
        } else if (currentUrl.includes('/appointments')) {
            document.getElementById('menu-appointments').classList.add('active');
        } else if (currentUrl.includes('/book-appointment')) {
            document.getElementById('menu-book-appointment').classList.add('active');
        } else if (currentUrl.includes('/find-doctor')) {
            document.getElementById('menu-find-doctor').classList.add('active');
        } else if (currentUrl.includes('/medical-records')) {
            document.getElementById('menu-medical-records').classList.add('active');
        } else if (currentUrl.includes('/prescriptions')) {
            document.getElementById('menu-prescriptions').classList.add('active');
        } else if (currentUrl.includes('/profile')) {
            document.getElementById('menu-profile').classList.add('active');
        } else if (currentUrl.includes('/settings')) {
            document.getElementById('menu-settings').classList.add('active');
        }
    });
</script>
