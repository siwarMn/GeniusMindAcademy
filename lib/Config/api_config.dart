// API Configuration
class ApiConfig {
  // Configuration pour le backend Spring Boot sur le port 8082
  //
  // IMPORTANT: Choisissez l'URL appropriée selon votre environnement:
  //
  // 1. Pour l'émulateur Android: utilisez 10.0.2.2 au lieu de localhost
  //    L'émulateur Android mappe 10.0.2.2 vers localhost de votre machine hôte
  static const String baseUrl = 'http://localhost:8082/api/v1';

  // 2. Pour iOS Simulator ou Web: utilisez localhost
  // static const String baseUrl = 'http://localhost:8082/api/v1';

  // 3. Pour un appareil réel: utilisez l'adresse IP de votre ordinateur
  //    Trouvez votre IP avec: ipconfig (Windows) ou ifconfig (Mac/Linux)
  // static const String baseUrl = 'http://192.168.1.100:8082/api/v1';

  // Forum endpoints
  static const String forumQuestions = '$baseUrl/forum/questions';
  static const String forumAnswers = '$baseUrl/forum/answers';

  // Auth endpoints
  static const String authLogin = '$baseUrl/auth/login';
  static const String authRegister = '$baseUrl/auth/register';

  // Courses endpoints
  static const String courses = '$baseUrl/courses';

  // Reclamation endpoints
  static const String reclamations = '$baseUrl/reclamations';

  // Helper methods
  static String getQuestionById(String id) => '$forumQuestions/$id';
  static String voteQuestion(String id) => '$forumQuestions/$id/vote';
  static String getAnswersByQuestion(String questionId) =>
      '$forumQuestions/$questionId/answers';
  static String voteAnswer(String id) => '$forumAnswers/$id/vote';
  static String acceptAnswer(String id) => '$forumAnswers/$id/accept';

  // Query parameters helpers for filtering
  static String getQuestionsWithFilter({
    String? filter, // 'unanswered', 'resolved', 'recent'
    String? search,
    String? tag,
  }) {
    final uri = Uri.parse(forumQuestions);
    final queryParams = <String, String>{};

    if (filter != null) queryParams['filter'] = filter;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (tag != null && tag.isNotEmpty) queryParams['tag'] = tag;

    return uri.replace(queryParameters: queryParams).toString();
  }
}
