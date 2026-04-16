import { on, sendToGodot, t, getLanguage, setLanguage } from './bridge.js';

const SCENES = [
  { id: 'scene_0', label: { zh: '品牌登場', en: 'Opening' }, color: '#ffd54f', icon: '✦' },
  { id: 'scene_1', label: { zh: '芽孢菌的秘密', en: 'Spore Secret' }, color: '#42a5f5', icon: '🔬' },
  { id: 'scene_2', label: { zh: '體內旅程', en: 'Body Journey' }, color: '#26c6da', icon: '🧬' },
  { id: 'scene_3', label: { zh: '免疫防線', en: 'Immune' }, color: '#66bb6a', icon: '🛡' },
  { id: 'scene_4', label: { zh: '全身功效', en: 'Wellness' }, color: '#ab47bc', icon: '🧠' },
  { id: 'scene_5', label: { zh: '臨床實證', en: 'Clinical' }, color: '#ff7043', icon: '📊' },
  { id: 'scene_6', label: { zh: '市場優勢', en: 'Market' }, color: '#78909c', icon: '🏆' },
];

const menuEl = document.getElementById('touch-menu');

function buildMenu() {
  menuEl.innerHTML = '';

  const center = document.createElement('div');
  center.className = 'menu-center';
  center.innerHTML = '<span class="menu-logo">MASTERBiotics™</span>';
  menuEl.appendChild(center);

  const radius = Math.min(window.innerWidth, window.innerHeight) * 0.3;
  SCENES.forEach((scene, i) => {
    const angle = (i / SCENES.length) * Math.PI * 2 - Math.PI / 2;
    const x = Math.cos(angle) * radius;
    const y = Math.sin(angle) * radius;

    const btn = document.createElement('button');
    btn.className = 'menu-btn';
    btn.style.cssText = `transform: translate(${x}px, ${y}px); border-color: ${scene.color};`;
    btn.innerHTML = `<span class="menu-icon">${scene.icon}</span><span class="menu-label">${t(scene.label)}</span>`;
    btn.addEventListener('click', () => {
      sendToGodot('jump_to_scene', scene.id);
      hideMenu();
    });
    btn.addEventListener('touchstart', (e) => { e.stopPropagation(); });
    menuEl.appendChild(btn);
  });

  const langBtn = document.createElement('button');
  langBtn.className = 'lang-toggle';
  langBtn.textContent = getLanguage() === 'zh' ? 'EN' : '中';
  langBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    const newLang = getLanguage() === 'zh' ? 'en' : 'zh';
    setLanguage(newLang);
    sendToGodot('set_language', newLang);
    buildMenu();
  });
  menuEl.appendChild(langBtn);
}

function showMenu() {
  buildMenu();
  menuEl.classList.remove('hidden');
  requestAnimationFrame(() => menuEl.classList.add('visible'));
}

function hideMenu() {
  menuEl.classList.remove('visible');
  setTimeout(() => menuEl.classList.add('hidden'), 400);
}

on('mode_change', (mode) => {
  if (mode === 'interactive') {
    showMenu();
  } else {
    hideMenu();
  }
});
