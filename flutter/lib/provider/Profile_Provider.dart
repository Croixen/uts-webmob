import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileProvider extends ChangeNotifier{
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Map<String, dynamic>? _profileData;

  Map<String, dynamic>? get profileData => _profileData;
  
  Future<Map<String, dynamic>?> fetchProfileData() async {
    String? id = await _storage.read(key: 'id');
    String apiUrl =
        'http://127.0.0.1/app_perpus/account/account.php?getAkun=$id'; // Replace with your API endpoint


    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
       _profileData = Map<String, dynamic>.from(json.decode(response.body));
      notifyListeners();
      return  _profileData;
    } else {
      throw Exception('Failed to load profile data');
    }
  }
}