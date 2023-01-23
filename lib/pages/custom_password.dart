import 'dart:convert';

import 'package:aduan/config/config.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';

class CustomPassword extends StatefulWidget {
  const CustomPassword({super.key});

  @override
  State<CustomPassword> createState() => _CustomPasswordState();
}

class _CustomPasswordState extends State<CustomPassword> {
  bool _isLoading = false;
  bool _obscurePLama = true;
  bool _obscurePBaru = true;
  bool _obscurePBaruConfirm = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passLamaController = TextEditingController();
  final TextEditingController _passBaruController = TextEditingController();
  final TextEditingController _passBaruConfirmController =
      TextEditingController();

  late String _passBaru;
  late String _passBaruConfirm;

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

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    } else if (!isEmail(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

  String? _passLamaValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    return null;
  }

  String? _passBaruValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  String? _passBaruConfirmValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // if value is different with _passBaru
    if (value != _passBaru) {
      return 'Password is not match';
    }

    return null;
  }

  void _toggleObscurePLama() {
    setState(() {
      _obscurePLama = !_obscurePLama;
    });
  }

  void _toggleObscurePBaru() {
    setState(() {
      _obscurePBaru = !_obscurePBaru;
    });
  }

  void _toggleObscurePBaruConfirm() {
    setState(() {
      _obscurePBaruConfirm = !_obscurePBaruConfirm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Hero(
            tag: "key-icon",
            child: Icon(Ionicons.arrow_back),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Reset Password'),
        elevation: 0,
        // remove border
        backgroundColor: Config().getColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Config().getColor,
        child: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Ionicons.lock_open_outline,
                          color: Colors.white,
                          // size: 50,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Lupa Password ?',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jangan risau, cuku masukkan email kamu di bawah ini, dan password baru akan diterapkan.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          validator: _emailValidator,
                          cursorColor: Colors.white,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            suffixIcon: Icon(
                              Ionicons.mail_outline,
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.white54),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          validator: _passLamaValidator,
                          cursorColor: Colors.white,
                          controller: _passLamaController,
                          obscureText: _obscurePLama,
                          decoration: InputDecoration(
                            labelText: 'Password Saat Ini',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePLama
                                    ? Ionicons.eye_off_outline
                                    : Ionicons.eye_outline,
                                color: Colors.white,
                              ),
                              onPressed: () => _toggleObscurePLama(),
                            ),
                            border: const OutlineInputBorder(),
                            labelStyle: const TextStyle(color: Colors.white54),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          validator: _passBaruValidator,
                          cursorColor: Colors.white,
                          controller: _passBaruController,
                          obscureText: _obscurePBaru,
                          decoration: InputDecoration(
                            labelText: 'Password Baru',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePBaru
                                    ? Ionicons.eye_off_outline
                                    : Ionicons.eye_outline,
                                color: Colors.white,
                              ),
                              onPressed: () => _toggleObscurePBaru(),
                            ),
                            border: const OutlineInputBorder(),
                            labelStyle: const TextStyle(color: Colors.white54),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          validator: _passBaruConfirmValidator,
                          cursorColor: Colors.white,
                          controller: _passBaruConfirmController,
                          obscureText: _obscurePBaruConfirm,
                          decoration: InputDecoration(
                            labelText: 'Konfirmasi Password Baru',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePBaruConfirm
                                    ? Ionicons.eye_off_outline
                                    : Ionicons.eye_outline,
                                color: Colors.white,
                              ),
                              onPressed: () => _toggleObscurePBaruConfirm(),
                            ),
                            border: const OutlineInputBorder(),
                            labelStyle: const TextStyle(color: Colors.white54),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  resetPassword();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: Text(
                                'Reset Password',
                                style: TextStyle(
                                  color: Config().getColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
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

  void resetPassword() async {
    setState(() {
      _isLoading = true;
      _renderLoadingIndicator();
    });

    final String email = _emailController.text;
    final String passLama = _passLamaController.text;
    final String passBaru = _passBaruController.text;

    final String url = '${Config().getApiUrl}/repass';
    await http.post(Uri.parse(url), body: {
      'email': email,
      'pass_lama': passLama,
      'pass_baru': passBaru,
    }).then((res) {
      final Map<String, dynamic> body = jsonDecode(res.body);
      setState(() {
        _isLoading = false;
        _renderLoadingIndicator();
      });

      if (body['success']) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: const [
                  Icon(
                    Ionicons.checkmark_circle_outline,
                    color: Colors.green,
                  ),
                  Text('Berhasil !'),
                ],
              ),
              content: const Text(
                  'Password Berhasil diubah !\nSilahkan login kembali'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('login', (route) => false);
                  },
                  child: const Text('Login'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Ionicons.close_circle_outline,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                    TextSpan(
                      text: ' Gagal',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('${body['message']}'),
            ],
          ),
        ));
      }
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        _renderLoadingIndicator();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Ionicons.close_circle_outline,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                    TextSpan(
                      text: ' Gagal',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(e.toString()),
            ],
          ),
        ),
      );
    });
  }
}
