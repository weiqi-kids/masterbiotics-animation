import { d3, createChartSvg, addTitle } from '../js/chart-utils.js';
import { t } from '../js/bridge.js';

export function renderSurvivalLine(data, containerId) {
  const { svg, width, height } = createChartSvg(containerId, { marginBottom: 60 });
  addTitle(svg, data.title, width);
  svg.append('text').attr('x', width / 2).attr('y', -2).attr('text-anchor', 'middle').attr('fill', 'rgba(255,255,255,0.5)').attr('font-size', '12px').text(t(data.subtitle));

  const x = d3.scalePoint().domain(data.timepoints).range([0, width]).padding(0.5);
  const y = d3.scaleLinear().domain([50, 110]).range([height, 0]);

  svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height})`).call(d3.axisBottom(x));
  svg.append('g').attr('class', 'axis').call(d3.axisLeft(y).ticks(6).tickFormat(d => d + '%'));

  const line = d3.line().x((_, i) => x(data.timepoints[i])).y(d => y(d)).curve(d3.curveMonotoneX);

  data.series.forEach((series, si) => {
    const path = svg.append('path').datum(series.values).attr('fill', 'none').attr('stroke', series.color).attr('stroke-width', 3).attr('d', line);
    const totalLength = path.node().getTotalLength();
    path.attr('stroke-dasharray', totalLength).attr('stroke-dashoffset', totalLength).transition().duration(2000).delay(si * 300).ease(d3.easeLinear).attr('stroke-dashoffset', 0);

    svg.selectAll(`.dot-${si}`).data(series.values).enter().append('circle')
      .attr('cx', (_, i) => x(data.timepoints[i])).attr('cy', d => y(d)).attr('r', 0).attr('fill', series.color)
      .transition().duration(400).delay((_, i) => 2000 + si * 300 + i * 200).attr('r', 5);
  });

  const legend = svg.append('g').attr('transform', `translate(0, ${height + 35})`);
  data.series.forEach((series, i) => {
    const g = legend.append('g').attr('transform', `translate(${i * (width / 2)}, 0)`);
    g.append('circle').attr('r', 5).attr('fill', series.color);
    g.append('text').attr('x', 12).attr('y', 4).attr('fill', '#e0e0e0').attr('font-size', '11px').text(t(series.name));
  });
}
