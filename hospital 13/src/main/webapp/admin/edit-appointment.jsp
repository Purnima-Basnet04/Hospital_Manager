<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Appointment | Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <jsp:include page="includes/admin-styles.jsp" />
    <style>
        .form-container {
            padding: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .form-control:focus {
            border-color: #0066cc;
            box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
            outline: none;
        }
        select.form-control {
            height: 46px;
        }
        .btn-container {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .patient-info {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            border-left: 4px solid #0066cc;
        }
        .patient-info h3 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #333;
            font-size: 18px;
        }
        .patient-info p {
            margin: 8px 0;
            font-size: 15px;
        }
        .patient-info strong {
            color: #555;
            font-weight: 600;
        }
        .form-row {
            display: flex;
            gap: 20px;
        }
        .form-row .form-group {
            flex: 1;
        }
        /* Success and error messages */
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
    </style>
</head>
<body>
    <jsp:include page="includes/admin-header-new.jsp" />

    <div class="admin-dashboard">
        <jsp:include page="includes/admin-sidebar-new.jsp" />

        <div class="admin-content">

            <div class="admin-page-header">
                <div>
                    <h1><i class="fas fa-edit"></i> Edit Appointment</h1>
                    <p>Update appointment details below</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-outline-primary">
                        <i class="fas fa-arrow-left"></i> Back to Appointments
                    </a>
                </div>
            </div>

            <div class="admin-table-container form-container">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                    </div>
                </c:if>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> ${successMessage}
                    </div>
                </c:if>

                <div class="patient-info">
                    <h3>Appointment Information</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <p><strong>Patient:</strong> ${appointment.patientName}</p>
                            <p><strong>Appointment ID:</strong> ${appointment.id}</p>
                        </div>
                        <div class="form-group">
                            <p><strong>Current Status:</strong> ${appointment.status}</p>
                            <p><strong>Created:</strong> <fmt:formatDate value="${appointment.createdAt}" pattern="MMM dd, yyyy HH:mm" /></p>
                        </div>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/edit-appointment" method="post">
                    <input type="hidden" name="id" value="${appointment.id}">
                    <input type="hidden" name="patientId" value="${appointment.patientId}">

                    <div class="form-group">
                        <label for="doctorId">Doctor</label>
                        <select id="doctorId" name="doctorId" class="form-control" required>
                            <c:forEach items="${doctors}" var="doctor">
                                <option value="${doctor.id}" ${doctor.id == appointment.doctorId ? 'selected' : ''}>
                                    Dr. ${doctor.name} ${not empty doctor.specialization ? '- ' : ''}${doctor.specialization}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="departmentId">Department</label>
                        <select id="departmentId" name="departmentId" class="form-control" required>
                            <c:forEach items="${departments}" var="department">
                                <option value="${department.id}" ${department.id == appointment.departmentId ? 'selected' : ''}>
                                    ${department.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="appointmentDate">Appointment Date</label>
                            <input type="date" id="appointmentDate" name="appointmentDate" class="form-control"
                                   value="<fmt:formatDate value="${appointment.appointmentDate}" pattern="yyyy-MM-dd" />"
                                   min="${today}" required>
                        </div>

                        <div class="form-group">
                            <label for="timeSlot">Time Slot</label>
                            <select id="timeSlot" name="timeSlot" class="form-control" required>
                                <option value="09:00 AM" ${appointment.timeSlot == '09:00 AM' ? 'selected' : ''}>09:00 AM</option>
                                <option value="09:30 AM" ${appointment.timeSlot == '09:30 AM' ? 'selected' : ''}>09:30 AM</option>
                                <option value="10:00 AM" ${appointment.timeSlot == '10:00 AM' ? 'selected' : ''}>10:00 AM</option>
                                <option value="10:30 AM" ${appointment.timeSlot == '10:30 AM' ? 'selected' : ''}>10:30 AM</option>
                                <option value="11:00 AM" ${appointment.timeSlot == '11:00 AM' ? 'selected' : ''}>11:00 AM</option>
                                <option value="11:30 AM" ${appointment.timeSlot == '11:30 AM' ? 'selected' : ''}>11:30 AM</option>
                                <option value="12:00 PM" ${appointment.timeSlot == '12:00 PM' ? 'selected' : ''}>12:00 PM</option>
                                <option value="12:30 PM" ${appointment.timeSlot == '12:30 PM' ? 'selected' : ''}>12:30 PM</option>
                                <option value="02:00 PM" ${appointment.timeSlot == '02:00 PM' ? 'selected' : ''}>02:00 PM</option>
                                <option value="02:30 PM" ${appointment.timeSlot == '02:30 PM' ? 'selected' : ''}>02:30 PM</option>
                                <option value="03:00 PM" ${appointment.timeSlot == '03:00 PM' ? 'selected' : ''}>03:00 PM</option>
                                <option value="03:30 PM" ${appointment.timeSlot == '03:30 PM' ? 'selected' : ''}>03:30 PM</option>
                                <option value="04:00 PM" ${appointment.timeSlot == '04:00 PM' ? 'selected' : ''}>04:00 PM</option>
                                <option value="04:30 PM" ${appointment.timeSlot == '04:30 PM' ? 'selected' : ''}>04:30 PM</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="notes">Notes (Optional)</label>
                        <textarea id="notes" name="notes" class="form-control" rows="4">${appointment.notes}</textarea>
                    </div>

                    <div class="btn-container">
                        <div></div>
                        <div>
                            <a href="${pageContext.request.contextPath}/admin/cancel-appointment?id=${appointment.id}"
                               class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this appointment?');">
                                <i class="fas fa-times-circle"></i> Cancel Appointment
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Save Changes
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="includes/admin-footer-new.jsp" />

    <script>
        // JavaScript to handle department change and update available doctors
        document.getElementById('departmentId').addEventListener('change', function() {
            const departmentId = this.value;
            const doctorSelect = document.getElementById('doctorId');

            // In a real application, this would make an AJAX call to get doctors by department
            // For now, we'll just log the change
            console.log('Department changed to: ' + departmentId);

            // This would be replaced with an AJAX call in a real application
            // fetch('/api/doctors?departmentId=' + departmentId)
            //     .then(response => response.json())
            //     .then(data => {
            //         // Update the doctors dropdown
            //     });
        });
    </script>
</body>
</html>
