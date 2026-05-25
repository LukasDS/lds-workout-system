# LDS Workout System

**LDS Workout System** is a modern monorepo designed to help users manage workout routines, track weights, and calculate personalized warmup sets.

This project features a functional **Flutter** mobile application and a **Next.js** web application for data visualization, using **Firebase** for data persistence.

## Features at a Glance

- **Workout Routine Management**: Pre-configured workout splits (Quads, Chest/Back, Legs, Shoulders/Arms).
- **Weight Tracking**: Edit and track your current working weights for each exercise.
- **Smart Warmup Calculator**: Automated warmup set suggestions based on your working weights and equipment (Barbell, EZ-Bar, Dumbbells).
- **Rest Stopwatch**: Integrated timer to manage rest periods between sets.
- **Weight Progression Visualization**: Interactive charts in the web app to track strength gains over time with exercise selection and timeline zooming.
- **Data Persistence**: Real-time synchronization with Cloud Firestore.
- **Modern Stack**: Flutter for mobile, Next.js 15+ for web, and Firebase for backend services.

## System Overview

- **Flutter Mobile App (`apps/mobile`):** A feature-rich mobile UI for tracking workouts, managing weights, and viewing warmup recommendations.
- **Next.js Web App (`apps/web`):** A modern TypeScript dashboard for visualizing weight progression and long-term strength trends.
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
2. Configure environment variables:
   - Copy `.env.example` to `.env.local`.
   - Fill in your Firebase configuration keys.
3. Install dependencies:
   ```bash
   pnpm install
   ```
4. Run the development server:
   ```bash
   pnpm dev
   ```

## About
This project is built and maintained by Lukas Daugaard Schröder. For questions or architectural discussions, please [contact me](https://www.linkedin.com/in/lukas-daugaard-schroeder).

## Dependencies & Acknowledgments
- **Flutter**: cloud_firestore, firebase_core, provider, shared_preferences.
- **Next.js**: React 19, Recharts, Firebase SDK, Tailwind CSS, TypeScript.
