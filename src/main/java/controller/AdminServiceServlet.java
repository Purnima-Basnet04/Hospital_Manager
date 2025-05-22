package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Service;
import dao.ServiceDAO;

import java.io.IOException;

@WebServlet("/admin/services/*")
public class AdminServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ServiceDAO serviceDAO;
    
    public void init() {
        serviceDAO = new ServiceDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        // Default to list action
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/services.jsp");
            return;
        }
        
        // Handle different actions based on path
        switch (pathInfo) {
            case "/view":
                viewService(request, response);
                break;
            case "/add":
                showAddForm(request, response);
                break;
            case "/edit":
                showEditForm(request, response);
                break;
            case "/delete":
                deleteService(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/services.jsp");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/services.jsp");
            return;
        }
        
        switch (action) {
            case "add":
                addService(request, response);
                break;
            case "update":
                updateService(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/services.jsp");
                break;
        }
    }
    
    private void viewService(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Service service = serviceDAO.getServiceById(id);
        
        if (service != null) {
            request.setAttribute("service", service);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/view-service.jsp");
            dispatcher.forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Service not found");
            response.sendRedirect(request.getContextPath() + "/admin/services.jsp");
        }
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-service.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Service service = serviceDAO.getServiceById(id);
        
        if (service != null) {
            request.setAttribute("service", service);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-service.jsp");
            dispatcher.forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Service not found");
            response.sendRedirect(request.getContextPath() + "/admin/services.jsp");
        }
    }
    
    private void addService(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String icon = request.getParameter("icon");
        String category = request.getParameter("category");
        
        // Validate service name
        if (serviceDAO.isServiceNameExists(name)) {
            request.setAttribute("errorMessage", "Service name already exists");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-service.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Create service object
        Service service = new Service();
        service.setName(name);
        service.setDescription(description);
        service.setIcon(icon);
        service.setCategory(category);
        
        // Add service
        boolean success = serviceDAO.addService(service);
        
        if (success) {
            // Store success message in session for display after redirect
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Service '" + name + "' was added successfully");
            response.sendRedirect(request.getContextPath() + "/admin/services.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to add service");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-service.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void updateService(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String icon = request.getParameter("icon");
        String category = request.getParameter("category");
        
        // Get existing service
        Service existingService = serviceDAO.getServiceById(id);
        
        if (existingService == null) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Service not found");
            response.sendRedirect(request.getContextPath() + "/admin/services.jsp");
            return;
        }
        
        // Check if name has changed and if it already exists
        if (!existingService.getName().equals(name) && serviceDAO.isServiceNameExists(name)) {
            request.setAttribute("errorMessage", "Service name already exists");
            request.setAttribute("service", existingService);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-service.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Update service object
        existingService.setName(name);
        existingService.setDescription(description);
        existingService.setIcon(icon);
        existingService.setCategory(category);
        
        // Update service
        boolean success = serviceDAO.updateService(existingService);
        
        if (success) {
            // Store success message in session for display after redirect
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Service '" + name + "' was updated successfully");
            response.sendRedirect(request.getContextPath() + "/admin/services.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to update service");
            request.setAttribute("service", existingService);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-service.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void deleteService(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Get service name before deletion for better message
        Service service = serviceDAO.getServiceById(id);
        String serviceName = (service != null && service.getName() != null) ? service.getName() : "Service";
        
        boolean success = serviceDAO.deleteService(id);
        
        // Store message in session for display after redirect
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("successMessage", "Service '" + serviceName + "' was deleted successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to delete '" + serviceName + "'");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/services.jsp");
    }
}
