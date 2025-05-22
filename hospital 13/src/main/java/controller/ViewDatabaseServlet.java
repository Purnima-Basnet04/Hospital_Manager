package controller;

import util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.DatabaseMetaData;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/view-database")
public class ViewDatabaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Database Contents</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println("h1, h2 { color: #333; }");
        out.println("table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }");
        out.println("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
        out.println("th { background-color: #f2f2f2; }");
        out.println("tr:nth-child(even) { background-color: #f9f9f9; }");
        out.println(".table-container { margin-bottom: 30px; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        out.println("<h1>Database Contents</h1>");
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Get all table names
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet tables = metaData.getTables(null, null, "%", new String[] {"TABLE"});
            
            List<String> tableNames = new ArrayList<>();
            while (tables.next()) {
                tableNames.add(tables.getString("TABLE_NAME"));
            }
            
            // Display each table
            for (String tableName : tableNames) {
                out.println("<div class='table-container'>");
                out.println("<h2>Table: " + tableName + "</h2>");
                
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT * FROM " + tableName)) {
                    
                    ResultSetMetaData rsMetaData = rs.getMetaData();
                    int columnCount = rsMetaData.getColumnCount();
                    
                    out.println("<table>");
                    
                    // Table header
                    out.println("<tr>");
                    for (int i = 1; i <= columnCount; i++) {
                        out.println("<th>" + rsMetaData.getColumnName(i) + "</th>");
                    }
                    out.println("</tr>");
                    
                    // Table data
                    int rowCount = 0;
                    while (rs.next()) {
                        rowCount++;
                        out.println("<tr>");
                        for (int i = 1; i <= columnCount; i++) {
                            out.println("<td>" + (rs.getString(i) != null ? rs.getString(i) : "NULL") + "</td>");
                        }
                        out.println("</tr>");
                    }
                    
                    out.println("</table>");
                    out.println("<p>Total rows: " + rowCount + "</p>");
                } catch (Exception e) {
                    out.println("<p>Error displaying table " + tableName + ": " + e.getMessage() + "</p>");
                }
                
                out.println("</div>");
            }
            
        } catch (Exception e) {
            out.println("<h2>Error connecting to database</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        
        out.println("<p><a href='index.jsp'>Back to Home</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
}
