import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    return Scaffold(
      // backgroundColor: Colors.grey[800],
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo.png',
                // width: 250,
              ),
              const SizedBox(
                height: 50,
              ),
              _buildLoginForm(),
              const SizedBox(
                height: 40,
              ),
              _buildAnimatedButton(),
              TextButton(
                onPressed: () {
                  _navigateToSignUp(context);
                },
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(color: Color(0xFF3C7C0C)),
                    children: [
                      TextSpan(text: 'Don\'t have an account? '),
                      TextSpan(
                          text: 'Sign Up.',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSignInWithOther(),
            ],
          ),
        ),
      )),
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
              'Email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3C7C0C),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
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
              fillColor: const Color(0xFFCBE4B9).withOpacity(0.5),
              hintText: 'Enter your email',
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
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3C7C0C),
              ),
            ),
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
              fillColor: const Color(0xFFCBE4B9).withOpacity(0.5),
              hintText: 'Enter your password',
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

  Widget _buildAnimatedButton() {
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
          color: const Color(0xFF3C7C0C),
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(milliseconds: 50),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF3C7C0C)),
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
                  color: Color(0xFF3C7C0C),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithOther() {
    return Column(
      children: [
        const Text(
          '- O R -',
          style: TextStyle(color: Color.fromARGB(255, 38, 78, 8)),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size.fromHeight(40)),
          onPressed: () async {},
          child: Ink(
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.google,
                    color: Colors.black,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Sign in with Google',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size.fromHeight(40)),
          onPressed: () {},
          child: Ink(
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    Icons.facebook,
                    color: Colors.black,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Sign in with Facebook',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
