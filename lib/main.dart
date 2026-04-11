import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/novel_provider.dart';
import 'services/storage_service.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'core/di/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService().init();

  final novelProvider = NovelProvider();
  await novelProvider.waitForInitialization();

  runApp(
    ProviderScope(
      overrides: [
        novelProviderBridgeProvider.overrideWithValue(NovelNotifierBridge(novelProvider)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bridge = ref.watch(novelProviderBridgeProvider);
    final provider = bridge.raw;

    return MaterialApp.router(
      title: 'Always Remember Me',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
