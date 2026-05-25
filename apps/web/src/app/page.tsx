import { Suspense } from "react";
import { 
  WorkoutDashboard, 
  ExerciseSelectorContainer,
  HistoryChartContainer,
  SidebarSkeleton,
  ChartSkeleton,
} from "@/features/workouts";

export default async function Home({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}) {
  const { exercises: exercisesParam } = await searchParams;
  
  let selectedNames: string[] | undefined = undefined;
  
  if (exercisesParam !== undefined) {
    const rawValue = Array.isArray(exercisesParam) ? exercisesParam[0] : exercisesParam;
    selectedNames = (rawValue || "").split(",").filter(Boolean);
  }

  return (
    <div className="min-h-screen bg-zinc-50 dark:bg-black">
      <main className="mx-auto max-w-[1600px] p-4 sm:p-6 lg:p-8">
        <WorkoutDashboard 
          sidebar={
            <Suspense fallback={<SidebarSkeleton />}>
              <ExerciseSelectorContainer selectedExercises={selectedNames} />
            </Suspense>
          }
          chart={
            <Suspense key={JSON.stringify(selectedNames)} fallback={<ChartSkeleton />}>
              <HistoryChartContainer selectedExercises={selectedNames} />
            </Suspense>
          }
        />
      </main>
    </div>
  );
}
