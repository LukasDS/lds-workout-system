import "server-only";
import * as admin from "firebase-admin";

/**
 * Initializes Firebase Admin SDK.
 * On the server, this avoids the limitations of the client SDK and 
 * bypasses Firestore Security Rules for privileged operations.
 */
function getAdminApp(): admin.app.App {
  if (admin.apps.length > 0) {
    const existingApp = admin.apps[0];
    if (existingApp) return existingApp;
  }

  const serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT;
  const projectId = process.env.FIREBASE_PROJECT_ID;

  if (serviceAccountJson) {
    try {
      const serviceAccount = JSON.parse(serviceAccountJson);
      return admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      }, "admin-app-sa");
    } catch (error) {
      throw new Error(
        `Failed to initialize Firebase Admin: FIREBASE_SERVICE_ACCOUNT is provided but invalid. ${
          error instanceof Error ? error.message : "Unknown error"
        }`
      );
    }
  }

  if (!projectId) {
    throw new Error(
      "Failed to initialize Firebase Admin: Missing FIREBASE_PROJECT_ID. Check your .env file."
    );
  }

  // Fallback to project ID (works in GCP environments or with GOOGLE_APPLICATION_CREDENTIALS)
  return admin.initializeApp({
    projectId: projectId,
  });
}

/**
 * Returns the Firestore database instance.
 * Lazily initializes the Admin SDK on first call.
 */
export function getDb(): admin.firestore.Firestore {
  const app = getAdminApp();
  return admin.firestore(app);
}
