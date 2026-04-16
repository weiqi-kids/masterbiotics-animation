import { on } from './bridge.js';
import { renderConsumerFocus } from '../charts/consumer-focus.js';

let chartData = null;
const chartContainer = document.getElementById('chart-container');

const SCENE_CHARTS = {
  scene_0: null,
  scene_1: {
    render: (data) => {
      renderConsumerFocus(data.s1_consumer_focus, 'chart-container');
    }
  },
  scene_2: null,
  scene_3: null,
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
