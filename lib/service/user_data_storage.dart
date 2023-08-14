import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../component/model/user_info.dart';

class UserDataStorage {
  static Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'users',
      users.map((user) => json.encode(user.toJson())).toList(),
    );
  }

  static Future<List<User>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsers = prefs.getStringList('users');
    if (savedUsers != null) {
      return savedUsers.map((userJson) {
        return User.fromJson(json.decode(userJson));
      }).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
