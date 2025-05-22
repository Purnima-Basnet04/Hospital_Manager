<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Appointment | LifeCare Hospital</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patient-dashboard.css">
    <style>
        .form-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        select.form-control {
            height: 42px;
        }
        .btn-container {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }
        .btn-primary:hover {
            background-color: #45a049;
        }
        .btn-outline {
            background-color: transparent;
            border: 1px solid #4CAF50;
            color: #4CAF50;
        }
        .btn-outline:hover {
            background-color: #f0f0f0;
        }
        .btn-danger {
            background-color: #f44336;
            color: white;
        }
        .btn-danger:hover {
            background-color: #d32f2f;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/patient-header.jsp" />
    
    <div class="container">
        <div class="dashboard-container">
            <jsp:include page="../includes/patient-sidebar.jsp" />
            
            <div class="main-content">
                <div class="content-header">
                    <h1><i class="fas fa-edit"></i> Edit Appointment</h1>
                    <p>Update your appointment details below</p>
                </div>
                
                <div class="form-container">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                        </div>
                    </c:if>
                    
                    <form action="${pageContext.request.contextPath}/patient/edit-appointment" method="post">
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
                        
                        <div class="form-group">
                            <label for="notes">Notes (Optional)</label>
                            <textarea id="notes" name="notes" class="form-control" rows="4">${appointment.notes}</textarea>
                        </div>
                        
                        <div class="btn-container">
                            <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-outline">
                                <i class="fas fa-arrow-left"></i> Back to Appointments
                            </a>
                            <div>
                                <a href="${pageContext.request.contextPath}/patient/cancel-appointment?id=${appointment.id}" 
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
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script>
        // JavaScript to handle department change and update available doctors
        document.getElementById('departmentId').addEventListener('change', function() {
            const departmentId = this.value;
            const doctorSelect = document.getElementById('doctorId');
            
            // In a real application, this would make an AJAX call to get doctors by department
            // For now, we'll just show/hide options based on the selected department
            
            // This is a placeholder - in a real app, you would fetch doctors by department
            console.log('Department changed to: ' + departmentId);
        });
    </script>
</body>
</html>
