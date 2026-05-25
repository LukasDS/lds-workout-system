import { WorkoutRepository } from "../../data/workout-repository";
import { resolveExerciseSelection } from "../../domain/logic";
import { ExerciseSelector } from "./ui";

interface ExerciseSelectorContainerProps {
  selectedExercises?: string[];
}

export async function ExerciseSelectorContainer({ 
  selectedExercises 
}: ExerciseSelectorContainerProps) {
  const exercises = await WorkoutRepository.getExercises();
  
  // Use central domain logic for determining the effective selection
  const effectiveSelection = resolveExerciseSelection(selectedExercises, exercises);
  
  return (
    <ExerciseSelector 
      exercises={exercises}
      selectedExercises={effectiveSelection}
    />
  );
}
