package controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.UserDAO;
import model.User;

/**
 * Servlet implementation class UpdateProfileServlet
 * Handles updating a patient's profile information
 */
@WebServlet("/patient/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateProfileServlet() {
        super();
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

        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            request.setAttribute("errorMessage", "User ID not found in session");
            request.getRequestDispatcher("/patient/profile.jsp").forward(request, response);
            return;
        }

        try {
            // Get user from database
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(userId);

            if (user == null) {
                request.setAttribute("errorMessage", "User not found");
                request.getRequestDispatcher("/patient/profile.jsp").forward(request, response);
                return;
            }

            // Update user information from form
            user.setName(request.getParameter("name"));

            // Validate that email ends with @gmail.com
            String email = request.getParameter("email");
            if (email != null && !email.trim().isEmpty() && !email.toLowerCase().endsWith("@gmail.com")) {
                session.setAttribute("errorMessage", "Email must be a Gmail address (ending with @gmail.com)");
                response.sendRedirect(request.getContextPath() + "/patient/edit-profile.jsp");
                return;
            }
            user.setEmail(email);
            user.setPhone(request.getParameter("phone"));

            // Handle gender selection
            String gender = request.getParameter("gender");
            if (gender != null && !gender.isEmpty() && !gender.equals("-- Select Gender --")) {
                user.setGender(gender);
            }

            // Handle blood group selection
            String bloodGroup = request.getParameter("bloodGroup");
            if (bloodGroup != null && !bloodGroup.isEmpty() && !bloodGroup.equals("-- Select Blood Type --")) {
                user.setBloodGroup(bloodGroup);
            }

            user.setAddress(request.getParameter("address"));
            user.setEmergencyContact(request.getParameter("emergencyContact"));
            user.setMedicalHistory(request.getParameter("medicalHistory"));

            // Parse date of birth
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                try {
                    // Try different date formats
                    SimpleDateFormat[] dateFormats = {
                        new SimpleDateFormat("yyyy-MM-dd"),
                        new SimpleDateFormat("MM/dd/yyyy"),
                        new SimpleDateFormat("dd/MM/yyyy")
                    };

                    Date dateOfBirth = null;
                    boolean parsed = false;

                    for (SimpleDateFormat format : dateFormats) {
                        try {
                            dateOfBirth = format.parse(dateOfBirthStr);
                            parsed = true;
                            System.out.println("UpdateProfileServlet: Successfully parsed date: " + dateOfBirthStr + " using format: " + format.toPattern());
                            break;
                        } catch (ParseException pe) {
                            // Try next format
                        }
                    }

                    if (parsed && dateOfBirth != null) {
                        user.setDateOfBirth(dateOfBirth);
                    } else {
                        System.out.println("UpdateProfileServlet: Could not parse date: " + dateOfBirthStr);
                    }
                } catch (Exception e) {
                    System.out.println("Error handling date of birth: " + e.getMessage());
                    e.printStackTrace();
                    // Continue without updating date of birth
                }
            }

            // Print debug information
            System.out.println("UpdateProfileServlet: Updating user with ID " + user.getId());
            System.out.println("UpdateProfileServlet: Name = " + user.getName());
            System.out.println("UpdateProfileServlet: Email = " + user.getEmail());
            System.out.println("UpdateProfileServlet: Phone = " + user.getPhone());
            System.out.println("UpdateProfileServlet: Gender = " + user.getGender());
            System.out.println("UpdateProfileServlet: Blood Group = " + user.getBloodGroup());
            System.out.println("UpdateProfileServlet: Date of Birth = " + user.getDateOfBirth());

            // Update user in database
            boolean success = userDAO.updateUser(user);
            System.out.println("UpdateProfileServlet: Update success = " + success);

            if (success) {
                // Update session attributes if name changed
                if (!user.getName().equals(session.getAttribute("name"))) {
                    session.setAttribute("name", user.getName());
                }

                // Set success message and redirect to profile page
                session.setAttribute("successMessage", "Profile updated successfully");
                response.sendRedirect(request.getContextPath() + "/patient/profile.jsp");
            } else {
                // Set error message in session for redirect
                session.setAttribute("errorMessage", "Failed to update profile. Please try again.");
                response.sendRedirect(request.getContextPath() + "/patient/edit-profile.jsp");
            }

        } catch (Exception e) {
            System.out.println("Error updating profile: " + e.getMessage());
            e.printStackTrace();
            // Set detailed error message in session for redirect
            session.setAttribute("errorMessage", "An error occurred while updating your profile: " + e.getMessage());
            System.out.println("UpdateProfileServlet: Exception details: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/patient/edit-profile.jsp");
        }
    }
}
