"use client";

import { useEffect, useState } from "react";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Legend,
  Brush,
} from "recharts";
import type { ChartDataPoint } from "../model/types";

interface WeightProgressionChartProps {
  data: ChartDataPoint[];
  selectedExercises: string[];
}

const COLORS = [
  "#2563eb", // blue-600
  "#dc2626", // red-600
  "#16a34a", // green-600
  "#ca8a04", // yellow-600
  "#9333ea", // purple-600
  "#0891b2", // cyan-600
  "#ea580c", // orange-600
  "#4f46e5", // indigo-600
  "#db2777", // pink-600
  "#4d7c0f", // lime-700
];

export function WeightProgressionChart({ data, selectedExercises }: WeightProgressionChartProps) {
  const [hasMounted, setHasMounted] = useState(false);

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setHasMounted(true);
  }, []);

  if (data.length === 0) {
    return (
      <div className="flex h-full flex-col items-center justify-center rounded-2xl border border-dashed border-zinc-300 dark:border-zinc-800">
        <p className="text-zinc-500">No data available for the selected exercises.</p>
        <p className="text-sm text-zinc-400">Select exercises above to see their progression.</p>
      </div>
    );
  }

  const formatDate = (dateValue: unknown) => {
    try {
      const dateStr = String(dateValue);
      const date = new Date(dateStr);
      if (isNaN(date.getTime())) return dateStr;
      return date.toLocaleDateString(undefined, { month: "short", day: "numeric" });
    } catch {
      return String(dateValue);
    }
  };

  if (!hasMounted) {
    return <div className="w-full h-[550px] bg-zinc-50/50 animate-pulse rounded-2xl dark:bg-zinc-900/50" />;
  }

  return (
    <div className="w-full h-full min-w-0">
      <ResponsiveContainer width="100%" height="100%">
        <LineChart data={data} margin={{ top: 10, right: 80, left: 40, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#e5e7eb" opacity={0.5} />
          <XAxis 
            dataKey="date" 
            tick={{ fontSize: 11, fill: '#71717a' }} 
            tickLine={false}
            axisLine={false}
            dy={10}
            tickFormatter={formatDate}
          />
          <YAxis 
            tick={{ fontSize: 11, fill: '#71717a' }} 
            tickLine={false}
            axisLine={false}
            unit="kg"
            width={40}
          />
          <Tooltip 
            labelFormatter={formatDate}
            contentStyle={{ 
              borderRadius: '12px', 
              border: '1px solid #e4e4e7',
              boxShadow: '0 10px 15px -3px rgb(0 0 0 / 0.1)',
              backgroundColor: 'rgba(255, 255, 255, 0.95)',
              backdropFilter: 'blur(4px)'
            }}
            itemStyle={{ fontSize: '12px', padding: '2px 0' }}
          />
          <Legend 
            verticalAlign="top" 
            height={50} 
            iconType="circle"
            wrapperStyle={{ fontSize: '12px', paddingTop: '10px' }}
          />
          {selectedExercises.map((exercise, index) => (
            <Line
              key={exercise}
              type="stepAfter"
              dataKey={exercise}
              stroke={COLORS[index % COLORS.length]}
              strokeWidth={2.5}
              dot={{ r: 3, strokeWidth: 1, fill: COLORS[index % COLORS.length] }}
              activeDot={{ r: 5, strokeWidth: 0 }}
              connectNulls
              animationDuration={500}
            />
          ))}
          <Brush 
            dataKey="date" 
            height={40} 
            stroke="#94a3b8" 
            fill="rgba(148, 163, 184, 0.05)"
            travellerWidth={12}
            tickFormatter={formatDate}
            gap={20}
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
