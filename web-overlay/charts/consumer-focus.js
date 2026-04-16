import { d3, createChartSvg, animateBarsIn, addTitle } from '../js/chart-utils.js';
import { t } from '../js/bridge.js';

export function renderConsumerFocus(data, containerId) {
  const { svg, width, height } = createChartSvg(containerId);

  addTitle(svg, data.title, width);

  const x = d3.scaleBand()
    .domain(data.data.map(d => t(d.label)))
    .range([0, width])
    .padding(0.4);

  const y = d3.scaleLinear()
    .domain([0, 100])
    .range([height, 0]);

  svg.append('g')
    .attr('class', 'axis')
    .attr('transform', `translate(0,${height})`)
    .call(d3.axisBottom(x).tickSize(0))
    .selectAll('text')
    .style('font-size', '13px')
    .style('fill', '#e0e0e0');

  svg.append('g')
    .attr('class', 'axis')
    .call(d3.axisLeft(y).ticks(5).tickFormat(d => d + '%'));

  const colors = ['#42a5f5', '#ffd54f', '#78909c'];

  const bars = svg.selectAll('.bar')
    .data(data.data)
    .enter()
    .append('rect')
    .attr('class', 'bar')
    .attr('x', d => x(t(d.label)))
    .attr('width', x.bandwidth())
    .attr('fill', (_, i) => colors[i])
    .attr('rx', 4)
    .attr('data-base-y', d => y(d.value))
    .attr('data-target-height', d => height - y(d.value));

  svg.selectAll('.value-label')
    .data(data.data)
    .enter()
    .append('text')
    .attr('x', d => x(t(d.label)) + x.bandwidth() / 2)
    .attr('y', d => y(d.value) - 8)
    .attr('text-anchor', 'middle')
    .attr('fill', '#e0e0e0')
    .attr('font-size', '14px')
    .attr('font-weight', '600')
    .attr('opacity', 0)
    .text(d => d.value + '%')
    .transition()
    .delay(1200)
    .duration(400)
    .attr('opacity', 1);

  animateBarsIn(bars);
}
