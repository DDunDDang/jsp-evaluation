package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DatabaseUtil {
    public static Connection getConnection() {
        try {
            String dbURL = "jdbc:mysql://localhost:3306/LectureEvaluation?useSSL=false";
            Properties jdbcProperties = new Properties();
            jdbcProperties.setProperty("user", "user");
            jdbcProperties.setProperty("password", "12345678");
            Class.forName("com.mysql.jdbc.Driver");
            return DriverManager.getConnection(dbURL, jdbcProperties);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
