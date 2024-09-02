import '../core.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static dynamic navigateTo(Widget route, {dynamic arguments}) {
    return navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (ctx) => route));
  }

  static dynamic goBack() {
    return navigatorKey.currentState?.pop();
  }
}
