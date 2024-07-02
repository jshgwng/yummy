// widgets/profile_tab.dart

import 'package:flutter/material.dart';
import '../models/user.dart';

class ProfileTab extends StatelessWidget {
  final User? user;

  const ProfileTab({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${user!.name}'),
            Text('Email: ${user!.email}'),
          ],
        ),
      );
    }
  }
}
