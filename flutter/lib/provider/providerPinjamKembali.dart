import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KembaliProvider extends ChangeNotifier {
  late List<dynamic> _kembaliList = [];

  List<dynamic>? get kembaliList => _kembaliList;

  Future<List<dynamic>?> fetchKembali() async {
      String apiUrl = 'http://127.0.0.1/app_perpus/pinjamKembali/kembali.php?daftarPinjaman';
      var response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        _kembaliList = jsonDecode(response.body);
        notifyListeners();
        return _kembaliList; 
      } else {
        throw Exception('Failed to fetch data');
      }

    
  }

  void searchByISBN(String isbn) {
    if (isbn.isEmpty) {
      // If the search query is empty, reset the list to the original data
      notifyListeners();
      return;
    }

    // Filtering the list by ISBN
    List<dynamic> filteredList = _kembaliList
        .where((item) => item['ISBN'].toString().contains(isbn))
        .toList();

    // Update the list with the filtered data
    _kembaliList = filteredList;
    notifyListeners();
  }
}