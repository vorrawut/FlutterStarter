import 'package:flutter/material.dart';

class GroupDetailPage extends StatelessWidget {
  final String groupId;

  const GroupDetailPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group $groupId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Group Detail Page - Coming Soon'),
            Text('Group ID: $groupId'),
          ],
        ),
      ),
    );
  }
}
