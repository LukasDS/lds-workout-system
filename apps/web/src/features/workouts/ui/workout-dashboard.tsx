"use client";

import { useEffect, useState } from "react";
import { 
  getExercises, 
  getCombinedHistory, 
} from "../api/workout-api";
import type { 
  ChartDataPoint, 
  ExerciseEntry 
} from "../model/types";
import { WeightProgressionChart } from "./weight-progression-chart";
import { ExerciseSelector } from "./exercise-selector";

export function WorkoutDashboard() {
  const [exercises, setExercises] = useState<ExerciseEntry[]>([]);
  const [selectedExercises, setSelectedExercises] = useState<string[]>([]);
  const [chartData, setChartData] = useState<ChartDataPoint[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Fetch exercise list on mount
  useEffect(() => {
    let isMounted = true;
    async function loadExercises() {
      try {
        const data = await getExercises();
        if (!isMounted) return;
        
        setExercises(data);
        // Default to selecting the 5 most recently updated exercises 
        // ONLY if the user hasn't already made a selection
        setSelectedExercises(prev => {
          if (prev.length > 0) return prev;
          return data.slice(0, 5).map(e => e.name);
        });
      } catch (err) {
        if (!isMounted) return;
        console.error("Failed to load exercises:", err);
        setError(err instanceof Error ? err.message : "Failed to load exercises");
      } finally {
        if (isMounted) setIsLoading(false);
      }
    }
    loadExercises();
    return () => { isMounted = false; };
  }, []);

  // Fetch chart data when selection changes
  useEffect(() => {
    let isStale = false;
    async function loadChartData() {
      if (selectedExercises.length === 0) {
        if (!isStale) setChartData([]);
        return;
      }

      try {
        const data = await getCombinedHistory(selectedExercises);
        if (!isStale) {
          setChartData(data);
        }
      } catch (err) {
        if (!isStale) {
          console.error("Failed to load chart data:", err);
        }
      }
    }
    loadChartData();
    return () => { isStale = true; };
  }, [selectedExercises]);

  const toggleExercise = (name: string) => {
    setSelectedExercises(prev => 
      prev.includes(name) 
        ? prev.filter(e => e !== name) 
        : [...prev, name]
    );
  };

  const selectNone = () => setSelectedExercises([]);
  const selectTop5 = () => setSelectedExercises(exercises.slice(0, 5).map(e => e.name));

  return (
    <div className="flex flex-col gap-6 lg:flex-row lg:items-start">
      {error && (
        <div className="w-full mb-6 rounded-xl border border-red-100 bg-red-50 p-4 text-red-700 dark:border-red-900/30 dark:bg-red-900/20 dark:text-red-400">
          {error}
        </div>
      )}

      {/* Sidebar - Exercise Selection */}
      <aside className="w-full lg:w-[320px] lg:shrink-0 lg:sticky lg:top-8 max-h-[calc(100vh-100px)] overflow-y-auto pr-4">
        <div className="mb-4 flex items-center justify-between sticky top-0 bg-zinc-50 dark:bg-black py-2 z-10">
          <h2 className="text-lg font-semibold text-zinc-900 dark:text-zinc-50">
            Exercises
          </h2>
        </div>
        <ExerciseSelector 
          exercises={exercises}
          selectedExercises={selectedExercises}
          onToggle={toggleExercise}
          onSelectNone={selectNone}
          onSelectTop5={selectTop5}
        />
      </aside>

      {/* Main Content - Chart */}
      <section className="flex-1 min-w-0">
        <div className="mb-6 flex items-center justify-between shrink-0">
          <h2 className="text-lg font-semibold text-zinc-900 dark:text-zinc-50">
            Progression Over Time
          </h2>
        </div>
        <div className="h-[600px] w-full">
          {isLoading ? (
            <div className="flex h-full items-center justify-center">
              <div className="h-8 w-8 animate-spin rounded-full border-4 border-blue-600 border-t-transparent"></div>
            </div>
          ) : (
            <WeightProgressionChart 
              data={chartData} 
              selectedExercises={selectedExercises} 
            />
          )}
        </div>
      </section>
    </div>
  );
}
