package com.urlshortener.controller;

import com.urlshortener.dto.UrlForm;
import com.urlshortener.model.Url;
import com.urlshortener.model.User;
import com.urlshortener.service.UrlService;
import com.urlshortener.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * UrlController — handles all URL CRUD operations and dashboard.
 *
 * Demonstrates:
 *  - Spring MVC @Controller with constructor-based DI (@Autowired)
 *  - @AuthenticationPrincipal to get the logged-in user from session
 *  - Full CRUD: Create, Read (dashboard), Update, Delete
 *  - Server-side validation with @Valid + BindingResult
 *  - Flash attributes for redirect-after-POST feedback
 */
@Controller
public class UrlController {

    private final UrlService urlService;
    private final UserService userService;

    @Autowired
    public UrlController(UrlService urlService, UserService userService) {
        this.urlService = urlService;
        this.userService = userService;
    }

    // ── DASHBOARD (READ) ───────────────────────────────────────────────────────

    @GetMapping("/dashboard")
    public String dashboard(
            @AuthenticationPrincipal UserDetails userDetails,
            Model model) {

        User user = userService.findByUsername(userDetails.getUsername());
        List<Url> urls = urlService.getUrlsForUser(user);

        model.addAttribute("user", user);
        model.addAttribute("urls", urls);
        model.addAttribute("totalUrls",   urlService.countUrlsByUser(user));
        model.addAttribute("totalClicks", urlService.countClicksByUser(user));
        model.addAttribute("urlForm", new UrlForm());   // for the inline shorten form

        return "url/dashboard";
    }

    // ── CREATE ─────────────────────────────────────────────────────────────────

    @GetMapping("/shorten")
    public String shortenPage(Model model) {
        model.addAttribute("urlForm", new UrlForm());
        return "url/shorten";
    }

    @PostMapping("/shorten")
    public String shorten(
            @Valid @ModelAttribute("urlForm") UrlForm form,
            BindingResult result,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes,
            Model model) {

        if (result.hasErrors()) {
            return "url/shorten";
        }

        try {
            User user = userService.findByUsername(userDetails.getUsername());
            Url url = urlService.shorten(form, user);
            redirectAttributes.addFlashAttribute("successMsg",
                "Short URL created: /s/" + url.getEffectiveCode());
            redirectAttributes.addFlashAttribute("newUrl", url);
            return "redirect:/dashboard";

        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMsg", e.getMessage());
            return "url/shorten";
        }
    }

    // ── EDIT ───────────────────────────────────────────────────────────────────

    @GetMapping("/url/{id}/edit")
    public String editPage(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails,
            Model model) {

        User user = userService.findByUsername(userDetails.getUsername());
        Url url = urlService.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("URL not found"));

        if (!url.getUser().getId().equals(user.getId())) {
            return "redirect:/dashboard";
        }

        UrlForm form = new UrlForm(url.getOriginalUrl(), url.getCustomAlias(), url.getTitle());

        model.addAttribute("urlForm", form);
        model.addAttribute("urlId", id);
        model.addAttribute("url", url);
        return "url/edit";
    }

    @PostMapping("/url/{id}/edit")
    public String edit(
            @PathVariable Long id,
            @Valid @ModelAttribute("urlForm") UrlForm form,
            BindingResult result,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes,
            Model model) {

        if (result.hasErrors()) {
            model.addAttribute("urlId", id);
            // Re-load url for the read-only display
            urlService.findById(id).ifPresent(u -> model.addAttribute("url", u));
            return "url/edit";
        }

        try {
            User user = userService.findByUsername(userDetails.getUsername());
            urlService.update(id, form, user);
            redirectAttributes.addFlashAttribute("successMsg", "URL updated successfully.");
            return "redirect:/dashboard";

        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMsg", e.getMessage());
            model.addAttribute("urlId", id);
            urlService.findById(id).ifPresent(u -> model.addAttribute("url", u));
            return "url/edit";
        }
    }

    // ── TOGGLE ACTIVE (UPDATE) ─────────────────────────────────────────────────

    @PostMapping("/url/{id}/toggle")
    public String toggle(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes) {

        User user = userService.findByUsername(userDetails.getUsername());
        Url url = urlService.toggleActive(id, user);
        redirectAttributes.addFlashAttribute("successMsg",
            "URL " + (url.isActive() ? "enabled" : "disabled") + " successfully.");
        return "redirect:/dashboard";
    }

    // ── DELETE ─────────────────────────────────────────────────────────────────

    @PostMapping("/url/{id}/delete")
    public String delete(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes) {

        User user = userService.findByUsername(userDetails.getUsername());
        urlService.delete(id, user);
        redirectAttributes.addFlashAttribute("successMsg", "URL deleted successfully.");
        return "redirect:/dashboard";
    }

    // ── ANALYTICS (READ) ───────────────────────────────────────────────────────

    @GetMapping("/url/{id}/stats")
    public String stats(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails,
            Model model) {

        User user = userService.findByUsername(userDetails.getUsername());
        Url url = urlService.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("URL not found"));

        if (!url.getUser().getId().equals(user.getId())) {
            return "redirect:/dashboard";
        }

        model.addAttribute("url", url);
        model.addAttribute("clicks", urlService.getClicksForUrl(url));
        model.addAttribute("clickCount", urlService.countClicksForUrl(url));
        return "url/stats";
    }
}
