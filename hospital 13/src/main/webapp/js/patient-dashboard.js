/**
 * Patient Dashboard JavaScript
 * This file contains all the JavaScript functionality for the patient dashboard
 */

// Execute when DOM is fully loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('Patient dashboard script loaded');
    
    // Initialize user menu dropdown
    initUserMenu();
    
    // Set active menu item
    setActiveMenuItem();
    
    // Ensure dashboard is visible
    ensureDashboardVisible();
});

// Execute when window is fully loaded (including all resources)
window.addEventListener('load', function() {
    console.log('Window fully loaded, ensuring dashboard visibility');
    ensureDashboardVisible();
    
    // Refresh stats with animation
    refreshStats();
});

/**
 * Initialize the user menu dropdown functionality
 */
function initUserMenu() {
    const userMenuToggle = document.querySelector('.user-menu-toggle');
    const userMenuDropdown = document.querySelector('.user-menu-dropdown');
    
    if (!userMenuToggle || !userMenuDropdown) {
        console.warn('User menu elements not found');
        return;
    }

    userMenuToggle.addEventListener('click', function() {
        userMenuDropdown.style.display = userMenuDropdown.style.display === 'block' ? 'none' : 'block';
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function(event) {
        if (!event.target.closest('.user-menu')) {
            userMenuDropdown.style.display = 'none';
        }
    });
}

/**
 * Set the active menu item based on the current URL
 */
function setActiveMenuItem() {
    const currentPath = window.location.pathname;
    console.log('Current path:', currentPath);
    
    try {
        // Remove active class from all menu items
        const menuItems = document.querySelectorAll('.sidebar-menu li a');
        if (!menuItems || menuItems.length === 0) {
            console.warn('Sidebar menu items not found');
            return;
        }
        
        menuItems.forEach(function(link) {
            link.classList.remove('active');
        });
        
        // Add active class to the current page's menu item
        let activeSet = false;
        
        if (currentPath.includes('/patient/dashboard')) {
            const dashboardLink = document.querySelector('.sidebar-menu li a[href*="/patient/dashboard"]');
            if (dashboardLink) {
                dashboardLink.classList.add('active');
                activeSet = true;
            }
        } else if (currentPath.includes('/patient/appointments')) {
            const appointmentsLink = document.querySelector('.sidebar-menu li a[href*="/patient/appointments"]');
            if (appointmentsLink) {
                appointmentsLink.classList.add('active');
                activeSet = true;
            }
        } else if (currentPath.includes('/patient/book-appointment')) {
            const bookAppointmentLink = document.querySelector('.sidebar-menu li a[href*="/patient/book-appointment"]');
            if (bookAppointmentLink) {
                bookAppointmentLink.classList.add('active');
                activeSet = true;
            }
        } else if (currentPath.includes('/patient/find-doctor')) {
            const findDoctorLink = document.querySelector('.sidebar-menu li a[href*="/patient/find-doctor"]');
            if (findDoctorLink) {
                findDoctorLink.classList.add('active');
                activeSet = true;
            }
        } else if (currentPath.includes('/patient/medical-records')) {
            const medicalRecordsLink = document.querySelector('.sidebar-menu li a[href*="/patient/medical-records"]');
            if (medicalRecordsLink) {
                medicalRecordsLink.classList.add('active');
                activeSet = true;
            }
        } else if (currentPath.includes('/patient/prescriptions')) {
            const prescriptionsLink = document.querySelector('.sidebar-menu li a[href*="/patient/prescriptions"]');
            if (prescriptionsLink) {
                prescriptionsLink.classList.add('active');
                activeSet = true;
            }
        } else if (currentPath.includes('/patient/billing')) {
            const billingLink = document.querySelector('.sidebar-menu li a[href*="/patient/billing"]');
            if (billingLink) {
                billingLink.classList.add('active');
                activeSet = true;
            }
        } else if (currentPath.includes('/patient/profile')) {
            const profileLink = document.querySelector('.sidebar-menu li a[href*="/patient/profile"]');
            if (profileLink) {
                profileLink.classList.add('active');
                activeSet = true;
            }
        } else if (currentPath.includes('/patient/settings')) {
            const settingsLink = document.querySelector('.sidebar-menu li a[href*="/patient/settings"]');
            if (settingsLink) {
                settingsLink.classList.add('active');
                activeSet = true;
            }
        }
        
        // If no menu item was set as active, default to dashboard
        if (!activeSet) {
            const dashboardLink = document.querySelector('.sidebar-menu li a[href*="/patient/dashboard"]');
            if (dashboardLink) {
                dashboardLink.classList.add('active');
            }
        }
    } catch (error) {
        console.error('Error setting active menu item:', error);
        // Force dashboard to be active as fallback
        try {
            const dashboardLink = document.querySelector('.sidebar-menu li a[href*="/patient/dashboard"]');
            if (dashboardLink) {
                dashboardLink.classList.add('active');
            }
        } catch (e) {
            console.error('Failed to set dashboard as active:', e);
        }
    }
}

/**
 * Ensure the dashboard is visible
 */
function ensureDashboardVisible() {
    try {
        // Make sure the main content is visible
        const mainContent = document.querySelector('.main-content');
        if (mainContent) {
            mainContent.style.display = 'block';
            mainContent.style.opacity = '1';
            mainContent.style.visibility = 'visible';
        }
        
        // Make sure the dashboard container is visible
        const dashboardContainer = document.querySelector('.dashboard-container');
        if (dashboardContainer) {
            dashboardContainer.style.display = 'flex';
            dashboardContainer.style.opacity = '1';
            dashboardContainer.style.visibility = 'visible';
        }
        
        // Make sure the sidebar is visible
        const sidebar = document.querySelector('.sidebar');
        if (sidebar) {
            sidebar.style.display = 'block';
            sidebar.style.opacity = '1';
            sidebar.style.visibility = 'visible';
        }
        
        // Force dashboard link to be active
        const dashboardLink = document.querySelector('.sidebar-menu li a[href*="/patient/dashboard"]');
        if (dashboardLink) {
            dashboardLink.classList.add('active');
        }
        
        console.log('Dashboard visibility ensured');
    } catch (error) {
        console.error('Error ensuring dashboard visibility:', error);
    }
}

/**
 * Refresh stats with a subtle animation
 */
function refreshStats() {
    try {
        const statCards = document.querySelectorAll('.stat-card');
        if (!statCards || statCards.length === 0) {
            console.warn('Stat cards not found');
            return;
        }
        
        statCards.forEach(function(card, index) {
            // Add a slight delay for each card for a cascade effect
            setTimeout(function() {
                card.style.opacity = '0';
                setTimeout(function() {
                    card.style.opacity = '1';
                }, 100);
            }, index * 50);
        });
        
        console.log('Stats refreshed with animation');
    } catch (error) {
        console.error('Error refreshing stats:', error);
    }
}
