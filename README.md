# LDS Workout System
**LDS Workout System** is a modern, containerized application designed to demonstrate full stack software engineering skills. It enables users to **build and manage custom workout routines, track weights lifted, calculate personalized warmup sets, and visualize progress with interactive charts**.

This project leverages a microservices architecture with **Flutter**, **Angular**, **Spring Boot**, and **PostgreSQL** for a robust, scalable solution.

## Video Demonstrations

### Mobile App
https://github.com/user-attachments/assets/82d1cfd2-f3fa-4cc4-948e-5ea1a644c24a

## Features at a Glance

- **Flexible workout routine builder** with warmup calculation suggestions
- **Edit and track weights** for each lift
- **Smart warmup calculator** based on your working weights
- **Visualize your performance** over time with dynamic graphs
- **User authentication** (post-MVP)
- **Modern cloud-native stack**: REST/gRPC APIs, message brokers, containerized services, and Postgres-backed storage

## System Overview

This project consists of several independent, containerized microservices:

- **Flutter Mobile App:** Mobile-first UI for reviewing workouts, inputting weights, and seeing warmup sets.
- **Mobile API:** Entry point and gateway for mobile app requests, routing to backend microservices.
- **Angular Web App:** Responsive interface to create/edit routines, enter weights, and view progress. Uses Signals and Standalone Components for a modern Angular experience.
- **Web API:** Frontend gateway for web app communication, relaying requests to backend services.
- **Weight Service:** Logic for managing weight data.
- **Weight Event Broker:** Asynchronous messaging service for weight updates.
- **Weight History Service:** Stores historical weight data for analysis.
- **Routine Service:** Manages creation, editing, and deletion of workout splits, routines and warmup info for exercises.
- **User Service:** Handles authentication, authorization, and user account management.
- **Communication:**  
  - **REST/HTTPS:** Frontends to APIs  
  - **gRPC/TLS:** Internal service-to-service calls
- **Database:** PostgreSQL schema optimized for fitness tracking & analytics.

## System Architecture

> The system architecture is designed using C4 container diagrams with [draw.io](draw.io) to illustrate the high-level structure and relationships between components.

### MVP
![MVP C4 Container Diagram](docs/mvp-container-diagram.svg)
- **Mobile App:** Hardcoded routine, but weights are editable, and warmup weights are displayed. Uses Cloud Firestore for data persistence.
- **Web App:** User can view their weight progression.
- **Web API:** Acts as an entry point for all web app client requests and distributes them among backend microservices.
- **Weight History Service:** Manages weights history. Uses Cloud Firestore for data retrieval.

For this stage, the system is designed to be simple and functional, focusing on core features without user management or advanced data handling. While the mobile app is functional, the rest still only locally and is not deployed.

### Version 1: Custom Routines & User Management
![Version 1 C4 Container Diagram](docs/v1-container-diagram.svg)
This version introduces user management and editable routines, allowing users to create and manage their workout, as described in the System Overview. The mobile app and web app are now fully functional, with user authentication and data persistence through PostgreSQL. The software is also containerized using Docker, making it easy to deploy and run locally or in a cloud environment.

### Version 2: Live Data & Real-Time Updates
This stage is still in the idea phase.

This version enhances the system with live data updates and real-time synchronization across devices. It introduces WebSockets and asynchronous messaging for real-time communication, allowing users to see changes in their workout data instantly. The mobile app and web app are updated to reflect these changes in real time.

## Getting Started

## Mobile
To run the mobile app, follow these steps:
1. Ensure you have [Flutter](https://docs.flutter.dev/get-started/install) and [Firebase](https://firebase.google.com/docs/flutter/setup) installed and set up on your machine.
2. Clone the repository:
3. Navigate to the `mobile` directory:
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

## Web & Microservices
To run the web app and microservices locally, follow these steps:
1. Ensure you have [Node.js](https://nodejs.org/), [Angular CLI](https://angular.io/cli), [Java 21](https://www.oracle.com/java/technologies/javase/jdk21-archive-downloads.html), and [Spring Boot](https://spring.io/projects/spring-boot) installed.
2. Clone the repository:
   ```bash
   git clone
   ```
3. Go to the Firebase Console
4. Create a new project or use an existing one.
5. Navigate to Project Settings > Service accounts.
6. Generate a new private key and download the JSON file.
7. Place this file in the `apps/weight-history-service/src/main/resources` directory as `serviceAccountKey.json`.
8. Replace the `workout-68651` firebase project ID in `apps/weight-history-service/src/main/resources/application.properties` with your Firebase project ID.
3. Run the Microservices:
   - Navigate to the `apps/weight-history-service` directory and run:
     ```bash
     ./mvnw spring-boot:run
     ```
   - Navigate to the `apps/web-api` directory and run:
     ```bash
     ./mvnw spring-boot:run
     ```
4. Run the Angular application:
   - Navigate to the `apps/web` directory and run:
     ```bash
     npm install
     npm start
     ```

## Branching Strategy

This repository follows the **[GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow)** branching strategy, with one exception tailored for solo development:

- All development occurs on feature branches, branched off `main`.
- **Exception:** As this is a solo project, pull requests are self-reviewed before being merged into `main`.
- The `main` branch always contains deployable, stable code.
- Frequent, small merges to `main` are encouraged.


## About
This demonstration project is built and maintained by Lukas Daugaard Schröder. For questions or architectural discussions, please [contact me](https://www.linkedin.com/in/lukas-daugaard-schroeder).

## Dependencies & Acknowledgments

This monorepo uses open source dependencies in Flutter, Angular, and Java. 

Dependency lists:
- Flutter: see `pubspec.yaml` 
- Angular: see `package.json`
- Spring Boot (Java): see `build.gradle`

You can generate a full tree of dependencies with the following commands:

- **Flutter**: N/A (`pubspec.yaml` lists all direct dependencies)
- **Angular**: `yarn licenses list --json` or `npx license-checker --summary`
- **Spring Boot**: `./gradlew dependencies`

For licensing details, refer to each technology’s documentation for generating third-party license reports.
