import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/profile_gallery_screen.dart';

void main() {
  runApp(const ProfileCardApp());
}

class ProfileCardApp extends StatelessWidget {
  const ProfileCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Layout Masterclass',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const ProfileGalleryScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}