<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${errorCode} — LinkShrink</title>
    <link rel="stylesheet" href="<c:url value='/static/css/style.css'/>">
</head>
<body class="auth-page">
<div class="auth-container">
    <div class="auth-card text-center">
        <div style="font-size: 5rem;">${errorCode eq '404' ? '🔗' : '⚠️'}</div>
        <h2 class="auth-title">${errorCode}</h2>
        <p class="auth-subtitle">${errorMsg}</p>
        <a href="<c:url value='/'/>" class="btn btn-primary">Go Home</a>
    </div>
</div>
</body>
</html>
