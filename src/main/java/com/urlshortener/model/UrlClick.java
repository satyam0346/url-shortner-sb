package com.urlshortener.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * UrlClick entity — tracks every redirect/click event for analytics.
 * Mapped to "url_clicks" table via Hibernate ORM.
 */
@Entity
@Table(name = "url_clicks")
public class UrlClick {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "url_id", nullable = false)
    private Url url;

    @Column(name = "clicked_at", nullable = false)
    private LocalDateTime clickedAt;

    @Column(name = "ip_address", length = 50)
    private String ipAddress;

    @Column(name = "user_agent", length = 512)
    private String userAgent;

    @Column(name = "referer", length = 512)
    private String referer;

    @PrePersist
    protected void onCreate() {
        this.clickedAt = LocalDateTime.now();
    }

    // ── Constructors ─────────────────────────────────────────────────────────
    public UrlClick() {}

    public UrlClick(Url url, String ipAddress, String userAgent, String referer) {
        this.url = url;
        this.ipAddress = ipAddress;
        this.userAgent = userAgent;
        this.referer = referer;
    }

    // ── Getters ───────────────────────────────────────────────────────────────
    public Long getId()                  { return id; }
    public Url getUrl()                  { return url; }
    public LocalDateTime getClickedAt()  { return clickedAt; }
    public String getIpAddress()         { return ipAddress; }
    public String getUserAgent()         { return userAgent; }
    public String getReferer()           { return referer; }

    @Transient
    public String getFormattedClickedAt() {
        return clickedAt != null ? clickedAt.format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm:ss")) : "";
    }

    // ── Setters ───────────────────────────────────────────────────────────────
    public void setId(Long id)                       { this.id = id; }
    public void setUrl(Url url)                      { this.url = url; }
    public void setClickedAt(LocalDateTime clickedAt){ this.clickedAt = clickedAt; }
    public void setIpAddress(String ipAddress)       { this.ipAddress = ipAddress; }
    public void setUserAgent(String userAgent)       { this.userAgent = userAgent; }
    public void setReferer(String referer)           { this.referer = referer; }
}
