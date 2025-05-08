package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class FileUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Directory to store uploaded files
    private static final String UPLOAD_DIRECTORY = "uploads";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Create the upload directory if it doesn't exist
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadPath = applicationPath + File.separator + UPLOAD_DIRECTORY;
            
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Get the file part from the request
            Part filePart = request.getPart("file");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            
            // Generate a unique file name to prevent overwriting
            String fileExtension = "";
            if (fileName.contains(".")) {
                fileExtension = fileName.substring(fileName.lastIndexOf("."));
            }
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            
            // Save the file to the server
            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);
            
            // Return the file path to the client
            String relativePath = request.getContextPath() + "/" + UPLOAD_DIRECTORY + "/" + uniqueFileName;
            
            // Log the file path
            System.out.println("File uploaded to: " + filePath);
            System.out.println("Relative path: " + relativePath);
            
            // Return JSON response
            out.println("{\"success\": true, \"filePath\": \"" + relativePath + "\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
