import 'package:event_planner_app/containers/custom_input_form.dart';
import 'package:event_planner_app/controllers/auth.dart';
import 'package:event_planner_app/views/homepage.dart';
import 'package:event_planner_app/views/signup_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                "Login",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 218, 255, 123)),
              ),
              const SizedBox(height: 20),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Color.fromARGB(255, 218, 255, 123),
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    loginUser(_emailController.text, _passwordController.text)
                        .then((value) => {
                              if (value)
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Login Successful"))),
                                  Future.delayed(
                                    const Duration(seconds: 2),
                                    () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage())),
                                  )
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Login Failed")))
                                }
                            });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 218, 255, 123),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Login"),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpPage())),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Create a New Account?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 218, 255, 123),
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Sign Up",
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
