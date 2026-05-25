import { getCombinedHistory, getExercises, getDefaultSelectedExercises } from "../api/workout-api";
import { WeightProgressionChart } from "./weight-progression-chart";

interface HistoryChartContainerProps {
  selectedExercises?: string[];
}

export async function HistoryChartContainer({ 
  selectedExercises 
}: HistoryChartContainerProps) {
  let effectiveSelection = selectedExercises;
  
  // If undefined (initial load), use central business logic for default selection
  if (effectiveSelection === undefined) {
    const exercises = await getExercises();
    effectiveSelection = getDefaultSelectedExercises(exercises);
  }
  
  const chartData = await getCombinedHistory(effectiveSelection);
  
  return (
    <WeightProgressionChart 
      data={chartData} 
      selectedExercises={effectiveSelection} 
    />
  );
}
