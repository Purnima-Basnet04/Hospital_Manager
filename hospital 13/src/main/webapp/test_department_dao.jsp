<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Department" %>
<%@ page import="dao.DepartmentDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Department DAO</title>
</head>
<body>
    <h1>Test Department DAO</h1>
    
    <%
    try {
        DepartmentDAO departmentDAO = new DepartmentDAO();
        List<Department> departments = departmentDAO.getAllDepartments();
        
        if (departments == null || departments.isEmpty()) {
            out.println("<p>No departments found in the database.</p>");
        } else {
            out.println("<h2>Departments from Database:</h2>");
            out.println("<table border='1'>");
            out.println("<tr><th>ID</th><th>Name</th><th>Description</th><th>Image URL</th><th>Building</th><th>Floor</th><th>Specialists</th></tr>");
            
            for (Department department : departments) {
                out.println("<tr>");
                out.println("<td>" + department.getId() + "</td>");
                out.println("<td>" + department.getName() + "</td>");
                out.println("<td>" + department.getDescription() + "</td>");
                out.println("<td>" + department.getImageUrl() + "</td>");
                out.println("<td>" + department.getBuilding() + "</td>");
                out.println("<td>" + department.getFloor() + "</td>");
                out.println("<td>" + department.getSpecialistsCount() + "</td>");
                out.println("</tr>");
            }
            
            out.println("</table>");
        }
    } catch (Exception e) {
        out.println("<h2>Error</h2>");
        out.println("<p>Error: " + e.getMessage() + "</p>");
        out.println("<pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
    }
    %>
    
    <p><a href="index.jsp">Back to Home</a></p>
    <p><a href="departments">Go to Departments Page</a></p>
</body>
</html>
