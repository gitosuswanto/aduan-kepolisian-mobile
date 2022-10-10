import 'dart:convert';

import 'package:aduan/config/config.dart';
import 'package:aduan/data/aduan_data.dart';
import 'package:aduan/components/status_gen.dart';
import 'package:aduan/pages/detail.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

class Aduan extends StatefulWidget {
  const Aduan({super.key});

  @override
  State<Aduan> createState() => _AduanState();
}

class _AduanState extends State<Aduan> {
  late Future<AduanData> _aduan;

  Future<AduanData> fetchAduan() async {
    final res = await http.get(Uri.parse('${Config().getApiUrl}/aduan/all'));

    if (res.statusCode == 200) {
      return AduanData.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAduan();
    _aduan = fetchAduan();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AduanData>(
      future: _aduan,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data!.data;
          if (data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 26, horizontal: 29),
                  child: Text(
                    'Belum ada aduan',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey[900],
                      elevation: 1,
                      padding: const EdgeInsets.all(8),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Detail(
                            nomor: data[index].nomor!,
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Hapus Aduan : ${data[index].nomor!}"),
                            content: Text(
                                'Apakah anda yakin akan menghapus aduan berikut ini: \n\nTentang : ${data[index].judul!} \nNomor : ${data[index].nomor!.toString()} \nDiajukan : ${data[index].tanggal!.toString()}'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.redAccent,
                                ),
                                child: const Text('Ya'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Batal'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 100,
                            color: Colors.grey[200],
                            child: Image.network(
                              '${Config().getBaseUrl}/foto_kejadian/${data[index].foto}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index].judul!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Ionicons.time_outline,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      data[index].tanggal!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Icon(
                                      Ionicons.location_sharp,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      data[index].lokasi!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: StatusGen(status: data[index].status!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        } else if (snapshot.hasError) {
          return Center(child: Text('Snapshot Error : ${snapshot.error}'));
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
