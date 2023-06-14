import 'package:event_planner_app/containers/custom_input_form.dart';
import 'package:event_planner_app/controllers/auth.dart';
import 'package:event_planner_app/views/login_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const Text(
                "Sign Up",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 218, 255, 123)),
              ),
              const SizedBox(height: 20),
              CustomInputForm(
                controller: _nameController,
                label: "Name",
                icon: Icons.person_2_outlined,
                hint: "Enter your Name",
              ),
              const SizedBox(height: 8),
              CustomInputForm(
                controller: _emailController,
                label: "Email",
                icon: Icons.email_outlined,
                hint: "Enter your email",
              ),
              const SizedBox(height: 8),
              CustomInputForm(
                obscureText: true,
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock_outline_rounded,
                hint: "Enter your password",
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    createUser(_nameController.text, _emailController.text,
                            _passwordController.text)
                        .then((value) => {
                              if (value == "success")
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("New Account Created"))),
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()))
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(value)))
                                }
                            });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 218, 255, 123),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Sign Up"),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 218, 255, 123),
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Color.fromARGB(255, 218, 255, 123),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
