package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;

@WebFilter(urlPatterns = {"/patient/*", "/doctor/*", "/admin/*", "/appointments"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        String requestURI = httpRequest.getRequestURI();

        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("username") != null);

        // Check if the request is for a restricted area
        boolean isPatientArea = requestURI.contains("/patient/");
        boolean isDoctorArea = requestURI.contains("/doctor/");
        boolean isAdminArea = requestURI.contains("/admin/");
        boolean isAppointmentArea = requestURI.contains("/appointments");

        // Allow doctors to access their dashboard
        if (session != null && "doctor".equals(session.getAttribute("role"))) {
            // Allow access to doctor area
            if (isDoctorArea) {
                chain.doFilter(request, response);
                return;
            }
        }

        // Public areas that don't require authentication
        boolean isPublicArea = requestURI.equals(httpRequest.getContextPath() + "/") ||
                              requestURI.contains("/login") ||
                              requestURI.contains("/register") ||
                              requestURI.contains("/css/") ||
                              requestURI.contains("/js/") ||
                              requestURI.contains("/images/") ||
                              requestURI.contains("/departments") ||
                              requestURI.contains("/services") ||
                              requestURI.contains("/patient/dashboard") ||
                              requestURI.contains("/patient-dashboard");

        // If it's a public area, allow access without authentication
        if (isPublicArea) {
            chain.doFilter(request, response);
            return;
        }

        // For protected areas, check if user is logged in
        if (isLoggedIn) {
            // User is logged in, check role-based access
            String role = (String) session.getAttribute("role");

            // Doctor redirects are handled above

            if ((isPatientArea && !"patient".equals(role)) ||
                (isDoctorArea && !"doctor".equals(role)) ||
                (isAdminArea && !"admin".equals(role))) {

                // Unauthorized access to role-specific area
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/unauthorized.jsp");
                return;
            }

            // Check if appointments area is being accessed by a patient, doctor, or admin
            if (isAppointmentArea && !"patient".equals(role) && !"doctor".equals(role) && !"admin".equals(role)) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/unauthorized.jsp");
                return;
            }

            // User has proper access, continue
            chain.doFilter(request, response);
        } else {
            // User is not logged in, redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }

    @Override
    public void destroy() {
        // Cleanup code
    }
}
