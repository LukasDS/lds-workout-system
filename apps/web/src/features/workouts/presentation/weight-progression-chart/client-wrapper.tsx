"use client";

import dynamic from "next/dynamic";
import { ChartSkeleton } from "./skeleton";
import type { ChartDataPoint } from "../../domain/types";

const WeightProgressionChart = dynamic(
  () => import("./ui").then((mod) => mod.WeightProgressionChart),
  { 
    ssr: false,
    loading: () => <ChartSkeleton />
  }
);

interface ChartClientWrapperProps {
  data: ChartDataPoint[];
  selectedExercises: string[];
}

export function ChartClientWrapper({ data, selectedExercises }: ChartClientWrapperProps) {
  return (
    <WeightProgressionChart 
      data={data} 
      selectedExercises={selectedExercises} 
    />
  );
}
