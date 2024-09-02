import '../ui.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  String? countryname;
  UserType userType = UserType.researcher;
  final ApiService apiService = ApiRepository();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CustomToast toast = CustomToast();

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "User Type",
                style: titleStyle,
              ),
              DropdownButton<UserType>(
                  isExpanded: true,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        userType = val;
                      });
                    }
                  },
                  value: userType,
                  items: UserType.values
                      .map((user) => DropdownMenuItem<UserType>(
                          value: user, child: Text(user.typeName)))
                      .toList()),
              SizedBox(height: context.height * 0.02),
              const Text("First Name", style: titleStyle),
              TextFormField(
                controller: firstname,
                decoration: const InputDecoration(hintText: "Enter first name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.height * 0.02),
              const Text("Last Name", style: titleStyle),
              TextFormField(
                controller: lastname,
                decoration: const InputDecoration(hintText: "Enter last name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.height * 0.02),
              const Text("Username", style: titleStyle),
              TextFormField(
                controller: userName,
                decoration: const InputDecoration(hintText: "Enter username"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.height * 0.02),
              const Text("Email", style: titleStyle),
              TextFormField(
                controller: email,
                decoration:
                    const InputDecoration(hintText: "Enter email address"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.height * 0.02),
              const Text("Password", style: titleStyle),
              TextFormField(
                controller: password,
                decoration:
                    const InputDecoration(hintText: "Enter your password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.height * 0.02),
              const Text("Country", style: titleStyle),
              SizedBox(height: context.height * 0.01),
              InkWell(
                onTap: () {
                  showCountryPicker(
                      context: context,
                      onSelect: (val) {
                        setState(() {
                          countryname = val.name;
                        });
                      });
                },
                child: SizedBox(
                  width: context.width,
                  height: context.height * 0.05,
                  child: Text(countryname ?? "Select country"),
                ),
              ),
              SizedBox(height: context.height * 0.05),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(context.width, context.height * 0.05)),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (countryname == null) {
                      toast.showToast(
                          child: const ToastUi(
                              message: "Kindly select your country"));
                      return;
                    }
                    apiService.signup(
                        email: email.text.trim(),
                        password: password.text.trim(),
                        firstName: firstname.text.trim(),
                        lastName: lastname.text.trim(),
                        userName: userName.text.trim(),
                        userType: userType.name,
                        country: countryname!);
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
