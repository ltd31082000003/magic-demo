import 'package:flutter/material.dart';
import 'package:magic_demo/tabs/home.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Magic? magic = Magic.instance;
  final emailInput = TextEditingController(text: 'ltd31082003@gmail.com');
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (magic == null) {
      print('Magic instance is null');
      return;
    }
    var future = magic!.user.isLoggedIn();
    future.then((isLoggedIn) {
      if (isLoggedIn) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const HomePage()));
        });
      }
    }).catchError((error) {
      print('Error checking login status: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magic Demo Login'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: TextFormField(
                  controller: emailInput,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (magic == null) {
                      showResult(context, 'Magic instance is null');
                      return;
                    }
                    print('Attempting to login with email: ${emailInput.text}');
                    try {
                      print('Sending OTP request...');
                      var token = await magic!.auth.loginWithEmailOTP(email: emailInput.text).timeout(
                        const Duration(seconds: 60),
                        onTimeout: () {
                          print('Timeout occurred while waiting for OTP response');
                          throw Exception('Login request timed out');
                        },
                      );
                      print('Login successful, token: $token');
                      showResult(context, 'token, $token');
                      if (token.isNotEmpty) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const HomePage()));
                      }
                    } catch (e) {
                      print('Login error: $e');
                      showResult(context, 'Login failed: $e');
                    }
                  }
                },
                child: const Text('Login With Email OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}