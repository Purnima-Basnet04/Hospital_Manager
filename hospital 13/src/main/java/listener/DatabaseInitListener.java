package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import util.DatabaseSetup;
import util.DatabaseInitializer;

/**
 * Application Lifecycle Listener implementation class DatabaseInitListener
 */
@WebListener
public class DatabaseInitListener implements ServletContextListener {

    /**
     * Default constructor.
     */
    public DatabaseInitListener() {
        // TODO Auto-generated constructor stub
    }

    /**
     * @see ServletContextListener#contextInitialized(ServletContextEvent)
     */
    public void contextInitialized(ServletContextEvent sce) {
        // Set up the database tables when the application starts
        DatabaseSetup.setupDoctorDepartmentsTable();

        // Initialize the database with tables and sample data
        DatabaseInitializer.initializeDatabase();
    }

    /**
     * @see ServletContextListener#contextDestroyed(ServletContextEvent)
     */
    public void contextDestroyed(ServletContextEvent sce) {
        // Do nothing
    }
}
