package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.Appointment;
import model.MedicalRecord;
import model.Prescription;
import dao.AppointmentDAO;
import dao.MedicalRecordDAO;
import dao.PrescriptionDAO;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Date;
import java.util.Calendar;
import java.util.stream.Collectors;

@WebServlet({"/patient/dashboard", "/patient-dashboard"})
public class PatientDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("PatientDashboardServlet: doGet method called");
        // Get or create session to ensure it exists
        HttpSession session = request.getSession(true);

        System.out.println("PatientDashboardServlet: doGet called");

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("PatientDashboardServlet: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Log all session attributes for debugging
        java.util.Enumeration<String> attributeNames = session.getAttributeNames();
        System.out.println("PatientDashboardServlet: All session attributes:");
        while (attributeNames.hasMoreElements()) {
            String attributeName = attributeNames.nextElement();
            System.out.println(attributeName + ": " + session.getAttribute(attributeName));
        }

        // Check if user is a patient
        String role = (String) session.getAttribute("role");
        if (!"patient".equals(role)) {
            System.out.println("PatientDashboardServlet: User is not a patient, redirecting to index");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // User is logged in and is a patient, forward to dashboard
        System.out.println("PatientDashboardServlet: Forwarding to dashboard.jsp");

        // Set flags to indicate this is a direct access from the servlet
        request.setAttribute("directAccess", "true");
        session.setAttribute("dashboardLoaded", "true");
        session.setAttribute("lastDashboardAccess", System.currentTimeMillis());

        // Debug session attributes
        System.out.println("PatientDashboardServlet: Session attributes");
        System.out.println("username: " + session.getAttribute("username"));
        System.out.println("name: " + session.getAttribute("name"));
        System.out.println("role: " + session.getAttribute("role"));

        // Get patient's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("PatientDashboardServlet: userId from session: " + userId);

        // If userId is null, try to get it from the user object
        if (userId == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
            System.out.println("PatientDashboardServlet: userId from user object: " + userId);

            // Store the userId in the session for future use
            session.setAttribute("userId", userId);
        }

        if (userId == null) {
            System.out.println("PatientDashboardServlet: User ID not found in session or user object");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Fetch upcoming appointments
        List<Appointment> allAppointments = new ArrayList<>();
        List<Appointment> upcomingAppointments = new ArrayList<>();
        int upcomingAppointmentsCount = 0;

        try {
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            allAppointments = appointmentDAO.getAppointmentsByPatientId(userId);

            // Filter for upcoming appointments (scheduled and not in the past)
            Date today = new Date();
            upcomingAppointments = allAppointments.stream()
                .filter(a -> (a.getStatus() != null &&
                       (a.getStatus().equalsIgnoreCase("Scheduled") || a.getStatus().equalsIgnoreCase("Pending")))
                       && (a.getAppointmentDate() != null &&
                       (a.getAppointmentDate().after(today) || isSameDay(a.getAppointmentDate(), today))))
                .collect(Collectors.toList());

            upcomingAppointmentsCount = upcomingAppointments.size();
            System.out.println("PatientDashboardServlet: Found " + upcomingAppointmentsCount + " upcoming appointments");
        } catch (Exception e) {
            System.out.println("PatientDashboardServlet: Error fetching appointments: " + e.getMessage());
            e.printStackTrace();
        }

        // Fetch medical records
        List<MedicalRecord> medicalRecords = new ArrayList<>();
        int medicalRecordsCount = 0;

        try {
            MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
            medicalRecords = medicalRecordDAO.getMedicalRecordsByPatientId(userId);
            medicalRecordsCount = medicalRecords.size();
            System.out.println("PatientDashboardServlet: Found " + medicalRecordsCount + " medical records");
        } catch (Exception e) {
            System.out.println("PatientDashboardServlet: Error fetching medical records: " + e.getMessage());
            e.printStackTrace();
        }

        // Fetch active prescriptions
        List<Prescription> allPrescriptions = new ArrayList<>();
        List<Prescription> activePrescriptions = new ArrayList<>();
        int activePrescriptionsCount = 0;

        try {
            PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
            allPrescriptions = prescriptionDAO.getPrescriptionsByPatientId(userId);

            // Filter for active prescriptions
            activePrescriptions = allPrescriptions.stream()
                .filter(p -> p.getStatus() != null && p.getStatus().equalsIgnoreCase("active"))
                .collect(Collectors.toList());

            activePrescriptionsCount = activePrescriptions.size();
            System.out.println("PatientDashboardServlet: Found " + activePrescriptionsCount + " active prescriptions");
        } catch (Exception e) {
            System.out.println("PatientDashboardServlet: Error fetching prescriptions: " + e.getMessage());
            e.printStackTrace();
        }

        // Billing section removed

        // Set both session and request attributes for the JSP
        // This ensures data persists when navigating back to the dashboard

        // User information
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("name", session.getAttribute("name"));
        request.setAttribute("role", session.getAttribute("role"));
        request.setAttribute("userId", userId);

        // Store dashboard data in both session and request
        // Upcoming appointments
        session.setAttribute("dashboardUpcomingAppointments", upcomingAppointments);
        session.setAttribute("dashboardUpcomingAppointmentsCount", upcomingAppointmentsCount);
        request.setAttribute("upcomingAppointments", upcomingAppointments);
        request.setAttribute("upcomingAppointmentsCount", upcomingAppointmentsCount);

        // Medical records
        session.setAttribute("dashboardMedicalRecords", medicalRecords);
        session.setAttribute("dashboardMedicalRecordsCount", medicalRecordsCount);
        request.setAttribute("medicalRecords", medicalRecords);
        request.setAttribute("medicalRecordsCount", medicalRecordsCount);

        // Prescriptions
        session.setAttribute("dashboardActivePrescriptions", activePrescriptions);
        session.setAttribute("dashboardActivePrescriptionsCount", activePrescriptionsCount);
        request.setAttribute("activePrescriptions", activePrescriptions);
        request.setAttribute("activePrescriptionsCount", activePrescriptionsCount);

        // Bills section removed

        // Set timestamp to track when dashboard data was last updated
        session.setAttribute("dashboardLastUpdated", new java.util.Date().getTime());

        // Set a flag to indicate this is a fresh load from the servlet
        request.setAttribute("fromServlet", "true");
        request.setAttribute("directAccess", "true");
        session.setAttribute("dashboardLoaded", "true");
        session.setAttribute("lastDashboardAccess", System.currentTimeMillis());

        // Log that we've set all the session attributes
        System.out.println("PatientDashboardServlet: All session attributes set successfully");
        System.out.println("  - dashboardUpcomingAppointments: " + (upcomingAppointments != null ? upcomingAppointments.size() + " items" : "null"));
        System.out.println("  - dashboardMedicalRecords: " + (medicalRecords != null ? medicalRecords.size() + " items" : "null"));
        System.out.println("  - dashboardActivePrescriptions: " + (activePrescriptions != null ? activePrescriptions.size() + " items" : "null"));
        System.out.println("  - dashboardLoaded: true");
        System.out.println("  - lastDashboardAccess: " + System.currentTimeMillis());

        // Log that we're about to forward to the JSP
        System.out.println("PatientDashboardServlet: Forwarding to dashboard.jsp with all attributes set");

        // Log all session attributes before forwarding
        System.out.println("PatientDashboardServlet: All session attributes before forwarding:");
        java.util.Enumeration<String> sessionAttributeNames = session.getAttributeNames();
        while (sessionAttributeNames.hasMoreElements()) {
            String name = sessionAttributeNames.nextElement();
            System.out.println("  - " + name + ": " + (session.getAttribute(name) != null ? "not null" : "null"));
        }

        // Check if there's a parameter to use the simple dashboard
        String useSimple = request.getParameter("simple");

        try {
            // Try to forward to the regular dashboard
            if ("true".equals(useSimple)) {
                System.out.println("PatientDashboardServlet: Using simple dashboard as requested");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/simple-dashboard.jsp");
                dispatcher.forward(request, response);
            } else {
                System.out.println("PatientDashboardServlet: Attempting to use regular dashboard");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/dashboard.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            // If there's any error, fall back to the simple dashboard
            System.out.println("PatientDashboardServlet: Error forwarding to dashboard.jsp: " + e.getMessage());
            e.printStackTrace();
            System.out.println("PatientDashboardServlet: Falling back to simple dashboard");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/patient/simple-dashboard.jsp");
            dispatcher.forward(request, response);
        }
    }

    /**
     * Helper method to check if two dates are the same day
     * @param date1 First date
     * @param date2 Second date
     * @return true if both dates are on the same day, false otherwise
     */
    private boolean isSameDay(Date date1, Date date2) {
        if (date1 == null || date2 == null) {
            return false;
        }
        Calendar cal1 = Calendar.getInstance();
        Calendar cal2 = Calendar.getInstance();
        cal1.setTime(date1);
        cal2.setTime(date2);
        return cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) &&
               cal1.get(Calendar.MONTH) == cal2.get(Calendar.MONTH) &&
               cal1.get(Calendar.DAY_OF_MONTH) == cal2.get(Calendar.DAY_OF_MONTH);
    }
}
