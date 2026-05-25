import { transformHistoriesToChartData } from "../logic";
import { HistoryEntry } from "../types";

// Mock implementation of a simple test runner since none is installed
function describe(name: string, fn: () => void) {
  console.log(`\n${name}`);
  fn();
}

function it(name: string, fn: () => void) {
  try {
    fn();
    console.log(`  ✓ ${name}`);
  } catch (error) {
    console.error(`  ✗ ${name}`);
    console.error(error);
    process.exit(1);
  }
}

function expect(actual: unknown) {
  return {
    toEqual(expected: unknown) {
      const a = JSON.stringify(actual);
      const e = JSON.stringify(expected);
      if (a !== e) {
        throw new Error(`Expected ${e} but got ${a}`);
      }
    },
    toHaveLength(expected: number) {
      if (!Array.isArray(actual)) {
        throw new Error(`Expected an array but got ${typeof actual}`);
      }
      if (actual.length !== expected) {
        throw new Error(`Expected length ${expected} but got ${actual.length}`);
      }
    }
  };
}

// Actual tests
describe("transformHistoriesToChartData", () => {
  it("should merge multiple exercise histories by date", () => {
    const historiesMap: Record<string, HistoryEntry[]> = {
      "Bench Press": [
        { date: new Date("2024-01-01T10:00:00"), weight: 80 },
        { date: new Date("2024-01-02T10:00:00"), weight: 82.5 },
      ],
      "Squat": [
        { date: new Date("2024-01-01T12:00:00"), weight: 100 },
        { date: new Date("2024-01-03T12:00:00"), weight: 105 },
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
      "A": [{ date: new Date("2024-01-10"), weight: 10 }],
      "B": [{ date: new Date("2024-01-01"), weight: 20 }]
    };
    const result = transformHistoriesToChartData(historiesMap);
    expect(result[0].date).toEqual("2024-01-01");
    expect(result[1].date).toEqual("2024-01-10");
  });
});
