import '../utils.dart';

class ApiConstants {
  ApiConstants._();

  static const String baseurl = "https://django-dev.aakscience.com/";
  static const String signup = "${baseurl}signup/";
  static const String userType = "user_type";
  static const String firstName = "first_name";
  static const String lastName = "last_name";
  static const String email = "email";
  static const String password = "password";
  static const String username = "username";
  static const String country = "country";
  static void showLoader() {
    final context = NavigationService.navigatorKey.currentContext!;
    showDialog(
        context: context,
        builder: (ctx) => const Dialog(
              backgroundColor: Colors.transparent,
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ));
  }
}

enum UserType { researcher, investor, institution_staff, service_provider }
