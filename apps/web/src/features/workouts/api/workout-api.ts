import { db } from "@/lib/firebase";
import { 
  collection, 
  getDocs, 
  orderBy, 
  query, 
  limit, 
  Timestamp 
} from "firebase/firestore";
import type { ExerciseEntry, HistoryEntry, ChartDataPoint } from "../model/types";
import { transformHistoriesToChartData } from "../model/logic";

const COLLECTION_NAME = "lukas_exercises";

/**
 * Fetches the list of exercises.
 * NOTE: This currently performs an N+1 query pattern by fetching the latest history entry 
 * for each exercise to determine its 'lastUpdated' status. This is a known performance 
 * bottleneck that should be remediated by denormalizing 'lastUpdated' onto the exercise document.
 */
export async function getExercises(): Promise<ExerciseEntry[]> {
  try {
    const querySnapshot = await getDocs(collection(db, COLLECTION_NAME));
    
    const exercises = await Promise.all(
      querySnapshot.docs.map(async (docSnapshot) => {
        const name = docSnapshot.id;
        const data = docSnapshot.data();
        
        // Fetch only the single most recent history document to get the timestamp
        const historyRef = collection(db, COLLECTION_NAME, name, "history");
        const latestQuery = query(historyRef, orderBy("date", "desc"), limit(1));
        const latestSnapshot = await getDocs(latestQuery);
        
        let lastUpdated: Date | null = null;
        if (!latestSnapshot.empty) {
          lastUpdated = (latestSnapshot.docs[0].data().date as Timestamp).toDate();
        }

        return {
          name,
          currentWeight: data.currentWeight as number | null,
          lastUpdated,
        };
      })
    );

    // Sort by lastUpdated desc (recency), then alphabetically for those without history
    return exercises.sort((a, b) => {
      if (a.lastUpdated && b.lastUpdated) {
        return b.lastUpdated.getTime() - a.lastUpdated.getTime();
      }
      if (a.lastUpdated) return -1;
      if (b.lastUpdated) return 1;
      return a.name.localeCompare(b.name);
    });
  } catch (error) {
    throw new Error(`Failed to fetch exercises: ${error instanceof Error ? error.message : 'Unknown error'}`);
  }
}

export async function getExerciseHistory(exerciseName: string): Promise<HistoryEntry[]> {
  try {
    const historyRef = collection(db, COLLECTION_NAME, exerciseName, "history");
    const q = query(historyRef, orderBy("date", "asc"));
    const querySnapshot = await getDocs(q);
    
    return querySnapshot.docs.map(doc => {
      const data = doc.data();
      return {
        weight: data.weight as number,
        date: (data.date as Timestamp).toDate(),
      };
    });
  } catch (error) {
    throw new Error(`Failed to fetch history for ${exerciseName}: ${error instanceof Error ? error.message : 'Unknown error'}`);
  }
}

/**
 * Merges history from multiple exercises into a single chronological array for Recharts.
 * Uses local date strings for grouping to avoid UTC shift bugs.
 */
export async function getCombinedHistory(exerciseNames: string[]): Promise<ChartDataPoint[]> {
  if (exerciseNames.length === 0) return [];

  try {
    const historiesMap: Record<string, HistoryEntry[]> = {};
    
    // Fetch all histories in parallel
    await Promise.all(
      exerciseNames.map(async (name) => {
        historiesMap[name] = await getExerciseHistory(name);
      })
    );

    return transformHistoriesToChartData(historiesMap);
  } catch (error) {
    throw new Error(`Failed to combine history: ${error instanceof Error ? error.message : 'Unknown error'}`);
  }
}
