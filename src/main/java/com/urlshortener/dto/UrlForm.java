package com.urlshortener.dto;

import jakarta.validation.constraints.*;

/**
 * DTO for URL creation / editing form.
 * Server-side validation via Jakarta Bean Validation annotations.
 */
public class UrlForm {

    @NotBlank(message = "Original URL is required")
    @Pattern(
        regexp = "^(https?://).+",
        message = "URL must start with http:// or https://"
    )
    private String originalUrl;

    @Size(max = 50, message = "Custom alias must be at most 50 characters")
    @Pattern(
        regexp = "^[a-zA-Z0-9_-]*$",
        message = "Alias can only contain letters, numbers, hyphens, and underscores"
    )
    private String customAlias;

    @Size(max = 255, message = "Title must be at most 255 characters")
    private String title;

    // ── Constructors ─────────────────────────────────────────────────────────
    public UrlForm() {}

    public UrlForm(String originalUrl, String customAlias, String title) {
        this.originalUrl = originalUrl;
        this.customAlias = customAlias;
        this.title = title;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────
    public String getOriginalUrl()               { return originalUrl; }
    public void setOriginalUrl(String originalUrl){ this.originalUrl = originalUrl; }

    public String getCustomAlias()               { return customAlias; }
    public void setCustomAlias(String customAlias){ this.customAlias = customAlias; }

    public String getTitle()                     { return title; }
    public void setTitle(String title)           { this.title = title; }
}
