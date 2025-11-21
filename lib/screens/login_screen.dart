import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../utils/app_toast.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textFormField.dart';
import 'register_screen.dart';
import 'user_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loading = false;



  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) {
      AppToast.show("Please fill all fields correctly");
      return;
    }

    setState(() => _loading = true);

    try {
      final userProv = Provider.of<UserProvider>(context, listen: false);

      await userProv.fetchUsers();

      final match = userProv.users.firstWhere(
            (u) =>
        u.email.toLowerCase() == _email.text.trim().toLowerCase() &&
            u.password == _password.text.trim(),
        orElse: () => throw Exception('User not found'),
      );

      await Provider.of<AuthProvider>(context, listen: false)
          .login(match.email, match.password);

      AppToast.show("Login Successful");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserListScreen()),
      );
    } catch (e) {
      AppToast.show("Invalid email or password");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: w > 500 ? 420 : double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 6))
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter your credentials to continue',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),

                  /// Email
                  CustomTextField(
                    controller: _email,
                    hint: "Email",
                    prefixIcon: Icons.email,
                  ),

                  const SizedBox(height: 12),

                  /// Password
                  CustomTextField(
                    controller: _password,
                    hint: "Password",
                    isPassword: true,
                    prefixIcon: Icons.lock,
                  ),

                  const SizedBox(height: 25),

                  _loading
                      ? const CircularProgressIndicator()
                      : CustomButton(title: "Login", onTap: _onLogin),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: const Text("Register"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
