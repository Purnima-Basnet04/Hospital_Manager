document.addEventListener('DOMContentLoaded', function() {
    // Mobile menu toggle
    const mobileMenuBtn = document.querySelector('.mobile-menu-btn');
    const navLinks = document.querySelector('.nav-links');
    
    if (mobileMenuBtn) {
        mobileMenuBtn.addEventListener('click', function() {
            navLinks.classList.toggle('show');
        });
    }
    
    // Password confirmation validation
    const registerForm = document.querySelector('form[action="register"]');
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            const password = document.getElementById('password');
            const confirm = document.getElementById('confirm');
            
            if (password.value !== confirm.value) {
                e.preventDefault();
                alert('Passwords do not match!');
            }
        });
    }
    
    // Department doctor selection
    const departmentSelect = document.getElementById('departmentId');
    if (departmentSelect) {
        departmentSelect.addEventListener('change', function() {
            const departmentId = this.value;
            if (departmentId) {
                window.location.href = 'appointments?action=new&dept=' + departmentId;
            }
        });
    }
    
    // Date validation for appointment booking
    const appointmentForm = document.querySelector('form[action="appointments"]');
    if (appointmentForm) {
        appointmentForm.addEventListener('submit', function(e) {
            const appointmentDate = document.getElementById('appointmentDate');
            const selectedDate = new Date(appointmentDate.value);
            const today = new Date();
            
            // Reset hours, minutes, seconds, and milliseconds for comparison
            today.setHours(0, 0, 0, 0);
            
            if (selectedDate < today) {
                e.preventDefault();
                alert('Please select a future date for your appointment.');
            }
        });
    }
    
    // Alert auto-close
    const alerts = document.querySelectorAll('.alert');
    if (alerts.length > 0) {
        setTimeout(function() {
            alerts.forEach(function(alert) {
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.style.display = 'none';
                }, 500);
            });
        }, 5000);
    }
});