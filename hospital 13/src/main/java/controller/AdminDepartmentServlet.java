package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Department;
import dao.DepartmentDAO;

import java.io.IOException;

@WebServlet("/admin/departments/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 50    // 50 MB
)
public class AdminDepartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DepartmentDAO departmentDAO;

    public void init() {
        departmentDAO = new DepartmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // Default to list action
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/departments.jsp");
            return;
        }

        // Handle different actions based on path
        switch (pathInfo) {
            case "/view":
                viewDepartment(request, response);
                break;
            case "/add":
                showAddForm(request, response);
                break;
            case "/edit":
                showEditForm(request, response);
                break;
            case "/delete":
                deleteDepartment(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/departments.jsp");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/departments.jsp");
            return;
        }

        switch (action) {
            case "add":
                addDepartment(request, response);
                break;
            case "update":
                updateDepartment(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/departments.jsp");
                break;
        }
    }

    private void viewDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Department department = departmentDAO.getDepartmentById(id);

        if (department != null) {
            request.setAttribute("department", department);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/view-department.jsp");
            dispatcher.forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Department not found");
            response.sendRedirect(request.getContextPath() + "/admin/departments.jsp");
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-department.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Department department = departmentDAO.getDepartmentById(id);

        if (department != null) {
            request.setAttribute("department", department);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-department.jsp");
            dispatcher.forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Department not found");
            response.sendRedirect(request.getContextPath() + "/admin/departments.jsp");
        }
    }

    private void addDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");
        String building = request.getParameter("building");
        int floor = 0;
        int specialistsCount = 0;

        try {
            floor = Integer.parseInt(request.getParameter("floor"));
        } catch (NumberFormatException e) {
            // Use default value
        }

        try {
            specialistsCount = Integer.parseInt(request.getParameter("specialistsCount"));
        } catch (NumberFormatException e) {
            // Use default value
        }

        // Validate department name
        if (departmentDAO.isDepartmentNameExists(name)) {
            request.setAttribute("errorMessage", "Department name already exists");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-department.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Create department object
        Department department = new Department();
        department.setName(name);
        department.setDescription(description);
        department.setImageUrl(imageUrl);
        department.setBuilding(building);
        department.setFloor(floor);
        department.setSpecialistsCount(specialistsCount);

        // Add department
        boolean success = departmentDAO.addDepartment(department);

        if (success) {
            // Store success message in session for display after redirect
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Department '" + name + "' was added successfully");
            response.sendRedirect(request.getContextPath() + "/admin/departments.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to add department");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add-department.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void updateDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");
        String building = request.getParameter("building");
        int floor = 0;
        int specialistsCount = 0;

        try {
            floor = Integer.parseInt(request.getParameter("floor"));
        } catch (NumberFormatException e) {
            // Use default value
        }

        try {
            specialistsCount = Integer.parseInt(request.getParameter("specialistsCount"));
        } catch (NumberFormatException e) {
            // Use default value
        }

        // Get existing department
        Department existingDepartment = departmentDAO.getDepartmentById(id);

        if (existingDepartment == null) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Department not found");
            response.sendRedirect(request.getContextPath() + "/admin/departments.jsp");
            return;
        }

        // Check if name has changed and if it already exists
        if (!existingDepartment.getName().equals(name) && departmentDAO.isDepartmentNameExists(name)) {
            request.setAttribute("errorMessage", "Department name already exists");
            request.setAttribute("department", existingDepartment);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-department.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Update department object
        existingDepartment.setName(name);
        existingDepartment.setDescription(description);
        existingDepartment.setImageUrl(imageUrl);
        existingDepartment.setBuilding(building);
        existingDepartment.setFloor(floor);
        existingDepartment.setSpecialistsCount(specialistsCount);

        // Update department
        boolean success = departmentDAO.updateDepartment(existingDepartment);

        if (success) {
            // Store success message in session for display after redirect
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Department '" + name + "' was updated successfully");
            response.sendRedirect(request.getContextPath() + "/admin/departments.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to update department");
            request.setAttribute("department", existingDepartment);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/edit-department.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        // Get department name before deletion for better message
        Department department = departmentDAO.getDepartmentById(id);
        String departmentName = (department != null && department.getName() != null) ? department.getName() : "Department";

        boolean success = departmentDAO.deleteDepartment(id);

        // Store message in session for display after redirect
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("successMessage", "Department '" + departmentName + "' was deleted successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to delete '" + departmentName + "'");
        }

        response.sendRedirect(request.getContextPath() + "/admin/departments.jsp");
    }
}
