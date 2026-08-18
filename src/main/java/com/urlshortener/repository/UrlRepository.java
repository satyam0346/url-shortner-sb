package com.urlshortener.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.urlshortener.util.DBConnection;

public class UrlRepository {
    public static void main(String[] args) {
        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO Urls (original_url, short_code) VALUES (?,?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString();

            int i = ps.executeUpdate();


        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
