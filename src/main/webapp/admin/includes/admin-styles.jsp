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
        max-width: 1400px; /* Wider container */
        margin: 0 auto;
        padding: 0 20px;
        width: 100%;
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
        border: 2px solid #0066cc;
        color: #0066cc;
    }

    .btn-outline-primary:hover {
        background-color: #0066cc;
        color: white;
    }

    .btn-sm {
        padding: 8px 16px;
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

    .btn-warning {
        background-color: #ffc107;
        color: #212529;
    }

    .btn-warning:hover {
        background-color: #e0a800;
    }

    /* Header Styles */
    .admin-header {
        background-color: white;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 15px 0;
        position: sticky;
        top: 0;
        z-index: 1000;
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
    }

    .admin-logo span {
        color: #0066cc;
    }

    .admin-user-menu {
        position: relative;
    }

    .admin-user-toggle {
        display: flex;
        align-items: center;
        cursor: pointer;
    }

    .admin-user-toggle img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        margin-right: 10px;
    }

    .admin-user-toggle span {
        font-weight: 500;
    }

    .admin-user-dropdown {
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

    .admin-user-menu:hover .admin-user-dropdown {
        display: block;
    }

    .admin-user-dropdown ul {
        list-style: none;
        padding: 10px 0;
    }

    .admin-user-dropdown ul li {
        margin: 0;
    }

    .admin-user-dropdown ul li a {
        display: flex;
        align-items: center;
        padding: 10px 15px;
        color: #333;
        transition: background-color 0.3s;
    }

    .admin-user-dropdown ul li a:hover {
        background-color: #f8f9fa;
    }

    .admin-user-dropdown ul li a i {
        margin-right: 10px;
        width: 20px;
        text-align: center;
    }

    /* Dashboard Layout */
    .admin-dashboard {
        display: flex;
        padding-top: 30px; /* Account for header */
        min-height: calc(100vh - 80px); /* Full height minus header */
    }

    /* For backward compatibility */
    .admin-dashboard-container {
        display: flex;
        margin-top: 30px;
        margin-bottom: 30px;
    }

    /* Sidebar Styles */
    .admin-sidebar {
        width: 280px; /* Slightly wider sidebar */
        min-width: 280px; /* Prevent sidebar from shrinking */
        background-color: #333;
        color: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin-right: 30px;
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

    /* Main Content Styles */
    .admin-content {
        flex: 1;
        padding: 0 30px 30px 30px;
    }

    /* For backward compatibility */
    .admin-main-content {
        flex: 1;
    }

    .admin-page-header {
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin-bottom: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
    }

    .admin-page-header h1 {
        font-size: 24px;
        color: #333;
        margin: 0;
    }

    .admin-page-header p {
        color: #6c757d;
        margin: 5px 0 0;
    }

    /* Table Styles */
    .admin-table-container {
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin-bottom: 20px;
        width: 100%;
        overflow-x: auto; /* For responsive tables */
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
        table-layout: fixed; /* For consistent column widths */
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

    .admin-table .status-badge {
        display: inline-block;
        padding: 5px 10px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
    }

    .admin-table .status-scheduled {
        background-color: #cce5ff;
        color: #004085;
    }

    .admin-table .status-completed {
        background-color: #d4edda;
        color: #155724;
    }

    .admin-table .status-cancelled {
        background-color: #f8d7da;
        color: #721c24;
    }

    .admin-table .status-pending {
        background-color: #fff3cd;
        color: #856404;
    }

    /* Card Styles */
    .admin-cards {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 20px;
    }

    .admin-card {
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        display: flex;
        flex-direction: column;
    }

    .admin-card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 15px;
    }

    .admin-card-title {
        font-size: 16px;
        font-weight: 600;
        color: #6c757d;
    }

    .admin-card-icon {
        width: 40px;
        height: 40px;
        border-radius: 8px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 20px;
    }

    .admin-card-icon.patients {
        background-color: #cce5ff;
        color: #0066cc;
    }

    .admin-card-icon.doctors {
        background-color: #d4edda;
        color: #28a745;
    }

    .admin-card-icon.appointments {
        background-color: #fff3cd;
        color: #ffc107;
    }

    .admin-card-icon.revenue {
        background-color: #f8d7da;
        color: #dc3545;
    }

    .admin-card-value {
        font-size: 28px;
        font-weight: 700;
        color: #333;
        margin-bottom: 5px;
    }

    .admin-card-change {
        font-size: 14px;
        color: #28a745;
    }

    .admin-card-change.negative {
        color: #dc3545;
    }

    /* Alert Styles */
    .alert {
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
    }

    .alert i {
        margin-right: 10px;
        font-size: 18px;
    }

    .alert-danger {
        background-color: #ffebee;
        color: #c62828;
        border-left: 4px solid #c62828;
    }

    .alert-success {
        background-color: #e8f5e9;
        color: #2e7d32;
        border-left: 4px solid #2e7d32;
    }

    .alert-warning {
        background-color: #fff8e1;
        color: #856404;
        border-left: 4px solid #ffc107;
    }

    .alert-info {
        background-color: #e3f2fd;
        color: #0066cc;
        border-left: 4px solid #0066cc;
    }

    /* Responsive Styles */
    @media (max-width: 768px) {
        .admin-header-content {
            flex-direction: column;
        }

        .admin-logo {
            margin-bottom: 15px;
        }

        .admin-dashboard-container {
            flex-direction: column;
        }

        .admin-sidebar {
            width: 100%;
            margin-right: 0;
            margin-bottom: 20px;
        }

        .admin-cards {
            grid-template-columns: 1fr;
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
