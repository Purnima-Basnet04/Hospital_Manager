package controller;

import java.io.IOException;
import java.util.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.PrescriptionDAO;
import dao.UserDAO;
import model.Prescription;
import model.User;

/**
 * Servlet implementation class AddPrescriptionServlet
 * Handles adding a new prescription for a patient
 */
@WebServlet("/doctor/add-prescription")
public class AddPrescriptionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddPrescriptionServlet() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the patient ID from the request parameter
        String patientIdStr = request.getParameter("patientId");

        if (patientIdStr != null && !patientIdStr.isEmpty()) {
            try {
                int patientId = Integer.parseInt(patientIdStr);

                // Get the patient information
                UserDAO userDAO = new UserDAO();
                User patient = userDAO.getUserById(patientId);

                if (patient != null) {
                    // Set the patient as a request attribute
                    request.setAttribute("patient", patient);

                    // Forward to the add prescription form
                    request.getRequestDispatcher("/doctor/add-prescription.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid patient ID: " + patientIdStr);
            }
        }

        // If we get here, either no patient ID was provided or the patient wasn't found
        // Redirect to the add prescription form without a patient
        response.sendRedirect(request.getContextPath() + "/doctor/add-prescription.jsp");
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is a doctor
        String role = (String) session.getAttribute("role");
        if (!"doctor".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Get doctor ID from session
        Integer doctorId = (Integer) session.getAttribute("userId");
        if (doctorId == null) {
            session.setAttribute("errorMessage", "Doctor ID not found in session");
            response.sendRedirect(request.getContextPath() + "/doctor/patients");
            return;
        }

        // Get form parameters
        String patientIdStr = request.getParameter("patientId");
        String medication = request.getParameter("medication");
        String dosage = request.getParameter("dosage");
        String frequency = request.getParameter("frequency");
        String duration = request.getParameter("duration");
        String instructions = request.getParameter("instructions");

        try {

            // Validate required fields
            if (patientIdStr == null || patientIdStr.isEmpty() ||
                medication == null || medication.isEmpty() ||
                dosage == null || dosage.isEmpty() ||
                frequency == null || frequency.isEmpty() ||
                duration == null || duration.isEmpty()) {

                session.setAttribute("errorMessage", "All required fields must be filled out");
                response.sendRedirect(request.getContextPath() + "/doctor/add-prescription.jsp?patientId=" + patientIdStr);
                return;
            }

            // Parse patient ID
            int patientId;
            try {
                patientId = Integer.parseInt(patientIdStr);
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid patient ID");
                response.sendRedirect(request.getContextPath() + "/doctor/patients");
                return;
            }

            // Check if patient exists
            UserDAO userDAO = new UserDAO();
            User patient = userDAO.getUserById(patientId);
            if (patient == null) {
                session.setAttribute("errorMessage", "Patient not found");
                response.sendRedirect(request.getContextPath() + "/doctor/patients");
                return;
            }

            // Get patient name
            String patientName = patient.getName();

            // Get doctor name
            User doctor = userDAO.getUserById(doctorId);
            String doctorName = (doctor != null) ? doctor.getName() : "Dr. Unknown";

            // Create new prescription
            Prescription prescription = new Prescription();
            prescription.setPatientId(patientId);
            prescription.setDoctorId(doctorId);
            prescription.setPatientName(patient.getName());
            prescription.setDoctorName(doctorName);
            prescription.setMedication(medication);
            prescription.setDosage(dosage);
            prescription.setFrequency(frequency);
            prescription.setDuration(duration);
            prescription.setNotes(instructions);
            prescription.setStatus("Active");
            prescription.setPrescriptionDate(new Date()); // Current date

            // Debug information
            System.out.println("AddPrescriptionServlet: Creating prescription with the following details:");
            System.out.println("Patient ID: " + patientId);
            System.out.println("Patient Name: " + patient.getName());
            System.out.println("Doctor ID: " + doctorId);
            System.out.println("Doctor Name: " + doctorName);
            System.out.println("Medication: " + medication);
            System.out.println("Dosage: " + dosage);
            System.out.println("Frequency: " + frequency);
            System.out.println("Duration: " + duration);
            System.out.println("Instructions: " + instructions);
            System.out.println("Status: Active");

            // Save prescription to database
            PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
            boolean success = prescriptionDAO.createPrescription(prescription);

            if (success) {
                // Set success message and redirect to patient details
                System.out.println("AddPrescriptionServlet: Prescription added successfully for patient ID " + patientId);
                session.setAttribute("successMessage", "Prescription added successfully for " + patientName);
                response.sendRedirect(request.getContextPath() + "/doctor/view-patient?id=" + patientId);
            } else {
                // Set error message and redirect back to form
                System.out.println("AddPrescriptionServlet: Failed to add prescription for patient ID " + patientId);
                System.out.println("AddPrescriptionServlet: Check the database connection and table structure");
                session.setAttribute("errorMessage", "Failed to add prescription. Please try again.");
                response.sendRedirect(request.getContextPath() + "/doctor/add-prescription?patientId=" + patientId);
            }

        } catch (Exception e) {
            System.out.println("Error adding prescription: " + e.getMessage());
            System.out.println("Exception type: " + e.getClass().getName());
            e.printStackTrace();

            session.setAttribute("errorMessage", "An error occurred while adding the prescription: " + e.getMessage());

            // Redirect to the add prescription page with the patient ID if available
            if (patientIdStr != null && !patientIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/doctor/add-prescription?patientId=" + patientIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/add-prescription");
            }
        }
    }
}
