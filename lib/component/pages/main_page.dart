import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:test_app/component/model/user_info.dart';
import 'package:test_app/component/pages/user_detail_page.dart';
import 'package:test_app/component/widget/card_item.dart';
import 'package:test_app/service/user_data_storage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<User>> usersFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    usersFuture = fetchUsers();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {}
  }

  Future<List<User>> fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('https://reqres.in/api/users?page=2'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final userList = jsonData['data'] as List<dynamic>;

        final users =
            userList.map((userData) => User.fromJson(userData)).toList();

        await UserDataStorage.saveUsers(users);

        return users;
      } else {
        return UserDataStorage.loadUsers();
      }
    } catch (e) {
      return UserDataStorage.loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<User>>(
        future: usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;

            return ListView.builder(
              controller: _scrollController,
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetail(user: users[index]),
                      ),
                    );
                  },
                  child: CardItem(user: users[index]),
                );
              },
            );
          } else {
            return const Text('No data available');
          }
        },
      ),
    );
  }
}
