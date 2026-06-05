import { cache } from "react";
import { unstable_cache } from "next/cache";
import { getDb } from "@/lib/firebase/admin";
import type { ExerciseEntry, HistoryEntry } from "../domain/types";

const COLLECTION_NAME = "lukas_exercises";

interface SerializedExerciseEntry {
  name: string;
  currentWeight: number | null;
  lastUpdatedTime: number | null;
}

interface SerializedHistoryEntry {
  weight: number;
  dateTime: number;
}

/**
 * Underlying database fetch for exercises.
 * Returns a JSON-serializable list (Dates converted to epoch ms).
 */
const fetchExercisesRaw = async (): Promise<SerializedExerciseEntry[]> => {
  const db = getDb();
  const querySnapshot = await db.collection(COLLECTION_NAME).get();
  
  return Promise.all(
    querySnapshot.docs.map(async (docSnapshot) => {
      const name = docSnapshot.id;
      const data = docSnapshot.data();
      
      const latestSnapshot = await db
        .collection(COLLECTION_NAME)
        .doc(name)
        .collection("history")
        .orderBy("date", "desc")
        .limit(1)
        .get();
      
      let lastUpdatedTime: number | null = null;
      if (!latestSnapshot.empty) {
        lastUpdatedTime = latestSnapshot.docs[0].data().date.toDate().getTime();
      }

      return {
        name,
        currentWeight: data.currentWeight as number | null,
        lastUpdatedTime,
      };
    })
  );
};

/**
 * Underlying database fetch for a single exercise's history.
 * Returns a JSON-serializable list (Dates converted to epoch ms).
 */
const fetchExerciseHistoryRaw = async (exerciseName: string): Promise<SerializedHistoryEntry[]> => {
  const db = getDb();
  const querySnapshot = await db
    .collection(COLLECTION_NAME)
    .doc(exerciseName)
    .collection("history")
    .orderBy("date", "asc")
    .get();
  
  return querySnapshot.docs.map(doc => {
    const data = doc.data();
    return {
      weight: data.weight as number,
      dateTime: data.date.toDate().getTime(),
    };
  });
};

/**
 * Cached queries. Revalidates every 60 seconds.
 */
const getCachedExercises = unstable_cache(
  async () => fetchExercisesRaw(),
  ["exercises-list"],
  { revalidate: 60 }
);

const getCachedExerciseHistory = unstable_cache(
  async (exerciseName: string) => fetchExerciseHistoryRaw(exerciseName),
  ["exercise-history"],
  { revalidate: 60 }
);

/**
 * Repository for workout data.
 * Uses Firebase Admin SDK for server-side privileged access.
 * Leverages Next.js unstable_cache to cache database queries across requests.
 */
export const WorkoutRepository = {
  /**
   * Fetches the list of exercises.
   * NOTE: N+1 query pattern maintained as requested until DB schema is updated.
   */
  getExercises: cache(async function getExercises(): Promise<ExerciseEntry[]> {
    try {
      const cached = await getCachedExercises();
      
      const exercises = cached.map((e) => ({
        name: e.name,
        currentWeight: e.currentWeight,
        lastUpdated: e.lastUpdatedTime ? new Date(e.lastUpdatedTime) : null,
      }));

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
  }),

  /**
   * Fetches history for a specific exercise.
   */
  getExerciseHistory: async function getExerciseHistory(exerciseName: string): Promise<HistoryEntry[]> {
    try {
      const cached = await getCachedExerciseHistory(exerciseName);
      
      return cached.map(h => ({
        weight: h.weight,
        date: new Date(h.dateTime),
      }));
    } catch (error) {
      throw new Error(`Failed to fetch history for ${exerciseName}: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }
};
