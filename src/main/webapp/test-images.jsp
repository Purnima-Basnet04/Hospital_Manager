<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Department Images</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
        }
        .image-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .image-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .image-container {
            height: 200px;
            overflow: hidden;
        }
        .image-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .image-info {
            padding: 15px;
        }
        .image-info h3 {
            margin-top: 0;
            margin-bottom: 10px;
        }
        .image-info p {
            margin: 0;
            color: #666;
        }
    </style>
</head>
<body>
    <h1>Test Department Images</h1>
    
    <div class="image-grid">
        <div class="image-card">
            <div class="image-container">
                <img src="<%= request.getContextPath() %>/images/departments/cardiology.jpg" alt="Cardiology" 
                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/departments/default-department.jpg';">
            </div>
            <div class="image-info">
                <h3>Cardiology</h3>
                <p>Path: /images/departments/cardiology.jpg</p>
            </div>
        </div>
        
        <div class="image-card">
            <div class="image-container">
                <img src="<%= request.getContextPath() %>/images/departments/neurology.jpg" alt="Neurology"
                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/departments/default-department.jpg';">
            </div>
            <div class="image-info">
                <h3>Neurology</h3>
                <p>Path: /images/departments/neurology.jpg</p>
            </div>
        </div>
        
        <div class="image-card">
            <div class="image-container">
                <img src="<%= request.getContextPath() %>/images/departments/pediatrics.jpg" alt="Pediatrics"
                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/departments/default-department.jpg';">
            </div>
            <div class="image-info">
                <h3>Pediatrics</h3>
                <p>Path: /images/departments/pediatrics.jpg</p>
            </div>
        </div>
        
        <div class="image-card">
            <div class="image-container">
                <img src="<%= request.getContextPath() %>/images/departments/orthopedics.jpg" alt="Orthopedics"
                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/departments/default-department.jpg';">
            </div>
            <div class="image-info">
                <h3>Orthopedics</h3>
                <p>Path: /images/departments/orthopedics.jpg</p>
            </div>
        </div>
        
        <div class="image-card">
            <div class="image-container">
                <img src="<%= request.getContextPath() %>/images/departments/dermatology.jpg" alt="Dermatology"
                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/departments/default-department.jpg';">
            </div>
            <div class="image-info">
                <h3>Dermatology</h3>
                <p>Path: /images/departments/dermatology.jpg</p>
            </div>
        </div>
        
        <div class="image-card">
            <div class="image-container">
                <img src="<%= request.getContextPath() %>/images/departments/ophthalmology.jpg" alt="Ophthalmology"
                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/departments/default-department.jpg';">
            </div>
            <div class="image-info">
                <h3>Ophthalmology</h3>
                <p>Path: /images/departments/ophthalmology.jpg</p>
            </div>
        </div>
        
        <div class="image-card">
            <div class="image-container">
                <img src="<%= request.getContextPath() %>/images/departments/oncology.jpg" alt="Oncology"
                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/departments/default-department.jpg';">
            </div>
            <div class="image-info">
                <h3>Oncology</h3>
                <p>Path: /images/departments/oncology.jpg</p>
            </div>
        </div>
        
        <div class="image-card">
            <div class="image-container">
                <img src="<%= request.getContextPath() %>/images/departments/gynecology.jpg" alt="Gynecology"
                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/departments/default-department.jpg';">
            </div>
            <div class="image-info">
                <h3>Gynecology</h3>
                <p>Path: /images/departments/gynecology.jpg</p>
            </div>
        </div>
        
        <div class="image-card">
            <div class="image-container">
                <img src="<%= request.getContextPath() %>/images/departments/default-department.jpg" alt="Default Department">
            </div>
            <div class="image-info">
                <h3>Default Department</h3>
                <p>Path: /images/departments/default-department.jpg</p>
            </div>
        </div>
    </div>
</body>
</html>
