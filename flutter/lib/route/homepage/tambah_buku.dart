import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aplikasi_perpustakaan/utility/utils.dart';
import 'package:http/http.dart' as http;

class TambahBuku extends StatefulWidget {
  const TambahBuku({super.key});

  @override
  State<TambahBuku> createState() => _TambahBuku();
}

class _TambahBuku extends State<TambahBuku> {
  TextEditingController ISBN = TextEditingController();
  TextEditingController judulBuku = TextEditingController();
  Uint8List? _img;

  void _selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _img = img;
    });
  }

  Future<int> postBuku() async {
    try {
      var response = await http.post(
          Uri.parse("http://127.0.0.1/app_perpus/buku/buku.php?addBook"),
          headers: {
            'Content-Type' : 'application/json'
          },
          body: jsonEncode({
            'isbn': ISBN.text,
            'judulbuku': judulBuku.text,
            'image': _img != null ? base64Encode(_img!) : ''
          }));
      return response.statusCode;
    } catch (e) {
      print("there is something wrong with your api, ${e}");
      return 500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          "Tambah Buku",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.3),
              ),
              child: TextField(
                decoration: const InputDecoration(
                    hintText: "ISBN",
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: ISBN,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.3),
              ),
              child: TextField(
                decoration: const InputDecoration(
                    hintText: "Judul Buku",
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none),
                controller: judulBuku,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 120,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(width: 1)),
              child: GestureDetector(
                onTap: _selectImage,
                child: const Center(child: Text("Upload Gambar")),
              ),
            ),
            const SizedBox(height: 20),
            if (_img != null)
              Image(image: MemoryImage(_img!))
            else
              const Image(
                  image: AssetImage(
                      'static/image/vector-book-icon.jpg')),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 90),
                child: ElevatedButton(
                  onPressed: () async {
                    int code = await postBuku();
                    if (code == 200) {
                      if (!context.mounted) return;
                      Navigator.of(context).pop(true);
                    }else if(code == 400){
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Terdapat entry buku dalam isbn yang double'),
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
