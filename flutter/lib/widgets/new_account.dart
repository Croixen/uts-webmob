import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  State<NewAccount> createState() => _NewAccount();
}

class _NewAccount extends State<NewAccount> {
  bool _showObscure = true;
  bool _showObscureC = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =TextEditingController();

Future<int> createAccount() async {
  const String uri = "http://127.0.0.1/app_perpus/account/account.php?newAccount"; 
  try {
    var response = await http.post(
      Uri.parse(uri),
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
        'nama': _namaController.text, 
      },
    );
    
    return response.statusCode;
  } catch (e) {
    print("Error creating account: $e");
    return 500; 
  }
}



  void setShowObscure() {
    setState(() {
      _showObscure = !_showObscure;
    });
  }

  void setShowObscureC() {
    setState(() {
      _showObscureC = !_showObscureC;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                      Colors.blue.shade900,
                      Colors.blue.shade800,
                      Colors.blue.shade700
                    ]),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 12),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(320)),
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                weight: 12,
                              )),
                        ),
                      ),
                      const SizedBox(height: 35),
                      const Center(
                        child: Text('Halo Selamat Datang!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ),
                      const Center(
                        child: Text('Anda bisa mendaftarkan diri anda disini!',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                            )),
                      ),
                      const SizedBox(height: 90),
                      Expanded(
                          child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35))),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                const Center(
                                  child: Text("Formulir Pendaftaran",
                                      style: TextStyle(
                                          fontSize: 24, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              const Color.fromARGB(255, 216, 216, 216)
                                                  .withOpacity(0.9),
                                          blurRadius: 0.7,
                                          offset: const Offset(0, 3),
                                          spreadRadius: 0.7,
                                        )
                                      ]),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  child: TextField(
                                    controller: _namaController,
                                    decoration: const InputDecoration(
                                        hintText: "Nama", border: InputBorder.none),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              const Color.fromARGB(255, 216, 216, 216)
                                                  .withOpacity(0.9),
                                          blurRadius: 0.7,
                                          offset: const Offset(0, 3),
                                          spreadRadius: 0.7,
                                        )
                                      ]),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  child: TextField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                        hintText: "Email", border: InputBorder.none),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              const Color.fromARGB(255, 216, 216, 216)
                                                  .withOpacity(0.9),
                                          blurRadius: 0.7,
                                          offset: const Offset(0, 3),
                                          spreadRadius: 0.3,
                                        )
                                      ]),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  child: TextField(
                                    obscureText: _showObscure,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                          onPressed: setShowObscure,
                                          icon: Icon(_showObscure
                                              ? Icons.visibility
                                              : Icons.visibility_off)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              const Color.fromARGB(255, 216, 216, 216)
                                                  .withOpacity(0.9),
                                          blurRadius: 0.7,
                                          offset: const Offset(0, 3),
                                          spreadRadius: 0.3,
                                        )
                                      ]),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  child: TextField(
                                    obscureText: _showObscureC,
                                    controller: _confirmPasswordController,
                                    decoration: InputDecoration(
                                      hintText: "Confirm Password",
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                          onPressed: setShowObscureC,
                                          icon: Icon(_showObscure
                                              ? Icons.visibility
                                              : Icons.visibility_off)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 60,
                                ),
                                Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 90),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if(_passwordController.text != _confirmPasswordController.text){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Password tidak sama.'),
                                          ),
                                        );
                                        }else{
                                          int statusCode = await createAccount();
                                          
                                          if(statusCode == 200){
                                            if (!context.mounted) return;
                                            Navigator.of(context).pop();
                                          }else if(statusCode == 409){
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                            content: Text(
                                                'Terdapat email yang sama.'),
                                          )
                                        );
                                          }else{
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                            content: Text(
                                                'Terdapat kesalahan di server. error: $statusCode'),
                                          )
                                        );
                                          }
                                            
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(80),
                                        ),
                                        backgroundColor: Colors.green.shade900,
                                        foregroundColor: Colors.green.shade700,
                                        elevation: 0,
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(80),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.green.shade900,
                                              Colors.green.shade800,
                                              Colors.green.shade700,
                                            ],
                                          ),
                                        ),
                                        child: Container(
                                          constraints:
                                              const BoxConstraints(minHeight: 50),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            "Daftar",
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
                        ),
                      )),
                    ],
                  ),
                ),
            ),
          );
  }
}
