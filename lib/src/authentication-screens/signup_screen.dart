import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _loginForm = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  void _submit() {}

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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Let\'s get started!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3C7C0C),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create a new account and start your journey.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF3C7C0C)),
                ),
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
                  Navigator.of(context).pop();
                },
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(color: Color(0xFF3C7C0C)),
                    children: [
                      TextSpan(text: 'Already have an account? '),
                      TextSpan(
                          text: 'Sign In.',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
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
                color: Color.fromARGB(255, 44, 94, 6),
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
                color: Color.fromARGB(255, 44, 94, 6),
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
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Confirm Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 44, 94, 6),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _confirmPasswordTextController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              // fill color: CBE4B9
              fillColor: const Color(0xFFCBE4B9).withOpacity(0.5),
              hintText: 'Confirm your password',
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
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
                "Sign Up",
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
}
