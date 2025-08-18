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

Handles the creation and payment of an order.

### 1. Create Order & Process Payment

- **Endpoint:** `POST /checkout`
- **Description:** Creates a new order and processes the payment. This is a single, atomic operation to ensure data consistency.
- **Request Body:**
  ```json
  {
    "cartItems": [
      {
        "foodItemId": "food_item_123",
        "quantity": 2
      },
      {
        "foodItemId": "food_item_456",
        "quantity": 1
      }
    ],
    "deliveryOption": "express",
    "paymentMethod": "card",
    "paymentToken": "tok_1J2x3y4z5"
  }
  ```
- **Successful Response (201 Created):**
  ```json
  {
    "status": "success",
    "data": {
      "orderId": "order_new_123",
      "transactionId": "txn_new_456",
      "status": "paid",
      "estimatedDeliveryTime": "15-20 minutes"
    }
  }
  ```
- **Error Response (400 Bad Request):**
  ```json
  {
    "status": "error",
    "message": "Invalid request body. Please check cart items and payment details."
  }
  ```
- **Error Response (500 Internal Server Error):**
  ```json
  {
    "status": "error",
    "message": "Order creation or payment processing failed."
  }
  ```

---

## About Us API

Provides endpoints for retrieving information about the restaurant.

### 1. Get Restaurant Logo

- **Endpoint:** `GET /about/logo`
- **Description:** Retrieves the URL for the restaurant's logo.
- **Successful Response (200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "logoUrl": "https://cdn.example.com/quickbite_logo.png"
    }
  }
  ```

### 2. Get About Screen Text

- **Endpoint:** `GET /about/text`
- **Description:** Retrieves the text content displayed on the "About Us" screen.
- **Successful Response (200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "title": "Welcome to QuickBite!",
      "body": "Serving the community with delicious meals since 2023. Our mission is to provide high-quality food with fast and friendly service."
    }
  }
  ```

### 3. Get Social Media Links

- **Endpoint:** `GET /about/socials`
- **Description:** Retrieves a list of the restaurant's social media profiles.
- **Successful Response (200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "socials": [
        {
          "platform": "Facebook",
          "url": "https://facebook.com/quickbite"
        },
        {
          "platform": "Instagram",
          "url": "https://instagram.com/quickbite"
        }
      ]
    }
  }
  ```

---

## Profile Management API

Handles user profile data.

### 1. Get User Profile

- **Endpoint:** `GET /profile`
- **Description:** Retrieves the profile information for the authenticated user.
- **Successful Response (200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "user": {
        "id": "user_123",
        "name": "Alex Doe",
        "email": "alex.doe@example.com",
        "phone": "123-456-7890"
      }
    }
  }
  ```

### 2. Update User Profile

- **Endpoint:** `PUT /profile`
- **Description:** Updates the profile information for the authenticated user.
- **Request Body:**
  ```json
  {
    "name": "Alexandra Doe",
    "phone": "098-765-4321"
  }
  ```
- **Successful Response (200 OK):**
  ```json
  {
    "status": "success",
    "message": "Profile updated successfully."
  }
  ```
- **Error Response (400 Bad Request):**
  ```json
  {
    "status": "error",
    "message": "Invalid data provided for update."
  }
  ```

---

## Ratings and Reviews API

Allows users to rate and review food items and the restaurant.

### 1. Add a Rating/Review for a Food Item

- **Endpoint:** `POST /reviews`
- **Description:** Adds a rating and an optional review for a specific food item.
- **Request Body:**
  ```json
  {
    "foodItemId": "food_item_123",
    "rating": 5,
    "review": "This burger was amazing! Highly recommended."
  }
  ```
- **Successful Response (201 Created):**
  ```json
  {
    "status": "success",
    "message": "Your review has been submitted."
  }
  ```

### 2. Get Reviews for a Food Item

- **Endpoint:** `GET /reviews/{foodItemId}`
- **Description:** Retrieves all reviews for a specific food item.
- **Successful Response (200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "reviews": [
        {
          "id": "review_1",
          "author": "John Doe",
          "rating": 5,
          "review": "This burger was amazing! Highly recommended.",
          "createdAt": "2023-10-27T10:00:00Z"
        }
      ]
    }
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
