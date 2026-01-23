# Forum Integration Guide

## Overview
The forum feature is now fully integrated with your Spring Boot backend running on `http://localhost:8082`.

## Files Structure

### Models
- **[lib/models/forum_model.dart](lib/models/forum_model.dart)** - Contains `ForumQuestion` and `ForumAnswer` classes

### Services
- **[lib/services/forum_service.dart](lib/services/forum_service.dart)** - Contains:
  - `ForumService` abstract interface
  - `MockForumService` - For testing without backend
  - `ApiForumService` - Real API integration with Spring Boot

### Controllers
- **[lib/controllers/forum_controller.dart](lib/controllers/forum_controller.dart)** - GetX controller managing forum state and operations

### Screens
- **[lib/screens/forum/forum_list_screen.dart](lib/screens/forum/forum_list_screen.dart)** - Main forum screen with question list
- **[lib/screens/forum/create_question_screen.dart](lib/screens/forum/create_question_screen.dart)** - Create new question
- **[lib/screens/forum/question_detail_screen.dart](lib/screens/forum/question_detail_screen.dart)** - View question details and answers

### Configuration
- **[lib/Config/api_config.dart](lib/Config/api_config.dart)** - API endpoints configuration

## Backend Integration

### API Endpoints Used

#### Questions
- `GET /api/v1/forum/questions` - Get all questions (supports filters: `filter`, `search`, `tag`)
- `GET /api/v1/forum/questions/{id}` - Get question by ID
- `POST /api/v1/forum/questions` - Create new question
- `POST /api/v1/forum/questions/{id}/vote` - Vote on question

#### Answers
- `GET /api/v1/forum/questions/{questionId}/answers` - Get answers for a question
- `POST /api/v1/forum/answers` - Create new answer
- `POST /api/v1/forum/answers/{id}/vote` - Vote on answer
- `PUT /api/v1/forum/answers/{id}/accept` - Accept an answer

### Request/Response Format

#### Create Question (POST /api/v1/forum/questions)
```json
{
  "title": "Question title",
  "content": "Question description/content",
  "tags": ["Flutter", "Firebase"],
  "author": "Current User"
}
```

#### Create Answer (POST /api/v1/forum/answers)
```json
{
  "questionId": 1,
  "content": "Answer content",
  "author": "Current User"
}
```

#### Vote (POST /api/v1/forum/questions/{id}/vote or /answers/{id}/vote)
```json
{
  "isUpvote": true,
  "userId": "user123"
}
```

## How to Use

### 1. Start Your Spring Boot Backend
Make sure your backend is running on port 8082:
```bash
# From your backend project directory
mvn spring-boot:run
# or
./mvnw spring-boot:run
```

### 2. Configure API URL (if needed)
Edit [lib/Config/api_config.dart](lib/Config/api_config.dart:8):
- For web/iOS simulator: `http://localhost:8082/api/v1` (current default)
- For Android emulator: `http://10.0.2.2:8082/api/v1`
- For real device: `http://YOUR_IP:8082/api/v1` (e.g., `http://192.168.1.100:8082/api/v1`)

### 3. Run the Flutter App
```bash
flutter run -d chrome  # For web
flutter run -d android # For Android
flutter run -d ios     # For iOS
```

### 4. Navigate to Forum
Add navigation to `ForumListScreen` in your app:
```dart
import 'package:codajoy/screens/forum/forum_list_screen.dart';

// In your navigation/menu
onTap: () => Get.to(() => ForumListScreen()),
```

## Features

### Forum List Screen
- View all questions with stats (votes, answers, views)
- Search questions by title, description, or tags
- Filter by: "Tous", "Sans réponse", "Résolu"
- Click on question to view details
- Floating action button to create new question

### Create Question Screen
- Enter title and description
- Add up to 5 tags (custom or suggested)
- Guidelines for asking good questions
- Form validation

### Question Detail Screen
- View full question with voting
- See all answers with voting
- Accept answers (for question author)
- Add new answers
- View author info and timestamps

## Switching Between Mock and Real API

To use mock data for testing without backend:

In [lib/controllers/forum_controller.dart](lib/controllers/forum_controller.dart:9):
```dart
// Use mock service
ForumController({ForumService? forumService})
    : forumService = forumService ?? MockForumService();

// Use real API (current default)
ForumController({ForumService? forumService})
    : forumService = forumService ?? ApiForumService();
```

## TODO - Authentication Integration

Currently, the API uses placeholder values for author and userId:
- `author: "Current User"`
- `userId: "user123"`

When you add authentication:
1. Pass auth token to `ApiForumService` constructor:
   ```dart
   ApiForumService(authToken: yourAuthToken)
   ```

2. Update author/userId fields to use actual authenticated user data

## Testing

### With Backend Running
1. Start Spring Boot backend
2. Run Flutter app
3. Test creating questions, answers, voting, etc.

### Without Backend (Mock Mode)
1. Switch to `MockForumService` in controller
2. Run Flutter app
3. Use pre-populated mock data

## Troubleshooting

### CORS Issues
Make sure your Spring Boot backend has `@CrossOrigin(origins = "*")` on the ForumController (already configured in your backend).

### Connection Refused
- Verify backend is running on port 8082
- Check API URL in `api_config.dart` matches your setup
- For Android emulator, use `10.0.2.2` instead of `localhost`
- For real device, use your computer's IP address

### JSON Parsing Errors
Check that backend response matches expected format. The service maps:
- Backend `content` → Frontend `description`
- Backend fields should include: `id`, `title`, `content`, `author`, `tags`, `votes`, `views`, `createdAt`, `answers`

## Next Steps

1. ✅ Forum UI screens created
2. ✅ GetX controller for state management
3. ✅ API service integration
4. ✅ Mock service for testing
5. ⏳ Add authentication integration
6. ⏳ Add user profile integration
7. ⏳ Add rich text editor for questions/answers
8. ⏳ Add image upload support
9. ⏳ Add notifications for new answers
