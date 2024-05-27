import 'dart:convert';
import 'package:dars4/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserController {
  final List<Product> _list = [];

  List<Product> get list => [..._list];

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        _list.clear();
        for (var user in data) {
          _list.add(Product.fromJson(user));
        }
      } else {
        debugPrint('${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
    }
  }
}
