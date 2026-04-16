import { d3, createChartSvg, animateBarsIn, addTitle } from '../js/chart-utils.js';
import { t } from '../js/bridge.js';

export function renderColonizationBar(data, containerId) {
  const { svg, width, height } = createChartSvg(containerId, { marginBottom: 70 });
  addTitle(svg, data.title, width);

  const categories = data.categories.map(c => t(c));
  const x0 = d3.scaleBand().domain(categories).range([0, width]).padding(0.2);
  const x1 = d3.scaleBand().domain(data.series.map(s => t(s.name))).range([0, x0.bandwidth()]).padding(0.1);
  const y = d3.scaleLinear().domain([0, 25]).range([height, 0]);

  svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height})`).call(d3.axisBottom(x0).tickSize(0))
    .selectAll('text').style('font-size', '10px').style('text-anchor', 'middle')
    .each(function(d) {
      const el = d3.select(this); const lines = d.split('\n');
      if (lines.length > 1) { el.text(''); lines.forEach((line, i) => { el.append('tspan').attr('x', 0).attr('dy', i === 0 ? '0' : '1.1em').text(line); }); }
    });

  svg.append('g').attr('class', 'axis').call(d3.axisLeft(y).ticks(5).tickFormat(d => d + '%'));
  svg.append('text').attr('transform', 'rotate(-90)').attr('y', -45).attr('x', -height / 2).attr('text-anchor', 'middle').attr('fill', 'rgba(255,255,255,0.5)').attr('font-size', '11px').text(t({ zh: '益生菌黏附力 (%)', en: 'Probiotic Adhesion (%)' }));

  data.series.forEach((series, si) => {
    const bars = svg.selectAll(`.bar-${si}`).data(series.values).enter().append('rect')
      .attr('x', (_, i) => x0(categories[i]) + x1(t(series.name))).attr('width', x1.bandwidth())
      .attr('fill', series.color).attr('rx', 3)
      .attr('data-base-y', d => y(d)).attr('data-target-height', d => height - y(d));
    animateBarsIn(bars, { duration: 800, stagger: 150 });
  });
}
