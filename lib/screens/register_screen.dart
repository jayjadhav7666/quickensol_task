import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../utils/app_toast.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textFormField.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _loading = false;

  bool _validateFields() {
    if (_name.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _phone.text.trim().isEmpty ||
        _password.text.trim().isEmpty) {
      AppToast.show("Please fill all fields");
      return false;
    }

    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
        .hasMatch(_email.text.trim())) {
      AppToast.show("Enter a valid email");
      return false;
    }

    if (_phone.text.trim().length < 10) {
      AppToast.show("Enter a valid phone number");
      return false;
    }

    if (_password.text.trim().length < 6) {
      AppToast.show("Password must be at least 6 characters");
      return false;
    }

    return true;
  }


  Future<void> _onRegister() async {
    if (!_validateFields()) return;

    setState(() => _loading = true);

    try {
      final user = UserModel(
        id: null,
        name: _name.text.trim(),
        email: _email.text.trim(),
        phoneNumber: _phone.text.trim(),
        password: _password.text.trim(),
      );

      await Provider.of<UserProvider>(context, listen: false).addUser(user);

      AppToast.show("Registered successfully");
      Navigator.pop(context);
    } catch (e) {
      AppToast.show("Registration failed");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(backgroundColor: Colors.grey.shade50),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: w > 600 ? 520 : double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 6),
                )
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Create account',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700),
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  controller: _name,
                  hint: 'Full name',
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  controller: _email,
                  hint: 'Email',
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  controller: _phone,
                  hint: 'Phone',
                  prefixIcon: Icons.call,
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  controller: _password,
                  hint: 'Password',
                  isPassword: true,
                  prefixIcon: Icons.lock,
                ),
                const SizedBox(height: 16),

                _loading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                  title: 'Register',
                  onTap: _onRegister,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
