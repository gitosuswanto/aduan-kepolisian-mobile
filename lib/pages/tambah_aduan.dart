import 'dart:io';

import 'package:html/parser.dart';
import 'package:aduan/data/aduan_data.dart';
import 'package:aduan/data/database_helper.dart';
import 'package:aduan/data/requests.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:file_picker/file_picker.dart';

class TambahAduan extends StatefulWidget {
  const TambahAduan({super.key});

  @override
  State<TambahAduan> createState() => _TambahAduanState();
}

class _TambahAduanState extends State<TambahAduan> {
  final _formKey = GlobalKey<FormState>();
  String _selectedJeis = '';
  String _selectedFileName = '';
  String uid = '';
  bool _isLoading = false;

  final List<String> _jenisAduan = [
    'Kecelakaan',
    'Kriminal',
    'Pencurian',
    'Pembunuhan',
    'Pemerkosaan',
    'Pembajakan',
  ];

  final _judulController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _detailController = TextEditingController();
  final _jenisController = TextEditingController();
  final _waktuController = TextEditingController();
  final _fotoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedJeis = _jenisAduan[0];

    getUid().then((value) => setState(() {
      uid = value;
    }));
  }

  Future<String> getUid()  {
    final db = DatabaseHelper.instance;
    final uid = db.getDataByKey('id');
    return uid;
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

  void _submit() {
    setState(() {
      _isLoading = true;
      _renderLoadingIndicator();
    });
    if (_formKey.currentState!.validate()) {
      Data dataAduan = Data(
        userId: uid,
        judul: _parseHtmlString(_judulController.text),
        lokasi: _parseHtmlString(_lokasiController.text),
        keterangan: _parseHtmlString(_detailController.text),
        jenis: _parseHtmlString(_jenisController.text),
        tanggal: _waktuController.text,
        foto: _fotoController.text,
      );

      ApiRequests.createAduan(dataAduan).then((value) {
        if (value.success!) {
          setState(() {
            _isLoading = false;
            _renderLoadingIndicator();
          });

          Navigator.pop(context);
        } else {
          setState(() {
            _isLoading = false;
            _renderLoadingIndicator();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(value.message!),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body?.text).documentElement!.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Tambah Aduan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 255,
                    controller: _judulController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Judul tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Ionicons.bookmark_outline),
                      border: OutlineInputBorder(),
                      labelText: 'Keterangan',
                      hintText: 'Masukkan keterangan aduan',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    maxLength: 255,
                    controller: _lokasiController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lokasi tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Lokasi',
                      suffixIcon: Icon(Ionicons.location_outline),
                      hintText: 'Masukkan lokasi aduan',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    maxLines: null,
                    controller: _detailController,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Detail tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Ionicons.newspaper_outline),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                      labelText: 'Detail',
                      hintText: 'Masukkan kronologi atau detail aduan',
                    ),
                  ),
                  const SizedBox(height: 15),
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
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            icon: const Icon(Ionicons.chevron_down),
                            value: _selectedJeis,
                            items: _jenisAduan.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? val) {
                              setState(() {
                                _selectedJeis = val!;
                                _jenisController.text = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    readOnly: true,
                    controller: _waktuController,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Waktu tidak boleh kosong';
                      }
                      return null;
                    },
                    onTap: () {
                      DatePicker.showDateTimePicker(
                        context,
                        theme: const DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true,
                        minTime: DateTime(DateTime.now().year - 1),
                        maxTime: DateTime.now(),
                        locale: LocaleType.id,
                        onConfirm: (date) {
                          setState(() {
                            _waktuController.text = '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}';
                          });
                        },
                      );
                    },
                    decoration: const InputDecoration(
                      labelText: 'Waktu Kejadian',
                      suffixIcon: Icon(Ionicons.calendar_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: _selectedFileName),
                    onTap: () {
                      FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        allowCompression: true,
                        type: FileType.image,
                      ).then((value) {
                        setState(() {
                          _selectedFileName = value!.files.first.name;
                          _fotoController.text = value.files.first.path!;
                        });
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Foto tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Foto Kejadian',
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _fotoController.text != ''
                              ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedFileName = '';
                                  _fotoController.text = '';
                                });
                              },
                              icon: const Icon(Ionicons.close_circle_outline)
                          ) : IconButton(onPressed: () {}, icon: const Icon(Ionicons.image_outline)),
                        ],
                      ),
                    ),
                  ),
                  _fotoController.text != ''
                      ? Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) {
                                  return child;
                                }
                                return AnimatedOpacity(
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOut,
                                  child: child,
                                );
                              },
                              File(_fotoController.text),
                              width: double.infinity,
                              height: 213,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ) : const SizedBox(height: 0),
                  const SizedBox(height: 35),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
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
                      child: const Text(
                        'KIRIM ADUAN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
