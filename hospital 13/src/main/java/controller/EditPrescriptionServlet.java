package controller;

import dao.PrescriptionDAO;
import dao.UserDAO;
import model.Prescription;
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

@WebServlet("/doctor/edit-prescription")
public class EditPrescriptionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("username") == null || !"doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get doctor ID from session
        Integer doctorId = (Integer) session.getAttribute("userId");
        if (doctorId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get prescription ID from request
        String prescriptionIdStr = request.getParameter("id");
        if (prescriptionIdStr == null || prescriptionIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/prescriptions?error=missing-id");
            return;
        }

        try {
            int prescriptionId = Integer.parseInt(prescriptionIdStr);

            // Get prescription from database
            PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
            Prescription prescription = prescriptionDAO.getPrescriptionById(prescriptionId);

            if (prescription == null) {
                response.sendRedirect(request.getContextPath() + "/doctor/prescriptions?error=not-found");
                return;
            }

            // Allow any doctor to edit any prescription
            System.out.println("EditPrescriptionServlet: Doctor ID: " + doctorId + ", Prescription Doctor ID: " + prescription.getDoctorId());
            // No longer checking if prescription belongs to this doctor

            // Get patient details
            UserDAO userDAO = new UserDAO();
            User patient = userDAO.getUserById(prescription.getPatientId());
            if (patient != null) {
                prescription.setPatientName(patient.getName());
            }

            // Get all patients for dropdown
            List<User> patients = userDAO.getAllPatients();

            // Set attributes for the JSP
            request.setAttribute("prescription", prescription);
            request.setAttribute("patient", patient);
            request.setAttribute("patients", patients);
            request.setAttribute("username", session.getAttribute("username"));
            request.setAttribute("name", session.getAttribute("name"));
            request.setAttribute("role", session.getAttribute("role"));

            // Forward to the JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/edit-prescription.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctor/prescriptions?error=invalid-id");
        } catch (Exception e) {
            System.out.println("EditPrescriptionServlet: Error editing prescription: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/prescriptions?error=server-error");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("username") == null || !"doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get doctor ID from session
        Integer doctorId = (Integer) session.getAttribute("userId");
        if (doctorId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get form data
            String prescriptionIdStr = request.getParameter("id");
            String patientIdStr = request.getParameter("patient");
            String medication = request.getParameter("medication");
            String dosage = request.getParameter("dosage");
            String frequency = request.getParameter("frequency");
            String duration = request.getParameter("duration");
            String notes = request.getParameter("notes");
            String status = request.getParameter("status");

            System.out.println("EditPrescriptionServlet: Updating prescription " + prescriptionIdStr +
                               ", medication: " + medication);

            // Validate form data
            if (prescriptionIdStr == null || prescriptionIdStr.isEmpty() ||
                patientIdStr == null || patientIdStr.isEmpty() ||
                medication == null || medication.isEmpty() ||
                dosage == null || dosage.isEmpty() ||
                frequency == null || frequency.isEmpty()) {

                request.setAttribute("errorMessage", "Please fill in all required fields");
                doGet(request, response);
                return;
            }

            // Parse IDs
            int prescriptionId = Integer.parseInt(prescriptionIdStr);
            int patientId = Integer.parseInt(patientIdStr);

            // Get the existing prescription
            PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
            Prescription prescription = prescriptionDAO.getPrescriptionById(prescriptionId);

            if (prescription == null) {
                response.sendRedirect(request.getContextPath() + "/doctor/prescriptions?error=not-found");
                return;
            }

            // Allow any doctor to edit any prescription
            System.out.println("EditPrescriptionServlet: Doctor ID: " + doctorId + ", Prescription Doctor ID: " + prescription.getDoctorId());
            // No longer checking if prescription belongs to this doctor

            // Update prescription object
            prescription.setPatientId(patientId);
            prescription.setMedication(medication);
            prescription.setDosage(dosage);
            prescription.setFrequency(frequency);
            prescription.setDuration(duration);
            prescription.setNotes(notes);

            // Only update status if it's provided
            if (status != null && !status.isEmpty()) {
                prescription.setStatus(status);
            }

            // Save prescription to database
            boolean success = prescriptionDAO.updatePrescription(prescription);

            if (success) {
                System.out.println("EditPrescriptionServlet: Prescription updated successfully");
                response.sendRedirect(request.getContextPath() + "/doctor/view-prescription?id=" + prescriptionId + "&success=true");
            } else {
                System.out.println("EditPrescriptionServlet: Failed to update prescription");
                request.setAttribute("errorMessage", "Failed to update prescription. Please try again.");
                doGet(request, response);
            }

        } catch (Exception e) {
            System.out.println("EditPrescriptionServlet: Error updating prescription: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            doGet(request, response);
        }
    }
}
