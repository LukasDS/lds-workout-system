# LDS Workout System

**LDS Workout System** is a modern monorepo designed to help users manage workout routines, track weights, and calculate personalized warmup sets.

This project currently features a functional **Flutter** mobile application and a foundational **Next.js** web architecture, using **Firebase** for data persistence.

## Features at a Glance

- **Workout Routine Management**: Pre-configured workout splits (Quads, Chest/Back, Legs, Shoulders/Arms).
- **Weight Tracking**: Edit and track your current working weights for each exercise.
- **Smart Warmup Calculator**: Automated warmup set suggestions based on your working weights and equipment (Barbell, EZ-Bar, Dumbbells).
- **Rest Stopwatch**: Integrated timer to manage rest periods between sets.
- **Data Persistence**: Real-time synchronization with Cloud Firestore.
- **Modern Stack**: Flutter for mobile, Next.js for web (in progress), and Firebase for backend services.

## System Overview

- **Flutter Mobile App (`apps/mobile`):** A feature-rich mobile UI for tracking workouts, managing weights, and viewing warmup recommendations.
- **Next.js Web App (`apps/web`):** A modern TypeScript web application (currently in the scaffolding phase) aimed at providing a desktop-friendly dashboard.
- **Firebase Integration:** Shared backend for data storage and real-time updates.

## Getting Started

### Mobile
To run the mobile app:
1. Ensure you have [Flutter](https://docs.flutter.dev/get-started/install) installed.
2. Navigate to `apps/mobile`.
3. Configure Firebase:
   ```bash
   flutterfire configure
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### Web
To run the web app:
1. Navigate to `apps/web`.
2. Install dependencies:
   ```bash
   pnpm install
   ```
3. Run the development server:
   ```bash
   pnpm dev
   ```

## About
This project is built and maintained by Lukas Daugaard Schröder. For questions or architectural discussions, please [contact me](https://www.linkedin.com/in/lukas-daugaard-schroeder).

## Dependencies & Acknowledgments
- **Flutter**: cloud_firestore, firebase_core, provider, shared_preferences.
- **Next.js**: React, Tailwind CSS, TypeScript.
