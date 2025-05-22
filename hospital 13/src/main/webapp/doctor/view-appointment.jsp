<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Appointment | Doctor Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-dashboard.css">
    <style>
        .dashboard-container {
            display: flex;
            margin-top: 20px;
        }

        .main-content {
            flex: 1;
            padding: 0 20px;
        }

        .content-header {
            margin-bottom: 25px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 15px;
        }

        .content-header h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
        }

        .content-header h1 i {
            margin-right: 10px;
            color: #0066cc;
        }

        .content-header p {
            color: #666;
            margin: 0;
        }

        .appointment-details {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            padding: 30px;
            margin-bottom: 30px;
        }

        .appointment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .appointment-header h2 {
            margin: 0;
            color: #333;
            font-size: 22px;
            font-weight: 600;
        }

        .appointment-status {
            padding: 8px 15px;
            border-radius: 50px;
            font-weight: bold;
            text-transform: uppercase;
            font-size: 14px;
            letter-spacing: 0.5px;
        }

        .status-scheduled {
            background-color: #e3f2fd;
            color: #1976d2;
        }

        .status-completed {
            background-color: #e8f5e9;
            color: #388e3c;
        }

        .status-cancelled {
            background-color: #ffebee;
            color: #d32f2f;
        }

        .status-pending {
            background-color: #fff8e1;
            color: #ffa000;
        }

        .appointment-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 30px;
            margin-bottom: 30px;
            padding: 0 10px;
        }

        .info-group {
            margin-bottom: 20px;
            position: relative;
            padding-left: 30px;
        }

        .info-group:before {
            content: '';
            position: absolute;
            left: 0;
            top: 5px;
            width: 10px;
            height: 10px;
            background-color: #0066cc;
            border-radius: 50%;
        }

        .info-group h3 {
            margin: 0 0 8px 0;
            font-size: 15px;
            color: #666;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-group p {
            margin: 0;
            font-size: 18px;
            color: #333;
            font-weight: 500;
        }

        .appointment-notes {
            background-color: #f9f9f9;
            padding: 20px 25px;
            border-radius: 8px;
            margin-bottom: 30px;
            border-left: 4px solid #0066cc;
        }

        .appointment-notes h3 {
            margin: 0 0 12px 0;
            font-size: 16px;
            color: #555;
            font-weight: 600;
        }

        .appointment-notes p {
            margin: 0;
            color: #333;
            line-height: 1.6;
        }

        .appointment-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .btn {
            padding: 12px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 15px;
        }

        .btn-primary {
            background-color: #0066cc;
            color: white;
        }

        .btn-primary:hover {
            background-color: #0052a3;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 102, 204, 0.2);
        }

        .btn-success {
            background-color: #388e3c;
            color: white;
        }

        .btn-success:hover {
            background-color: #2e7d32;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(56, 142, 60, 0.2);
        }

        .btn-danger {
            background-color: #e53935;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c62828;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(229, 57, 53, 0.2);
        }

        .btn-outline-primary {
            background-color: transparent;
            color: #0066cc;
            border: 2px solid #0066cc;
        }

        .btn-outline-primary:hover {
            background-color: #f0f7ff;
            transform: translateY(-2px);
        }

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
    </style>
</head>
<body>
    <jsp:include page="../includes/doctor-header.jsp" />

    <div class="container">
        <div class="dashboard-container">
            <jsp:include page="../includes/doctor-sidebar.jsp" />

            <div class="main-content">
                <div class="content-header">
                    <h1><i class="fas fa-calendar-check"></i> View Appointment</h1>
                    <p>Detailed information about the appointment</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                    </div>
                </c:if>

                <c:if test="${not empty appointment}">
                    <div class="appointment-details">
                        <div class="appointment-header">
                            <h2><i class="fas fa-calendar-alt" style="color: #0066cc; margin-right: 10px;"></i>Appointment #${appointment.id}</h2>
                            <span class="appointment-status status-${appointment.status.toLowerCase()}">
                                <i class="fas fa-${appointment.status eq 'Scheduled' ? 'clock' : appointment.status eq 'Completed' ? 'check-circle' : 'ban'}"></i> ${appointment.status}
                            </span>
                        </div>

                        <div class="appointment-info">
                            <div>
                                <div class="info-group">
                                    <h3><i class="fas fa-user-injured" style="margin-right: 5px;"></i>Patient</h3>
                                    <p>${appointment.patientName}</p>
                                </div>
                                <div class="info-group">
                                    <h3><i class="fas fa-hospital" style="margin-right: 5px;"></i>Department</h3>
                                    <p>${appointment.departmentName}</p>
                                </div>
                                <div class="info-group">
                                    <h3><i class="fas fa-id-card-alt" style="margin-right: 5px;"></i>Patient ID</h3>
                                    <p>${appointment.patientId}</p>
                                </div>
                            </div>
                            <div>
                                <div class="info-group">
                                    <h3><i class="fas fa-calendar-day" style="margin-right: 5px;"></i>Date</h3>
                                    <p><fmt:formatDate value="${appointment.appointmentDate}" pattern="EEEE, MMMM d, yyyy" /></p>
                                </div>
                                <div class="info-group">
                                    <h3><i class="fas fa-clock" style="margin-right: 5px;"></i>Time</h3>
                                    <p>${appointment.timeSlot}</p>
                                </div>
                                <div class="info-group">
                                    <h3><i class="fas fa-history" style="margin-right: 5px;"></i>Created</h3>
                                    <p><fmt:formatDate value="${appointment.createdAt}" pattern="MMM d, yyyy HH:mm" /></p>
                                </div>
                            </div>
                        </div>

                        <div class="appointment-notes">
                            <h3><i class="fas fa-sticky-note" style="margin-right: 8px;"></i>Notes</h3>
                            <p>${not empty appointment.notes ? appointment.notes : 'No notes available'}</p>
                        </div>

                        <div class="appointment-actions">
                            <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-outline-primary">
                                <i class="fas fa-arrow-left"></i> Back to Appointments
                            </a>

                            <div>
                                <c:if test="${appointment.status eq 'scheduled' or appointment.status eq 'Scheduled' or appointment.status eq 'pending' or appointment.status eq 'Pending'}">
                                    <a href="${pageContext.request.contextPath}/doctor/edit-appointment?id=${appointment.id}" class="btn btn-primary">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <a href="${pageContext.request.contextPath}/doctor/cancel-appointment?id=${appointment.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this appointment?');">
                                        <i class="fas fa-times-circle"></i> Cancel
                                    </a>
                                </c:if>

                                <c:if test="${appointment.status eq 'scheduled' or appointment.status eq 'Scheduled'}">
                                    <a href="${pageContext.request.contextPath}/doctor/complete-appointment?id=${appointment.id}" class="btn btn-success" onclick="return confirm('Mark this appointment as completed?');">
                                        <i class="fas fa-check-circle"></i> Complete
                                    </a>
                                </c:if>

                                <c:if test="${appointment.status eq 'cancelled' or appointment.status eq 'Cancelled'}">
                                    <a href="${pageContext.request.contextPath}/doctor/reschedule-appointment?id=${appointment.id}" class="btn btn-primary">
                                        <i class="fas fa-calendar-plus"></i> Reschedule
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <jsp:include page="../includes/footer.jsp" />
</body>
</html>
