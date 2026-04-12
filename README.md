# LDS Workout System
**LDS Workout System** is a modern application designed to help users **build and manage custom workout routines, track weights lifted, calculate personalized warmup sets, and visualize progress**.

This project features a **Flutter** mobile application and is transitioning towards a consolidated **Next.js** web architecture using **Firebase** for data persistence.

## Video Demonstrations

### Mobile App
https://github.com/user-attachments/assets/82d1cfd2-f3fa-4cc4-948e-5ea1a644c24a

## Features at a Glance

- **Flexible workout routine builder** with warmup calculation suggestions
- **Edit and track weights** for each lift
- **Smart warmup calculator** based on your working weights
- **Visualize your performance** over time with dynamic graphs
- **User authentication** (via Firebase)
- **Modern stack**: Flutter for mobile, Next.js (planned) for web, and Firebase for real-time data and storage.

## System Overview

- **Flutter Mobile App:** Mobile-first UI for reviewing workouts, inputting weights, and seeing warmup sets. Uses Cloud Firestore for data persistence.
- **Next.js Web App (In Progress):** Consolidating legacy services into a modern, unified TypeScript web application.

## Getting Started

### Mobile
To run the mobile app, follow these steps:
1. Ensure you have [Flutter](https://docs.flutter.dev/get-started/install) and [Firebase](https://firebase.google.com/docs/flutter/setup) installed and set up on your machine.
2. Clone the repository.
3. Navigate to the `apps/mobile` directory.
4. Login to Firebase:
   ```bash
   firebase login
   ```
5. Install flutterfire CLI:
    ```bash
    dart pub global activate flutterfire_cli
    ```
6. Configure Firebase for the project:
    ```bash
    flutterfire configure
    ```
7. Connect your device or start an emulator.
8. Run the app:
   ```bash
   flutter run
   ```

## About
This demonstration project is built and maintained by Lukas Daugaard Schröder. For questions or architectural discussions, please [contact me](https://www.linkedin.com/in/lukas-daugaard-schroeder).

## Dependencies & Acknowledgments

This monorepo uses open source dependencies.

- **Flutter**: See `apps/mobile/pubspec.yaml` for details.
