<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — LinkShrink</title>
    <link rel="stylesheet" href="<c:url value='/static/css/style.css'/>">
</head>
<body class="auth-page">

<div class="auth-container">
    <div class="auth-card">

        <div class="auth-logo">
            <a href="<c:url value='/'/>">🔗 LinkShrink</a>
        </div>

        <h2 class="auth-title">Create Your Account</h2>
        <p class="auth-subtitle">Join thousands managing their links smarter</p>

        <%-- ── SERVER-SIDE ERROR MESSAGE ──────────────────────────────────── --%>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-error" role="alert">
                <span class="alert-icon">⚠️</span>
                ${fn:escapeXml(errorMsg)}
            </div>
        </c:if>

        <%-- ── REGISTER FORM ──────────────────────────────────────────────────
             Uses JSTL c:url for action, EL for form repopulation.
             Spring MVC @ModelAttribute binds to RegisterForm DTO.
        ─────────────────────────────────────────────────────────────────────── --%>
        <form action="<c:url value='/register'/>" method="post"
              id="registerForm" class="auth-form" novalidate>

            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <%-- Full Name --%>
            <div class="form-group">
                <label for="fullName" class="form-label">Full Name</label>
                <input type="text"
                       id="fullName"
                       name="fullName"
                       class="form-input <c:if test='${not empty registerForm and registerForm.fullName != null}'>has-value</c:if>"
                       value="${fn:escapeXml(registerForm.fullName)}"
                       placeholder="Your full name"
                       required minlength="2" maxlength="100"/>
                <c:if test="${not empty bindingResult}">
                    <%-- Display field-level Spring validation errors --%>
                </c:if>
                <span class="field-error" id="fullName-error"></span>
            </div>

            <%-- Username --%>
            <div class="form-group">
                <label for="username" class="form-label">Username</label>
                <input type="text"
                       id="username"
                       name="username"
                       class="form-input"
                       value="${fn:escapeXml(registerForm.username)}"
                       placeholder="Choose a username"
                       required minlength="3" maxlength="50"
                       pattern="^[a-zA-Z0-9_]+$"/>
                <span class="field-error" id="username-error"></span>
                <span class="field-hint">Letters, numbers, and underscores only.</span>
            </div>

            <%-- Email --%>
            <div class="form-group">
                <label for="email" class="form-label">Email Address</label>
                <input type="email"
                       id="email"
                       name="email"
                       class="form-input"
                       value="${fn:escapeXml(registerForm.email)}"
                       placeholder="you@example.com"
                       required/>
                <span class="field-error" id="email-error"></span>
            </div>

            <%-- Password --%>
            <div class="form-group">
                <label for="password" class="form-label">Password</label>
                <div class="input-with-toggle">
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-input"
                           placeholder="Min. 6 characters"
                           required minlength="6"
                           autocomplete="new-password"/>
                    <button type="button" class="toggle-password" onclick="togglePassword('password')">👁</button>
                </div>
                <span class="field-error" id="password-error"></span>
                <div class="password-strength" id="strengthBar"></div>
            </div>

            <%-- Confirm Password --%>
            <div class="form-group">
                <label for="confirmPassword" class="form-label">Confirm Password</label>
                <div class="input-with-toggle">
                    <input type="password"
                           id="confirmPassword"
                           name="confirmPassword"
                           class="form-input"
                           placeholder="Re-enter your password"
                           required
                           autocomplete="new-password"/>
                    <button type="button" class="toggle-password" onclick="togglePassword('confirmPassword')">👁</button>
                </div>
                <span class="field-error" id="confirm-error"></span>
            </div>

            <button type="submit" class="btn btn-primary btn-block">
                Create Account
            </button>
        </form>

        <div class="auth-footer">
            <p>Already have an account?
                <a href="<c:url value='/login'/>">Sign in here</a>
            </p>
        </div>

    </div>
</div>

<script src="<c:url value='/static/js/validation.js'/>"></script>
<script>
    // ── CLIENT-SIDE VALIDATION ──────────────────────────────────────────────
    const form = document.getElementById('registerForm');
    const pwd  = document.getElementById('password');
    const conf = document.getElementById('confirmPassword');

    // Real-time password strength indicator
    pwd.addEventListener('input', function() {
        const bar = document.getElementById('strengthBar');
        const len = this.value.length;
        bar.className = 'password-strength';
        if (len === 0) { bar.textContent = ''; return; }
        if (len < 6)   { bar.classList.add('strength-weak');   bar.textContent = 'Weak'; }
        else if (len < 10) { bar.classList.add('strength-medium'); bar.textContent = 'Medium'; }
        else           { bar.classList.add('strength-strong'); bar.textContent = 'Strong'; }
    });

    // Real-time confirm-password match
    conf.addEventListener('input', function() {
        const err = document.getElementById('confirm-error');
        if (this.value && this.value !== pwd.value) {
            err.textContent = 'Passwords do not match.';
            this.classList.add('input-error');
        } else {
            err.textContent = '';
            this.classList.remove('input-error');
        }
    });

    form.addEventListener('submit', function(e) {
        let valid = true;
        const fields = [
            { id: 'fullName',       errId: 'fullName-error',  minLen: 2, label: 'Full name' },
            { id: 'username',       errId: 'username-error',  minLen: 3, label: 'Username',
              pattern: /^[a-zA-Z0-9_]+$/, patternMsg: 'Only letters, numbers, underscore.' },
            { id: 'email',          errId: 'email-error',    isEmail: true, label: 'Email' },
            { id: 'password',       errId: 'password-error', minLen: 6, label: 'Password' },
        ];

        fields.forEach(f => {
            const el  = document.getElementById(f.id);
            const err = document.getElementById(f.errId);
            err.textContent = '';
            el.classList.remove('input-error');

            if (!el.value.trim()) {
                err.textContent = f.label + ' is required.';
                el.classList.add('input-error');
                valid = false;
            } else if (f.minLen && el.value.trim().length < f.minLen) {
                err.textContent = f.label + ' must be at least ' + f.minLen + ' characters.';
                el.classList.add('input-error');
                valid = false;
            } else if (f.isEmail && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(el.value)) {
                err.textContent = 'Please enter a valid email address.';
                el.classList.add('input-error');
                valid = false;
            } else if (f.pattern && !f.pattern.test(el.value)) {
                err.textContent = f.patternMsg;
                el.classList.add('input-error');
                valid = false;
            }
        });

        // Confirm password
        const confErr = document.getElementById('confirm-error');
        confErr.textContent = '';
        conf.classList.remove('input-error');
        if (!conf.value) {
            confErr.textContent = 'Please confirm your password.';
            conf.classList.add('input-error');
            valid = false;
        } else if (conf.value !== pwd.value) {
            confErr.textContent = 'Passwords do not match.';
            conf.classList.add('input-error');
            valid = false;
        }

        if (!valid) e.preventDefault();
    });
</script>
</body>
</html>
