import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:aplikasi_perpustakaan/provider/Profile_Provider.dart';
import 'package:aplikasi_perpustakaan/route/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:provider/provider.dart';

class ProfilePengguna extends StatelessWidget {
  const ProfilePengguna({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: const _ProfilePengguna(),
    );
  }
}

class _ProfilePengguna extends StatelessWidget {
  const _ProfilePengguna({Key? key}) : super(key: key);
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> _idPustakawan() async {
    String? id = await _storage.read(key: 'id');
    return id ?? 'null';
  }

  Future<int> _deletePustakawan() async {
    String id = await _idPustakawan();
    Map<String, dynamic> body = {'id': id};

    Map<String, String> headers = {'Content-Type': 'application/json'};

    Uri uri = Uri.parse(
        'http://127.0.0.1/app_perpus/account/account.php?HapusProfile');

    try {
      var response =
          await http.delete(uri, body: jsonEncode(body), headers: headers);
      print(jsonDecode(response.body));
      print(response.statusCode);

      return response.statusCode;
    } catch (e) {
      print('terjadi kesalahan di sini, $e');
      return 500;
    }
  }

  int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String getFormattedDate(DateTime? dateTime) {
    if (dateTime != null) {
      // Format the date as needed (in this case, yyyy-MM-dd)
      return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
    } else {
      return ''; // Return an empty string for null DateTime
    }
  }

  @override
  Widget build(BuildContext context) {
    var profileNotifier = Provider.of<ProfileProvider>(context, listen: false);

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        if (profileProvider.profileData == null ||
            profileProvider.profileData!.isEmpty) {
          profileNotifier.fetchProfileData();
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          Map<String, dynamic>? profileData = profileProvider.profileData;

          if (profileData != null && profileData.isNotEmpty) {
            String? gambar = profileData['gambar'];
            String? nama = profileData['nama'];
            String? tanggalLahir = profileData['tanggal_lahir'];
            DateTime? tanggalMasuk =
                DateTime.parse(profileData['tanggal_masuk']);
            String formattedDate = getFormattedDate(tanggalMasuk);
            DateTime? parsedTanggalLahir =
                tanggalLahir != null ? DateTime.parse(tanggalLahir) : null;
            int umur = parsedTanggalLahir != null
                ? calculateAge(parsedTanggalLahir)
                : 0;

            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      colors: [
                        Colors.blue.shade900,
                        Colors.blue.shade800,
                        Colors.blue.shade700
                      ],
                    ),
                  ),
                ),
                // Profile content with fixed size
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 130,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(360),
                                    color: Colors.grey),
                                child: ClipOval(
                                  child: Image.network(
                                    "http://127.0.0.1/app_perpus/account/account.php?GetPic&img=$gambar",
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 35),
                                child: Divider(),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 35, horizontal: 25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                spreadRadius: 0.7,
                                                offset: const Offset(0, 2),
                                              )
                                            ],
                                            color: Colors.white),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Nama : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              "$nama",
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              spreadRadius: 0.7,
                                              offset: const Offset(0, 2),
                                            )
                                          ],
                                          color: Colors.white,
                                        ),
                                        child: FutureBuilder<String>(
                                          future: _idPustakawan(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              return Row(
                                                children: [
                                                  const Text(
                                                    "ID Pustakawan: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    snapshot.data ?? '',
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  )
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                spreadRadius: 0.7,
                                                offset: const Offset(0, 2),
                                              )
                                            ],
                                            color: Colors.white),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Umur : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              "$umur",
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                spreadRadius: 0.7,
                                                offset: const Offset(0, 2),
                                              )
                                            ],
                                            color: Colors.white),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Tanggal Masuk : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              formattedDate,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                spreadRadius: 0.7,
                                                offset: const Offset(0, 2),
                                              )
                                            ],
                                            color: Colors.white),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Tanggal Lahir : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              "$tanggalLahir",
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 90,
                                      ),
                                      Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 90),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(80),
                                              ),
                                              backgroundColor:
                                                  Colors.red.shade900,
                                              elevation: 0,
                                            ),
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(80),
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 165, 2, 2),
                                                    Color.fromARGB(
                                                        255, 199, 3, 3),
                                                    Color.fromARGB(
                                                        255, 218, 7, 7),
                                                  ],
                                                ),
                                              ),
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        minHeight: 50),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                      const SizedBox(height: 30),
                                      Center(
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SafeArea(
                                                    child: EditProfile(),
                                                  ),
                                                ))
                                                    .then((value) {
                                                  if (value != null &&
                                                      value is bool &&
                                                      value) {
                                                    Provider.of<ProfileProvider>(
                                                            context,
                                                            listen: false)
                                                        .fetchProfileData();
                                                  }
                                                });
                                              },
                                              child: const Text(
                                                "Edit Data Anda?",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 16),
                                              ))),
                                      const SizedBox(height: 10),
                                      Center(
                                          child: TextButton(
                                        onPressed: () => showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Hapus Profile'),
                                            content: const Text(
                                                'Apakah anda yakin untuk Menghapus Akun Ini?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  int statusCode = await _deletePustakawan();
                                                  if (statusCode == 200) {
                                                    if(!context.mounted) return;
                                                     Navigator.of(context).popUntil((route) => route.isFirst);
                                                    
                                                  } else {
                                                    const ScaffoldMessenger(
                                                        child: SnackBar(
                                                            content: Text(
                                                                "terjadi kesalahan")));
                                                  }
                                                },
                                                child: const Text('Iya'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        child: const Text(
                                          'Ingin Hapus Akun Anda?',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('No profile data available.'),
            );
          }
        }
      },
    );
  }
}
