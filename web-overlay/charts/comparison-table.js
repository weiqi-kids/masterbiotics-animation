import { d3 } from '../js/chart-utils.js';
import { t } from '../js/bridge.js';

export function renderComparisonTable(data, containerId) {
  const container = document.getElementById(containerId);
  const table = document.createElement('div');
  table.style.cssText = 'width:100%;font-size:12px;opacity:0;transition:opacity 0.6s;';
  container.appendChild(table);

  const headerRow = document.createElement('div');
  headerRow.style.cssText = 'display:grid;grid-template-columns:80px repeat(4,1fr);gap:2px;margin-bottom:4px;';
  data.headers.forEach((h, i) => {
    const cell = document.createElement('div');
    cell.style.cssText = `padding:8px 6px;background:${i === 1 ? 'rgba(255,213,79,0.15)' : 'rgba(255,255,255,0.05)'};border-radius:4px;font-weight:600;text-align:center;font-size:11px;color:${i === 1 ? '#ffd54f' : '#e0e0e0'};`;
    cell.textContent = t(h);
    headerRow.appendChild(cell);
  });
  table.appendChild(headerRow);

  data.rows.forEach((row, ri) => {
    const rowDiv = document.createElement('div');
    rowDiv.style.cssText = 'display:grid;grid-template-columns:80px repeat(4,1fr);gap:2px;margin-bottom:2px;opacity:0;transition:opacity 0.5s;';

    const labelCell = document.createElement('div');
    labelCell.style.cssText = 'padding:6px;background:rgba(255,255,255,0.03);border-radius:4px;font-size:11px;color:rgba(255,255,255,0.7);';
    labelCell.textContent = t(row.label);
    rowDiv.appendChild(labelCell);

    row.values.forEach((val, vi) => {
      const cell = document.createElement('div');
      const isHighlight = vi === 0;
      cell.style.cssText = `padding:6px;background:${isHighlight ? 'rgba(255,213,79,0.08)' : 'rgba(255,255,255,0.02)'};border-radius:4px;font-size:10px;text-align:center;color:${isHighlight ? '#ffd54f' : 'rgba(255,255,255,0.6)'};`;
      cell.textContent = typeof val === 'string' ? val : t(val);
      rowDiv.appendChild(cell);
    });

    table.appendChild(rowDiv);
    setTimeout(() => { rowDiv.style.opacity = '1'; }, 800 + ri * 400);
  });

  requestAnimationFrame(() => { table.style.opacity = '1'; });
}
