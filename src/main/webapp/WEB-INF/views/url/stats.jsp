<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Link Analytics — LinkShrink</title>
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

<div class="app-layout">
    <main class="main-content full-width">

        <div class="card">
            <div class="card-header">
                <h2>📊 Analytics for <code>/s/${fn:escapeXml(url.effectiveCode)}</code></h2>
            </div>
            <div class="card-body">

                <%-- Link info summary (EL expressions) --%>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon">👆</div>
                        <div class="stat-value">${clickCount}</div>
                        <div class="stat-label">Total Clicks</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">🔗</div>
                        <div class="stat-value">
                            <code>/s/${fn:escapeXml(url.effectiveCode)}</code>
                        </div>
                        <div class="stat-label">Short Link</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">📅</div>
                        <div class="stat-value">
                            ${url.formattedCreatedAt}
                        </div>
                        <div class="stat-label">Created On</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">
                            <c:choose>
                                <c:when test="${url.active}">✅</c:when>
                                <c:otherwise>⏸</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-value">
                            <c:out value="${url.active ? 'Active' : 'Disabled'}"/>
                        </div>
                        <div class="stat-label">Status</div>
                    </div>
                </div>

                <div class="info-box" style="margin-top: 1.5rem;">
                    <strong>Destination:</strong>
                    <a href="${fn:escapeXml(url.originalUrl)}" target="_blank" rel="noopener">
                        ${fn:escapeXml(url.originalUrl)}
                    </a>
                </div>

            </div>
        </div>

        <%-- ── CLICK LOG TABLE ──────────────────────────────────────────── --%>
        <div class="card" style="margin-top: 1.5rem;">
            <div class="card-header">
                <h3>🕐 Click Log</h3>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty clicks}">
                        <div class="empty-state">
                            <p>No clicks recorded yet. Share your link to start tracking!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-wrapper">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Date &amp; Time</th>
                                        <th>IP Address</th>
                                        <th>Referrer</th>
                                        <th>User Agent</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%-- JSTL forEach + EL — no Java scriptlets --%>
                                    <c:forEach var="click" items="${clicks}" varStatus="st">
                                        <tr>
                                            <td>${st.count}</td>
                                            <td>
                                                ${click.formattedClickedAt}
                                            </td>
                                            <td>
                                                <code><c:out value="${not empty click.ipAddress ? click.ipAddress : '—'}"/></code>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty click.referer}">
                                                        <a href="${fn:escapeXml(click.referer)}"
                                                           target="_blank" rel="noopener" class="text-link">
                                                            ${fn:escapeXml(fn:substring(click.referer, 0, 40))}
                                                            <c:if test="${fn:length(click.referer) > 40}">…</c:if>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>Direct / Unknown</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="ua-cell" title="${fn:escapeXml(click.userAgent)}">
                                                <c:out value="${fn:substring(click.userAgent, 0, 60)}"/>
                                                <c:if test="${fn:length(click.userAgent) > 60}">…</c:if>
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

</body>
</html>
