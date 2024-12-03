import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_crud/models/user.dart';
import 'package:http/http.dart' as http;

class Users with ChangeNotifier {
  static const _baseUrl =
      "https://crud-firebase-212f8-default-rtdb.firebaseio.com/";
  final Map<String, User> _items = {};

  Future<List<User>> get all async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/users.json"));
      if (response.statusCode == 200 && response.body != "null") {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final Map<String, User> loadedUsers = {};
        data.forEach((id, userData) {
          loadedUsers[id] = User(
            id: id,
            name: userData['name'],
            email: userData['email'],
            avatarUrl: userData['avatarUrl'],
          );
        });
        _items.clear();
        _items.addAll(loadedUsers);
        notifyListeners();
        return loadedUsers.values.toList();
      }
    } catch (error) {
      print("Erro ao buscar usuários: $error");
    }
    return [];
  }

  int get count {
    return _items.length;
  }

  User byIndex(int i) {
    return _items.values.elementAt(i);
  }

  Future<void> put(User user) async {
    if (user == null) {
      return;
    }
    // alterar
    if (user.id != null &&
        user.id!.trim().isNotEmpty &&
        _items.containsKey(user.id)) {
      await http.patch(
        Uri.parse("$_baseUrl/users/${user.id}.json"),
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'avatarUrl': user.avatarUrl,
        }),
      );

      _items.update(
        user.id,
        (_) => User(
          id: user.id,
          name: user.name,
          email: user.email,
          avatarUrl: user.avatarUrl,
        ),
      );
    } else {
      final response = await http.post(
        Uri.parse("$_baseUrl/users.json"),
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'avatarUrl': user.avatarUrl,
        }),
      );

      final id = json.decode(response.body)['name'];
      print(json.decode(response.body));
      _items.putIfAbsent(
        id,
        () => User(
          id: id,
          name: user.name,
          email: user.email,
          avatarUrl: user.avatarUrl,
        ),
      );
    }
    notifyListeners();
  }

  void remove(User user) async {
    if (user != null && user.id != null) {
      await http.delete(Uri.parse("$_baseUrl/users/${user.id}.json"));
      _items.remove(user.id);
      notifyListeners();
    }
  }
}
