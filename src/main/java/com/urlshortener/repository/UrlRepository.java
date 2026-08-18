package com.urlshortener.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.urlshortener.model.Url;
import com.urlshortener.util.DBConnection;

public class UrlRepository {
    public void saveUrl(Url url){
        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO Urls (original_url, short_code) VALUES (?,?)";

            PreparedStatement ps = con.prepareStatement(sql);

            /* url.getOriginalUrl(). ----> it is a method that gives us the original url from the url object */
            ps.setString(1, url.getOriginalUrl());
            ps.setString(2, url.getShortCode());

            int i = ps.executeUpdate();


        } catch (Exception e) {
            e.printStackTrace();
        }

    }
        
    
}
