import 'package:aduan/components/status_gen.dart';
import 'package:aduan/data/aduan_data.dart';
import 'package:aduan/data/database_helper.dart';
import 'package:aduan/data/requests.dart';
import 'package:aduan/pages/detail.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _user = [];
  List _aduanSelesai = [];
  String _waktu = '', _nama = '';
  Future<AduanData> _aduan = ApiRequests().getAllAduan('0');

  @override
  initState() {
    super.initState();
    getUser().then((value) => {
      setState(() {
        _user = value;
        getAllAduanData();
        getTimeNow();
        _nama = getUserData('nama');
      })
    });
    getAllAduanData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAllAduanData();
  }

  Future<List> getUser() {
    final db = DatabaseHelper.instance;
    return db.getData();
  }

  getUserData(String key) {
    for (var i = 0; i < _user.length; i++) {
      if (_user[i]['key'] == key) {
        return _user[i]['value'];
      }
    }
    return '';
  }

  Future<void> getAllAduanData() async {
    setState(() {
      _aduan = ApiRequests().getAllAduan(getUserData('id'));
    });
  }

  void getTimeNow() {
    var hour = new DateTime.now().hour;
    if (hour <= 12) {
      setState(() {
        _waktu = 'Pagi';
      });
    } else if (hour <= 15) {
      setState(() {
        _waktu = 'Siang';
      });
    } else if (hour <= 18) {
      setState(() {
        _waktu = 'Sore';
      });
    } else if (hour <= 24) {
      setState(() {
        _waktu = 'Malam';
      });
    }
  }

  countWidget({required String title, required int count}) {
    return Expanded(
      child: SizedBox(
        height: 180,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _aduan,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? aduanData = snapshot.data!.data;
          for (var element in aduanData!) {
            if (element.status == 'selesai') {
              _aduanSelesai.add(element);
            }
          }
          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                    "Selamat $_waktu",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w300,
                    ),
                ),
                Text(
                    getUserData('nama'),
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    countWidget(title: 'Aduan\nDiajukan', count: aduanData.length),
                    countWidget(title: 'Aduan\nSelesai ditangani', count: _aduanSelesai.length),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Aduan Terbaru',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: aduanData.length > 5 ? 5 : aduanData.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => Detail(
                                  nomor: aduanData[index].nomor!,
                                ),
                              ),
                            ).then((value) => getAllAduanData());
                          },
                          leading: const Icon(Ionicons.chatbubble_ellipses_outline),
                          title: Text(
                            aduanData[index].judul!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            aduanData[index].tanggal!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: StatusGen().bullet(status: aduanData[index].status!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}