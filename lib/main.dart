import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ps_mosquito/src/presentation/screens/splash.dart';
import 'package:ps_mosquito/src/presentation/screens/add_task.dart';
import 'package:ps_mosquito/src/presentation/screens/login_mobile.dart';
import 'package:ps_mosquito/src/presentation/screens/Restore_password.dart';
import 'package:ps_mosquito/src/presentation/screens/menu_mobile.dart';
import 'package:ps_mosquito/src/presentation/screens/User_data.dart';
import 'package:ps_mosquito/src/presentation/screens/look_task.dart';
import 'package:ps_mosquito/src/presentation/screens/storage.dart';
import 'package:firebase_core/firebase_core.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBd0_dWTNOTQOA4vxbao9kWX6yEUWPhmuk",
        appId: "1:172987635386:web:906f3bfbf3495d1a745483",
        messagingSenderId: "172987635386",
        projectId: "mosquitobd-202b0",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}
class Task {
  String name;

  Task(this.name);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mosquito',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/User_data': (context) => const UserData(),
        '/storage': (context) => Storage(),
        '/Restore_password': (context) => const ResetPasswordScreen(),
        '/add_task': (context) => const AddTaskScreen(
              taskData: {},
              taskId: '',
              taskDetails: {},
            ),
        '/menu_mobile': (context) => const MenuMobile(),
        '/look_task': (context) => const LookTaskView(
              taskDetails: {},
              taskData: {},
              taskId: '',
              tareaDetails: '',
            ),
      },
      initialRoute: '/splash',
    );
  }
}