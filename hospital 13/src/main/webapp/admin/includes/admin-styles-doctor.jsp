<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        color: #0066cc;
        border: 1px solid #0066cc;
    }

    .btn-outline-primary:hover {
        background-color: #0066cc;
        color: white;
    }

    .btn-sm {
        padding: 8px 15px;
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

    .user-menu:hover .user-menu-dropdown {
        display: block;
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
        background-color: #333;
        color: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin-right: 20px;
        height: fit-content;
    }

    .sidebar-header {
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 1px solid #444;
    }

    .sidebar-header h3 {
        font-size: 18px;
        color: white;
        margin-bottom: 5px;
    }

    .sidebar-header p {
        color: #ccc;
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
        color: #ccc;
        border-radius: 4px;
        transition: all 0.3s;
    }

    .sidebar-menu li a:hover {
        background-color: #444;
        color: white;
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

    /* Admin-specific styles */
    .admin-page-header {
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin-bottom: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .admin-page-header h1 {
        font-size: 24px;
        color: #333;
        margin-bottom: 5px;
    }

    .admin-page-header p {
        color: #6c757d;
    }

    .admin-table-container {
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin-bottom: 20px;
        width: 100%;
        overflow-x: auto;
    }

    .admin-table-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }

    .admin-table-filters {
        display: flex;
        gap: 10px;
    }

    .admin-table-filters select,
    .admin-table-filters input {
        padding: 8px 12px;
        border: 1px solid #ced4da;
        border-radius: 4px;
    }

    .admin-table {
        width: 100%;
        border-collapse: collapse;
    }

    .admin-table th,
    .admin-table td {
        padding: 12px 15px;
        text-align: left;
        border-bottom: 1px solid #e9ecef;
    }

    .admin-table th {
        background-color: #f8f9fa;
        font-weight: 600;
    }

    .admin-table tr:hover {
        background-color: #f8f9fa;
    }

    .admin-table .actions {
        display: flex;
        gap: 5px;
    }

    .status-badge {
        display: inline-block;
        padding: 5px 10px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
    }

    .status-scheduled {
        background-color: #cce5ff;
        color: #004085;
    }

    .status-completed {
        background-color: #d4edda;
        color: #155724;
    }

    .status-cancelled {
        background-color: #f8d7da;
        color: #721c24;
    }

    .status-pending {
        background-color: #fff3cd;
        color: #856404;
    }

    /* For backward compatibility */
    .admin-dashboard {
        display: flex;
        margin-top: 30px;
        margin-bottom: 30px;
    }

    .admin-sidebar {
        width: 250px;
        background-color: #333;
        color: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin-right: 20px;
        height: fit-content;
    }

    .admin-sidebar-header {
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 1px solid #444;
    }

    .admin-sidebar-header h3 {
        font-size: 18px;
        color: white;
        margin-bottom: 5px;
    }

    .admin-sidebar-header p {
        color: #ccc;
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
        color: #ccc;
        border-radius: 4px;
        transition: all 0.3s;
    }

    .admin-sidebar-menu li a:hover {
        background-color: #444;
        color: white;
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

    .admin-content {
        flex: 1;
    }

    .admin-main-content {
        flex: 1;
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

        .dashboard-container,
        .admin-dashboard {
            flex-direction: column;
        }

        .sidebar,
        .admin-sidebar {
            width: 100%;
            margin-right: 0;
            margin-bottom: 20px;
        }

        .admin-table-header {
            flex-direction: column;
            align-items: flex-start;
        }

        .admin-table-filters {
            margin-top: 10px;
            flex-wrap: wrap;
        }
    }
</style>
