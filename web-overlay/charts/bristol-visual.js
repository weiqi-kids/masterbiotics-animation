import { d3, createChartSvg, addTitle } from '../js/chart-utils.js';
import { t } from '../js/bridge.js';

export function renderBristolVisual(data, containerId) {
  const { svg, width, height } = createChartSvg(containerId, { marginBottom: 40 });
  const group = data.groups[1];
  addTitle(svg, group.name, width);

  const x = d3.scaleBand().domain(group.days).range([0, width]).padding(0.2);
  const y = d3.scaleLinear().domain([0, 100]).range([height, 0]);

  svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height})`).call(d3.axisBottom(x).tickSize(0));
  svg.append('g').attr('class', 'axis').call(d3.axisLeft(y).ticks(5).tickFormat(d => d + '%'));

  const stack = ['constipation', 'diarrhea', 'healthy'];
  const colors = { constipation: '#ffd54f', diarrhea: '#26c6da', healthy: '#66bb6a' };

  group.days.forEach((day, di) => {
    let yOffset = 0;
    stack.forEach(key => {
      const val = group[key][di];
      svg.append('rect').attr('x', x(day)).attr('width', x.bandwidth()).attr('fill', colors[key]).attr('rx', 2)
        .attr('y', height).attr('height', 0)
        .transition().duration(600).delay(di * 150)
        .attr('y', y(yOffset + val)).attr('height', y(yOffset) - y(yOffset + val));
      yOffset += val;
    });
  });

  svg.append('text').attr('x', width).attr('y', 30).attr('text-anchor', 'end')
    .attr('fill', '#66bb6a').attr('font-size', '16px').attr('font-weight', '600').attr('opacity', 0)
    .text(t(group.improvement))
    .transition().delay(1200).duration(500).attr('opacity', 1);
}
