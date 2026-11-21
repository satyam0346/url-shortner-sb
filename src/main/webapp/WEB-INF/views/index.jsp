<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LinkShrink — URL Shortener</title>
    <link rel="stylesheet" href="<c:url value='/static/css/style.css'/>">
</head>
<body class="home-page">

<%-- ── NAVIGATION ─────────────────────────────────────────────────────────── --%>
<nav class="navbar">
    <div class="nav-brand">
        <a href="<c:url value='/'/>">🔗 LinkShrink</a>
    </div>
    <div class="nav-links">
        <a href="<c:url value='/login'/>">Login</a>
        <a href="<c:url value='/register'/>" class="btn btn-primary">Get Started</a>
    </div>
</nav>

<%-- ── HERO SECTION ──────────────────────────────────────────────────────── --%>
<section class="hero">
    <div class="hero-content">
        <h1>Shorten. Share. Track.</h1>
        <p class="hero-subtitle">
            Turn long URLs into clean, shareable links and track every click in real time.
        </p>
        <div class="hero-actions">
            <a href="<c:url value='/register'/>" class="btn btn-primary btn-lg">Start for Free</a>
            <a href="<c:url value='/login'/>" class="btn btn-outline btn-lg">Sign In</a>
        </div>
    </div>
</section>

<%-- ── FEATURES ──────────────────────────────────────────────────────────── --%>
<section class="features">
    <div class="feature-grid">
        <div class="feature-card">
            <span class="feature-icon">⚡</span>
            <h3>Instant Shortening</h3>
            <p>Create short links in seconds with or without a custom alias.</p>
        </div>
        <div class="feature-card">
            <span class="feature-icon">📊</span>
            <h3>Click Analytics</h3>
            <p>Track every click with detailed stats including IP, browser, and referrer.</p>
        </div>
        <div class="feature-card">
            <span class="feature-icon">🔒</span>
            <h3>Secure & Private</h3>
            <p>Your links are protected behind authenticated sessions.</p>
        </div>
        <div class="feature-card">
            <span class="feature-icon">🛠️</span>
            <h3>Full Control</h3>
            <p>Enable, disable, edit, or delete your links at any time.</p>
        </div>
    </div>
</section>

<footer class="footer">
    <p>&copy; 2026 LinkShrink | Built with Spring Boot &amp; Hibernate</p>
</footer>

</body>
</html>
