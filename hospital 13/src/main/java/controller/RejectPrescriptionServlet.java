package controller;

import dao.PrescriptionDAO;
import model.Prescription;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/doctor/reject-prescription")
public class RejectPrescriptionServlet extends HttpServlet {
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

            // Check if the prescription belongs to this doctor
            if (prescription.getDoctorId() != doctorId) {
                response.sendRedirect(request.getContextPath() + "/doctor/prescriptions?error=unauthorized");
                return;
            }

            // Update prescription status
            prescription.setStatus("Cancelled");
            boolean success = prescriptionDAO.updatePrescriptionStatus(prescriptionId, "Cancelled");

            if (success) {
                response.sendRedirect(request.getContextPath() + "/doctor/view-prescription?id=" + prescriptionId + "&success=rejected");
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/view-prescription?id=" + prescriptionId + "&error=update-failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctor/prescriptions?error=invalid-id");
        } catch (Exception e) {
            System.out.println("RejectPrescriptionServlet: Error rejecting prescription: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/prescriptions?error=server-error");
        }
    }
}
