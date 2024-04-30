import 'dart:typed_data';

import 'package:aplikasi_perpustakaan/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  TextEditingController nama = TextEditingController();
  TextEditingController tanggalLahir = TextEditingController();
  TextEditingController email = TextEditingController();

  Uint8List? _img;
  
  Future<int> _updateProfile() async {
    String? id = await _storage.read(key: 'id');
    String uri = 'http://127.0.0.1/app_perpus/account/account.php?EditProfile'; 
    var headers = {
      'Content-Type': 'application/json', // Set the content type
    };
    
    Map<String, dynamic> data = {
      'id': id,
      'Nama': nama.text,
      'tanggalLahir': tanggalLahir.text,
      'email': email.text,
      'gambar': _img != null ? base64Encode(_img!) : '', 
    };

    var response = await http.put(Uri.parse(uri), headers: headers, body: jsonEncode(data));

    return response.statusCode;
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
        
        tanggalLahir.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  void _selectImage() async{
    Uint8List img = await pickImage(ImageSource.gallery);
    setState((){
    _img = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: backGround(),
          ),

          Positioned.fill(child: 
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 15 ,8, 30),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackButton(),
                const SizedBox(height: 50),
                const Center(
                    child: Text(
                  "Form Edit Biodata",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                )),
                const SizedBox(height: 50),
                Center(
                  child: Stack(
                    children: [
                      if(_img != null)
                          CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_img!),
                        )
                      else
                        const CircleAvatar(
                        radius: 64,
                        backgroundImage: AssetImage('static/image/toppng.com-donna-picarro-dummy-avatar-768x768.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 80,
                        child: 
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(360),
                            color: Colors.white
                          ),
                          child: IconButton(onPressed: _selectImage, icon: const Icon(Icons.add_a_photo),))
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.withOpacity(0.6)),
                        child: TextField(
                          controller: nama,
                          decoration: const InputDecoration(
                              hintText: "Nama",
                              contentPadding: EdgeInsets.all(5),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey.withOpacity(0.6),
                        ),
                        child: GestureDetector(
                          onTap: () =>
                              _selectDate(context), // Open date picker on tap
                          child: AbsorbPointer(
                            child: TextField(
                              controller: tanggalLahir,
                              decoration: const InputDecoration(
                                hintText: "Tanggal Lahir",
                                contentPadding: EdgeInsets.all(5),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.withOpacity(0.6)),
                        child: TextField(
                          controller: email,
                          decoration: const InputDecoration(
                              hintText: "E-mail",
                              contentPadding: EdgeInsets.all(5),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 90),
                          child: ElevatedButton(
                            onPressed: () async {
                              int code = await _updateProfile();
                              if(code == 200){
                                if(!context.mounted) return;
                                Navigator.of(context).pop(true);
                              }else{
                                 if(!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Terjadi masalah, code: $code.'),
                                  ),);
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
                    ]),
                  ),
                )
              ],
                      ),
            ),
          ),)
        ],
      )
    );
  }

  BoxDecoration backGround() {
    return BoxDecoration(
      gradient: LinearGradient(colors: [
        Colors.blue.shade900,
        Colors.blue.shade700,
        Colors.blue.shade800,
      ]),
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(64),
          color: Colors.white.withOpacity(0.3),
        ),
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_left_sharp,
            )));
  }
}