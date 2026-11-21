<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Link — LinkShrink</title>
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

        <h2 class="form-title">✏️ Edit Short Link</h2>

        <%-- Show current short URL info (read-only via EL) --%>
        <div class="info-box">
            <strong>Short Code:</strong>
            <code>/s/${fn:escapeXml(url.effectiveCode)}</code>
            &nbsp;→&nbsp;
            <span class="text-muted" title="${fn:escapeXml(url.originalUrl)}">
                <c:choose>
                    <c:when test="${fn:length(url.originalUrl) > 60}">
                        ${fn:escapeXml(fn:substring(url.originalUrl, 0, 60))}…
                    </c:when>
                    <c:otherwise>${fn:escapeXml(url.originalUrl)}</c:otherwise>
                </c:choose>
            </span>
        </div>

        <c:if test="${not empty errorMsg}">
            <div class="alert alert-error" role="alert">⚠️ ${fn:escapeXml(errorMsg)}</div>
        </c:if>

        <form action="<c:url value='/url/${urlId}/edit'/>" method="post"
              id="editForm" class="auth-form" novalidate>

            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <%-- Original URL is not editable after creation --%>
            <div class="form-group">
                <label class="form-label">Original URL (read-only)</label>
                <input type="text" class="form-input" readonly
                       value="${fn:escapeXml(url.originalUrl)}"/>
                <%-- Send it as hidden so the DTO is populated --%>
                <input type="hidden" name="originalUrl" value="${fn:escapeXml(url.originalUrl)}"/>
            </div>

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
                           placeholder="my-alias"
                           maxlength="50"
                           pattern="^[a-zA-Z0-9_-]*$"/>
                </div>
                <span class="field-error" id="alias-error"></span>
            </div>

            <div class="form-group">
                <label for="title" class="form-label">Title</label>
                <input type="text"
                       id="title"
                       name="title"
                       class="form-input"
                       value="${fn:escapeXml(urlForm.title)}"
                       placeholder="Descriptive title"
                       maxlength="255"/>
            </div>

            <div class="form-actions">
                <a href="<c:url value='/dashboard'/>" class="btn btn-outline">Cancel</a>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>

    </div>
</div>

<script src="<c:url value='/static/js/validation.js'/>"></script>
<script>
    document.getElementById('editForm').addEventListener('submit', function(e) {
        const alias = document.getElementById('customAlias');
        const aliasError = document.getElementById('alias-error');
        aliasError.textContent = '';
        alias.classList.remove('input-error');

        const val = alias.value.trim();
        if (val && !/^[a-zA-Z0-9_-]+$/.test(val)) {
            aliasError.textContent = 'Alias can only contain letters, numbers, hyphens, underscores.';
            alias.classList.add('input-error');
            e.preventDefault();
        }
    });
</script>

</body>
</html>
