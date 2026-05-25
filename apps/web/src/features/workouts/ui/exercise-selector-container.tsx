import { getExercises, getDefaultSelectedExercises } from "../api/workout-api";
import { ExerciseSelector } from "./exercise-selector";

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
