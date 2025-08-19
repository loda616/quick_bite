# Suggested APIs for Future Implementation

This document contains a list of suggested APIs for features that are not yet implemented in the QuickBite application.

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
