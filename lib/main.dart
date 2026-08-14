import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'injection_container.dart' as di;
import 'core/services/local_storage_service.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  await di.init();

  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();
  await Supabase.initialize(
      url: 'https://atwfxittmjjuhtukfqeb.supabase.co',
      publishableKey: 'sb_publishable_hagST303OtCMtd_G9zhehw_HF84m2bg'
  );
  runApp(const App());
}