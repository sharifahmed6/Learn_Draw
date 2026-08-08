import 'package:flutter/material.dart';
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
  
  runApp(const App());
}
