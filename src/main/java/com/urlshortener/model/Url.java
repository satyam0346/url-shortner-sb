package com.urlshortener.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Url entity mapped to the "urls" table via Hibernate ORM.
 * Demonstrates @ManyToOne / @OneToMany relationships.
 */
@Entity
@Table(name = "urls")
public class Url {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Original URL is required")
    @Pattern(
        regexp = "^(https?://).+",
        message = "URL must start with http:// or https://"
    )
    @Column(name = "original_url", nullable = false, length = 2048)
    private String originalUrl;

    @Column(name = "short_code", nullable = false, unique = true, length = 10)
    private String shortCode;

    @Column(name = "custom_alias", length = 50)
    private String customAlias;

    @Column(name = "title", length = 255)
    private String title;

    @Column(name = "is_active", nullable = false)
    private boolean active = true;

    @Column(name = "expiry_date")
    private LocalDateTime expiryDate;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @OneToMany(mappedBy = "url", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<UrlClick> clicks;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    /** Returns the effective short code (custom alias takes priority) */
    @Transient
    public String getEffectiveCode() {
        return (customAlias != null && !customAlias.isBlank()) ? customAlias : shortCode;
    }

    // ── Constructors ─────────────────────────────────────────────────────────
    public Url() {}

    // ── Getters ───────────────────────────────────────────────────────────────
    public Long getId()                  { return id; }
    public String getOriginalUrl()       { return originalUrl; }
    public String getShortCode()         { return shortCode; }
    public String getCustomAlias()       { return customAlias; }
    public String getTitle()             { return title; }
    public boolean isActive()            { return active; }
    public LocalDateTime getExpiryDate() { return expiryDate; }
    public LocalDateTime getCreatedAt()  { return createdAt; }
    public User getUser()                { return user; }
    public List<UrlClick> getClicks()    { return clicks; }

    @Transient
    public String getFormattedCreatedAt() {
        return createdAt != null ? createdAt.format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy")) : "";
    }

    // ── Setters ───────────────────────────────────────────────────────────────
    public void setId(Long id)                       { this.id = id; }
    public void setOriginalUrl(String originalUrl)   { this.originalUrl = originalUrl; }
    public void setShortCode(String shortCode)       { this.shortCode = shortCode; }
    public void setCustomAlias(String customAlias)   { this.customAlias = customAlias; }
    public void setTitle(String title)               { this.title = title; }
    public void setActive(boolean active)            { this.active = active; }
    public void setExpiryDate(LocalDateTime expiryDate) { this.expiryDate = expiryDate; }
    public void setCreatedAt(LocalDateTime createdAt){ this.createdAt = createdAt; }
    public void setUser(User user)                   { this.user = user; }
    public void setClicks(List<UrlClick> clicks)     { this.clicks = clicks; }
}
