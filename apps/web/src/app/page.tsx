import { 
  WorkoutDashboard, 
  getExercises, 
  getCombinedHistory 
} from "@/features/workouts";

export default async function Home({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}) {
  const { exercises: exercisesParam } = await searchParams;
  
  // 1. Fetch all exercises for the sidebar
  const allExercises = await getExercises();
  
  // 2. Determine which exercises are selected
  let selectedNames: string[] = [];
  if (exercisesParam !== undefined) {
    const rawValue = Array.isArray(exercisesParam) ? exercisesParam[0] : exercisesParam;
    selectedNames = (rawValue || "").split(",").filter(Boolean);
  } else {
    // Default to top 5 recent if no param is provided
    selectedNames = allExercises.slice(0, 5).map(e => e.name);
  }

  // 3. Fetch chart data for selected exercises
  const chartData = await getCombinedHistory(selectedNames);

  return (
    <div className="min-h-screen bg-zinc-50 dark:bg-black">
      <main className="mx-auto max-w-[1600px] p-4 sm:p-6 lg:p-8">
        <WorkoutDashboard 
          exercises={allExercises}
          chartData={chartData}
          selectedExercises={selectedNames}
        />
      </main>
    </div>
  );
}
