"use client";

import { useRouter, usePathname, useSearchParams } from "next/navigation";
import { useTransition } from "react";
import type { 
  ChartDataPoint, 
  ExerciseEntry 
} from "../model/types";
import { WeightProgressionChart } from "./weight-progression-chart";
import { ExerciseSelector } from "./exercise-selector";

interface WorkoutDashboardProps {
  exercises: ExerciseEntry[];
  chartData: ChartDataPoint[];
  selectedExercises: string[];
}

export function WorkoutDashboard({ 
  exercises, 
  chartData, 
  selectedExercises 
}: WorkoutDashboardProps) {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const [isPending, startTransition] = useTransition();

  const updateSelection = (newSelection: string[]) => {
    const params = new URLSearchParams(searchParams.toString());
    params.set("exercises", newSelection.join(","));
    startTransition(() => {
      router.replace(`${pathname}?${params.toString()}`, { scroll: false });
    });
  };

  const toggleExercise = (name: string) => {
    const next = selectedExercises.includes(name)
      ? selectedExercises.filter((e) => e !== name)
      : [...selectedExercises, name];
    updateSelection(next);
  };

  const selectNone = () => updateSelection([]);
  const selectTop5 = () => updateSelection(exercises.slice(0, 5).map((e) => e.name));

  return (
    <div className="flex flex-col gap-6 lg:flex-row lg:items-start">
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
        <div className="h-[600px] w-full relative">
          {isPending && (
            <div className="absolute inset-0 z-20 flex items-center justify-center bg-zinc-50/50 backdrop-blur-[1px] dark:bg-black/50">
              <div className="h-8 w-8 animate-spin rounded-full border-4 border-blue-600 border-t-transparent"></div>
            </div>
          )}
          <WeightProgressionChart 
            data={chartData} 
            selectedExercises={selectedExercises} 
          />
        </div>
      </section>
    </div>
  );
}
