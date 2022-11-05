import 'package:aduan/data/aduan_data.dart';
import 'package:aduan/data/database_helper.dart';
import 'package:aduan/data/requests.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List _data = [];
  Future<AduanData> _aduan = ApiRequests().getAllAduan('0');
  List _aduanSelesai = [];

  @override
  void initState() {
    super.initState();
    getData().then((value) => {
      setState(() {
        _data = value;
        getAllAduanData();
      })
    });
  }

  Future<void> getAllAduanData() async {
    setState(() {
      _aduan = ApiRequests().getAllAduan(getUserData('id'));
    });
  }

  Future<List> getData() {
    final db = DatabaseHelper.instance;
    return db.getData();
  }

  getUserData(String key) {
    for (var i = 0; i < _data.length; i++) {
      if (_data[i]['key'] == key) {
        return _data[i]['value'];
      }
    }
    return '';
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

          return RefreshIndicator(
            onRefresh: () => Future.delayed(
              const Duration(seconds: 1),
              () => setState(() {
                getAllAduanData();
              }),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://robohash.org/${getUserData('username')}?bgset=bg2'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getUserData('nama'),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Ionicons.mail_outline,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  getUserData('email'),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              aduanData.length.toString(),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Aduan',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              _aduanSelesai.length.toString(),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Selesai',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            DatabaseHelper db = DatabaseHelper.instance;
                            db.deleteAll();

                            Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                          },
                          icon: const Icon(
                            Ionicons.log_out_outline,
                            size: 28,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          );
        } else if(snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
