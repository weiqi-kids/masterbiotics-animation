import { d3, createChartSvg, addTitle } from '../js/chart-utils.js';
import { t } from '../js/bridge.js';

function renderSmallBar(container, dataset, chartIndex, { delayMs = 0 } = {}) {
  const div = document.createElement('div');
  div.id = `immune-chart-${chartIndex}`;
  div.style.flex = '1';
  div.style.minHeight = '0';
  div.style.opacity = '0';
  div.style.transition = 'opacity 0.5s ease';
  container.appendChild(div);

  setTimeout(() => {
    div.style.opacity = '1';
    const rect = div.getBoundingClientRect();
    const margin = { top: 25, right: 10, bottom: 30, left: 45 };
    const width = rect.width - margin.left - margin.right;
    const height = rect.height - margin.top - margin.bottom;
    if (width <= 0 || height <= 0) return;

    const svg = d3.select(div).append('svg').attr('width', rect.width).attr('height', rect.height)
      .append('g').attr('transform', `translate(${margin.left},${margin.top})`);

    svg.append('text').attr('class', 'chart-title').attr('x', width / 2).attr('y', -10)
      .attr('text-anchor', 'middle').attr('font-size', '13px').text(t(dataset.title));

    const x = d3.scaleBand().domain(dataset.categories).range([0, width]).padding(0.3);
    const maxVal = d3.max(dataset.values) * 1.15;
    const y = d3.scaleLinear().domain([0, maxVal]).range([height, 0]);

    svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height})`).call(d3.axisBottom(x).tickSize(0)).selectAll('text').style('font-size', '9px');
    svg.append('g').attr('class', 'axis').call(d3.axisLeft(y).ticks(4));

    const highlight = dataset.highlight || [];
    svg.selectAll('.bar').data(dataset.values).enter().append('rect')
      .attr('x', (_, i) => x(dataset.categories[i])).attr('width', x.bandwidth())
      .attr('fill', (_, i) => {
        if (highlight.includes(i)) return i === highlight[0] ? '#ffd54f' : '#42a5f5';
        return 'rgba(255, 255, 255, 0.25)';
      })
      .attr('rx', 3).attr('y', height).attr('height', 0)
      .transition().duration(600).delay((_, i) => i * 80).ease(d3.easeCubicOut)
      .attr('height', d => height - y(d)).attr('y', d => y(d));
  }, delayMs);
}

export function renderImmuneGroup(chartData, containerId) {
  const container = document.getElementById(containerId);
  container.style.display = 'flex';
  container.style.flexDirection = 'column';
  container.style.gap = '4px';

  const datasets = [
    chartData.s3_ifn_beta, chartData.s3_ifn_gamma, chartData.s3_tgf_beta,
    chartData.s3_il4, chartData.s3_ifn_il4_ratio,
  ];

  datasets.forEach((ds, i) => {
    renderSmallBar(container, ds, i, { delayMs: i * 8000 });
  });
}
