import 'package:flutter/material.dart';
import 'package:test_app/component/model/user_info.dart';
import 'package:test_app/utils/color_source.dart';

class UserDetail extends StatelessWidget {
  final User user;

  const UserDetail({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSource.purple,
        title: const Text('User Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${user.id}'),
            const SizedBox(
              height: 10,
            ),
            Text('Name: ${user.firstName} ${user.lastName}'),
            const SizedBox(
              height: 10,
            ),
            Text('Email: ${user.email}'),
            const SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.avatar),
            ),
          ],
        ),
      ),
    );
  }
}
