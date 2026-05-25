import { WorkoutDashboard } from "@/features/workouts";

export default function Home() {
  return (
    <div className="min-h-screen bg-zinc-50 dark:bg-black">
      <main className="mx-auto max-w-[1600px] p-4 sm:p-6 lg:p-8">
        <WorkoutDashboard />
      </main>
    </div>
  );
}
