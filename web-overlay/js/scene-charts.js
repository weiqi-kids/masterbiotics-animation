import { on } from './bridge.js';
import { renderConsumerFocus } from '../charts/consumer-focus.js';
import { renderImmuneGroup } from '../charts/immune-group.js';
import { renderSurvivalLine } from '../charts/survival-line.js';
import { renderColonizationBar } from '../charts/colonization-bar.js';

let chartData = null;
const chartContainer = document.getElementById('chart-container');

const SCENE_CHARTS = {
  scene_0: null,
  scene_1: {
    render: (data) => {
      renderConsumerFocus(data.s1_consumer_focus, 'chart-container');
    }
  },
  scene_2: {
    render: (data) => {
      const container = document.getElementById('chart-container');
      const topDiv = document.createElement('div');
      topDiv.id = 'chart-s2-survival';
      topDiv.style.flex = '1';
      const bottomDiv = document.createElement('div');
      bottomDiv.id = 'chart-s2-colonization';
      bottomDiv.style.flex = '1';
      container.appendChild(topDiv);
      container.appendChild(bottomDiv);
      renderSurvivalLine(data.s2_survival_rate, 'chart-s2-survival');
      setTimeout(() => {
        renderColonizationBar(data.s2_colonization, 'chart-s2-colonization');
      }, 40000);
    }
  },
  scene_3: {
    render: (data) => {
      renderImmuneGroup(data, 'chart-container');
    }
  },
  scene_4: null,
  scene_5: null,
  scene_6: null,
};

async function init() {
  const resp = await fetch('data/chart-data.json');
  chartData = await resp.json();

  on('scene_change', (sceneId) => {
    chartContainer.innerHTML = '';

    const config = SCENE_CHARTS[sceneId];
    if (config) {
      chartContainer.classList.remove('fullscreen-hidden');
      chartContainer.classList.add('visible');
      config.render(chartData);
    } else {
      chartContainer.classList.add('fullscreen-hidden');
      chartContainer.classList.remove('visible');
    }
  });

  on('mode_change', (mode) => {
    if (mode === 'interactive') {
      // Touch menu handles its own visibility
    }
  });
}

init();
