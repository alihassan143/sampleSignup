abstract class ApiService {
  Future<void> signup(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String userName,
      required String userType,
      required String country});
}
