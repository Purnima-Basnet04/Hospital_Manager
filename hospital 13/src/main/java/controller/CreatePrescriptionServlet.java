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

@WebServlet("/doctor/create-prescription")
public class CreatePrescriptionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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
            String patientIdStr = request.getParameter("patient");
            String medication = request.getParameter("medication");
            String dosage = request.getParameter("dosage");
            String frequency = request.getParameter("frequency");
            String duration = request.getParameter("duration");
            String notes = request.getParameter("notes");

            System.out.println("CreatePrescriptionServlet: Creating prescription for patient " + patientIdStr +
                               ", medication: " + medication);

            // Validate form data
            if (patientIdStr == null || patientIdStr.isEmpty() ||
                medication == null || medication.isEmpty() ||
                dosage == null || dosage.isEmpty() ||
                frequency == null || frequency.isEmpty()) {

                request.setAttribute("errorMessage", "Please fill in all required fields");

                // Get patients who have appointments with this doctor
                UserDAO userDAO = new UserDAO();
                List<User> patients = userDAO.getPatientsByDoctorId(doctorId);
                request.setAttribute("patients", patients);

                // Forward back to the form
                RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/prescriptions");
                dispatcher.forward(request, response);
                return;
            }

            // Parse patient ID
            int patientId = Integer.parseInt(patientIdStr);

            // Create prescription object
            Prescription prescription = new Prescription();
            prescription.setPatientId(patientId);
            prescription.setDoctorId(doctorId);
            prescription.setMedication(medication);
            prescription.setDosage(dosage);
            prescription.setFrequency(frequency);
            prescription.setDuration(duration);
            prescription.setNotes(notes);
            prescription.setStatus("Active");

            // Save prescription to database
            PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
            boolean success = prescriptionDAO.createPrescription(prescription);

            if (success) {
                System.out.println("CreatePrescriptionServlet: Prescription created successfully");
                response.sendRedirect(request.getContextPath() + "/doctor/prescriptions?success=true");
            } else {
                System.out.println("CreatePrescriptionServlet: Failed to create prescription");

                // Get all patients
                UserDAO userDAO = new UserDAO();
                List<User> patients = userDAO.getAllPatients();
                request.setAttribute("patients", patients);

                request.setAttribute("errorMessage", "Failed to create prescription. Please try again.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/prescriptions");
                dispatcher.forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("CreatePrescriptionServlet: Error creating prescription: " + e.getMessage());
            e.printStackTrace();

            // Get all patients
            UserDAO userDAO = new UserDAO();
            List<User> patients = userDAO.getAllPatients();
            request.setAttribute("patients", patients);

            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor/prescriptions");
            dispatcher.forward(request, response);
        }
    }
}
