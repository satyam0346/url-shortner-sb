<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — LinkShrink</title>
    <link rel="stylesheet" href="<c:url value='/static/css/style.css'/>">
</head>
<body class="app-page">

<%-- ── NAVBAR ───────────────────────────────────────────────────────────────── --%>
<nav class="navbar app-navbar">
    <div class="nav-brand">
        <a href="<c:url value='/dashboard'/>">🔗 LinkShrink</a>
    </div>
    <div class="nav-links">
        <%-- EL expression to display the logged-in user's name --%>
        <span class="nav-user">👤 ${fn:escapeXml(user.fullName)}</span>
        <a href="<c:url value='/shorten'/>" class="btn btn-primary btn-sm">+ New Link</a>
        <form action="<c:url value='/logout'/>" method="post" class="logout-form">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-outline btn-sm">Logout</button>
        </form>
    </div>
</nav>

<div class="app-layout">

    <%-- ── SIDEBAR ──────────────────────────────────────────────────────────── --%>
    <aside class="sidebar">
        <ul class="sidebar-nav">
            <li class="sidebar-item active">
                <a href="<c:url value='/dashboard'/>">📊 Dashboard</a>
            </li>
            <li class="sidebar-item">
                <a href="<c:url value='/shorten'/>">➕ Shorten URL</a>
            </li>
        </ul>
    </aside>

    <%-- ── MAIN CONTENT ─────────────────────────────────────────────────────── --%>
    <main class="main-content">

        <%-- Flash Messages (from RedirectAttributes) --%>
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success" role="alert">✅ ${fn:escapeXml(successMsg)}</div>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-error" role="alert">⚠️ ${fn:escapeXml(errorMsg)}</div>
        </c:if>

        <%-- New URL created flash --%>
        <c:if test="${not empty newUrl}">
            <div class="alert alert-info">
                <strong>🎉 Your short link is ready:</strong>
                <a href="<c:url value='/s/${newUrl.effectiveCode}'/>" target="_blank">
                    /s/${fn:escapeXml(newUrl.effectiveCode)}
                </a>
            </div>
        </c:if>

        <%-- ── STATS CARDS ────────────────────────────────────────────────── --%>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">🔗</div>
                <div class="stat-value">${totalUrls}</div>
                <div class="stat-label">Total Links</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">👆</div>
                <div class="stat-value">${totalClicks}</div>
                <div class="stat-label">Total Clicks</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📅</div>
                <div class="stat-value">
                    ${user.formattedCreatedAt}
                </div>
                <div class="stat-label">Member Since</div>
            </div>
        </div>

        <%-- ── QUICK SHORTEN FORM ────────────────────────────────────────── --%>
        <div class="card">
            <div class="card-header">
                <h3>✂️ Quick Shorten</h3>
            </div>
            <div class="card-body">
                <form action="<c:url value='/shorten'/>" method="post"
                      id="quickShortenForm" class="inline-form" novalidate>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="url"
                           name="originalUrl"
                           class="form-input"
                           placeholder="https://your-long-url.com/..."
                           required/>
                    <button type="submit" class="btn btn-primary">Shorten</button>
                </form>
                <span class="field-error" id="quick-url-error"></span>
            </div>
        </div>

        <%-- ── MY LINKS TABLE ────────────────────────────────────────────── --%>
        <div class="card">
            <div class="card-header">
                <h3>📋 My Links</h3>
                <a href="<c:url value='/shorten'/>" class="btn btn-primary btn-sm">+ New</a>
            </div>
            <div class="card-body">

                <c:choose>
                    <c:when test="${empty urls}">
                        <%-- JSTL: show empty state if no URLs --%>
                        <div class="empty-state">
                            <p>🔗 You haven't created any short links yet.</p>
                            <a href="<c:url value='/shorten'/>" class="btn btn-primary">
                                Create your first link
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-wrapper">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Short URL</th>
                                        <th>Original URL</th>
                                        <th>Title</th>
                                        <th>Created</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%-- JSTL c:forEach to iterate URLs; varStatus for index --%>
                                    <c:forEach var="url" items="${urls}" varStatus="status">
                                        <tr class="${url.active ? '' : 'row-disabled'}">
                                            <td>${status.count}</td>
                                            <td>
                                                <a href="<c:url value='/s/${url.effectiveCode}'/>"
                                                   target="_blank"
                                                   class="short-link">
                                                    /s/${fn:escapeXml(url.effectiveCode)}
                                                </a>
                                            </td>
                                            <td class="original-url-cell" title="${fn:escapeXml(url.originalUrl)}">
                                                <%-- Truncate long URLs with JSTL fn:substring --%>
                                                <c:choose>
                                                    <c:when test="${fn:length(url.originalUrl) > 50}">
                                                        ${fn:escapeXml(fn:substring(url.originalUrl, 0, 50))}…
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${fn:escapeXml(url.originalUrl)}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:out value="${not empty url.title ? url.title : '—'}"/>
                                            </td>
                                            <td>
                                                ${url.formattedCreatedAt}
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${url.active}">
                                                        <span class="badge badge-active">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-disabled">Disabled</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="actions-cell">
                                                <%-- Stats --%>
                                                <a href="<c:url value='/url/${url.id}/stats'/>"
                                                   class="btn btn-xs btn-info" title="View Analytics">📊</a>

                                                <%-- Edit --%>
                                                <a href="<c:url value='/url/${url.id}/edit'/>"
                                                   class="btn btn-xs btn-warning" title="Edit">✏️</a>

                                                <%-- Toggle active --%>
                                                <form action="<c:url value='/url/${url.id}/toggle'/>"
                                                      method="post" class="inline-action-form">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <button type="submit"
                                                            class="btn btn-xs ${url.active ? 'btn-secondary' : 'btn-success'}"
                                                            title="${url.active ? 'Disable' : 'Enable'}">
                                                        ${url.active ? '⏸' : '▶️'}
                                                    </button>
                                                </form>

                                                <%-- Delete --%>
                                                <form action="<c:url value='/url/${url.id}/delete'/>"
                                                      method="post" class="inline-action-form"
                                                      onsubmit="return confirm('Delete this link permanently?')">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <button type="submit" class="btn btn-xs btn-danger" title="Delete">🗑</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>

    </main>
</div>

<script src="<c:url value='/static/js/validation.js'/>"></script>
<script>
    // Client-side validation for quick shorten form
    document.getElementById('quickShortenForm').addEventListener('submit', function(e) {
        const urlInput = this.querySelector('input[name="originalUrl"]');
        const errEl = document.getElementById('quick-url-error');
        errEl.textContent = '';
        urlInput.classList.remove('input-error');

        const val = urlInput.value.trim();
        if (!val) {
            errEl.textContent = 'Please enter a URL.';
            urlInput.classList.add('input-error');
            e.preventDefault();
        } else if (!/^https?:\/\/.+/.test(val)) {
            errEl.textContent = 'URL must start with http:// or https://';
            urlInput.classList.add('input-error');
            e.preventDefault();
        }
    });

    // Auto-dismiss alerts after 5s
    setTimeout(() => {
        document.querySelectorAll('.alert').forEach(el => {
            el.style.transition = 'opacity 0.5s';
            el.style.opacity = '0';
            setTimeout(() => el.remove(), 500);
        });
    }, 5000);
</script>

</body>
</html>
