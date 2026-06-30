import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/app_initializer.dart';

export 'app/app.dart' show MyApp;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  runApp(const MyApp());
}
