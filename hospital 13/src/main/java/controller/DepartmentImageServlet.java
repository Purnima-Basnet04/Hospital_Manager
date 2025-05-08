package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.DepartmentImageMapper;

import java.io.IOException;

@WebServlet("/department-image")
public class DepartmentImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get department name from request parameter
        String departmentName = request.getParameter("name");
        
        if (departmentName == null || departmentName.trim().isEmpty()) {
            // Redirect to default image if no department name provided
            response.sendRedirect(request.getContextPath() + "/images/departments/default-department.jpg");
            return;
        }
        
        // Get appropriate image URL for the department
        String imageUrl = DepartmentImageMapper.getImageUrl(departmentName);
        
        // Redirect to the image
        response.sendRedirect(request.getContextPath() + imageUrl);
    }
}
