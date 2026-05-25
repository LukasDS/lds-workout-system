import { cache } from "react";
import { getDb } from "@/lib/firebase/admin";
import type { ExerciseEntry, HistoryEntry } from "../domain/types";

const COLLECTION_NAME = "lukas_exercises";

/**
 * Repository for workout data.
 * Uses Firebase Admin SDK for server-side privileged access.
 */
export const WorkoutRepository = {
  /**
   * Fetches the list of exercises.
   * NOTE: N+1 query pattern maintained as requested until DB schema is updated.
   */
  getExercises: cache(async function getExercises(): Promise<ExerciseEntry[]> {
    try {
      const db = getDb();
      const querySnapshot = await db.collection(COLLECTION_NAME).get();
      
      const exercises = await Promise.all(
        querySnapshot.docs.map(async (docSnapshot) => {
          const name = docSnapshot.id;
          const data = docSnapshot.data();
          
          // Fetch only the single most recent history document
          const latestSnapshot = await db
            .collection(COLLECTION_NAME)
            .doc(name)
            .collection("history")
            .orderBy("date", "desc")
            .limit(1)
            .get();
          
          let lastUpdated: Date | null = null;
          if (!latestSnapshot.empty) {
            lastUpdated = latestSnapshot.docs[0].data().date.toDate();
          }

          return {
            name,
            currentWeight: data.currentWeight as number | null,
            lastUpdated,
          };
        })
      );

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
          date: data.date.toDate(),
        };
      });
    } catch (error) {
      throw new Error(`Failed to fetch history for ${exerciseName}: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }
};
