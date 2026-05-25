import { describe, it, expect } from "vitest";
import { transformHistoriesToChartData } from "../transform";
import { HistoryEntry } from "../../../domain/types";

describe("transformHistoriesToChartData", () => {
  it("should merge multiple exercise histories by date using UTC boundaries", () => {
    const historiesMap: Record<string, HistoryEntry[]> = {
      "Bench Press": [
        { date: new Date(Date.UTC(2024, 0, 1, 10, 0, 0)), weight: 80 },
        { date: new Date(Date.UTC(2024, 0, 2, 10, 0, 0)), weight: 82.5 },
      ],
      "Squat": [
        { date: new Date(Date.UTC(2024, 0, 1, 12, 0, 0)), weight: 100 },
        { date: new Date(Date.UTC(2024, 0, 3, 12, 0, 0)), weight: 105 },
      ]
    };

    const result = transformHistoriesToChartData(historiesMap);

    expect(result).toHaveLength(3);
    expect(result[0]).toEqual({ date: "2024-01-01", "Bench Press": 80, "Squat": 100 });
    expect(result[1]).toEqual({ date: "2024-01-02", "Bench Press": 82.5 });
    expect(result[2]).toEqual({ date: "2024-01-03", "Squat": 105 });
  });

  it("should handle empty history map", () => {
    const result = transformHistoriesToChartData({});
    expect(result).toHaveLength(0);
  });

  it("should sort results by date ascending", () => {
    const historiesMap: Record<string, HistoryEntry[]> = {
      "A": [{ date: new Date(Date.UTC(2024, 0, 10)), weight: 10 }],
      "B": [{ date: new Date(Date.UTC(2024, 0, 1)), weight: 20 }]
    };
    const result = transformHistoriesToChartData(historiesMap);
    expect(result[0].date).toEqual("2024-01-01");
    expect(result[1].date).toEqual("2024-01-10");
  });
});
