package com.urlshortener.model;

import java.time.LocalDateTime;

//creating the class for storing the data

public class Url{
   private int id;
    private String originalUrl;
    private String shortCode;
    private LocalDateTime createdAt;

    //getter
    public int getId(){
        return id;
    }

    public String getOriginalUrl(){
        return originalUrl;
    }

    public String getShortCode(){
        return shortCode;
    }

    public LocalDateTime getCreatedAt(){
        return createdAt;
    }

    //Setter
    public void setId(int id){
        this.id = id;
    }
    
    public void setOriginalUrl(String originalUrl){
        this.originalUrl = originalUrl;
    }
    
    public void setShortCode(String shortCode){
        this.shortCode = shortCode;
    }

    public void setCreatedAt(LocalDateTime date){
        this.createdAt = date;
    }
    public Url(){}

    public Url(int id, String originalUrl, String shortCode, LocalDateTime createdAt) {
    this.id = id;
    this.originalUrl = originalUrl;
    this.shortCode = shortCode;
    this.createdAt = createdAt;
}
}



