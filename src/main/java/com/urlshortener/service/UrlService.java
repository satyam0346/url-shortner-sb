package com.urlshortener.service;

import com.urlshortener.repository.UrlRepository;

public class UrlService {
    
    /*
    By using the object references (OOPS) we can use the method of different class.
    eg: UrlRepository repository;

    here:
    UrlRepository ---> means reference type
    repository. ----> means reference variable

    then we can actually create the object to use: repository = new UrlRepository();

    also both can be used together :
    UrlRepository repository = new UrlRepository();

    */

    UrlRepository repository; //it create a variable capable of referring to a UrlRepository object.

    public UrlService(){
        repository = new UrlRepository();

    }

    public void shortenUrl(String originalUrl){
        repository.saveUrl();
    }
    

}
