package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/generate-department-images")
public class GenerateDepartmentImagesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final Map<String, String> DEPARTMENT_IMAGES = new HashMap<>();
    
    static {
        // Initialize with image URLs
        DEPARTMENT_IMAGES.put("cardiology.jpg", "https://images.unsplash.com/photo-1576091160550-2173dba999ef?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80");
        DEPARTMENT_IMAGES.put("neurology.jpg", "https://images.unsplash.com/photo-1559757175-5700dde675bc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80");
        DEPARTMENT_IMAGES.put("pediatrics.jpg", "https://images.unsplash.com/photo-1535131749006-b7f58c99034b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80");
        DEPARTMENT_IMAGES.put("orthopedics.jpg", "https://images.unsplash.com/photo-1579684385127-1ef15d508118?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80");
        DEPARTMENT_IMAGES.put("dermatology.jpg", "https://images.unsplash.com/photo-1576671414121-aa2d0967c60d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80");
        DEPARTMENT_IMAGES.put("ophthalmology.jpg", "https://images.unsplash.com/photo-1551884831-bbf3cdc6469e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80");
        // Default image for any other departments
        DEPARTMENT_IMAGES.put("default-department.jpg", "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80");
    }
    
    @Override
    public void init() throws ServletException {
        super.init();
        // Generate images when the servlet is initialized
        try {
            generateImages();
        } catch (IOException e) {
            throw new ServletException("Failed to generate department images", e);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Generate images and show results
        generateImages();
        
        response.setContentType("text/html");
        response.getWriter().println("<!DOCTYPE html>");
        response.getWriter().println("<html>");
        response.getWriter().println("<head>");
        response.getWriter().println("<title>Department Images Generated</title>");
        response.getWriter().println("<style>");
        response.getWriter().println("body { font-family: Arial, sans-serif; line-height: 1.6; margin: 0; padding: 20px; }");
        response.getWriter().println(".container { max-width: 800px; margin: 0 auto; background-color: #f9f9f9; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        response.getWriter().println("h1 { color: #0066cc; }");
        response.getWriter().println("p { margin-bottom: 20px; }");
        response.getWriter().println(".btn { display: inline-block; background-color: #0066cc; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px; }");
        response.getWriter().println(".image-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; margin-top: 30px; }");
        response.getWriter().println(".image-item { border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }");
        response.getWriter().println(".image-item img { width: 100%; height: 150px; object-fit: cover; }");
        response.getWriter().println(".image-item p { padding: 10px; margin: 0; text-align: center; font-weight: bold; }");
        response.getWriter().println("</style>");
        response.getWriter().println("</head>");
        response.getWriter().println("<body>");
        response.getWriter().println("<div class='container'>");
        response.getWriter().println("<h1>Department Images Generated</h1>");
        response.getWriter().println("<p>All department images have been generated successfully. You can now view them on the departments page.</p>");
        response.getWriter().println("<a href='Department.jsp' class='btn'>Go to Departments Page</a>");
        
        response.getWriter().println("<div class='image-grid'>");
        for (String fileName : DEPARTMENT_IMAGES.keySet()) {
            response.getWriter().println("<div class='image-item'>");
            response.getWriter().println("<img src='images/departments/" + fileName + "' alt='" + fileName + "'>");
            response.getWriter().println("<p>" + fileName + "</p>");
            response.getWriter().println("</div>");
        }
        response.getWriter().println("</div>");
        
        response.getWriter().println("</div>");
        response.getWriter().println("</body>");
        response.getWriter().println("</html>");
    }
    
    private void generateImages() throws IOException {
        // Get the real path to the images directory
        String imagesPath = getServletContext().getRealPath("/images/departments");
        Path dirPath = Paths.get(imagesPath);
        
        // Create directory if it doesn't exist
        if (!Files.exists(dirPath)) {
            Files.createDirectories(dirPath);
        }
        
        for (Map.Entry<String, String> entry : DEPARTMENT_IMAGES.entrySet()) {
            String fileName = entry.getKey();
            String imageUrl = entry.getValue();
            Path filePath = Paths.get(imagesPath, fileName);
            
            try {
                URL url = new URL(imageUrl);
                URLConnection connection = url.openConnection();
                connection.setRequestProperty("User-Agent", "Mozilla/5.0");
                
                try (InputStream in = connection.getInputStream()) {
                    Files.copy(in, filePath, StandardCopyOption.REPLACE_EXISTING);
                }
                
                System.out.println("Generated image: " + fileName);
            } catch (Exception e) {
                System.err.println("Error generating image " + fileName + ": " + e.getMessage());
            }
        }
    }
}
