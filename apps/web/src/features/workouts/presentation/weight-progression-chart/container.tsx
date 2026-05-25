import { WorkoutRepository } from "../../data/workout-repository";
import { resolveExerciseSelection } from "../../domain/logic";
import { transformHistoriesToChartData } from "./transform";
import { ChartClientWrapper } from "./client-wrapper";
import type { HistoryEntry } from "../../domain/types";

interface WeightProgressionChartContainerProps {
  selectedExercises?: string[];
}

export async function WeightProgressionChartContainer({ 
  selectedExercises 
}: WeightProgressionChartContainerProps) {
  const exercises = await WorkoutRepository.getExercises();
  
  // Use central domain logic for determining the effective selection
  const effectiveSelection = resolveExerciseSelection(selectedExercises, exercises);
  
  if (effectiveSelection.length === 0) {
    return (
      <ChartClientWrapper 
        data={[]} 
        selectedExercises={[]} 
      />
    );
  }

  // Fetch all histories in parallel using the repository
  const historiesMap: Record<string, HistoryEntry[]> = {};
  await Promise.all(
    effectiveSelection.map(async (name) => {
      historiesMap[name] = await WorkoutRepository.getExerciseHistory(name);
    })
  );

  const chartData = transformHistoriesToChartData(historiesMap);
  
  return (
    <ChartClientWrapper 
      data={chartData} 
      selectedExercises={effectiveSelection} 
    />
  );
}
