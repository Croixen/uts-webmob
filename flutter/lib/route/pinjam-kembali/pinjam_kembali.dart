import 'package:aplikasi_perpustakaan/route/pinjam-kembali/kembali.dart';
import 'package:aplikasi_perpustakaan/route/pinjam-kembali/pinjam.dart';
import 'package:flutter/material.dart';

class PinjamKembali extends StatelessWidget {
  const PinjamKembali({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10, right: 10),
        child: Column(
          children: [
            Center(
              child: Text(
                "Pinjam / Kembalikan Buku",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            TabBar(tabs: [
              Tab(text: "Pinjam"),
              Tab(text: "Kembalikan"),
            ]),
            Expanded( 
              child: TabBarView(children: [
                Pinjam(),
                Kembali(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}