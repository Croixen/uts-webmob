import 'dart:convert';

import 'package:aplikasi_perpustakaan/provider/Buku_Provider.dart';
import 'package:aplikasi_perpustakaan/route/homepage/tambah_buku.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BukuProvider(),
      child: _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  _HomePage({Key? key}) : super(key: key);

  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<BukuProvider>(
      builder: (context, bukuProvider, _) {
        Widget buildSearchBar(context) {
          return Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(64),
              border: Border.all(width: 1),
            ),
            child: TextField(
              controller: search,
              onChanged: (value) {
                bukuProvider.filterDataByTitle(value);
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
                hintText: 'search by title'
              ),
            ),
          );
        }

        if (bukuProvider.bukuData == null || bukuProvider.bukuData!.isEmpty) {
          bukuProvider.fetchDataBuku();
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "DAFTAR BUKU",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(240),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => const SafeArea(
                              child: TambahBuku(),
                            ),
                          ))
                              .then((value) {
                            if (value != null && value is bool && value) {
                              Provider.of<BukuProvider>(context, listen: false)
                                  .fetchDataBuku();
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buildSearchBar(context),
                  const Divider(),
                  const ListBuku(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class ListBuku extends StatelessWidget {
  const ListBuku({Key? key}) : super(key: key);

  Future<int> _deleteBuku(var isbn) async {
    Map<String, dynamic> body = {'isbn': isbn};

    Map<String, String> headers = {'Content-Type': 'application/json'};

    Uri uri = Uri.parse('http://127.0.0.1/app_perpus/buku/buku.php?hapusBuku');

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

  @override
  Widget build(BuildContext context) {
    var bukuProvider = Provider.of<BukuProvider>(context);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bukuProvider.bukuData!.length,
      itemBuilder: (context, index) {
        var book = bukuProvider.bukuData![index];

        String imageURL =
            "http://127.0.0.1/app_perpus/buku/buku.php?getBookImage&img=${book['gambar'].toString()}";

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
            ),
            child: ListTile(
              leading: Image.network(imageURL),
              title: Text(book['judulBuku']),
              subtitle: Text("ISBN: ${book['ISBN'].toString()}"),
              trailing: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () async {
                    var responseCode = await _deleteBuku(book['ISBN']);
                    if (responseCode == 200) {
                      if (!context.mounted) return;
                      const ScaffoldMessenger(
                          child: SnackBar(content: Text('Berhasil!')));
                      Provider.of<BukuProvider>(context, listen: false)
                          .fetchDataBuku();
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger(
                          child:
                              SnackBar(content: Text('gagal! $responseCode')));
                    }
                  },
                  icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
