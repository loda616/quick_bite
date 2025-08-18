# Suggested APIs for Future Implementation

This document contains a list of suggested APIs for features that are not yet implemented in the QuickBite application.

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

## Restaurant Feedback API

Allows users to provide general feedback about the restaurant.

### 1. Submit Feedback

- **Endpoint:** `POST /feedback`
- **Description:** Submits general feedback about the restaurant.
- **Request Body:**
  ```json
  {
    "topic": "Service",
    "message": "The delivery was very fast and the driver was friendly."
  }
  ```
- **Successful Response (201 Created):**
  ```json
  {
    "status": "success",
    "message": "Thank you for your feedback!"
  }
  ```
