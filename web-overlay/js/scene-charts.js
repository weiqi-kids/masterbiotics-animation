import { on } from './bridge.js';
import { renderConsumerFocus } from '../charts/consumer-focus.js';
import { renderImmuneGroup } from '../charts/immune-group.js';
import { renderSurvivalLine } from '../charts/survival-line.js';
import { renderColonizationBar } from '../charts/colonization-bar.js';
import { renderGlp1Bar } from '../charts/glp1-bar.js';
import { renderDopamineBar } from '../charts/dopamine-bar.js';
import { renderSodCatalase } from '../charts/sod-catalase.js';
import { renderProteinAbsorption } from '../charts/protein-absorption.js';
import { renderBristolVisual } from '../charts/bristol-visual.js';
import { renderComparisonTable } from '../charts/comparison-table.js';

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
  scene_4: {
    render: (data) => {
      const container = document.getElementById('chart-container');
      container.style.display = 'flex';
      container.style.flexDirection = 'column';
      container.style.gap = '4px';

      const glpDiv = document.createElement('div');
      glpDiv.id = 'chart-glp1';
      glpDiv.style.flex = '1';
      container.appendChild(glpDiv);
      renderGlp1Bar(data.s4_glp1, 'chart-glp1');

      setTimeout(() => {
        glpDiv.style.transition = 'opacity 0.5s';
        glpDiv.style.opacity = '0';
        setTimeout(() => {
          glpDiv.remove();
          const dopaDiv = document.createElement('div');
          dopaDiv.id = 'chart-dopamine';
          dopaDiv.style.flex = '1';
          container.insertBefore(dopaDiv, container.firstChild);
          renderDopamineBar(data.s4_dopamine, 'chart-dopamine');
        }, 500);
      }, 20000);

      setTimeout(() => {
        container.innerHTML = '';
        renderSodCatalase(data, 'chart-container');
      }, 40000);
    }
  },
  scene_5: {
    render: (data) => {
      const container = document.getElementById('chart-container');
      container.style.display = 'flex';
      container.style.flexDirection = 'column';
      container.style.gap = '8px';

      const topDiv = document.createElement('div');
      topDiv.id = 'chart-s5-protein';
      topDiv.style.flex = '1';
      const bottomDiv = document.createElement('div');
      bottomDiv.id = 'chart-s5-bristol';
      bottomDiv.style.flex = '1';
      container.appendChild(topDiv);
      container.appendChild(bottomDiv);

      renderProteinAbsorption(data.s5_protein_output, 'chart-s5-protein');
      setTimeout(() => { renderBristolVisual(data.s5_bristol_whey, 'chart-s5-bristol'); }, 3000);
    }
  },
  scene_6: {
    render: (data) => {
      renderComparisonTable(data.s6_comparison, 'chart-container');
    }
  },
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
