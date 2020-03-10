requireModernBrowser = document.getElementById('require-modern-browser')
okModernBrowser = document.getElementById('ok-modern-browser')
if window.Promise?
  okModernBrowser.classList.remove('d-none')
else
  requireModernBrowser.classList.remove('d-none')
