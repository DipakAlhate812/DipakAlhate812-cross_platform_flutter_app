import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'screens/login_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/recurring_task_screen.dart'; 
import 'providers/task_provider.dart';
import 'providers/recurring_task_provider.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String appId = 'ADD APP ID';
  const String clientKey = 'ADD Client Key';
  const String parseServerUrl = 'Add parse server URL';

  await Parse().initialize(
    appId,
    parseServerUrl,
    clientKey: clientKey,
    autoSendSessionId: true,
    debug: true,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => RecurringTaskProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recurring Reminder',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginScreen(),
        '/signup': (_) => SignUpScreen(),
        '/reset': (_) => ResetPasswordScreen(),
        '/add': (_) => TaskScreen(), 
        '/recurring': (_) => RecurringTaskScreen(), 
      },
    );
  }
}
