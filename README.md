# UEMF Restaurant

A comprehensive mobile application for managing and ordering from the UEMF Restaurant. This project features a dual-interface Flutter application serving both Administrators and Customers.

## Project Overview

The solution is built with **Flutter** and serves two distinct user roles:

*   **User App**: allows students and staff to browse daily menus, order meals, view upcoming schedules, and manage their cart.
*   **Admin Panel**: empowers restaurant staff to manage products, track orders in real-time, view analytics, and update the menu.

## Repository Structure

*   **`mobiledev/`**: Contains the complete source code for the Flutter mobile application.
    *   `lib/admin/`: Admin-specific screens and logic.
    *   `lib/user/`: User-specific screens and logic.
    *   `lib/login/`: Shared authentication and routing logic.

## Features

### Admin Side
*   **Dashboard**: View active orders and key metrics.
*   **Product Management**: Add, edit, or remove menu items with image support.
*   **Statistics**: Visual charts for revenue, popular items, and customer activity.
*   **Order Control**: Accept or refuse orders with status updates.

### User Side
*   **Menu Browsing**: Filter by category (Breakfast, Lunch, etc.) and search items.
*   **Ordering**: seamless cart management and order placement.
*   **History**: View past orders and status.
*   **Upcoming**: Check future menu items.

## Technology Stack

*   **Framework**: Flutter
*   **Backend**: Firebase (Firestore, Storage) via `cloud_firestore` & `firebase_storage`.
*   **State Management**: Provider
*   **Charts**: `fl_chart`
*   **Local Storage**: `shared_preferences`

## Getting Started

### Prerequisites

*   Flutter SDK installed (tested with v3.x)
*   Dart SDK
*   Android Studio / VS Code with Flutter extensions

### Installation

1.  Clone the repository:
    ```bash
    git clone <repository-url>
    ```

2.  Navigate to the mobile project directory:
    ```bash
    cd UEMF-Restaurant/mobiledev
    ```

3.  Install dependencies:
    ```bash
    flutter pub get
    ```

4.  Run the application:
    ```bash
    flutter run
    ```

## Credentials (Mock/Test)

*   **Admin Access**:
    *   Email: `admin@restaurant.com`
    *   Password: `123456`

*   **User Access**:
    *   Email: `user@restaurant.com`
    *   Password: `123456`

## 📄 Documentation

For more detailed documentation on specific modules, refer to the docs inside the `mobiledev` folder:
*   [Admin App Analysis](mobiledev/ADMIN_APP_ANALYSIS.md)
*   [Login Documentation](mobiledev/LOGIN_DOCS.md)
*   [Product Features](mobiledev/PRODUCT_FEATURES.md)
