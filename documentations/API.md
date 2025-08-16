# QuickBite API Documentation

This document outlines the API endpoints for new and upcoming features in the QuickBite application.

## Base URL

`https://api.quickbite.com/v1`

---

## Favorites API

Handles the management of a user's favorite food items. All endpoints require user authentication (e.g., via a JWT token in the `Authorization` header).

### 1. Get User's Favorites

- **Endpoint:** `GET /favorites`
- **Description:** Retrieves a list of all favorite food items for the authenticated user.
- **Successful Response (200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "favorites": [
        {
          "id": "food_item_123",
          "name": "Classic Burger",
          "description": "A juicy beef patty with fresh vegetables.",
          "price": 9.99,
          "imageUrl": "https://cdn.example.com/burger.jpg",
          "category": "Burgers"
        },
        {
          "id": "food_item_456",
          "name": "Margherita Pizza",
          "description": "Classic pizza with tomato, mozzarella, and basil.",
          "price": 12.50,
          "imageUrl": "https://cdn.example.com/pizza.jpg",
          "category": "Pizza"
        }
      ]
    }
  }
  ```
- **Error Response (404 Not Found):**
  ```json
  {
    "status": "error",
    "message": "No favorite items found for this user."
  }
  ```

### 2. Add an Item to Favorites

- **Endpoint:** `POST /favorites`
- **Description:** Adds a food item to the user's list of favorites.
- **Request Body:**
  ```json
  {
    "foodItemId": "food_item_789"
  }
  ```
- **Successful Response (201 Created):**
  ```json
  {
    "status": "success",
    "message": "Item added to favorites successfully."
  }
  ```
- **Error Response (400 Bad Request):**
  ```json
  {
    "status": "error",
    "message": "Invalid food item ID provided."
  }
  ```
- **Error Response (409 Conflict):**
  ```json
  {
    "status": "error",
    "message": "This item is already in your favorites."
  }
  ```

### 3. Remove an Item from Favorites

- **Endpoint:** `DELETE /favorites/{foodItemId}`
- **Description:** Removes a food item from the user's list of favorites.
- **Successful Response (200 OK):**
  ```json
  {
    "status": "success",
    "message": "Item removed from favorites successfully."
  }
  ```
- **Error Response (404 Not Found):**
  ```json
  {
    "status": "error",
    "message": "Favorite item not found."
  }
  ```

---

## Search API

Provides a server-side search functionality for finding food items.

### 1. Search for Food Items

- **Endpoint:** `GET /search`
- **Description:** Searches for food items based on a query string. The search can be filtered by category, price range, etc.
- **Query Parameters:**
  - `q` (required): The search term.
  - `category` (optional): The category ID to filter by.
  - `minPrice` (optional): The minimum price.
  - `maxPrice` (optional): The maximum price.
  - `sortBy` (optional): The field to sort by (e.g., `name`, `price`).
  - `order` (optional): The sort order (`asc` or `desc`).
- **Successful Response (200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "results": [
        {
          "id": "food_item_123",
          "name": "Classic Burger",
          "description": "A juicy beef patty with fresh vegetables.",
          "price": 9.99,
          "imageUrl": "https://cdn.example.com/burger.jpg",
          "category": "Burgers"
        }
      ]
    }
  }
  ```
- **Error Response (400 Bad Request):**
  ```json
  {
    "status": "error",
    "message": "Search query parameter 'q' is required."
  }
  ```

---

## Checkout API

Handles the payment process for an order.

### 1. Process Payment

- **Endpoint:** `POST /checkout/pay`
- **Description:** Processes the payment for the user's current order. This endpoint would integrate with a payment gateway (e.g., Stripe, PayPal).
- **Request Body:**
  ```json
  {
    "orderId": "order_xyz_789",
    "paymentMethod": "stripe",
    "paymentToken": "tok_1J2x3y4z5"
  }
  ```
- **Successful Response (200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "orderId": "order_xyz_789",
      "transactionId": "txn_abc_123",
      "status": "paid"
    }
  }
  ```
- **Error Response (400 Bad Request):**
  ```json
  {
    "status": "error",
    "message": "Invalid payment token or order ID."
  }
  ```
- **Error Response (500 Internal Server Error):**
  ```json
  {
    "status": "error",
    "message": "Payment processing failed."
  }
  ```

---

## App Update API

Provides a way for the mobile client to check for new updates.

### 1. Check for Updates

- **Endpoint:** `GET /updates`
- **Description:** Checks if a new version of the app is available for a given platform and version.
- **Query Parameters:**
  - `platform` (required): The client platform (e.g., `ios`, `android`).
  - `currentVersion` (required): The current version of the app installed on the client's device (e.g., `1.0.0`).
- **Successful Response (200 OK - Update Available):**
  ```json
  {
    "status": "success",
    "data": {
      "updateAvailable": true,
      "latestVersion": "1.1.0",
      "releaseNotes": "- New feature: Dark mode\n- Bug fixes and performance improvements.",
      "updateUrl": "https://quickbite.com/update/android"
    }
  }
  ```
- **Successful Response (200 OK - No Update):**
  ```json
  {
    "status": "success",
    "data": {
      "updateAvailable": false
    }
  }
  ```
- **Error Response (400 Bad Request):**
  ```json
  {
    "status": "error",
    "message": "Platform and currentVersion are required."
  }
  ```
