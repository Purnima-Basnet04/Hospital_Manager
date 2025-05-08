package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/lifecare_db?createDatabaseIfNotExist=true";
    private static final String USER = "root";
    private static final String PASSWORD = "oracle";

    static {
        System.out.println("DatabaseConnection: Static initializer called");
        System.out.println("DatabaseConnection: URL = " + URL);
        System.out.println("DatabaseConnection: USER = " + USER);
    }

    private static Connection connection = null;

    static {
        try {
            System.out.println("DatabaseConnection: Loading MySQL JDBC driver");
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("DatabaseConnection: MySQL JDBC driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.out.println("DatabaseConnection: Error loading MySQL JDBC driver: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            System.out.println("DatabaseConnection: Getting connection");
            if (connection == null || connection.isClosed()) {
                System.out.println("DatabaseConnection: Creating new connection");
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("DatabaseConnection: Connection created successfully");
            } else {
                System.out.println("DatabaseConnection: Reusing existing connection");
            }
            return connection;
        } catch (SQLException e) {
            System.out.println("DatabaseConnection: Error getting connection: " + e.getMessage());
            throw e;
        }
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}