import '../core.dart';

class ApiRepository extends ApiService {
  final Dio dio = Dio();
  final CustomToast customToast = CustomToast();
  @override
  Future<void> signup(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String userName,
      required String userType,
      required String country}) async {
    try {
      ApiConstants.showLoader();
      final Map<String, dynamic> jsonData = {
        ApiConstants.firstName: firstName,
        ApiConstants.lastName: lastName,
        ApiConstants.email: email,
        ApiConstants.password: password,
        ApiConstants.username: userName,
        ApiConstants.userType: userType,
        ApiConstants.country: country
      };
      await dio.post(ApiConstants.signup, data: jsonData);
      NavigationService.goBack();
      customToast.showToast(
          child: const ToastUi(message: "Account created successfully"));
    } catch (e) {
      NavigationService.goBack();
      final CustomException exception = _customException(e);
      customToast.showToast(child: ToastUi(message: exception.message));
    }
  }

  CustomException _customException(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final Response response = error.response!;
        if (response.data is String) {
          return CustomException(response.data);
        }
      }

      return CustomException('An error occurred');
    } else {
      return CustomException('An unexpected error occurred');
    }
  }
}

class CustomException implements Exception {
  final String message;
  CustomException(this.message);
}
