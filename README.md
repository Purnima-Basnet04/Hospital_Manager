# LifeCare Medical Center

A hospital management system built with Java EE (Jakarta EE) that allows patients to book appointments with doctors, and doctors to manage their appointments.

## Features

- User authentication and role-based access control
- Patient registration
- Appointment booking and management
- Department and doctor listings
- Service information

## Technologies Used

- Jakarta EE 10
- Tomcat 11
- MySQL 8
- JSP and JSTL
- HTML, CSS, JavaScript

## Setup Instructions

### Prerequisites

- JDK 17 or higher
- Apache Tomcat 11
- MySQL 8.0 or higher
- Maven (optional)

### Database Setup

1. Create a MySQL database named `lifecare_db`
2. Run the SQL script in `src/main/resources/database_setup.sql` to create the necessary tables and sample data

```bash
mysql -u root -p < src/main/resources/database_setup.sql
```

### Configuration

1. Update the database connection settings in `src/main/java/util/DatabaseConnection.java` if needed:

```java
private static final String URL = "jdbc:mysql://localhost:3306/lifecare_db";
private static final String USER = "root";
private static final String PASSWORD = "your_password";
```

### Deployment

1. Build the project using Maven:

```bash
mvn clean package
```

2. Deploy the generated WAR file to Tomcat:
   - Copy the `target/hospital.war` file to Tomcat's `webapps` directory
   - Start Tomcat

3. Access the application at `http://localhost:8080/hospital`

## Default Users

### Admin
- Username: admin
- Password: admin123

### Doctors
- Username: drsmith
- Password: doctor123

- Username: drjohnson
- Password: doctor123

### Patients
- Username: johndoe
- Password: patient123

- Username: janesmith
- Password: patient123

## Project Structure

- `src/main/java/controller/` - Servlet controllers
- `src/main/java/model/` - Model classes
- `src/main/java/dao/` - Data Access Objects
- `src/main/java/util/` - Utility classes
- `src/main/java/filter/` - Filters for authentication and authorization
- `src/main/webapp/` - JSP pages, CSS, JavaScript, and other web resources
- `src/main/resources/` - Configuration files and SQL scripts

## License

This project is licensed under the MIT License - see the LICENSE file for details.
