/**
 * Returns the default list of exercise names to select (Top 5 most recent).
 */
export function getDefaultSelectedExercises(exercises: { name: string }[]): string[] {
  return exercises.slice(0, 5).map((e) => e.name);
}

/**
 * Sanitizes and validates the user-requested exercise selection.
 * Handles deduplication and filters out names that don't exist in the available list.
 */
export function validateExerciseSelection(
  requested: string[],
  available: { name: string }[]
): string[] {
  const availableNames = new Set(available.map((e) => e.name));
  const uniqueRequested = Array.from(new Set(requested));
  
  return uniqueRequested.filter((name) => availableNames.has(name));
}

/**
 * Resolves the effective exercise selection based on user request and available exercises.
 * Centralizes the policy: if undefined (initial load), use default 5; 
 * otherwise (even if empty) respect the user's explicit selection.
 */
export function resolveExerciseSelection(
  rawRequested: string[] | undefined,
  available: { name: string }[]
): string[] {
  if (rawRequested === undefined) {
    return getDefaultSelectedExercises(available);
  }
  return validateExerciseSelection(rawRequested, available);
}
