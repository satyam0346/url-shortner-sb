package com.urlshortener.controller;

import com.urlshortener.service.UrlService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

/**
 * RedirectController — handles short URL redirection and click tracking.
 *
 * Public endpoint: /s/{code} → resolves to original URL and redirects.
 */
@Controller
public class RedirectController {

    private final UrlService urlService;

    @Autowired
    public RedirectController(UrlService urlService) {
        this.urlService = urlService;
    }

    @GetMapping("/s/{code}")
    public String redirect(
            @PathVariable String code,
            HttpServletRequest request,
            Model model) {

        try {
            String originalUrl = urlService.resolveAndTrack(code, request);
            // HTTP 302 redirect to the original URL
            return "redirect:" + originalUrl;

        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMsg", "The short URL '" + code + "' was not found.");
            model.addAttribute("errorCode", "404");
            return "error/not-found";

        } catch (IllegalStateException e) {
            model.addAttribute("errorMsg", e.getMessage());
            model.addAttribute("errorCode", "410");
            return "error/not-found";
        }
    }
}
