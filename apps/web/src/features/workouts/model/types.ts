export interface ExerciseEntry {
  name: string;
  currentWeight: number | null;
  lastUpdated: Date | null;
}

export interface HistoryEntry {
  weight: number;
  date: Date;
}

export interface ChartDataPoint {
  date: string;
  [exerciseName: string]: number | string;
}
