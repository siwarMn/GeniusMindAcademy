abstract class AuthService {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(
      String email, String password, String name);
}

class MockAuthService implements AuthService {
  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    if (email.isNotEmpty && password.isNotEmpty) {
      return {
        'success': true,
        'token': 'mock_token_12345',
        'user': {
          'id': 'user_001',
          'email': email,
          'name': 'Test User',
        }
      };
    } else {
      return {
        'success': false,
        'message': 'Invalid credentials',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> register(
      String email, String password, String name) async {
    await Future.delayed(Duration(seconds: 1));
    return {
      'success': true,
      'token': 'mock_token_register_123',
      'user': {
        'id': 'user_002',
        'email': email,
        'name': name,
      }
    };
  }
}
