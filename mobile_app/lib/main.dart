import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/home/presentation/pages/home_dashboard_page.dart';
import 'routing/app_router.dart';
import 'themes/dark_theme.dart';
import 'themes/light_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0D1117),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Healthcare Assistant',
      debugShowCheckedModeBanner: false,
      theme: LightTheme.data,
      darkTheme: DarkTheme.data,
      themeMode: ThemeMode.dark,
      home: const HomeDashboardPage(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
