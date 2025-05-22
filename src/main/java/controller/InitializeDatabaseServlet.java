package controller;

import util.DatabaseInitializer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/initialize-database")
public class InitializeDatabaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Database Initialization</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println("h1 { color: #333; }");
        out.println(".success { color: green; }");
        out.println(".error { color: red; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");

        out.println("<h1>Database Initialization</h1>");

        try {
            // Initialize the database
            DatabaseInitializer.initializeDatabase();

            out.println("<p class='success'>Database initialized successfully!</p>");
            out.println("<p>You can now <a href='login'>login</a> to the system.</p>");

        } catch (Exception e) {
            out.println("<p class='error'>Error initializing database: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }

        out.println("</body>");
        out.println("</html>");
    }
}
