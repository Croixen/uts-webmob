// ignore_for_file: use_build_context_synchronously

import 'package:aplikasi_perpustakaan/widgets/dashboard.dart';
import 'package:aplikasi_perpustakaan/widgets/new_account.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final storage = const FlutterSecureStorage();
  bool _showObscure = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void setShowObscure() {
    setState(() {
      _showObscure = !_showObscure;
    });
  }

  Future<int> _login() async {
  var uri = "http://127.0.0.1/app_perpus/account/account.php?login";
  var response = await http.post(Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text
      }));

  if (response.statusCode == 200) { 
    try {
      var data = jsonDecode(response.body);
      await storage.write(key: 'id', value: data['id'].toString());
      return response.statusCode;
    } catch (e) {
      print(e);
    }
  }
  print(response.body);
  return response.statusCode;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Colors.blue.shade900,
              Colors.blue.shade800,
              Colors.blue.shade700
            ]),
          ),
        ),
        Positioned.fill(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(
                    "Aplikasi Perpustakaan",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 80,
              ),
              const Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Welcome!',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(164, 235, 239, 0.298),
                                  blurRadius: 20,
                                  offset: Offset(0, 20))
                            ]),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200))),
                              child: TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                    hintText: "Email",
                                    border: InputBorder.none),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200))),
                              child: TextField(
                                controller: passwordController,
                                obscureText: _showObscure,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                        onPressed: setShowObscure,
                                        icon: Icon(_showObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 90),
                          child: ElevatedButton(
                            onPressed: () async {
                              int status_code = await _login();
                              if (status_code == 200) {
                                if (!context.mounted) return;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const SafeArea(
                                        child: WidgetBottNavBar())));
                              } else if (status_code == 401) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Login gagal, $status_code.'),
                                  ),
                                );
                              } else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Terjadi masalah lain, $status_code'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80),
                              ),
                              backgroundColor: Colors.blue.shade900,
                              foregroundColor: Colors.blue.shade700,
                              elevation: 0,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade900,
                                    Colors.blue.shade800,
                                    Colors.blue.shade700,
                                  ],
                                ),
                              ),
                              child: Container(
                                constraints:
                                    const BoxConstraints(minHeight: 50),
                                alignment: Alignment.center,
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 70,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const SafeArea(child: NewAccount())));
                        },
                        child: const Text(
                          "Belum Punya Akun? Register di sini!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        )
      ]),
    );
  }
}
