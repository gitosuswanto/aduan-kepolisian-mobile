import 'dart:convert';

import 'package:aduan/config/config.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:validators/validators.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isEmail(value)) {
      return 'Email is invalid';
    }
    return null;
  }

  void resetPassword() async {
    setState(() {
      _isLoading = true;
      _renderLoadingIndicator();
    });

    final String email = _emailController.text;
    final String url = '${Config().getApiUrl}/reset-password';
    await http.post(Uri.parse(url), body: {
      'email': email,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Hero(
                  tag: 'reset-password',
                  child: Text(
                    'Lupa Password ?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Row(
                                          children: [
                                            Hero(
                                              tag:
                                                  'bantuan_icon_reset_password',
                                              child: Icon(
                                                Ionicons
                                                    .information_circle_outline,
                                                color: Config().getColor,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Text('Bantuan'),
                                          ],
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: const TextSpan(
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'Password baru akan dirubah berdasarkan tanggal lahir yang terdaftar pada akun anda, dengan format',
                                                    ),
                                                    TextSpan(
                                                      text: ' DDMMYYYY',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Contoh : 28121990',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Ok')),
                                        ],
                                      ));
                            },
                            icon: const Hero(
                              tag: 'bantuan_icon_reset_password',
                              child: Icon(
                                Ionicons.help_circle_outline,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
