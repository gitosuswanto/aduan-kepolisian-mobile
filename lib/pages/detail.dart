import 'package:aduan/components/jenis_gen.dart';
import 'package:aduan/config/config.dart';
import 'package:aduan/data/aduan_data.dart';
import 'package:aduan/components/status_gen.dart';
import 'package:aduan/data/requests.dart';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Detail extends StatefulWidget {
  const Detail({super.key, required this.nomor});

  final String nomor;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late Future<AduanData> _aduan;

  @override
  void initState() {
    super.initState();
    _aduan = ApiRequests().getAduanByNomor(nomor: widget.nomor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Detail Aduan'),
      ),
      body: FutureBuilder<AduanData>(
        future: _aduan,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Data? data = snapshot.data!.data!.first;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Hero(
                      tag: data.nomor.toString(),
                      child: Image.network(
                        '${Config().getBaseUrl}/foto_kejadian/${data.foto}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.judul!,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          data.tanggal!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${data.lokasi}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            StatusGen().text(status: data.status!),
                            const SizedBox(width: 10),
                            JenisGen().jenisAduanGenerator(jenis: data.jenis!),
                          ],
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          blurRadius: 5,
                          offset: const Offset(0, -5),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      top: 25,
                      left: 20,
                      right: 20,
                      bottom: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Keterangan",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          data.keterangan!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Snapshot Error : ${snapshot.error}');
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
