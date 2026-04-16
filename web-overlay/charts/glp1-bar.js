import { d3, createChartSvg, addTitle } from '../js/chart-utils.js';
import { t } from '../js/bridge.js';

export function renderGlp1Bar(data, containerId) {
  const { svg, width, height } = createChartSvg(containerId, { marginBottom: 80 });
  addTitle(svg, data.title, width);

  const categories = data.categories.map(c => t(c));
  const x = d3.scaleBand().domain(categories).range([0, width]).padding(0.25);
  const y = d3.scaleLinear().domain([0, 600]).range([height, 0]);

  svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height})`).call(d3.axisBottom(x).tickSize(0))
    .selectAll('text').style('font-size', '9px').style('text-anchor', 'end').attr('transform', 'rotate(-30)');
  svg.append('g').attr('class', 'axis').call(d3.axisLeft(y).ticks(6));
  svg.append('text').attr('transform', 'rotate(-90)').attr('y', -45).attr('x', -height / 2)
    .attr('text-anchor', 'middle').attr('fill', 'rgba(255,255,255,0.5)').attr('font-size', '11px').text('GLP-1 (pg/ml)');

  svg.selectAll('.bar').data(data.values).enter().append('rect')
    .attr('x', (_, i) => x(categories[i])).attr('width', x.bandwidth())
    .attr('fill', (_, i) => data.colors[i]).attr('rx', 3)
    .attr('y', height).attr('height', 0)
    .transition().duration(800).delay((_, i) => i * 100).ease(d3.easeCubicOut)
    .attr('height', d => height - y(d)).attr('y', d => y(d));
}
