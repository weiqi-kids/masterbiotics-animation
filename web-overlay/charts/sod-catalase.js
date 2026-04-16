import { d3, createChartSvg, addTitle } from '../js/chart-utils.js';
import { t } from '../js/bridge.js';

function renderSingleEnzymeChart(data, containerId) {
  const { svg, width, height } = createChartSvg(containerId, { marginBottom: 70 });
  addTitle(svg, data.title, width);

  const categories = data.categories.map(c => t(c));
  const x = d3.scaleBand().domain(categories).range([0, width]).padding(0.25);
  const maxVal = d3.max(data.values) * 1.15;
  const y = d3.scaleLinear().domain([0, maxVal]).range([height, 0]);

  svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height})`).call(d3.axisBottom(x).tickSize(0))
    .selectAll('text').style('font-size', '8px').style('text-anchor', 'end').attr('transform', 'rotate(-35)')
    .each(function(d) {
      const el = d3.select(this); const lines = d.split('\n');
      if (lines.length > 1) { el.text(''); lines.forEach((line, i) => { el.append('tspan').attr('x', 0).attr('dy', i === 0 ? '0' : '1.1em').text(line); }); }
    });

  svg.append('g').attr('class', 'axis').call(d3.axisLeft(y).ticks(5));

  svg.selectAll('.bar').data(data.values).enter().append('rect')
    .attr('x', (_, i) => x(categories[i])).attr('width', x.bandwidth())
    .attr('fill', (_, i) => data.colors[i]).attr('rx', 3)
    .attr('y', height).attr('height', 0)
    .transition().duration(800).delay((_, i) => i * 100).ease(d3.easeCubicOut)
    .attr('height', d => height - y(d)).attr('y', d => y(d));
}

export function renderSodCatalase(chartData, containerId) {
  const container = document.getElementById(containerId);
  container.style.display = 'flex';
  container.style.flexDirection = 'column';
  container.style.gap = '8px';

  const topDiv = document.createElement('div');
  topDiv.id = 'chart-catalase';
  topDiv.style.flex = '1';
  const bottomDiv = document.createElement('div');
  bottomDiv.id = 'chart-sod';
  bottomDiv.style.flex = '1';
  container.appendChild(topDiv);
  container.appendChild(bottomDiv);

  renderSingleEnzymeChart(chartData.s4_catalase, 'chart-catalase');
  setTimeout(() => { renderSingleEnzymeChart(chartData.s4_sod, 'chart-sod'); }, 1000);
}
