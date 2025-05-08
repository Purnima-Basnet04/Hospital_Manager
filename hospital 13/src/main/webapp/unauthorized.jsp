<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unauthorized Access - LifeCare Medical Center</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <section class="error-section">
        <div class="container">
            <div class="error-content">
                <div class="error-icon">
                    <i class="icon-lock"></i>
                </div>
                <h1>Unauthorized Access</h1>
                <p>Sorry, you don't have permission to access this page.</p>
                <p>Please log in with the appropriate account or contact the administrator if you believe this is an error.</p>
                <div class="error-actions">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go to Homepage</a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Login</a>
                </div>
            </div>
        </div>
    </section>

    <%@ include file="footer.jsp" %>

    <script src="js/script.js"></script>
</body>
</html>
