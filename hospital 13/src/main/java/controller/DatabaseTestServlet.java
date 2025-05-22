package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.DatabaseConnection;
import util.DatabaseInitializer;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

@WebServlet("/db-test")
public class DatabaseTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Database Test</title></head><body>");
        out.println("<h1>Database Connection Test</h1>");
        
        try {
            // Initialize the database
            out.println("<h2>Initializing Database</h2>");
            DatabaseInitializer.initializeDatabase();
            out.println("<p>Database initialization completed.</p>");
            
            // Test connection
            out.println("<h2>Testing Database Connection</h2>");
            Connection conn = DatabaseConnection.getConnection();
            out.println("<p>Database connection successful!</p>");
            
            // Test query
            out.println("<h2>Testing Query</h2>");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM departments");
            
            out.println("<h3>Departments:</h3>");
            out.println("<table border='1'>");
            out.println("<tr><th>ID</th><th>Name</th><th>Description</th><th>Building</th><th>Floor</th><th>Specialists</th></tr>");
            
            int count = 0;
            while (rs.next()) {
                count++;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getString("name") + "</td>");
                out.println("<td>" + rs.getString("description") + "</td>");
                out.println("<td>" + rs.getString("building") + "</td>");
                out.println("<td>" + rs.getInt("floor") + "</td>");
                out.println("<td>" + rs.getInt("specialists_count") + "</td>");
                out.println("</tr>");
            }
            
            out.println("</table>");
            out.println("<p>Total departments found: " + count + "</p>");
            
            rs.close();
            stmt.close();
            
        } catch (SQLException e) {
            out.println("<h2>Database Error</h2>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        } catch (Exception e) {
            out.println("<h2>General Error</h2>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
        
        out.println("</body></html>");
    }
}
