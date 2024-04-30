import 'dart:convert';

import 'package:aplikasi_perpustakaan/provider/providerPinjamKembali.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Kembali extends StatelessWidget {
  const Kembali({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => KembaliProvider(),
      child: _Kembali(),
    );
  }
}

class _Kembali extends StatelessWidget {
  _Kembali({Key? key}) : super(key: key);
  TextEditingController search = TextEditingController();

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
          Provider.of<KembaliProvider>(context, listen: false)
              .searchByISBN(value);
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KembaliProvider>(builder: (context, kembaliProvider, _) {
      if (kembaliProvider.kembaliList == null ||
          kembaliProvider.kembaliList!.isEmpty) {
        kembaliProvider.fetchKembali();
        return const Scaffold(
          body: Center(child: Text('Tidak ada data disini!')),
        );
      } else {
        List<dynamic> kembaliList = kembaliProvider.kembaliList!;
        List<dynamic> belumKembaliList =
            kembaliList.where((item) => item['selesai'] == '0').toList();
        List<dynamic> kembaliSelesaiList =
            kembaliList.where((item) => item['selesai'] == '1').toList();
        return Column(
          children: [
            buildSearchBar(context),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Belum Selesai',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: belumKembaliList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: TileBelumKembali(
                            belumKembaliList: belumKembaliList,
                            index: index,
                          ),
                          // Add other information here
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'Selesai',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: kembaliSelesaiList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: listSelesai(
                            kembaliSelesaiList: kembaliSelesaiList,
                            index: index,
                          ),
                          // Add other information here
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    });
  }
}

class listSelesai extends StatelessWidget {
  const listSelesai(
      {super.key, required this.kembaliSelesaiList, required this.index});

  final List kembaliSelesaiList;
  final int index;

  Future<int> deleteKembali() async {
    String uri =
        'http://127.0.0.1/app_perpus/pinjamKembali/kembali.php?deletePengembalian';
    var headers = {
      'Content-Type': 'application/json', // Set the content type
    };

    Map<String, dynamic> body = {
      'idPinjam': kembaliSelesaiList[index]['idPinjam'],
    };

    try {
      var response =
          await http.delete(Uri.parse(uri), headers: headers, body: jsonEncode(body));
      return response.statusCode;
    } catch (e) {
      print('there is something wrong here, ${e}');
    }

    return 500;
  }

  TextButton deleteButton(context) {
    return TextButton(
      onPressed: () async {
        var respCode = await deleteKembali();
        if (respCode == 200) {
          const ScaffoldMessenger(child: SnackBar(content: Text('Sukses')));
          Provider.of<KembaliProvider>(context, listen: false).fetchKembali();
        } else {
          ScaffoldMessenger(
              child: SnackBar(content: Text('terjadi kesalahan: $respCode')));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.cancel, color: Colors.white),
      ),
    );
  }

  Widget bottomText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13),
    );
  }

  Column mainItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          kembaliSelesaiList[index]['judulBuku'],
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
            bottomText("ISBN: ${kembaliSelesaiList[index]['ISBN']}"),
            const SizedBox(
              width: 5,
            ),
            bottomText(
                "Tanggal peminjaman: ${kembaliSelesaiList[index]['tanggalPeminjaman']}"),
        bottomText("Nama: ${kembaliSelesaiList[index]['namaPeminjam']}"),
      
        bottomText(
            "tanggal pegembalian: ${kembaliSelesaiList[index]['tanggalPengembalian']}"),
        const SizedBox(
          width: 5,
        ),
            
        if (kembaliSelesaiList[index]['penalty'] == '1' || kembaliSelesaiList[index]['penalty'] == true)
              bottomText("Penalty?: Iya")
        else
              bottomText("Penalty?: Tidak")

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            mainItem(),
            deleteButton(context),
          ],
        ));
  }
}

class TileBelumKembali extends StatelessWidget {
  const TileBelumKembali(
      {super.key, required this.belumKembaliList, required this.index});

  final List belumKembaliList;
  final int index;

  Future<int> updateKembali() async {
    String uri =
        'http://127.0.0.1/app_perpus/pinjamKembali/kembali.php?updatePengembalian';
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 7));
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    Map<String, dynamic> body = {
      'idPinjam': belumKembaliList[index]['idPinjam'],
      'tanggalPengembalian': formattedDate
    };

    try {
      var response =
          await http.put(Uri.parse(uri), body: jsonEncode(body));
      return response.statusCode;
    } catch (e) {
      print('there is something wrong here, ${e}');
    }

    return 500;
  }

  // ignore: non_constant_identifier_names
  TextButton SubmitButton(context) {
    return TextButton(
      onPressed: () async {
        int statusCode = await updateKembali();
        if (statusCode == 200) {
          const ScaffoldMessenger(child: SnackBar(content: Text('Sukses')));
          Provider.of<KembaliProvider>(context, listen: false).fetchKembali();
        } else {
          Text(statusCode.toString());
        }
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(10)),
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget bottomText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13),
    );
  }

  // ignore: non_constant_identifier_names
  Column MainItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          belumKembaliList[index]['judulBuku'],
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
            bottomText("ISBN: ${belumKembaliList[index]['ISBN']}"),
            const SizedBox(
              width: 5,
            ),
            bottomText(
                "Tanggal peminjaman: ${belumKembaliList[index]['tanggalPeminjaman']}"),
        bottomText("Nama: ${belumKembaliList[index]['namaPeminjam']}"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainItem(),
            SubmitButton(context),
          ],
        ));
  }
}
