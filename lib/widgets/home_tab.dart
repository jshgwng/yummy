// widgets/home_tab.dart

import 'package:flutter/material.dart';
import '../models/user.dart';

class HomeTab extends StatelessWidget {
  final User user;

  const HomeTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hello, ${user.name}'),
        ],
      ),
    );
  }
}
