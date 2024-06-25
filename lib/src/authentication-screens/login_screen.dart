import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se346_project/src/authentication-screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginForm = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final dio = Dio();
  final auth = FirebaseAuth.instance;

  void _submit() async {
    try {
      if (_loginForm.currentState!.validate()) {
        await auth.signInWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text,
        );
      }
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).clearSnackBars();
      String errorMessage = 'An error occurred';
      if (err.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (err.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else if (err.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      // backgroundColor: Colors.grey[800],
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildWelcomeImage(mediaQuery)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  _buildLoginForm(),
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  Expanded(child: Container()),
                  _buildSignInButton(),
                  TextButton(
                    onPressed: () {
                      _navigateToSignUp(context);
                    },
                    child: const Text.rich(
                      TextSpan(
                        style: TextStyle(color: Color(0xFF053555)),
                        children: [
                          TextSpan(text: 'Don\'t have an account? '),
                          TextSpan(
                              text: 'Sign Up.',
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeImage(MediaQueryData mediaQuery) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF053555),
      ),
      child: Column(
        children: [
          Expanded(child: Container()),
          // SizedBox(
          //   height: mediaQuery.size.height * 0.12,
          // ),
          Image.asset(
            'assets/images/full-stack 1.png',
            // width: 250,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginForm,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Login to your account',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF053555),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _emailTextController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              // fill color: CBE4B9
              fillColor: const Color(0xFFDEB9F9).withOpacity(0.3),
              hintText: 'Email',
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _passwordTextController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              // fill color: CBE4B9
              fillColor: const Color(0xFFDEB9F9).withOpacity(0.3),
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  double _padding = 6;

  Widget _buildSignInButton() {
    return GestureDetector(
      onTap: () {
        if (_loginForm.currentState!.validate()) {
          _submit();
        }
      },
      onTapDown: (_) {
        setState(() {
          _padding = 0;
        });
      },
      onTapCancel: () {
        setState(() {
          _padding = 6;
        });
      },
      onTapUp: (_) {
        setState(() {
          _padding = 6;
        });
      },
      child: AnimatedContainer(
        padding: EdgeInsets.only(bottom: _padding),
        margin: EdgeInsets.only(top: -(_padding - 6)),
        decoration: BoxDecoration(
          // color: Theme.of(context).primaryColor,
          color: const Color(0xFF053555),
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(milliseconds: 50),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF053555)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Sign In",
                style: TextStyle(
                  letterSpacing: 3,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF053555),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
