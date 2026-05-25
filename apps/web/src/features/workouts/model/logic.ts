import type { HistoryEntry, ChartDataPoint } from "./types";

/**
 * Merges history from multiple exercises into a single chronological array for Recharts.
 * Uses local date strings for grouping to avoid UTC shift bugs.
 */
export function transformHistoriesToChartData(
  historiesMap: Record<string, HistoryEntry[]>
): ChartDataPoint[] {
  const dateMap: Record<string, Record<string, number>> = {};
  
  Object.entries(historiesMap).forEach(([exerciseName, entries]) => {
    entries.forEach((entry) => {
      // Use local YYYY-MM-DD to avoid UTC date shift bugs
      const year = entry.date.getFullYear();
      const month = String(entry.date.getMonth() + 1).padStart(2, '0');
      const day = String(entry.date.getDate()).padStart(2, '0');
      const dateStr = `${year}-${month}-${day}`;
      
      if (!dateMap[dateStr]) {
        dateMap[dateStr] = {};
      }
      dateMap[dateStr][exerciseName] = entry.weight;
    });
  });

  // Convert map to sorted array
  return Object.entries(dateMap)
    .sort(([dateA], [dateB]) => dateA.localeCompare(dateB))
    .map(([date, weights]) => ({
      date,
      ...weights,
    }));
}
