abstract class UserService {
  Future<bool> updateProfile(String name, String email);
  Future<bool> sendReclamation(
      String categorie, String description, String title, String? creatorEmail);
}

class MockUserService implements UserService {
  @override
  Future<bool> updateProfile(String name, String email) async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  @override
  Future<bool> sendReclamation(String categorie, String description,
      String title, String? creatorEmail) async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  }
}
