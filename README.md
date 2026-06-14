# Flutter E-Commerce Interview Task

A fully-featured Flutter e-commerce application built to demonstrate clean architecture, optimal state management, and modern UI/UX principles. This project fulfills all mandatory and bonus requirements for the interview assignment.

## 📱 Features

* **Infinite Scroll Pagination:** Dynamically loads products in batches to optimize memory and network usage.
* **Debounced Searching:** Search bar optimized with a custom 500ms debouncer to prevent excessive API calls.
* **Category Filtering:** Horizontal scrollable chips to filter products by category.
* **Offline Caching (Bonus):** App caches the initial product payload locally and falls back to it if the device loses internet connection.
* **Wishlist & Cart (Bonus):** Users can save items to a local storage wishlist or add them to an interactive shopping cart. Data persists across app restarts using `shared_preferences`.
* **Premium UI/UX:** Built with a cohesive Dark Theme, glassmorphic UI elements, Hero animations for image transitions, and Lottie animations for empty/loading states.

## 🏗 Architecture & State Management

This project strictly adheres to the **MVVM (Model-View-ViewModel)** architectural pattern to ensure separation of concerns, testability, and scalability.

* **Models (`/models`):** Contains data classes (`Product`, `CartItem`) with JSON serialization logic.
* **Views (`/views`):** Contains the UI screens. UI components are dumb and only react to state changes.
* **ViewModels (`/viewmodels`):** Uses **Provider** (`ChangeNotifier`) to handle all business logic, pagination state, and interactions between the UI and Services.
* **Services (`/services`):** * `ApiService`: Handles HTTP requests and error interception (e.g., catching `SocketException` for offline mode).
  * `LocalStorageService`: Abstracts `shared_preferences` logic for Wishlist, Cart, and Offline Cache using full object serialization.

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (v3.0.0 or higher)
* Dart SDK
* An IDE (VS Code, Android Studio, or IntelliJ)

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <your-repository-url>
   cd interview_task