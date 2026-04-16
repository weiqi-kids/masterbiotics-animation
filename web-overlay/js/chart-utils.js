import * as d3 from 'https://cdn.jsdelivr.net/npm/d3@7/+esm';
import { t, getLanguage } from './bridge.js';

export function createChartSvg(containerId, { marginTop = 40, marginRight = 20, marginBottom = 50, marginLeft = 60 } = {}) {
  const container = document.getElementById(containerId) || document.getElementById('chart-container');
  const rect = container.getBoundingClientRect();
  const width = rect.width - marginLeft - marginRight;
  const height = rect.height - marginTop - marginBottom;

  d3.select(container).selectAll('svg').remove();

  const svg = d3.select(container)
    .append('svg')
    .attr('width', rect.width)
    .attr('height', rect.height)
    .append('g')
    .attr('transform', `translate(${marginLeft},${marginTop})`);

  return { svg, width, height, margin: { top: marginTop, right: marginRight, bottom: marginBottom, left: marginLeft } };
}

export function animateBarsIn(bars, { duration = 800, stagger = 100 } = {}) {
  bars
    .attr('height', 0)
    .attr('y', function() { return +this.getAttribute('data-base-y') + +this.getAttribute('data-target-height'); })
    .transition()
    .duration(duration)
    .delay((_, i) => i * stagger)
    .ease(d3.easeCubicOut)
    .attr('height', function() { return +this.getAttribute('data-target-height'); })
    .attr('y', function() { return +this.getAttribute('data-base-y'); });
}

export function addTitle(svg, titleObj, width) {
  svg.append('text')
    .attr('class', 'chart-title')
    .attr('x', width / 2)
    .attr('y', -15)
    .attr('text-anchor', 'middle')
    .text(t(titleObj));
}

export function barColor(index, colors, highlightIndices) {
  if (colors && colors[index]) return colors[index];
  if (highlightIndices && highlightIndices.includes(index)) return '#ffd54f';
  return 'rgba(255, 255, 255, 0.3)';
}

export { d3 };
