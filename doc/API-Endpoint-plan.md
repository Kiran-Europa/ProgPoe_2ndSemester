# API Endpoint Plan

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **POST** | `/api/auth/register` | Registers a new user account as an Organiser or Participant. | None (public) | `{"username": "string", "email": "string", "password": "string", "userRole": "Participant"}` | `201 Created` - User object<br>`400 Bad Request`<br>`409 Conflict` |
| **POST** | `/api/auth/login` | Authenticates user credentials and returns a JWT token. | None (public) | `{"email": "string", "password": "string"}` | `200 OK` - Bearer Token<br>`401 Unauthorized` |
| **GET** | `/api/users/profile` | Retrieves current logged-in user profile details. | Any (logged in) | None | `200 OK` - User object<br>`401 Unauthorized` |
| **PUT** | `/api/users/profile` | Updates personal details for logged-in user. | Any (logged in) | `{"username": "string", "email": "string"}` | `200 OK` - Updated User object<br>`400 Bad Request` |
| **GET** | `/api/participants` | Retrieves all registered participants. | None (public) | None | `200 OK` - Array of Participant objects |
| **POST** | `/api/participants` | Registers a new participant profile. | Participant | `{"partName": "string", "partCar": "string"}` | `201 Created` - Participant object<br>`400 Bad Request` |
| **GET** | `/api/tracks` | Retrieves all race tracks. | None (public) | None | `200 OK` - Array of Track objects |
| **POST** | `/api/tracks` | Adds a new race track to the system. | Organiser | `{"trackName": "string", "trackLocation": "string", "trackGrade": "A"}` | `201 Created` - Track object<br>`400 Bad Request` |
| **GET** | `/api/events` | Retrieves all scheduled racing events. | None (public) | None | `200 OK` - Array of Event objects |
| **POST** | `/api/events` | Creates a new racing event. | Organiser | `{"eventName": "string", "trackID": 501}` | `201 Created` - Event object<br>`400 Bad Request` |
| **GET** | `/api/events/{id}/categories` | Retrieves all categories/classes for a specific event. | None (public) | None | `200 OK` - Array of Category objects<br>`404 Not Found` |
| **POST** | `/api/events/{id}/categories` | Adds a race category/class to an event. | Organiser | `{"categoryName": "SS Class", "distanceKm": 15.5}` | `201 Created` - Category object<br>`400 Bad Request` |
| **GET** | `/api/enrolments` | Retrieves all team and participant enrolments. | Organiser | None | `200 OK` - Array of Enrolment objects |
| **POST** | `/api/enrolments` | Enrolls a participant or team into an event category. | Participant | `{"teamID": 401, "categoryID": 10}` | `201 Created` - Enrolment object<br>`400 Bad Request`<br>`409 Conflict` |
| **POST** | `/api/results` | Records official race result for an enrolment. | Organiser | `{"enrolmentID": 701, "completionTime": "01:23:45", "position": 1}` | `201 Created` - Result object<br>`400 Bad Request` |
| **GET** | `/api/results/category/{categoryId}` | Retrieves leaderboard results for a specific category. | None (public) | None | `200 OK` - Array of sorted Result objects |
| **GET** | `/api/fees` | Retrieves all fee payment records. | Organiser | None | `200 OK` - Array of Fee objects |
| **POST** | `/api/fees` | Records a new fee payment entry. | Organiser | `{"feePaid": "Yes", "feeDiscount": "No", "feeAmount": "5500", "partID": 201}` | `201 Created` - Fee object<br>`400 Bad Request` |