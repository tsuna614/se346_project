import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se346_project/src/data/global_data.dart' as globals;

class DetailSignUpScreen extends StatefulWidget {
  const DetailSignUpScreen({
    super.key,
    required this.email,
    required this.password,
  });

  final String email, password;

  @override
  State<DetailSignUpScreen> createState() => _DetailSignUpScreenState();
}

class _DetailSignUpScreenState extends State<DetailSignUpScreen> {
  final _detailForm = GlobalKey<FormState>();

  final _firstNameTextField = TextEditingController();
  final _lastNameTextField = TextEditingController();

  final dio = Dio();

  final _firebase = FirebaseAuth.instance;

  @override
  void dispose() {
    _firstNameTextField.dispose();
    _lastNameTextField.dispose();
    super.dispose();
  }

  void _submit() async {
    await _firebase
        .createUserWithEmailAndPassword(
            email: widget.email, password: widget.password)
        .then((value) async {
      await dio.post(
        '${globals.baseUrl}/user/addUser',
        data: {
          'userId': value.user!.uid,
          'email': widget.email,
          'password': widget.password,
          'name': "${_firstNameTextField.text} ${_lastNameTextField.text}",
        },
      ).catchError((error) {
        throw Exception('Failed to create user');
      }).then((value) {
        // successfully created user
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF053555),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _detailForm,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'One last step...',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Tell us more about yourself.',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          const SizedBox(height: 70),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'First name',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _firstNameTextField,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: 'Enter your first name',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
            // onSaved: (newValue) => _enteredEmail = newValue!,
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Last name',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _lastNameTextField,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: 'Enter your last name',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
            // onSaved: (newValue) => _enteredPassword = newValue!,
          ),
          const SizedBox(height: 60),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50)),
            onPressed: _submit,
            child: const Text(
              'Finalize',
              style: TextStyle(
                  color: Color(0xFF02131D),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
