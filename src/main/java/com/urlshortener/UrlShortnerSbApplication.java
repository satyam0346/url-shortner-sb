package com.urlshortener;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Main Spring Boot application entry point.
 *
 * Extends SpringBootServletInitializer to support WAR deployment
 * (required for JSP pages to work inside the embedded Tomcat container).
 */
@SpringBootApplication
public class UrlShortnerSbApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(UrlShortnerSbApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(UrlShortnerSbApplication.class, args);
    }
}
