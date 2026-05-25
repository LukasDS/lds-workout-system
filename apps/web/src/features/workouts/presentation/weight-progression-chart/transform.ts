import type { HistoryEntry, ChartDataPoint } from "../../domain/types";

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
      // Use UTC YYYY-MM-DD to ensure consistent grouping regardless of server timezone
      const year = entry.date.getUTCFullYear();
      const month = String(entry.date.getUTCMonth() + 1).padStart(2, '0');
      const day = String(entry.date.getUTCDate()).padStart(2, '0');
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
