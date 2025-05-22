package controller;

import dao.BillingDAO;
import model.Bill;
import model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Date;

// Billing functionality has been removed
// @WebServlet({"/patient/billing", "/patient-billing"})
public class PatientBillingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("PatientBillingServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("PatientBillingServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("PatientBillingServlet: User is not a patient, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get patient's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("PatientBillingServlet: userId from session: " + userId);

        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("PatientBillingServlet: userId from user object: " + userId);

            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }

        if (userId == null) {
            System.out.println("PatientBillingServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get patient's bills
        List<Bill> bills = new ArrayList<>();

        try {
            // Check if BillingDAO exists
            Class.forName("dao.BillingDAO");
            BillingDAO billingDAO = new BillingDAO();
            bills = billingDAO.getBillsByPatientId(userId);
            System.out.println("PatientBillingServlet: Found " + bills.size() + " bills for patient ID " + userId);
        } catch (ClassNotFoundException e) {
            System.out.println("PatientBillingServlet: BillingDAO not found, using sample data");
            // If BillingDAO doesn't exist, use sample data
            bills = createSampleBills(userId);
        } catch (Exception e) {
            System.out.println("PatientBillingServlet: Error getting bills: " + e.getMessage());
            e.printStackTrace();
            // If there's an error, use sample data
            bills = createSampleBills(userId);
        }

        // Set bills as request attribute
        request.setAttribute("bills", bills);

        // Set request attributes for the JSP
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));
        request.setAttribute("userId", userId);

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/billing.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle search functionality
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is a patient
        if (session == null || session.getAttribute("username") == null || !"patient".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            session.setAttribute("userId", userId);
        }

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String searchQuery = request.getParameter("search");
        String statusFilter = request.getParameter("status");

        System.out.println("PatientBillingServlet: doPost called with search=" + searchQuery + ", status=" + statusFilter);

        // Get all bills for this patient
        List<Bill> bills = new ArrayList<>();

        try {
            // Check if BillingDAO exists
            Class.forName("dao.BillingDAO");
            BillingDAO billingDAO = new BillingDAO();
            bills = billingDAO.getBillsByPatientId(userId);
        } catch (ClassNotFoundException e) {
            System.out.println("PatientBillingServlet: BillingDAO not found, using sample data");
            // If BillingDAO doesn't exist, use sample data
            bills = createSampleBills(userId);
        } catch (Exception e) {
            System.out.println("PatientBillingServlet: Error getting bills: " + e.getMessage());
            e.printStackTrace();
            // If there's an error, use sample data
            bills = createSampleBills(userId);
        }

        // TODO: Implement filtering logic based on search query and status

        // Set attributes for the JSP
        request.setAttribute("bills", bills);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));
        request.setAttribute("userId", userId);

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/billing.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Create sample bills for testing
     *
     * @param patientId The ID of the patient
     * @return List of sample bills
     */
    private List<Bill> createSampleBills(int patientId) {
        List<Bill> sampleBills = new ArrayList<>();

        // Sample bill 1
        Bill bill1 = new Bill();
        bill1.setId(1);
        bill1.setPatientId(patientId);
        bill1.setDescription("General Consultation");
        bill1.setAmount(150.00);
        bill1.setStatus("paid");
        bill1.setBillingDate(new Date());
        bill1.setDueDate(new Date(System.currentTimeMillis() + 30 * 24 * 60 * 60 * 1000)); // 30 days from now
        bill1.setPaymentDate(new Date());
        sampleBills.add(bill1);

        // Sample bill 2
        Bill bill2 = new Bill();
        bill2.setId(2);
        bill2.setPatientId(patientId);
        bill2.setDescription("Blood Test");
        bill2.setAmount(75.50);
        bill2.setStatus("pending");
        bill2.setBillingDate(new Date(System.currentTimeMillis() - 15 * 24 * 60 * 60 * 1000)); // 15 days ago
        bill2.setDueDate(new Date(System.currentTimeMillis() + 15 * 24 * 60 * 60 * 1000)); // 15 days from now
        sampleBills.add(bill2);

        // Sample bill 3
        Bill bill3 = new Bill();
        bill3.setId(3);
        bill3.setPatientId(patientId);
        bill3.setDescription("X-Ray");
        bill3.setAmount(250.00);
        bill3.setStatus("overdue");
        bill3.setBillingDate(new Date(System.currentTimeMillis() - 45 * 24 * 60 * 60 * 1000)); // 45 days ago
        bill3.setDueDate(new Date(System.currentTimeMillis() - 15 * 24 * 60 * 60 * 1000)); // 15 days ago
        sampleBills.add(bill3);

        System.out.println("PatientBillingServlet: Created " + sampleBills.size() + " sample bills");

        return sampleBills;
    }
}
