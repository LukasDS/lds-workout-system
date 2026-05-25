import { describe, it, expect } from "vitest";
import { getDefaultSelectedExercises, validateExerciseSelection, resolveExerciseSelection } from "../logic";

describe("getDefaultSelectedExercises", () => {
  it("should return the first 5 exercise names", () => {
    const exercises = [
      { name: "A" }, { name: "B" }, { name: "C" }, { name: "D" }, { name: "E" }, { name: "F" }
    ];
    expect(getDefaultSelectedExercises(exercises)).toEqual(["A", "B", "C", "D", "E"]);
  });

  it("should return all if less than 5", () => {
    const exercises = [{ name: "A" }, { name: "B" }];
    expect(getDefaultSelectedExercises(exercises)).toEqual(["A", "B"]);
  });
});

describe("validateExerciseSelection", () => {
  const available = [
    { name: "Bench Press" },
    { name: "Squat" },
    { name: "Deadlift" }
  ];

  it("should deduplicate requested names", () => {
    const requested = ["Squat", "Squat", "Bench Press"];
    const result = validateExerciseSelection(requested, available);
    expect(result).toEqual(["Squat", "Bench Press"]);
  });

  it("should filter out names not in available list", () => {
    const requested = ["Squat", "Unknown Exercise", "Deadlift"];
    const result = validateExerciseSelection(requested, available);
    expect(result).toEqual(["Squat", "Deadlift"]);
  });

  it("should return empty array if none match", () => {
    const requested = ["Not An Exercise"];
    const result = validateExerciseSelection(requested, available);
    expect(result).toEqual([]);
  });

  it("should handle empty requested list", () => {
    const result = validateExerciseSelection([], available);
    expect(result).toEqual([]);
  });
});

describe("resolveExerciseSelection", () => {
  const available = [
    { name: "A" }, { name: "B" }, { name: "C" }, { name: "D" }, { name: "E" }, { name: "F" }
  ];

  it("should return defaults if rawRequested is undefined", () => {
    const result = resolveExerciseSelection(undefined, available);
    expect(result).toEqual(["A", "B", "C", "D", "E"]);
  });

  it("should return empty list if rawRequested is explicitly empty", () => {
    const result = resolveExerciseSelection([], available);
    expect(result).toEqual([]);
  });

  it("should return validated list if rawRequested is provided", () => {
    const result = resolveExerciseSelection(["B", "F", "Unknown"], available);
    expect(result).toEqual(["B", "F"]);
  });
});
