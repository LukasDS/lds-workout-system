export function ChartSkeleton() {
  return (
    <div className="w-full h-full animate-pulse flex flex-col gap-4">
      {/* Legend Skeleton */}
      <div className="flex justify-center gap-4 py-2">
        {[...Array(3)].map((_, i) => (
          <div key={i} className="flex items-center gap-2">
            <div className="h-3 w-3 rounded-full bg-zinc-200 dark:bg-zinc-800" />
            <div className="h-3 w-20 bg-zinc-200 dark:bg-zinc-800 rounded" />
          </div>
        ))}
      </div>
      
      {/* Chart Area Skeleton */}
      <div className="flex-1 rounded-2xl border border-zinc-200 bg-zinc-50/50 dark:border-zinc-800 dark:bg-zinc-900/50" />
      
      {/* Brush/Slider Skeleton */}
      <div className="h-10 w-full rounded-lg bg-zinc-100 dark:bg-zinc-900" />
    </div>
  );
}
