package com.urlshortener.dto;

import jakarta.validation.constraints.*;

/**
 * DTO for user registration form.
 * Server-side validation via Jakarta Bean Validation annotations.
 */
public class RegisterForm {

    @NotBlank(message = "Full name is required")
    @Size(min = 2, max = 100, message = "Name must be 2–100 characters")
    private String fullName;

    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 50, message = "Username must be 3–50 characters")
    @Pattern(
        regexp = "^[a-zA-Z0-9_]+$",
        message = "Username can only contain letters, numbers, and underscores"
    )
    private String username;

    @NotBlank(message = "Email is required")
    @Email(message = "Please enter a valid email address")
    private String email;

    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password must be at least 6 characters")
    private String password;

    @NotBlank(message = "Please confirm your password")
    private String confirmPassword;

    // ── Constructors ─────────────────────────────────────────────────────────
    public RegisterForm() {}

    // ── Getters & Setters ─────────────────────────────────────────────────────
    public String getFullName()                   { return fullName; }
    public void setFullName(String fullName)       { this.fullName = fullName; }

    public String getUsername()                   { return username; }
    public void setUsername(String username)       { this.username = username; }

    public String getEmail()                      { return email; }
    public void setEmail(String email)             { this.email = email; }

    public String getPassword()                   { return password; }
    public void setPassword(String password)       { this.password = password; }

    public String getConfirmPassword()             { return confirmPassword; }
    public void setConfirmPassword(String c)       { this.confirmPassword = c; }
}
