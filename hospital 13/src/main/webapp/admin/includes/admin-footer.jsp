<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="admin-footer">
    <div class="container">
        <div class="footer-content">
            <div class="footer-section about">
                <h3>LifeCare Medical Center</h3>
                <p>Providing quality healthcare services with state-of-the-art facilities.</p>
            </div>
            
            <div class="footer-section links">
                <h3>Quick Links</h3>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/departments">Departments</a></li>
                    <li><a href="${pageContext.request.contextPath}/services">Services</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                </ul>
            </div>
            
            <div class="footer-section contact">
                <h3>Contact Us</h3>
                <p><i class="fas fa-map-marker-alt"></i> 123 Medical Center Drive, City, Country</p>
                <p><i class="fas fa-phone"></i> +1 (555) 123-4567</p>
                <p><i class="fas fa-envelope"></i> info@lifecaremedical.com</p>
            </div>
        </div>
        
        <div class="footer-bottom">
            <p>&copy; <%= new java.util.Date().getYear() + 1900 %> LifeCare Medical Center. All rights reserved.</p>
        </div>
    </div>
</footer>

<style>
    .admin-footer {
        background-color: #333;
        color: #fff;
        padding: 40px 0 20px;
        margin-top: 50px;
    }
    
    .admin-footer .footer-content {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
    }
    
    .admin-footer .footer-section {
        flex: 1;
        min-width: 250px;
        margin-bottom: 20px;
        padding-right: 20px;
    }
    
    .admin-footer h3 {
        color: #fff;
        margin-bottom: 15px;
        font-size: 18px;
    }
    
    .admin-footer p {
        margin-bottom: 10px;
        color: #ccc;
    }
    
    .admin-footer ul {
        list-style: none;
    }
    
    .admin-footer ul li {
        margin-bottom: 8px;
    }
    
    .admin-footer ul li a {
        color: #ccc;
        transition: color 0.3s;
    }
    
    .admin-footer ul li a:hover {
        color: #fff;
    }
    
    .admin-footer .footer-bottom {
        text-align: center;
        padding-top: 20px;
        margin-top: 20px;
        border-top: 1px solid #444;
        color: #999;
    }
    
    .admin-footer i {
        margin-right: 8px;
        color: #0066cc;
    }
</style>
