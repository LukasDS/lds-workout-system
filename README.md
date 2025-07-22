# LDS Workout System
**LDS Workout System** is a modern, containerized application designed to demonstrate full stack software engineering skills. It enables users to **build and manage custom workout routines, track weights lifted, calculate personalized warmup sets, and visualize progress with interactive charts**.

This project leverages a microservices architecture with **Flutter**, **Angular**, **Spring Boot**, and **PostgreSQL** for a robust, scalable solution.

## Features at a Glance

- **Flexible workout schedule builder** with warmup calculation suggestions
- **Edit and track weights** for each lift
- **Smart warmup calculator** based on your working weights
- **Visualize your performance** over time with dynamic graphs
- **User authentication** (post-MVP)
- **Modern cloud-native stack**: REST/gRPC APIs, containerized services, and Postgres-backed storage

## System Overview

This project consists of several independent, containerized microservices:

- **Flutter Mobile App:** Mobile-first UI for reviewing workouts, inputting weights, and seeing warmup sets.
- **Mobile API:** Entry point and gateway for mobile app requests, routing to backend microservices.
- **Angular Web App:** Responsive interface to create/edit schedules, enter weights, and view progress. Uses Signals and Standalone Components for a modern Angular experience.
- **Web API:** Frontend gateway for web app communication, relaying requests to backend services.
- **Weight Service:** Logic for managing weight data and calculating warmup sets.
- **Schedule Service:** Manages creation, editing, and deletion of workout splits and routines.
- **User Service:** Handles authentication, authorization, and user account management.
- **Communication:**  
  - **REST/HTTPS:** Frontends to APIs  
  - **gRPC/TLS:** Internal service-to-service calls
- **Database:** PostgreSQL schema optimized for fitness tracking & analytics.

## System Architecture

> The system architecture is designed using C4 container diagrams with [draw.io](draw.io) to illustrate the high-level structure and relationships between components.

### MVP
![MVP C4 Container Diagram](docs/mvp-container-diagram.svg)
- **Mobile App:** Hardcoded schedule, but weights are editable, and warmup weights are displayed. Uses Cloud Firestore for data persistence.
- **Web App:** User can view their weight progression.
- **Web API:** Acts as an entry point for all web app client requests and distributes them among backend microservices.
- **Weight Service:** Manages weights and warmup calculations. Uses Cloud Firestore for data retrieval.

For this stage, the system is designed to be simple and functional, focusing on core features without user management or advanced data handling. While the mobile app is functional, the rest still only locally and is not deployed.

### Version 1: Custom Schedules & User Management
![Version 1 C4 Container Diagram](docs/v1-container-diagram.svg)
This version introduces user management and editable schedules, allowing users to create and manage their workout routines, as described in the System Overview. The mobile app and web app are now fully functional, with user authentication and data persistence through PostgreSQL. The software is also containerized using Docker, making it easy to deploy and run locally or in a cloud environment.

### Version 2: Live Data & Real-Time Updates
This stage is still in the idea phase.

This version enhances the system with live data updates and real-time synchronization across devices. It introduces WebSockets and asynchronous messaging for real-time communication, allowing users to see changes in their workout data instantly. The mobile app and web app are updated to reflect these changes in real time.

## Getting Started

*Instructions for running locally, development, and deployment coming soon.*

## Branching Strategy

This repository follows the **[GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow)** branching strategy, with one exception tailored for solo development:

- All development occurs on feature branches, branched off `main`.
- **Exception:** As this is a solo project, pull requests are self-reviewed before being merged into `main`.
- The `main` branch always contains deployable, stable code.
- Frequent, small merges to `main` are encouraged.


## About
This demonstration project is built and maintained by Lukas Daugaard Schröder. For questions or architectural discussions, please [contact me](https://www.linkedin.com/in/lukas-daugaard-schroeder).