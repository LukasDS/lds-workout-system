"use client";

import { type ReactNode } from "react";

interface WorkoutDashboardProps {
  sidebar: ReactNode;
  chart: ReactNode;
}

export function WorkoutDashboard({ 
  sidebar, 
  chart 
}: WorkoutDashboardProps) {
  return (
    <div className="flex flex-col gap-6 lg:flex-row lg:items-start">
      {/* Sidebar - Exercise Selection */}
      <aside className="w-full lg:w-[320px] lg:shrink-0 lg:sticky lg:top-8 max-h-[calc(100vh-100px)] overflow-y-auto pr-4">
        <div className="mb-4 flex items-center justify-between sticky top-0 bg-zinc-50 dark:bg-black py-2 z-10">
          <h2 className="text-lg font-semibold text-zinc-900 dark:text-zinc-50">
            Exercises
          </h2>
        </div>
        {sidebar}
      </aside>

      {/* Main Content - Chart */}
      <section className="flex-1 min-w-0">
        <div className="mb-6 flex items-center justify-between shrink-0">
          <h2 className="text-lg font-semibold text-zinc-900 dark:text-zinc-50">
            Progression Over Time
          </h2>
        </div>
        <div className="h-[600px] w-full relative">
          {chart}
        </div>
      </section>
    </div>
  );
}
