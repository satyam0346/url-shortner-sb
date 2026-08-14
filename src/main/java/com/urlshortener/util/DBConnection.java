package com.urlshortener.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    
    static String url = "jdbc:postgresql://localhost:5432/url_shortner";
    static String username = "postgres";
    static String password = "satyam0346";
    
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }
   
    
    
}

