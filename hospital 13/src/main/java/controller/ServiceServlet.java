package controller;

import dao.ServiceDAO;
import model.Service;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/services")
public class ServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String category = request.getParameter("category");

        ServiceDAO serviceDAO = new ServiceDAO();
        List<Service> services;

        if (category != null && !category.trim().isEmpty()) {
            // Get services by category
            services = serviceDAO.getServicesByCategory(category);
            request.setAttribute("categoryTitle", category);
        } else {
            // Get all services
            services = serviceDAO.getAllServices();
        }

        request.setAttribute("services", services);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/services.jsp");
        dispatcher.forward(request, response);
    }
}