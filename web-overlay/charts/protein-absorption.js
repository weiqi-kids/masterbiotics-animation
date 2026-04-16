import { d3, createChartSvg, addTitle } from '../js/chart-utils.js';
import { t } from '../js/bridge.js';

export function renderProteinAbsorption(data, containerId) {
  const { svg, width, height } = createChartSvg(containerId);
  addTitle(svg, data.title, width);

  const proteins = data.groups;
  const x0 = d3.scaleBand().domain(proteins.map(p => t(p.protein))).range([0, width]).padding(0.2);
  const x1 = d3.scaleBand().domain(['no_probiotic', 'bc', 'bs']).range([0, x0.bandwidth()]).padding(0.1);
  const y = d3.scaleLinear().domain([0, 50]).range([height, 0]);

  svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height})`).call(d3.axisBottom(x0).tickSize(0));
  svg.append('g').attr('class', 'axis').call(d3.axisLeft(y).ticks(5).tickFormat(d => d + 'g'));

  const colorMap = { no_probiotic: 'rgba(255,255,255,0.3)', bc: '#ffd54f', bs: '#42a5f5' };

  proteins.forEach((p, pi) => {
    ['no_probiotic', 'bc', 'bs'].forEach(key => {
      const val = p[key];
      svg.append('rect')
        .attr('x', x0(t(p.protein)) + x1(key)).attr('width', x1.bandwidth())
        .attr('fill', colorMap[key]).attr('rx', 3)
        .attr('y', height).attr('height', 0)
        .transition().duration(800).delay(pi * 200).ease(d3.easeCubicOut)
        .attr('y', y(val)).attr('height', height - y(val));
    });
  });

  svg.append('text').attr('x', width / 2).attr('y', height / 4).attr('text-anchor', 'middle')
    .attr('fill', '#ffd54f').attr('font-size', '28px').attr('font-weight', '700').attr('opacity', 0)
    .text(t({ zh: '吸收率提升 200%+', en: 'Absorption +200%+' }))
    .transition().delay(1500).duration(600).attr('opacity', 1);
}
