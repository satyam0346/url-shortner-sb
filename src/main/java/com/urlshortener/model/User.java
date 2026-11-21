package com.urlshortener.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.time.LocalDateTime;
import java.util.List;

/**
 * User entity mapped to the "users" table via Hibernate ORM.
 * Demonstrates Spring Dependency Injection + Hibernate @Entity annotations.
 */
@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Full name is required")
    @Size(min = 2, max = 100, message = "Name must be between 2 and 100 characters")
    @Column(name = "full_name", nullable = false)
    private String fullName;

    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 50, message = "Username must be between 3 and 50 characters")
    @Column(name = "username", nullable = false, unique = true)
    private String username;

    @NotBlank(message = "Email is required")
    @Email(message = "Please enter a valid email address")
    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password must be at least 6 characters")
    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "role", nullable = false)
    private String role = "ROLE_USER";

    @Column(name = "enabled", nullable = false)
    private boolean enabled = true;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Url> urls;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    // ── Constructors ─────────────────────────────────────────────────────────
    public User() {}

    public User(Long id, String fullName, String username, String email,
                String password, String role, boolean enabled, LocalDateTime createdAt) {
        this.id = id;
        this.fullName = fullName;
        this.username = username;
        this.email = email;
        this.password = password;
        this.role = role;
        this.enabled = enabled;
        this.createdAt = createdAt;
    }

    // ── Getters ───────────────────────────────────────────────────────────────
    public Long getId()                { return id; }
    public String getFullName()        { return fullName; }
    public String getUsername()        { return username; }
    public String getEmail()           { return email; }
    public String getPassword()        { return password; }
    public String getRole()            { return role; }
    public boolean isEnabled()         { return enabled; }
    public LocalDateTime getCreatedAt(){ return createdAt; }
    public List<Url> getUrls()         { return urls; }

    @Transient
    public String getFormattedCreatedAt() {
        return createdAt != null ? createdAt.format(java.time.format.DateTimeFormatter.ofPattern("MMM yyyy")) : "";
    }

    // ── Setters ───────────────────────────────────────────────────────────────
    public void setId(Long id)                   { this.id = id; }
    public void setFullName(String fullName)      { this.fullName = fullName; }
    public void setUsername(String username)      { this.username = username; }
    public void setEmail(String email)            { this.email = email; }
    public void setPassword(String password)      { this.password = password; }
    public void setRole(String role)              { this.role = role; }
    public void setEnabled(boolean enabled)       { this.enabled = enabled; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public void setUrls(List<Url> urls)           { this.urls = urls; }
}
