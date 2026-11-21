package com.urlshortener.repository;

import com.urlshortener.model.Url;
import com.urlshortener.model.UrlClick;
import com.urlshortener.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * UrlRepository — Spring Data JPA / Hibernate ORM repository.
 * Demonstrates CRUD operations and custom JPQL queries.
 */
@Repository
public interface UrlRepository extends JpaRepository<Url, Long> {

    Optional<Url> findByShortCode(String shortCode);

    Optional<Url> findByCustomAlias(String customAlias);

    List<Url> findByUserOrderByCreatedAtDesc(User user);

    boolean existsByShortCode(String shortCode);

    boolean existsByCustomAlias(String customAlias);

    /** Finds a URL by either its short code or custom alias */
    @Query("SELECT u FROM Url u WHERE u.shortCode = :code OR u.customAlias = :code")
    Optional<Url> findByCode(@Param("code") String code);

    /** Count URLs created by a specific user */
    @Query("SELECT COUNT(u) FROM Url u WHERE u.user = :user")
    long countByUser(@Param("user") User user);

    /** Count total clicks across all URLs for a user */
    @Query("SELECT COUNT(c) FROM UrlClick c WHERE c.url.user = :user")
    long countClicksByUser(@Param("user") User user);
}
