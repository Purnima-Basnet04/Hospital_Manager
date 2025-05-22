package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/doctor/redirect-to-edit")
public class RedirectToEditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("username") == null || !"doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get medical record ID from request parameter
        String recordIdStr = request.getParameter("id");
        System.out.println("RedirectToEditServlet: Record ID = " + recordIdStr);
        
        if (recordIdStr == null || recordIdStr.isEmpty()) {
            System.out.println("RedirectToEditServlet: No medical record ID provided");
            response.sendRedirect(request.getContextPath() + "/doctor/medical-records");
            return;
        }
        
        // Redirect to the edit page
        String editUrl = request.getContextPath() + "/doctor/edit-medical-record?id=" + recordIdStr;
        System.out.println("RedirectToEditServlet: Redirecting to " + editUrl);
        response.sendRedirect(editUrl);
    }
}
