import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Pinjam extends StatefulWidget {
  const Pinjam({super.key});

  @override
  State<Pinjam> createState() => _Pinjam();
}

class _Pinjam extends State<Pinjam> {
  TextEditingController nama = TextEditingController();
  TextEditingController ISBN = TextEditingController();
  TextEditingController tanggalPeminjaman = TextEditingController();

  Future<int> postPinjam() async {
    try {
      var response = await http.post(
          Uri.parse("http://127.0.0.1/app_perpus/pinjamKembali/pinjam.php?pinjamBuku"),
          headers: {
            'Content-Type' : 'application/json'
          },
          body: jsonEncode({
            'ISBN': ISBN.text,
            'namaPeminjam': nama.text,
            'tanggalPeminjaman': tanggalPeminjaman.text
          }));
      return response.statusCode;
    } catch (e) {
      print("there is something wrong with your api, ${e}");
      return 500;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale("en", "US"),
      selectableDayPredicate: (DateTime day) {
        return day.isBefore(DateTime.now());
      },
    );

    if (picked != null) {
      setState(() {
        tanggalPeminjaman.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(0.4)),
                    child: TextField(
                      controller: nama,
                      decoration: const InputDecoration(
                          hintText: "Nama Peminjam",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(15)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(0.4)),
                    child: TextField(
                      controller: ISBN,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          hintText: "ISBN",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(15)),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withOpacity(0.4)),
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: tanggalPeminjaman,
                      decoration: const InputDecoration(
                        hintText: "Tanggal Peminjaman",
                        suffixIcon: Icon(Icons.calendar_month_outlined),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40,),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 90),
                child: ElevatedButton(
                  onPressed: () async {
                    int code = await postPinjam();
                    if (code == 200) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selesai'),
                        ));
                    }else if(code == 400){
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Buku ini sudah di pinjam'),
                        ),
                      );
                    }else if(code == 404){
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Buku ini tidak ditemukan'),
                        ),
                      );
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Terjadi masalah, code: $code.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                    backgroundColor: Colors.red.shade900,
                    elevation: 0,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 7, 165, 2),
                          Color.fromARGB(255, 3, 199, 45),
                          Color.fromARGB(255, 25, 218, 7),
                        ],
                      ),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 50),
                      alignment: Alignment.center,
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
