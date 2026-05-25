"use client";

import React, { useState } from "react";
import { cn } from "@/lib/utils";
import { Search, X, CheckCircle2 } from "lucide-react";
import type { ExerciseEntry } from "../model/types";

interface ExerciseSelectorProps {
  exercises: ExerciseEntry[];
  selectedExercises: string[];
  onToggle: (exercise: string) => void;
  onSelectNone: () => void;
  onSelectTop5: () => void;
}

export function ExerciseSelector({ 
  exercises, 
  selectedExercises, 
  onToggle,
  onSelectNone,
  onSelectTop5
}: ExerciseSelectorProps) {
  const [searchTerm, setSearchTerm] = useState("");

  const filteredExercises = exercises.filter((e) =>
    e.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const formatLastUpdated = (date: Date | null) => {
    if (!date) return "No history";
    const now = new Date();
    const diffDays = Math.floor((now.getTime() - date.getTime()) / (1000 * 3600 * 24));
    
    if (diffDays === 0) return "Today";
    if (diffDays === 1) return "Yesterday";
    if (diffDays < 7) return `${diffDays}d ago`;
    if (diffDays < 30) return `${Math.floor(diffDays / 7)}w ago`;
    return date.toLocaleDateString(undefined, { month: 'short', year: 'numeric' });
  };

  return (
    <div className="space-y-4">
      <div className="space-y-3">
        <div className="relative w-full">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-zinc-400" />
          <input
            type="text"
            placeholder="Search exercises..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full rounded-xl border border-zinc-200 bg-zinc-50 py-2.5 pl-10 pr-4 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500 dark:border-zinc-800 dark:bg-zinc-900"
          />
          {searchTerm && (
            <button
              onClick={() => setSearchTerm("")}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 hover:text-zinc-600"
            >
              <X className="h-4 w-4" />
            </button>
          )}
        </div>
        
        <div className="flex items-center justify-end gap-3 px-1">
          <button
            onClick={onSelectTop5}
            className="text-[11px] font-semibold text-blue-600 hover:text-blue-700 dark:text-blue-400"
          >
            Select Recent 5
          </button>
          <div className="h-3 w-px bg-zinc-200 dark:bg-zinc-800" />
          <button
            onClick={onSelectNone}
            className="text-[11px] font-semibold text-zinc-500 hover:text-zinc-700 dark:text-zinc-400"
          >
            Clear All
          </button>
        </div>
      </div>

      <div className="flex flex-col gap-2">
        {filteredExercises.map((exercise) => {
          const isSelected = selectedExercises.includes(exercise.name);
          return (
            <button
              key={exercise.name}
              onClick={() => onToggle(exercise.name)}
              className={cn(
                "flex items-center justify-between rounded-xl border p-3 text-left transition-all",
                isSelected
                  ? "border-blue-200 bg-blue-50 ring-1 ring-blue-200 dark:border-blue-900/50 dark:bg-blue-900/20 dark:ring-blue-900/30"
                  : "border-zinc-200 bg-white hover:border-zinc-300 hover:bg-zinc-50 dark:border-zinc-800 dark:bg-zinc-950 dark:hover:bg-zinc-900"
              )}
            >
              <div className="min-w-0">
                <div className={cn(
                  "truncate text-sm font-semibold",
                  isSelected ? "text-blue-900 dark:text-blue-100" : "text-zinc-900 dark:text-zinc-100"
                )}>
                  {exercise.name}
                </div>
                <div className="text-[10px] text-zinc-500 dark:text-zinc-400">
                  Last updated: {formatLastUpdated(exercise.lastUpdated)}
                </div>
              </div>
              {isSelected && (
                <CheckCircle2 className="h-4 w-4 flex-shrink-0 text-blue-600 dark:text-blue-400" />
              )}
            </button>
          );
        })}
      </div>
      
      {filteredExercises.length === 0 && (
        <div className="py-8 text-center text-sm text-zinc-500">
          No exercises found matching &quot;{searchTerm}&quot;
        </div>
      )}
    </div>
  );
}
