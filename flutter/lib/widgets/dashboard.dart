import 'package:aplikasi_perpustakaan/route/homepage/homepage.dart';
import 'package:aplikasi_perpustakaan/route/pinjam-kembali/pinjam_kembali.dart';
import 'package:aplikasi_perpustakaan/route/profile/profile.dart';
import 'package:flutter/material.dart';

class WidgetBottNavBar extends StatefulWidget {
  const WidgetBottNavBar({Key? key}) : super(key: key);

  @override
  State<WidgetBottNavBar> createState() => _WidgetBottNavBar();
}

class _WidgetBottNavBar extends State<WidgetBottNavBar> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  List<Widget> body = const [
    HomePage(),
    ProfilePengguna(),
    PinjamKembali(),
  ];

  void handleNavigation(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: PageView(
          onPageChanged: handleNavigation,
          controller: _pageController,
          children: body,
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 32,
          currentIndex: _currentIndex,
          onTap: (int index) {
            if (_currentIndex != index) {
              setState(() {
                _currentIndex = index;
                _pageController.animateToPage(_currentIndex,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear);
              });
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(Icons.book), label: "Pinjam/Kembalikan"),
          ],
        ),
      ),
    );
  }
}
