import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_root.dart';
import 'core/theme/os_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: OsColors.page,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const IpfOSApp());
}
