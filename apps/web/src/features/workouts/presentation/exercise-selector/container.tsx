import { getExercises, getDefaultSelectedExercises } from "../../data/workout-api";
import { ExerciseSelector } from "./ui";

interface ExerciseSelectorContainerProps {
  selectedExercises?: string[];
}

export async function ExerciseSelectorContainer({ 
  selectedExercises 
}: ExerciseSelectorContainerProps) {
  const exercises = await getExercises();
  
  // If undefined (initial load), use central business logic for default selection
  const effectiveSelection = selectedExercises ?? getDefaultSelectedExercises(exercises);
  
  return (
    <ExerciseSelector 
      exercises={exercises}
      selectedExercises={effectiveSelection}
    />
  );
}
