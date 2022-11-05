import 'package:aduan/config/config.dart';
import 'package:aduan/data/aduan_data.dart';
import 'package:aduan/components/status_gen.dart';
import 'package:aduan/data/database_helper.dart';
import 'package:aduan/pages/detail.dart';
import 'package:aduan/data/requests.dart';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Aduan extends StatefulWidget {
  const Aduan({super.key});

  @override
  State<Aduan> createState() => _AduanState();
}

class _AduanState extends State<Aduan> {
  String uid = '';
  late Future<AduanData> _aduan;

  @override
  void initState() {
    super.initState();
    refreshData();

    getUid().then((value) {
      if (value != '') {
        setState(() {
          uid = value;
          refreshData();
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshData();
  }

  Future<String> getUid() {
    final dbHelper = DatabaseHelper.instance;
    final uid = dbHelper.getDataByKey('id');
    return uid;
  }

  Future<void> refreshData() async {
    setState(() {
      print('refreshing data');
      _aduan = ApiRequests().getAllAduan(uid);
    });
  }

  void hapusAduan(String nomor) {
    ApiRequests().deleteAduan(nomor: nomor).then((res) {
      if(res.success!) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.message!),
            backgroundColor: Colors.green,
          ),
        );
        refreshData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.message!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  emptyMessage() {
    return RefreshIndicator(
      onRefresh: () => Future.delayed(
        const Duration(seconds: 1),
            () => _AduanState().refreshData(),
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.information_circle_outline,
                    size: 100,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tidak ada aduan",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(uid == '') {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return FutureBuilder<AduanData>(
        future: _aduan,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Data>? data = snapshot.data!.data;
            return data!.isEmpty ? emptyMessage() : RefreshIndicator(
              onRefresh: () => Future.delayed(
                const Duration(seconds: 1),
                    () => refreshData(),
              ),
              child: ListView.builder(
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
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => Detail(
                              nomor: data[index].nomor!,
                            ),
                          ),
                        ).then((value) => refreshData());
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  const Icon(
                                    Ionicons.alert_circle_outline,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 8),
                                  Text("Hapus Aduan : ${data[index].nomor!}"),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:  MainAxisAlignment.start ,
                                children: [
                                  const Text("Apakah anda yakin ingin menghapus aduan ini?"),
                                  const SizedBox(height: 10),
                                  Text('Tentang\t: ${data[index].judul!}',),
                                  Text('Nomor\t: ${data[index].nomor!}',),
                                  Text('Diajukan\t: ${data[index].tanggal!}',),
                                  Text('Status\t: ${data[index].status!}',),
                                ],
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        hapusAduan(data[index].nomor!);
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
                                )
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
                              child: Hero(
                                tag: data[index].nomor!.toString(),
                                child: Image.network(
                                  '${Config().getBaseUrl}/foto_kejadian/${data[index].foto}',
                                  fit: BoxFit.cover,
                                ),
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
                                        Ionicons.warning_outline,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        data[index].jenis!,
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
                            child:
                            StatusGen().bullet(status: data[index].status!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
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
}