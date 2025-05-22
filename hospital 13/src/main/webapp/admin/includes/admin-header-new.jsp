<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get user information from session
    String username = (String) session.getAttribute("username");
    String name = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");

    // Use name if available, otherwise use username
    String displayName = (name != null && !name.isEmpty()) ? name : username;
%>
<!-- Admin Header -->
<header class="admin-header">
    <div class="container">
        <div class="admin-header-content">
            <div class="admin-logo">
                <a href="<%= request.getContextPath() %>/index.jsp">LifeCare <span>Medical</span></a>
            </div>
            <nav class="admin-nav">
                <ul>
                    <li><a href="<%= request.getContextPath() %>/index.jsp">Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/dashboard">Admin Dashboard</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/departments">Departments</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/services">Services</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/appointments">Appointments</a></li>
                </ul>
            </nav>
            <div class="admin-user-menu">
                <div class="admin-user-toggle">
                    <img src="https://via.placeholder.com/40x40" alt="Admin">
                    <span><%= displayName %></span>
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="admin-user-dropdown">
                    <ul>
                        <li><a href="<%= request.getContextPath() %>/admin/profile"><i class="fas fa-user"></i> Profile</a></li>
                        <li><a href="<%= request.getContextPath() %>/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                        <li><a href="<%= request.getContextPath() %>/admin/settings"><i class="fas fa-cog"></i> Settings</a></li>
                        <li><a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</header>

<style>
    /* Admin Header Styles */
    .admin-header {
        background-color: #fff;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 15px 0;
        position: sticky;
        top: 0;
        z-index: 1000;
        margin-bottom: 30px;
    }

    .admin-header-content {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .admin-logo a {
        font-size: 24px;
        font-weight: 700;
        color: #333;
        text-decoration: none;
    }

    .admin-logo span {
        color: #0066cc;
    }

    .admin-nav ul {
        display: flex;
        list-style: none;
        margin: 0;
        padding: 0;
    }

    .admin-nav ul li {
        margin: 0 15px;
    }

    .admin-nav ul li a {
        color: #333;
        font-weight: 500;
        text-decoration: none;
        padding: 8px 0;
        position: relative;
        transition: color 0.3s;
    }

    .admin-nav ul li a:hover {
        color: #0066cc;
    }

    .admin-nav ul li a.active {
        color: #0066cc;
    }

    .admin-nav ul li a.active:after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 2px;
        background-color: #0066cc;
    }

    .admin-user-menu {
        position: relative;
    }

    .admin-user-toggle {
        display: flex;
        align-items: center;
        cursor: pointer;
        padding: 8px 12px;
        border-radius: 4px;
        transition: background-color 0.3s;
    }

    .admin-user-toggle:hover {
        background-color: #f5f5f5;
    }

    .admin-user-toggle img {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        margin-right: 10px;
        object-fit: cover;
    }

    .admin-user-toggle span {
        font-weight: 500;
        margin-right: 8px;
    }

    .admin-user-toggle i {
        font-size: 12px;
        color: #666;
    }

    .admin-user-dropdown {
        position: absolute;
        top: 100%;
        right: 0;
        background-color: white;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        border-radius: 4px;
        width: 200px;
        display: none;
        z-index: 1000;
        margin-top: 10px;
        overflow: hidden;
    }

    .admin-user-menu:hover .admin-user-dropdown {
        display: block;
    }

    .admin-user-dropdown ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .admin-user-dropdown ul li {
        margin: 0;
    }

    .admin-user-dropdown ul li a {
        display: flex;
        align-items: center;
        padding: 12px 15px;
        color: #333;
        text-decoration: none;
        transition: background-color 0.3s;
    }

    .admin-user-dropdown ul li a:hover {
        background-color: #f5f5f5;
    }

    .admin-user-dropdown ul li a i {
        margin-right: 10px;
        width: 20px;
        text-align: center;
        color: #0066cc;
    }

    /* Responsive Styles */
    @media (max-width: 992px) {
        .admin-nav ul li {
            margin: 0 10px;
        }
    }

    @media (max-width: 768px) {
        .admin-header-content {
            flex-direction: column;
        }

        .admin-logo {
            margin-bottom: 15px;
        }

        .admin-nav {
            margin-bottom: 15px;
        }

        .admin-nav ul {
            flex-wrap: wrap;
            justify-content: center;
        }

        .admin-nav ul li {
            margin: 5px 10px;
        }
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Get the current page URL
        var currentUrl = window.location.pathname;
        console.log('Current URL:', currentUrl);

        // Find all nav links
        var navLinks = document.querySelectorAll('.admin-nav ul li a');

        // Remove active class from all links
        navLinks.forEach(function(link) {
            link.classList.remove('active');
        });

        // Add active class to the link that matches the current URL
        navLinks.forEach(function(link) {
            var linkPath = link.getAttribute('href');
            console.log('Checking link:', linkPath);

            // Special case for appointments
            if (currentUrl.includes('view-appointment') && linkPath.includes('/admin/appointments')) {
                link.classList.add('active');
                console.log('Activated appointments link for view-appointment');
            }
            // General case
            else if (currentUrl.includes(linkPath) && linkPath !== '<%= request.getContextPath() %>/index.jsp') {
                link.classList.add('active');
                console.log('Activated link:', linkPath);
            }
        });
    });
</script>
