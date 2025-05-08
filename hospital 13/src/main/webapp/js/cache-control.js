// Cache control script
document.addEventListener('DOMContentLoaded', function() {
    // Force reload if page was loaded from cache
    if (performance.navigation.type === 2) {
        console.log('Reloading page to ensure fresh content');
        location.reload(true);
    }

    // Add timestamp to all internal links to prevent caching
    const links = document.querySelectorAll('a[href^="index.jsp"], a[href^="departments"], a[href^="Service.jsp"], a[href^="appointments.jsp"], a[href^="AboutUs.jsp"], a[href^="ContactUs.jsp"], a[href^="Login.jsp"], a[href^="Register.jsp"], a[href^="doctor-dashboard-redirect.html"]');

    links.forEach(function(link) {
        const href = link.getAttribute('href');
        const timestamp = new Date().getTime();

        if (href.indexOf('?') === -1) {
            link.setAttribute('href', href + '?t=' + timestamp);
        } else {
            link.setAttribute('href', href + '&t=' + timestamp);
        }
    });
});
