import 'dart:convert';

import 'package:aduan/config/config.dart';
import 'package:aduan/data/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:validators/validators.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _errorMessages = '';
  bool _isLoading = false;

  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    if (!isEmail(value)) {
      return 'Email is invalid';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // attempt login
  void attemptLogin() async {
    final dbHelper = DatabaseHelper.instance;

    setState(() {
      _isLoading = true;
      _renderLoadingIndicator();
    });

    final String email = _emailController.text;
    final String password = _passwordController.text;

    await http.post(Uri.parse('${Config().getApiUrl}login'), body: {
      'login': email,
      'password': password,
    }).then((response) {
      setState(() {
        _isLoading = false;
        _renderLoadingIndicator();
      });

      final data = jsonDecode(response.body);
      if (data['success']) {
        if (data['data']['role'] != 'admin') {
          if (data['data']['active']) {
            data['data'].forEach((key, value) {
              dbHelper.getDataByKey(key).then((dbVal) {
                if (dbVal.isEmpty) {
                  dbHelper.insertData(key, value);
                } else {
                  dbHelper.updateData(key, value);
                }
              });
            });

            Navigator.pushReplacementNamed(context, 'pages');
          } else {
            setState(() {
              _errorMessages = 'Akun anda belum aktif';
            });
          }
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Login Gagal'),
                  content: const Text(
                    'Anda tidak diizinkan untuk login di aplikasi ini',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    )
                  ],
                );
              });
        }
      } else {
        setState(() {
          _errorMessages = data['message'];
        });
      }
    }).catchError(
      (error) {
        setState(() {
          _isLoading = false;
          _renderLoadingIndicator();
          _errorMessages = "pastikan anda terhubung ke internet !";
        });
      },
    );
  }

  void _renderLoadingIndicator() {
    _isLoading
        ? showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        : Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Config().getColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        validator: _emailValidator,
                        cursorColor: Colors.white,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Ionicons.mail_outline,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _passwordController,
                        cursorColor: Colors.white,
                        obscureText: _obscureText,
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: _passwordValidator,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Ionicons.lock_closed_outline,
                            color: Colors.white,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Ionicons.eye_off_outline
                                  : Ionicons.eye_outline,
                              color: Colors.white,
                            ),
                            onPressed: () => _toggleObscureText(),
                          ),
                          border: const OutlineInputBorder(),
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Hero(
                            tag: 'reset-password',
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'reset-password');
                              },
                              child: const Text(
                                'Lupa Password ?',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _errorMessages.isNotEmpty
                          ? Text(
                              _errorMessages,
                              style: const TextStyle(color: Colors.redAccent),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              attemptLogin();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                            foregroundColor: Config().getColor,
                            backgroundColor: Colors.white,
                          ),
                          child: const Text('Masuk'),
                        ),
                      ),
                      // create account
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Belum punya akun ?',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'register');
                            },
                            child: const Text(
                              'Daftar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
