// bridge.js — Bidirectional communication between Godot canvas and Web overlay
const listeners = new Map();

export function on(eventType, callback) {
  if (!listeners.has(eventType)) {
    listeners.set(eventType, []);
  }
  listeners.get(eventType).push(callback);
}

export function off(eventType, callback) {
  const cbs = listeners.get(eventType);
  if (cbs) {
    const idx = cbs.indexOf(callback);
    if (idx !== -1) cbs.splice(idx, 1);
  }
}

function emit(eventType, data) {
  const cbs = listeners.get(eventType);
  if (cbs) cbs.forEach(cb => cb(data));
}

// --- Godot → Web ---
window.onGodotSceneChange = function(sceneId) {
  emit('scene_change', sceneId);
};

window.onGodotChartTrigger = function(chartId, delayMs) {
  emit('chart_trigger', { chartId, delayMs: delayMs || 0 });
};

window.onGodotModeChange = function(mode) {
  emit('mode_change', mode);
};

// --- Web → Godot ---
let _godotCallbackRef = null;

window.registerGodotCallback = function(callbackRef) {
  _godotCallbackRef = callbackRef;
};

export function sendToGodot(command, payload) {
  if (_godotCallbackRef) {
    _godotCallbackRef(JSON.stringify({ command, payload }));
  } else {
    console.warn('[bridge] Godot callback not registered yet. Command:', command, payload);
  }
}

// --- Language state ---
let currentLang = 'zh';

export function setLanguage(lang) {
  currentLang = lang;
  emit('language_change', lang);
}

export function getLanguage() {
  return currentLang;
}

export function t(obj) {
  if (!obj) return '';
  if (typeof obj === 'string') return obj;
  return obj[currentLang] || obj.zh || '';
}

window.onGodotSetLanguage = function(lang) {
  setLanguage(lang);
};

// --- Loading screen ---
const loadingScreen = document.getElementById('loading-screen');
const loadingProgress = loadingScreen?.querySelector('.loading-progress');

window.onGodotLoadingProgress = function(current, total) {
  if (loadingProgress && total > 0) {
    const pct = Math.min(100, (current / total) * 100);
    loadingProgress.style.width = pct + '%';
  }
};

window.onGodotLoaded = function() {
  if (loadingScreen) {
    loadingScreen.classList.add('fade-out');
    setTimeout(() => loadingScreen.remove(), 800);
  }
};
