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
