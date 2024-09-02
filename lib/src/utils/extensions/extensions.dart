import '../utils.dart';

extension ContextModifier on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).width;
}

extension UserTypeModifier on UserType {
  String get typeName {
    switch (this) {
      case UserType.institution_staff:
        return "Institution Staff";
      case UserType.investor:
        return "Investor";
      case UserType.researcher:
        return "Researcher";
      case UserType.service_provider:
        return "Service Provider";
    }
  }
}
