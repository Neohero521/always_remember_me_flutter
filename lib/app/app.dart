import 'package:flutter/material.dart';
import '../features/novels/presentation/screens/novel_list_screen.dart';
import 'theme/app_theme.dart';

class MiaobiApp extends StatelessWidget {
  const MiaobiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '妙笔',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const NovelListScreen(),
    );
  }
}
