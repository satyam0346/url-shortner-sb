package com.urlshortener.controller;

import com.urlshortener.dto.RegisterForm;
import com.urlshortener.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * AuthController — handles login, register views.
 *
 * Demonstrates:
 *  - Spring MVC @Controller with Spring DI (@Autowired)
 *  - Server-side form validation with BindingResult
 *  - Redirect-after-POST pattern (PRG)
 *  - Session handling via Spring Security
 */
@Controller
public class AuthController {

    private final UserService userService;

    @Autowired
    public AuthController(UserService userService) {
        this.userService = userService;
    }

    // ── HOME ─────────────────────────────────────────────────────────────────

    @GetMapping("/")
    public String home() {
        return "index";
    }

    // ── LOGIN ─────────────────────────────────────────────────────────────────

    @GetMapping("/login")
    public String loginPage(
            @RequestParam(value = "error",   required = false) String error,
            @RequestParam(value = "logout",  required = false) String logout,
            @RequestParam(value = "expired", required = false) String expired,
            Model model) {

        if (error != null) {
            model.addAttribute("errorMsg", "Invalid username or password. Please try again.");
        }
        if (logout != null) {
            model.addAttribute("successMsg", "You have been logged out successfully.");
        }
        if (expired != null) {
            model.addAttribute("errorMsg", "Your session has expired. Please log in again.");
        }
        return "auth/login";
    }

    // ── REGISTER ──────────────────────────────────────────────────────────────

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("registerForm", new RegisterForm());
        return "auth/register";
    }

    @PostMapping("/register")
    public String register(
            @Valid @ModelAttribute("registerForm") RegisterForm form,
            BindingResult result,
            RedirectAttributes redirectAttributes,
            Model model) {

        // If annotation-level validation failed, return to form with errors
        if (result.hasErrors()) {
            return "auth/register";
        }

        try {
            userService.register(form);
            redirectAttributes.addFlashAttribute("successMsg",
                "Account created successfully! Please log in.");
            return "redirect:/login";

        } catch (IllegalArgumentException e) {
            // Business-rule violations (duplicate username/email, password mismatch)
            model.addAttribute("errorMsg", e.getMessage());
            return "auth/register";
        }
    }
}
