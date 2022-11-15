import 'package:aduan/config/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:validators/validators.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String _selectedJK = '';
  String _selectedAgama = '';
  String _selectedPekerjaan = '';

  bool _isLoading = false;

  final List<String> jk = [
    'Pilih Jenis Kelamin',
    'Laki-laki',
    'Perempuan',
  ];

  final List<String> agama = [
    'Pilih Agama',
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Budha',
    'Konghucu',
  ];

  final List<String> pekerjaan = [
    'Pilih Pekerjaan',
    'PNS',
    'TNI',
    'Polri',
    'Wiraswasta',
    'Pelajar',
    'Wirausaha',
    'Lainnya',
  ];

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahir = TextEditingController();
  final _jkController = TextEditingController();
  final _agamaController = TextEditingController();
  final _pekerjaanController = TextEditingController();
  final _nomoHpController = TextEditingController();
  final _alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedJK = jk[0];
    _selectedAgama = agama[0];
    _selectedPekerjaan = pekerjaan[0];
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

  void _submit() async {
    setState(() {
      _isLoading = true;
      _renderLoadingIndicator();
    });

    if (_formKey.currentState!.validate()) {
      // get data from controllers
      await http.post(Uri.parse('${Config().getApiUrl}/register'), body: {
        'email': _emailController.text,
        'username': _usernameController.text,
        'nama': _namaController.text,
        'tempat_lahir': _tempatLahirController.text,
        'tanggal_lahir': _tanggalLahir.text,
        'jenis_kelamin': _selectedJK,
        'agama': _selectedAgama,
        'pekerjaan': _selectedPekerjaan,
        'alamat': _alamatController.text,
        'nomor_hp': _nomoHpController.text,
      }).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
            _renderLoadingIndicator();
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(
                const SnackBar(
                  content: Text('Register Berhasil'),
                ),
              )
              .closed
              .then((value) {
            Navigator.pop(context);
          });
        } else {
          setState(() {
            _isLoading = false;
            _renderLoadingIndicator();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal mendaftar'),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Config().getColor,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Ionicons.arrow_back),
                      iconSize: 24,
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 10),
                    const Hero(
                      tag: 'register-text',
                      child: Text(
                        'Daftar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Ionicons.help_circle_outline),
                      iconSize: 24,
                      color: Colors.white,
                      onPressed: () {
                        // show help dialog
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  'Bantuan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: const TextSpan(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  'Password baru akan dirubah berdasarkan tanggal lahir yang terdaftar pada akun anda, dengan format',
                                            ),
                                            TextSpan(
                                              text: ' DDMMYYYY',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Contoh : 28121990',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'))
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Daftarkan diri anda',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _namaController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Nama',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!isEmail(value)) {
                                return 'Email is invalid';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _usernameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username tidak boleh kosong';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _tempatLahirController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tempat lahir tidak boleh kosong';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Tempat Lahir',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            readOnly: true,
                            controller: _tanggalLahir,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Waktu tidak boleh kosong';
                              }
                              return null;
                            },
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1945),
                                lastDate: DateTime.now(),
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    _tanggalLahir.text =
                                        DateFormat('yyyy-MM-dd')
                                            .format(value)
                                            .toString();
                                  });
                                }
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Tanggal Lahir',
                              suffixIcon: Icon(Ionicons.calendar_outline),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              child: DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null) {
                                    return 'Jenis kelamin tidak boleh kosong';
                                  }
                                  if (value == 'Pilih Jenis Kelamin') {
                                    return 'Jenis kelamin tidak boleh kosong';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                                hint: const Text('Jenis Kelamin'),
                                value: _selectedJK,
                                items: jk.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedJK = value.toString();
                                    _jkController.text = value.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              child: DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null) {
                                    return 'Agama tidak boleh kosong';
                                  }
                                  if (value == 'Pilih Agama') {
                                    return 'Agama tidak boleh kosong';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                                hint: const Text('Agama'),
                                value: _selectedAgama,
                                items: agama.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAgama = value.toString();
                                    _agamaController.text = value.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              child: DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null) {
                                    return 'Pekerjaan tidak boleh kosong';
                                  }
                                  if (value == 'Pilih Pekerjaan') {
                                    return 'Pekerjaan tidak boleh kosong';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                                hint: const Text('Pekerjaan'),
                                value: _selectedPekerjaan,
                                items: pekerjaan.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPekerjaan = value.toString();
                                    _pekerjaanController.text =
                                        value.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Nomor HP boleh kosong';
                              }
                              return null;
                            },
                            controller: _nomoHpController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Nomor HP',
                              suffixIcon: Icon(Ionicons.call_outline),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Alamat tidak boleh kosong';
                              }
                              return null;
                            },
                            controller: _alamatController,
                            minLines: null,
                            maxLines: 3,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'Alamat',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Config().getColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  _submit();
                                }
                              },
                              child: const Text('Daftar'),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
