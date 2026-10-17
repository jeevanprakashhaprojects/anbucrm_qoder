(() => {
  'use strict';

  const APP_URL = 'anbucrm://app/sign-up-login-screen';
  const REQUEST_TIMEOUT_MS = 35000;
  const RESEND_COOLDOWN_MS = 60000;
  const byId = (id) => document.getElementById(id);
  const views = {
    checking: byId('checking-view'),
    password: byId('password-view'),
    unavailable: byId('unavailable-view'),
    success: byId('success-view'),
  };
  const titles = {
    checking: byId('checking-title'),
    password: byId('password-title'),
    unavailable: byId('unavailable-title'),
    success: byId('success-title'),
  };
  const passwordForm = byId('password-form');
  const password = byId('new-password');
  const confirmation = byId('confirm-password');
  const passwordError = byId('password-error');
  const confirmationError = byId('confirmation-error');
  const passwordStatus = byId('password-status');
  const saveButton = byId('save-password');
  const saveLabel = byId('save-label');
  const passwordToggle = byId('toggle-password');
  const confirmationToggle = byId('toggle-confirmation');
  const retryButton = byId('retry-verify');
  const emailForm = byId('email-form');
  const email = byId('recovery-email');
  const emailError = byId('email-error');
  const emailStatus = byId('email-status');
  const sendButton = byId('send-email');
  const cooldownHint = byId('email-cooldown');
  const openMailLink = byId('open-mail');
  const countdownLine = byId('return-countdown');
  const countdownNumber = byId('countdown-number');
  const countdownUnit = byId('countdown-unit');
  const returnStatus = byId('return-status');

  // Same conditions as the app's create-account password rules.
  const passwordRules = [
    { id: 'rule-length', test: (v) => v.length >= 8, message: 'Use at least 8 characters.' },
    { id: 'rule-case', test: (v) => /[A-Z]/.test(v) && /[a-z]/.test(v), message: 'Include both uppercase and lowercase letters.' },
    { id: 'rule-number', test: (v) => /[0-9]/.test(v), message: 'Include at least one number.' },
    { id: 'rule-special', test: (v) => /[!@#$%^&*(),.?":{}|<>]/.test(v), message: 'Include at least one special character (!@#$...).' },
  ];
  const ruleElements = new Map(passwordRules.map((rule) => [rule.id, {
    row: byId(rule.id),
    text: byId(rule.id).querySelector('.rule-text'),
    defaultText: byId(rule.id).querySelector('.rule-text').textContent,
  }]));

  // Secrets stay in this closure and the original fragment; never persist them.
  let oobCode = '';
  let verified = false;
  let completed = false;
  let verifyBusy = false;
  let confirmBusy = false;
  let resendBusy = false;
  let currentView = 'checking';
  let cooldownUntil = 0;
  let cooldownTimer = null;
  let lastSentEmail = '';
  let returnTimer = null;
  let returnCancelled = false;
  let automaticLaunchAttempted = false;

  class RequestError extends Error {
    constructor(kind, status = 0) {
      super(kind);
      this.kind = kind;
      this.status = status;
    }
  }

  async function postJson(path, payload) {
    const controller = new AbortController();
    const timeout = window.setTimeout(() => controller.abort(), REQUEST_TIMEOUT_MS);
    try {
      const response = await fetch(path, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(payload),
        signal: controller.signal,
        cache: 'no-store',
        credentials: 'omit',
        redirect: 'error',
        referrerPolicy: 'no-referrer',
      });
      let result;
      try {
        result = await response.json();
      } catch {
        // Preserve HTTP error meaning even when a proxy returns an HTML error.
        if (!response.ok) throw new RequestError('http', response.status);
        throw new RequestError('response', response.status);
      }
      if (!response.ok) throw new RequestError('http', response.status);
      if (!result || typeof result !== 'object' || result.ok !== true) {
        throw new RequestError('response', response.status);
      }
      return result;
    } catch (error) {
      if (controller.signal.aborted) throw new RequestError('timeout');
      if (error instanceof RequestError) throw error;
      throw new RequestError('network');
    } finally {
      window.clearTimeout(timeout);
    }
  }

  function requestErrorMessage(error) {
    if (error.status === 429) return 'Too many attempts right now. Please wait 15 minutes, then try again.';
    if (error.status === 422) return 'Choose a stronger password with uppercase and lowercase letters, a number, and a symbol.';
    if (error.status === 503) return 'Account security is temporarily unavailable. Please try again shortly.';
    if (error.kind === 'timeout') return 'The request took too long. Check your connection, then try again.';
    if (error.kind === 'network') return 'We couldn’t reach the server. Check your connection, then try again.';
    if (error.kind === 'response') return 'We couldn’t read the server’s response. Please try again.';
    return 'Something interrupted this request. Please try again shortly.';
  }

  function showView(name, focus = true) {
    currentView = name;
    Object.entries(views).forEach(([key, element]) => { element.hidden = key !== name; });
    if (focus) titles[name].focus();
  }

  function setFieldError(input, element, message) {
    element.textContent = message;
    element.hidden = !message;
    if (message) input.setAttribute('aria-invalid', 'true');
    else input.removeAttribute('aria-invalid');
  }

  function showNotice(element, message, isError = false) {
    element.textContent = message;
    element.hidden = !message;
    element.classList.toggle('notice-error', isError);
  }

  function showUnavailable(title, description, canRetry = false) {
    verified = false;
    byId('unavailable-title').textContent = title;
    byId('unavailable-description').textContent = description;
    retryButton.hidden = !canRetry;
    showView('unavailable');
    updateRecoveryControls();
  }

  function showInvalidLink() {
    showUnavailable(
      'This reset link is no longer valid',
      'It may have expired or already been used. Request a fresh link below to choose a new password.',
    );
  }

  async function verifyLink() {
    if (!oobCode || completed || verifyBusy || confirmBusy || resendBusy) return;
    verifyBusy = true;
    verified = false;
    updateRecoveryControls();
    showView('checking');
    try {
      await postJson('/auth/reset-password/verify', { oobCode });
      if (completed) return;
      verified = true;
      showView('password');
    } catch (error) {
      if (completed) return;
      if (error.status === 400) showInvalidLink();
      else showUnavailable('We couldn’t check your link', requestErrorMessage(error), true);
    } finally {
      verifyBusy = false;
      updateRecoveryControls();
    }
  }

  function updateRuleRows(value) {
    passwordRules.forEach((rule) => {
      const row = ruleElements.get(rule.id);
      row.row.classList.toggle('satisfied', Boolean(value) && rule.test(value));
    });
  }

  function validatePassword() {
    const value = password.value;
    updateRuleRows(value);
    let message = '';
    if (!value) message = 'Enter a new password.';
    else if (value.length > 128) message = 'Use up to 128 characters.';
    else {
      const failed = passwordRules.find((rule) => !rule.test(value));
      if (failed) message = failed.message;
    }
    setFieldError(password, passwordError, message);
    return !message;
  }

  function validateConfirmation() {
    let message = '';
    if (!confirmation.value) message = 'Enter your new password again.';
    else if (confirmation.value !== password.value) message = 'Your passwords don’t match. Please try again.';
    setFieldError(confirmation, confirmationError, message);
    return !message;
  }

  function setConfirmBusy(busy) {
    confirmBusy = busy;
    passwordForm.setAttribute('aria-busy', String(busy));
    [password, confirmation, passwordToggle, confirmationToggle, saveButton].forEach((element) => {
      element.disabled = busy || completed;
    });
    saveLabel.textContent = busy ? 'Changing password…' : 'Change password';
  }

  function attachVisibilityToggle(button, input, label) {
    const slash = button.querySelector('.slash');
    button.addEventListener('click', () => {
      if (confirmBusy || completed) return;
      const visible = input.type === 'password';
      input.type = visible ? 'text' : 'password';
      // Same convention as the app's sign-in field: strike while hidden.
      slash.hidden = !visible;
      button.setAttribute('aria-label', `${visible ? 'Hide' : 'Show'} ${label}`);
      button.setAttribute('aria-pressed', String(visible));
    });
  }

  function resetVisibilityToggle(button, input, label) {
    input.type = 'password';
    button.querySelector('.slash').hidden = false;
    button.setAttribute('aria-label', `Show ${label}`);
    button.setAttribute('aria-pressed', 'false');
  }

  function clearPasswords() {
    password.value = '';
    confirmation.value = '';
    resetVisibilityToggle(passwordToggle, password, 'new password');
    resetVisibilityToggle(confirmationToggle, confirmation, 'password confirmation');
    updateRuleRows('');
    setFieldError(password, passwordError, '');
    setFieldError(confirmation, confirmationError, '');
  }

  passwordForm.addEventListener('submit', async (event) => {
    event.preventDefault();
    if (completed || confirmBusy || !verified || !oobCode || currentView !== 'password') return;
    showNotice(passwordStatus, '');
    const passwordValid = validatePassword();
    const confirmationValid = validateConfirmation();
    if (!passwordValid || !confirmationValid) {
      (passwordValid ? confirmation : password).focus();
      return;
    }
    setConfirmBusy(true);
    try {
      await postJson('/auth/reset-password/confirm', { oobCode, newPassword: password.value });
      finishReset();
    } catch (error) {
      if (completed) return;
      if (error.status === 400) {
        clearPasswords();
        showInvalidLink();
      } else {
        showNotice(passwordStatus, requestErrorMessage(error), true);
      }
    } finally {
      setConfirmBusy(false);
    }
  });

  password.addEventListener('blur', () => {
    if (password.value || password.hasAttribute('aria-invalid')) validatePassword();
  });
  confirmation.addEventListener('blur', () => {
    if (confirmation.value || confirmation.hasAttribute('aria-invalid')) validateConfirmation();
  });
  password.addEventListener('input', () => {
    updateRuleRows(password.value);
    if (password.hasAttribute('aria-invalid')) validatePassword();
    if (confirmation.hasAttribute('aria-invalid')) validateConfirmation();
    showNotice(passwordStatus, '');
  });
  confirmation.addEventListener('input', () => {
    if (confirmation.hasAttribute('aria-invalid')) validateConfirmation();
    showNotice(passwordStatus, '');
  });
  attachVisibilityToggle(passwordToggle, password, 'new password');
  attachVisibilityToggle(confirmationToggle, confirmation, 'password confirmation');
  retryButton.addEventListener('click', verifyLink);

  function updateRecoveryControls() {
    const remaining = Math.max(0, Math.ceil((cooldownUntil - Date.now()) / 1000));
    sendButton.disabled = completed || resendBusy || verifyBusy || remaining > 0;
    email.disabled = completed || resendBusy || verifyBusy;
    retryButton.disabled = completed || resendBusy || verifyBusy;
    emailForm.setAttribute('aria-busy', String(resendBusy));
    sendButton.textContent = resendBusy ? 'Sending link…' : remaining > 0 ? `Resend in ${remaining}s` : 'Send reset link';
    cooldownHint.hidden = remaining === 0;
    cooldownHint.textContent = remaining > 0 ? `You can request another link in ${remaining} seconds.` : '';
    if (remaining === 0 && cooldownTimer !== null) {
      window.clearInterval(cooldownTimer);
      cooldownTimer = null;
    }
  }

  function resumeCooldown() {
    updateRecoveryControls();
    if (cooldownUntil > Date.now() && cooldownTimer === null && !completed) {
      cooldownTimer = window.setInterval(updateRecoveryControls, 1000);
    }
  }

  function startCooldown(duration = RESEND_COOLDOWN_MS) {
    cooldownUntil = Date.now() + duration;
    resumeCooldown();
  }

  function clearCooldown() {
    cooldownUntil = 0;
    if (cooldownTimer !== null) {
      window.clearInterval(cooldownTimer);
      cooldownTimer = null;
    }
    updateRecoveryControls();
  }

  function setOpenMailLink(address) {
    if (!address) {
      openMailLink.hidden = true;
      openMailLink.removeAttribute('href');
      return;
    }
    // A plain mailto: link opens the browser's default mail app.
    openMailLink.href = `mailto:${address}`;
    openMailLink.hidden = false;
  }

  function validateEmail() {
    email.value = email.value.trim();
    const message = !email.value ? 'Enter your email address.' : !email.validity.valid ? 'Enter a valid email address.' : '';
    setFieldError(email, emailError, message);
    return !message;
  }

  email.addEventListener('input', () => {
    // Don’t alter the user’s address while they are still typing it.
    if (email.hasAttribute('aria-invalid') && email.validity.valid) setFieldError(email, emailError, '');
    // A changed address is a new attempt: drop the countdown and re-enable Send.
    if (cooldownUntil > 0 && email.value.trim().toLowerCase() !== lastSentEmail) {
      clearCooldown();
      setOpenMailLink('');
    }
  });

  emailForm.addEventListener('submit', async (event) => {
    event.preventDefault();
    if (completed || resendBusy || verifyBusy || currentView !== 'unavailable' || cooldownUntil > Date.now()) return;
    if (!validateEmail()) {
      email.focus();
      return;
    }
    resendBusy = true;
    showNotice(emailStatus, '');
    updateRecoveryControls();
    try {
      await postJson('/auth/forgot-password', { email: email.value });
      // Deliberately identical for existing and nonexistent accounts.
      lastSentEmail = email.value.trim().toLowerCase();
      setOpenMailLink(lastSentEmail);
      showNotice(emailStatus, 'If an account exists for this email, we’ll send a password reset link. Check your inbox and spam folder.');
      startCooldown();
    } catch (error) {
      showNotice(emailStatus, error.status === 400 ? 'We couldn’t accept that request. Check the email address and try again.' : requestErrorMessage(error), true);
      if (error.status === 429) startCooldown(15 * 60 * 1000);
    } finally {
      resendBusy = false;
      updateRecoveryControls();
    }
  });

  function isMobileDevice() {
    return navigator.userAgentData?.mobile === true
      || /Android|iPhone|iPad|iPod/i.test(navigator.userAgent)
      || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1);
  }

  function clearReturnTimer() {
    if (returnTimer !== null) window.clearInterval(returnTimer);
    returnTimer = null;
    countdownLine.hidden = true;
  }

  function cancelReturn(message) {
    returnCancelled = true;
    clearReturnTimer();
    if (completed && message) {
      returnStatus.textContent = message;
      returnStatus.hidden = false;
    }
  }

  function beginReturnCountdown(mobile) {
    if (returnCancelled || automaticLaunchAttempted || document.hidden) {
      cancelReturn('Your password is changed. Use Open AnbuCRM whenever you’re ready.');
      return;
    }
    let remaining = 5;
    byId('countdown-prefix').textContent = mobile ? 'Opening AnbuCRM in' : 'Next step in';
    countdownNumber.textContent = String(remaining);
    countdownUnit.textContent = 'seconds';
    countdownLine.hidden = false;
    returnTimer = window.setInterval(() => {
      if (document.hidden || returnCancelled) {
        cancelReturn('Automatic opening is paused. Use Open AnbuCRM when you’re ready.');
        return;
      }
      remaining -= 1;
      if (remaining > 0) {
        countdownNumber.textContent = String(remaining);
        countdownUnit.textContent = remaining === 1 ? 'second' : 'seconds';
        return;
      }
      clearReturnTimer();
      returnStatus.hidden = false;
      if (!mobile) {
        returnStatus.textContent = 'Next: open AnbuCRM on your phone and sign in.';
        return;
      }
      if (automaticLaunchAttempted) return;
      automaticLaunchAttempted = true;
      returnStatus.textContent = 'If the app hasn’t opened, tap Open AnbuCRM below.';
      // One attempt only. A blocked custom scheme must never replace success.
      try {
        window.location.href = APP_URL;
      } catch {
        returnStatus.textContent = 'This browser couldn’t open the app automatically. Tap Open AnbuCRM below.';
      }
    }, 1000);
  }

  function finishReset() {
    if (completed) return;
    completed = true;
    verified = false;
    oobCode = '';
    clearPasswords();
    email.value = '';
    lastSentEmail = '';
    setOpenMailLink('');
    if (cooldownTimer !== null) window.clearInterval(cooldownTimer);
    cooldownTimer = null;
    updateRecoveryControls();
    showView('success');
    document.title = 'Password changed successfully · AnbuCRM';
    const mobile = isMobileDevice();
    byId('return-help').textContent = mobile
      ? 'Some mobile browsers block automatic app opening. If needed, tap Open AnbuCRM. Make sure the app is installed, then sign in with your new password.'
      : 'On a computer, open AnbuCRM on your phone and sign in with your new password. We won’t automatically launch a mobile-only link here. The button works on devices with AnbuCRM installed.';
    try {
      // Do not retain the one-time code in the current history entry after success.
      window.history.replaceState(null, '', window.location.pathname);
    } catch {
      // Even a restricted History API cannot undo a confirmed password change.
      cancelReturn('Your password is changed. Open AnbuCRM to continue, then close this page.');
      return;
    }
    beginReturnCountdown(mobile);
  }

  byId('open-app').addEventListener('click', () => {
    // A user-initiated launch also cancels the pending automatic attempt.
    cancelReturn('Use your new password when you sign in to AnbuCRM.');
  });

  document.addEventListener('visibilitychange', () => {
    if (document.hidden && completed) cancelReturn('Use Open AnbuCRM when you’re ready to sign in.');
  });

  window.addEventListener('pagehide', () => {
    if (completed) cancelReturn('Use Open AnbuCRM when you’re ready to sign in.');
    if (cooldownTimer !== null) window.clearInterval(cooldownTimer);
    cooldownTimer = null;
  });

  window.addEventListener('pageshow', () => {
    if (completed) {
      // A bfcache restore must never expose the form or launch the app again.
      clearPasswords();
      showView('success', false);
      setConfirmBusy(false);
      cancelReturn('Your password is already changed. Open AnbuCRM to sign in.');
    } else {
      resumeCooldown();
    }
  });

  function initialize() {
    document.documentElement.classList.remove('no-js');
    // Never accept oobCode from a query parameter. Mode is optional, but if
    // supplied in either part of the URL it must describe a password reset.
    const fragment = new URLSearchParams(window.location.hash.slice(1));
    const codes = fragment.getAll('oobCode');
    const modes = [...fragment.getAll('mode'), ...new URLSearchParams(window.location.search).getAll('mode')];
    if (modes.some((mode) => mode !== 'resetPassword')) {
      showUnavailable('This isn’t a password reset link', 'Open a password reset link from your email, or request a new one below.');
      return;
    }
    if (codes.length === 0 || (codes.length === 1 && !codes[0].trim())) {
      showUnavailable('Let’s get you a reset link', 'This page needs the complete reset link from your email. You can request a new one below.');
      return;
    }
    if (codes.length !== 1) {
      showInvalidLink();
      return;
    }
    oobCode = codes[0];
    verifyLink();
  }

  window.addEventListener('hashchange', () => window.location.reload());
  initialize();
})();
