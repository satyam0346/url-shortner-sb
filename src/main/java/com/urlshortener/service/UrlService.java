package com.urlshortener.service;

import com.urlshortener.dto.UrlForm;
import com.urlshortener.model.Url;
import com.urlshortener.model.UrlClick;
import com.urlshortener.model.User;
import com.urlshortener.repository.UrlClickRepository;
import com.urlshortener.repository.UrlRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * UrlService — demonstrates:
 *  - Spring Dependency Injection (@Service + @Autowired constructor injection)
 *  - Hibernate ORM operations via JPA repositories
 *  - Full CRUD: Create, Read, Update (toggle), Delete
 *  - Business logic: short-code generation, click tracking
 */
@Service
public class UrlService {

    // Spring DI: both injected via constructor by Spring container
    private final UrlRepository urlRepository;
    private final UrlClickRepository urlClickRepository;

    @Autowired
    public UrlService(UrlRepository urlRepository, UrlClickRepository urlClickRepository) {
        this.urlRepository = urlRepository;
        this.urlClickRepository = urlClickRepository;
    }

    private static final String CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    private static final int CODE_LENGTH = 7;
    private static final SecureRandom RANDOM = new SecureRandom();

    // ── CREATE ────────────────────────────────────────────────────────────────

    /**
     * Shortens a URL for the given user. Validates alias uniqueness.
     */
    @Transactional
    public Url shorten(UrlForm form, User user) {
        String alias = form.getCustomAlias();

        // Validate custom alias uniqueness (server-side business rule)
        if (alias != null && !alias.isBlank()) {
            if (urlRepository.existsByCustomAlias(alias)) {
                throw new IllegalArgumentException("Custom alias '" + alias + "' is already taken");
            }
        }

        String shortCode = generateUniqueCode();

        Url url = new Url();
        url.setOriginalUrl(form.getOriginalUrl());
        url.setShortCode(shortCode);
        url.setCustomAlias((alias != null && !alias.isBlank()) ? alias : null);
        url.setTitle(form.getTitle());
        url.setUser(user);
        url.setActive(true);

        return urlRepository.save(url);
    }

    // ── READ ─────────────────────────────────────────────────────────────────

    @Transactional(readOnly = true)
    public List<Url> getUrlsForUser(User user) {
        return urlRepository.findByUserOrderByCreatedAtDesc(user);
    }

    @Transactional(readOnly = true)
    public Optional<Url> findByCode(String code) {
        return urlRepository.findByCode(code);
    }

    @Transactional(readOnly = true)
    public Optional<Url> findById(Long id) {
        return urlRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public long countUrlsByUser(User user) {
        return urlRepository.countByUser(user);
    }

    @Transactional(readOnly = true)
    public long countClicksByUser(User user) {
        return urlRepository.countClicksByUser(user);
    }

    @Transactional(readOnly = true)
    public List<UrlClick> getClicksForUrl(Url url) {
        return urlClickRepository.findByUrlOrderByClickedAtDesc(url);
    }

    @Transactional(readOnly = true)
    public long countClicksForUrl(Url url) {
        return urlClickRepository.countByUrl(url);
    }

    // ── UPDATE ────────────────────────────────────────────────────────────────

    /**
     * Toggles the active status of a URL (enable/disable).
     */
    @Transactional
    public Url toggleActive(Long urlId, User owner) {
        Url url = getUrlOwnedBy(urlId, owner);
        url.setActive(!url.isActive());
        return urlRepository.save(url);
    }

    /**
     * Updates title and custom alias of an existing URL.
     */
    @Transactional
    public Url update(Long urlId, UrlForm form, User owner) {
        Url url = getUrlOwnedBy(urlId, owner);

        String newAlias = form.getCustomAlias();
        if (newAlias != null && !newAlias.isBlank()
                && !newAlias.equals(url.getCustomAlias())
                && urlRepository.existsByCustomAlias(newAlias)) {
            throw new IllegalArgumentException("Custom alias '" + newAlias + "' is already taken");
        }

        url.setTitle(form.getTitle());
        url.setCustomAlias((newAlias != null && !newAlias.isBlank()) ? newAlias : null);
        return urlRepository.save(url);
    }

    // ── DELETE ────────────────────────────────────────────────────────────────

    @Transactional
    public void delete(Long urlId, User owner) {
        Url url = getUrlOwnedBy(urlId, owner);
        urlRepository.delete(url);
    }

    // ── REDIRECT + CLICK TRACKING ─────────────────────────────────────────────

    /**
     * Records a click event when a short URL is visited.
     */
    @Transactional
    public String resolveAndTrack(String code, HttpServletRequest request) {
        Url url = urlRepository.findByCode(code)
            .orElseThrow(() -> new IllegalArgumentException("Short URL not found: " + code));

        if (!url.isActive()) {
            throw new IllegalStateException("This link has been disabled");
        }

        if (url.getExpiryDate() != null && LocalDateTime.now().isAfter(url.getExpiryDate())) {
            throw new IllegalStateException("This link has expired");
        }

        // Track the click (Hibernate ORM insert)
        UrlClick click = new UrlClick(url, getClientIp(request),
                                      request.getHeader("User-Agent"),
                                      request.getHeader("Referer"));
        urlClickRepository.save(click);

        return url.getOriginalUrl();
    }

    // ── HELPERS ───────────────────────────────────────────────────────────────

    private String generateUniqueCode() {
        String code;
        do {
            code = generateCode();
        } while (urlRepository.existsByShortCode(code));
        return code;
    }

    private String generateCode() {
        StringBuilder sb = new StringBuilder(CODE_LENGTH);
        for (int i = 0; i < CODE_LENGTH; i++) {
            sb.append(CHARS.charAt(RANDOM.nextInt(CHARS.length())));
        }
        return sb.toString();
    }

    private Url getUrlOwnedBy(Long urlId, User owner) {
        Url url = urlRepository.findById(urlId)
            .orElseThrow(() -> new IllegalArgumentException("URL not found with id: " + urlId));
        if (!url.getUser().getId().equals(owner.getId())) {
            throw new SecurityException("Access denied: you do not own this URL");
        }
        return url;
    }

    private String getClientIp(HttpServletRequest request) {
        String xff = request.getHeader("X-Forwarded-For");
        return (xff != null && !xff.isBlank()) ? xff.split(",")[0].trim() : request.getRemoteAddr();
    }
}
