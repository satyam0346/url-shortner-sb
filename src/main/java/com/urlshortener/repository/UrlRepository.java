package com.urlshortener.repository;

import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public class UrlRepository {
    private final JdbcTemplate jdbcTemplate;
    
}
