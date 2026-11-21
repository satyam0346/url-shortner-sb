<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shorten URL — LinkShrink</title>
    <link rel="stylesheet" href="<c:url value='/static/css/style.css'/>">
</head>
<body class="app-page">

<nav class="navbar app-navbar">
    <div class="nav-brand">
        <a href="<c:url value='/dashboard'/>">🔗 LinkShrink</a>
    </div>
    <div class="nav-links">
        <a href="<c:url value='/dashboard'/>">← Dashboard</a>
        <form action="<c:url value='/logout'/>" method="post" class="logout-form">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-outline btn-sm">Logout</button>
        </form>
    </div>
</nav>

<div class="centered-content">
    <div class="form-card">

        <h2 class="form-title">✂️ Shorten a URL</h2>
        <p class="form-subtitle">Fill in the details below to create your short link.</p>

        <%-- ── SERVER-SIDE ERROR ────────────────────────────────────────── --%>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-error" role="alert">⚠️ ${fn:escapeXml(errorMsg)}</div>
        </c:if>

        <%-- ── URL SHORTEN FORM ───────────────────────────────────────────
             - Uses JSTL c:url for action
             - EL expressions for field re-population on validation error
             - Both client-side (JS) and server-side (Spring @Valid) validation
        ─────────────────────────────────────────────────────────────────── --%>
        <form action="<c:url value='/shorten'/>" method="post"
              id="shortenForm" class="auth-form" novalidate>

            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <%-- Original URL --%>
            <div class="form-group">
                <label for="originalUrl" class="form-label">
                    Original URL <span class="required">*</span>
                </label>
                <input type="url"
                       id="originalUrl"
                       name="originalUrl"
                       class="form-input"
                       value="${fn:escapeXml(urlForm.originalUrl)}"
                       placeholder="https://example.com/very/long/url"
                       required/>
                <span class="field-error" id="url-error"></span>
            </div>

            <%-- Custom Alias (optional) --%>
            <div class="form-group">
                <label for="customAlias" class="form-label">
                    Custom Alias <span class="optional">(optional)</span>
                </label>
                <div class="input-prefix-group">
                    <span class="input-prefix">/s/</span>
                    <input type="text"
                           id="customAlias"
                           name="customAlias"
                           class="form-input"
                           value="${fn:escapeXml(urlForm.customAlias)}"
                           placeholder="my-link"
                           maxlength="50"
                           pattern="^[a-zA-Z0-9_-]*$"/>
                </div>
                <span class="field-error" id="alias-error"></span>
                <span class="field-hint">Leave blank for a random code. Letters, numbers, hyphens, underscores only.</span>
            </div>

            <%-- Title (optional) --%>
            <div class="form-group">
                <label for="title" class="form-label">
                    Title <span class="optional">(optional)</span>
                </label>
                <input type="text"
                       id="title"
                       name="title"
                       class="form-input"
                       value="${fn:escapeXml(urlForm.title)}"
                       placeholder="e.g., My Portfolio Website"
                       maxlength="255"/>
                <span class="field-error" id="title-error"></span>
            </div>

            <div class="form-actions">
                <a href="<c:url value='/dashboard'/>" class="btn btn-outline">Cancel</a>
                <button type="submit" class="btn btn-primary">🔗 Create Short Link</button>
            </div>
        </form>

    </div>
</div>

<script src="<c:url value='/static/js/validation.js'/>"></script>
<script>
    document.getElementById('shortenForm').addEventListener('submit', function(e) {
        let valid = true;

        const originalUrl  = document.getElementById('originalUrl');
        const customAlias  = document.getElementById('customAlias');
        const urlError     = document.getElementById('url-error');
        const aliasError   = document.getElementById('alias-error');

        // Reset
        urlError.textContent   = '';
        aliasError.textContent = '';
        originalUrl.classList.remove('input-error');
        customAlias.classList.remove('input-error');

        // Validate URL
        const urlVal = originalUrl.value.trim();
        if (!urlVal) {
            urlError.textContent = 'Original URL is required.';
            originalUrl.classList.add('input-error');
            valid = false;
        } else if (!/^https?:\/\/.+/.test(urlVal)) {
            urlError.textContent = 'URL must start with http:// or https://';
            originalUrl.classList.add('input-error');
            valid = false;
        }

        // Validate custom alias (if provided)
        const aliasVal = customAlias.value.trim();
        if (aliasVal && !/^[a-zA-Z0-9_-]+$/.test(aliasVal)) {
            aliasError.textContent = 'Alias can only contain letters, numbers, hyphens, underscores.';
            customAlias.classList.add('input-error');
            valid = false;
        } else if (aliasVal && aliasVal.length > 50) {
            aliasError.textContent = 'Alias must be at most 50 characters.';
            customAlias.classList.add('input-error');
            valid = false;
        }

        if (!valid) e.preventDefault();
    });
</script>

</body>
</html>
