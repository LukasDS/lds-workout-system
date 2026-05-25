export function SidebarSkeleton() {
  return (
    <div className="space-y-4 animate-pulse">
      <div className="space-y-3">
        {/* Search Bar Skeleton */}
        <div className="h-10 w-full rounded-xl bg-zinc-200 dark:bg-zinc-800" />
        
        {/* Action Buttons Skeleton */}
        <div className="flex justify-end gap-3 px-1">
          <div className="h-3 w-20 bg-zinc-200 dark:bg-zinc-800 rounded" />
          <div className="h-3 w-px bg-zinc-200 dark:bg-zinc-800" />
          <div className="h-3 w-16 bg-zinc-200 dark:bg-zinc-800 rounded" />
        </div>
      </div>

      {/* Exercise Cards Skeleton */}
      <div className="flex flex-col gap-2">
        {[...Array(8)].map((_, i) => (
          <div 
            key={i}
            className="h-[68px] w-full rounded-xl border border-zinc-200 bg-white p-3 dark:border-zinc-800 dark:bg-zinc-950"
          >
            <div className="h-4 w-2/3 bg-zinc-200 dark:bg-zinc-800 rounded mb-2" />
            <div className="h-3 w-1/3 bg-zinc-100 dark:bg-zinc-900 rounded" />
          </div>
        ))}
      </div>
    </div>
  );
}

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
