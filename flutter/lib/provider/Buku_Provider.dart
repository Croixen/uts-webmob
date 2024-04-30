import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BukuProvider extends ChangeNotifier {
  List<dynamic>? _bukuData;
  List<dynamic>? _filteredData;

  // List<dynamic>? get bukuData => _bukuData;
  List<dynamic>? get bukuData => _filteredData ?? _bukuData;

  Future<List<dynamic>?> fetchDataBuku() async {
    String apiUrl = 'http://127.0.0.1/app_perpus/buku/buku.php?getAllBooks';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      _bukuData = json.decode(response.body);
      notifyListeners();
      return _bukuData;
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  void filterDataByTitle(String query) {
    if (query.isEmpty) {
      _filteredData = _bukuData;
    } else {
      _filteredData = _bukuData
          ?.where((book) =>
              book['judulBuku'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
  
}
