<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — LinkShrink</title>
    <link rel="stylesheet" href="<c:url value='/static/css/style.css'/>">
</head>
<body class="auth-page">

<div class="auth-container">
    <div class="auth-card">

        <%-- Logo / Brand --%>
        <div class="auth-logo">
            <a href="<c:url value='/'/>">🔗 LinkShrink</a>
        </div>

        <h2 class="auth-title">Welcome Back</h2>
        <p class="auth-subtitle">Sign in to manage your short links</p>

        <%-- ── SESSION MESSAGES (EL Expressions) ───────────────────────────── --%>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-error" role="alert">
                <span class="alert-icon">⚠️</span>
                ${fn:escapeXml(errorMsg)}
            </div>
        </c:if>

        <c:if test="${not empty successMsg}">
            <div class="alert alert-success" role="alert">
                <span class="alert-icon">✅</span>
                ${fn:escapeXml(successMsg)}
            </div>
        </c:if>

        <%-- ── LOGIN FORM ────────────────────────────────────────────────────
             Spring Security processes POST /login automatically.
             Client-side validation via HTML5 + JavaScript.
        ─────────────────────────────────────────────────────────────────────── --%>
        <form action="<c:url value='/login'/>" method="post"
              id="loginForm" class="auth-form" novalidate>

            <%-- CSRF token (Spring Security requires this) --%>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="form-group">
                <label for="username" class="form-label">Username</label>
                <input type="text"
                       id="username"
                       name="username"
                       class="form-input"
                       placeholder="Enter your username"
                       autocomplete="username"
                       required
                       minlength="3"/>
                <span class="field-error" id="username-error"></span>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">Password</label>
                <div class="input-with-toggle">
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-input"
                           placeholder="Enter your password"
                           autocomplete="current-password"
                           required
                           minlength="6"/>
                    <button type="button" class="toggle-password" onclick="togglePassword('password')">👁</button>
                </div>
                <span class="field-error" id="password-error"></span>
            </div>

            <button type="submit" class="btn btn-primary btn-block" id="loginBtn">
                Sign In
            </button>
        </form>

        <div class="auth-footer">
            <p>Don't have an account?
                <a href="<c:url value='/register'/>">Create one for free</a>
            </p>
        </div>

    </div>
</div>

<script src="<c:url value='/static/js/validation.js'/>"></script>
<script>
    // Client-side validation for login form
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        let valid = true;

        const username = document.getElementById('username');
        const password = document.getElementById('password');
        const usernameErr = document.getElementById('username-error');
        const passwordErr = document.getElementById('password-error');

        // Reset errors
        usernameErr.textContent = '';
        passwordErr.textContent = '';
        username.classList.remove('input-error');
        password.classList.remove('input-error');

        if (!username.value.trim()) {
            usernameErr.textContent = 'Username is required.';
            username.classList.add('input-error');
            valid = false;
        } else if (username.value.trim().length < 3) {
            usernameErr.textContent = 'Username must be at least 3 characters.';
            username.classList.add('input-error');
            valid = false;
        }

        if (!password.value) {
            passwordErr.textContent = 'Password is required.';
            password.classList.add('input-error');
            valid = false;
        } else if (password.value.length < 6) {
            passwordErr.textContent = 'Password must be at least 6 characters.';
            password.classList.add('input-error');
            valid = false;
        }

        if (!valid) e.preventDefault();
    });
</script>
</body>
</html>
