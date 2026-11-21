/**
 * validation.js — Client-side validation utilities for LinkShrink
 * Used across all JSP pages with JSTL+EL for server-side counterpart.
 */

/**
 * Toggle password field visibility.
 * @param {string} fieldId - ID of the password input field
 */
function togglePassword(fieldId) {
    const field = document.getElementById(fieldId);
    if (!field) return;
    field.type = field.type === 'password' ? 'text' : 'password';
}

/**
 * Show an inline field error message.
 * @param {string} fieldId - ID of the input field
 * @param {string} errorId - ID of the error span
 * @param {string} message - Error message to display
 */
function showError(fieldId, errorId, message) {
    const field = document.getElementById(fieldId);
    const error = document.getElementById(errorId);
    if (field) field.classList.add('input-error');
    if (error) error.textContent = message;
}

/**
 * Clear an inline field error.
 * @param {string} fieldId - ID of the input field
 * @param {string} errorId - ID of the error span
 */
function clearError(fieldId, errorId) {
    const field = document.getElementById(fieldId);
    const error = document.getElementById(errorId);
    if (field) field.classList.remove('input-error');
    if (error) error.textContent = '';
}

/**
 * Validate a URL string (must start with http:// or https://).
 * @param {string} url
 * @returns {boolean}
 */
function isValidUrl(url) {
    return /^https?:\/\/.+/.test(url.trim());
}

/**
 * Validate an email address.
 * @param {string} email
 * @returns {boolean}
 */
function isValidEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim());
}

/**
 * Validate a custom alias (letters, numbers, hyphens, underscores only).
 * @param {string} alias
 * @returns {boolean}
 */
function isValidAlias(alias) {
    return /^[a-zA-Z0-9_-]+$/.test(alias);
}

// Auto-dismiss alerts after 5 seconds if validation.js is included
document.addEventListener('DOMContentLoaded', function () {
    setTimeout(function () {
        document.querySelectorAll('.alert').forEach(function (el) {
            el.style.transition = 'opacity 0.5s ease';
            el.style.opacity = '0';
            setTimeout(function () { el.remove(); }, 500);
        });
    }, 5000);
});
