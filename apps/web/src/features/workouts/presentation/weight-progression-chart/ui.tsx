"use client";

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
  type TooltipContentProps,
} from "recharts";
import type { ChartDataPoint } from "../../domain/types";
import type { ValueType, NameType } from "recharts/types/component/DefaultTooltipContent";

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

const formatDate = (dateValue: unknown) => {
  try {
    const dateStr = String(dateValue);
    // Parse YYYY-MM-DD as a local date to avoid UTC shift bugs
    const [year, month, day] = dateStr.split("-").map(Number);
    if (!isNaN(year) && !isNaN(month) && !isNaN(day)) {
      const date = new Date(year, month - 1, day);
      return date.toLocaleDateString(undefined, { month: "short", day: "numeric" });
    }
    return dateStr;
  } catch {
    return String(dateValue);
  }
};

function CustomTooltip({ active, payload, label }: TooltipContentProps<ValueType, NameType>) {
  if (active && payload && payload.length) {
    return (
      <div className="bg-white/95 dark:bg-zinc-950/95 border border-zinc-200 dark:border-zinc-800 shadow-xl rounded-xl p-3 backdrop-blur-sm">
        <p className="text-xs font-medium text-zinc-500 dark:text-zinc-400 mb-2">{formatDate(label)}</p>
        <div className="space-y-1.5">
          {payload.map((entry) => (
            <div key={entry.name} className="flex items-center gap-2">
              <div 
                className="w-2 h-2 rounded-full" 
                style={{ backgroundColor: entry.color }}
              />
              <span className="text-xs font-semibold text-zinc-900 dark:text-zinc-100">
                {entry.name}:
              </span>
              <span className="text-xs text-zinc-700 dark:text-zinc-300">
                {entry.value}kg
              </span>
            </div>
          ))}
        </div>
      </div>
    );
  }

  return null;
}

export function WeightProgressionChart({ data, selectedExercises }: WeightProgressionChartProps) {
  if (data.length === 0) {
    return (
      <div className="flex h-full flex-col items-center justify-center rounded-2xl border border-dashed border-zinc-300 dark:border-zinc-800">
        <p className="text-zinc-500">No data available for the selected exercises.</p>
        <p className="text-sm text-zinc-400">Select exercises above to see their progression.</p>
      </div>
    );
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
          <Tooltip content={CustomTooltip} />
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
