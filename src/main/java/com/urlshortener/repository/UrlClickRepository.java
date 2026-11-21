package com.urlshortener.repository;

import com.urlshortener.model.Url;
import com.urlshortener.model.UrlClick;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * UrlClickRepository — Hibernate ORM-backed repository for click analytics.
 */
@Repository
public interface UrlClickRepository extends JpaRepository<UrlClick, Long> {

    List<UrlClick> findByUrlOrderByClickedAtDesc(Url url);

    long countByUrl(Url url);

    /** Recent clicks across all URLs for a given user */
    @Query("SELECT c FROM UrlClick c WHERE c.url.user.id = :userId ORDER BY c.clickedAt DESC")
    List<UrlClick> findRecentClicksByUserId(@Param("userId") Long userId);
}
