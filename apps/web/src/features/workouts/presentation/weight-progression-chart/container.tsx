import { getCombinedHistory, getExercises, getDefaultSelectedExercises } from "../../data/workout-api";
import { WeightProgressionChart } from "./ui";

interface WeightProgressionChartContainerProps {
  selectedExercises?: string[];
}

export async function WeightProgressionChartContainer({ 
  selectedExercises 
}: WeightProgressionChartContainerProps) {
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
