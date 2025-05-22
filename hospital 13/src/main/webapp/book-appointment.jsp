<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - LifeCare Medical Center</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <section class="book-appointment-section">
        <div class="container">
            <h1 class="page-title">Book an Appointment</h1>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    ${errorMessage}
                </div>
            </c:if>

            <div class="appointment-form-container">
                <form action="${pageContext.request.contextPath}/appointments" method="post" class="appointment-form">
                    <input type="hidden" name="action" value="book">

                    <div class="form-group">
                        <label for="departmentId">Department</label>
                        <select id="departmentId" name="departmentId" required onchange="this.form.submit()">
                            <option value="">Select Department</option>
                            <c:forEach var="department" items="${departments}">
                                <option value="${department.id}" ${department.id == selectedDepartment ? 'selected' : ''}>
                                    ${department.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="doctorId">Doctor</label>
                        <select id="doctorId" name="doctorId" required>
                            <option value="">Select Doctor</option>
                            <c:forEach var="doctor" items="${doctors}">
                                <option value="${doctor.id}">${doctor.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="appointmentDate">Appointment Date</label>
                        <input type="date" id="appointmentDate" name="appointmentDate" required min="${today}">
                    </div>

                    <div class="form-group">
                        <label for="timeSlot">Time Slot</label>
                        <select id="timeSlot" name="timeSlot" required>
                            <option value="">Select Time</option>
                            <option value="09:00 AM">09:00 AM</option>
                            <option value="09:30 AM">09:30 AM</option>
                            <option value="10:00 AM">10:00 AM</option>
                            <option value="10:30 AM">10:30 AM</option>
                            <option value="11:00 AM">11:00 AM</option>
                            <option value="11:30 AM">11:30 AM</option>
                            <option value="12:00 PM">12:00 PM</option>
                            <option value="12:30 PM">12:30 PM</option>
                            <option value="02:00 PM">02:00 PM</option>
                            <option value="02:30 PM">02:30 PM</option>
                            <option value="03:00 PM">03:00 PM</option>
                            <option value="03:30 PM">03:30 PM</option>
                            <option value="04:00 PM">04:00 PM</option>
                            <option value="04:30 PM">04:30 PM</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="notes">Notes (Optional)</label>
                        <textarea id="notes" name="notes" rows="4" placeholder="Any specific concerns or information for the doctor"></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Book Appointment</button>
                        <a href="appointments" class="btn btn-outline">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <%@ include file="footer.jsp" %>

    <script>
        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('appointmentDate').setAttribute('min', today);

        // If the form was submitted to select a department, prevent the actual submission
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('.appointment-form');
            const departmentSelect = document.getElementById('departmentId');

            departmentSelect.addEventListener('change', function(e) {
                form.action = 'appointments?action=new&dept=' + this.value;
            });
        });
    </script>

    <script src="js/script.js"></script>
</body>
</html>
