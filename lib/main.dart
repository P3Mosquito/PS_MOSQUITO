import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ps_mosquito/src/presentation/screens/add_task.dart';
import 'package:ps_mosquito/src/presentation/screens/login_mobile.dart';
import 'package:ps_mosquito/src/presentation/screens/register_web.dart';
import 'package:ps_mosquito/src/presentation/screens/Restore_password.dart';
import 'package:ps_mosquito/src/presentation/screens/menu_web.dart';
import 'package:ps_mosquito/src/presentation/screens/menu_mobile.dart';
import 'package:ps_mosquito/src/presentation/screens/zone_map.dart';
import 'package:ps_mosquito/src/presentation/screens/map_mobile.dart';
import 'package:ps_mosquito/src/presentation/screens/look_task.dart';


import 'package:firebase_core/firebase_core.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
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
  runApp(MyApp());
}
class Task {
  String name;

  Task(this.name);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mosquito',
      // Define las rutas de la aplicación
      routes: {

            '/login': (context) =>
          LoginScreen(),

            '/map_mobile': (context) =>
            MapMobile(),

            '/menu_web': (context) =>
            AdminMenu(),

            '/register_web': (context) =>
            RegisterScreen(),

            '/Restore_password': (context) =>
            ResetPasswordScreen(),

            '/zone_map': (context) =>
            const ZoneMapScreen(),

            '/add_task': (context) =>
            AddTaskScreen(taskData: {},),

            '/menu_mobile': (context) =>
            MenuMobile(),

            '/look_task': (context) =>
            LookTaskView(),


      },
      // Define la pantalla inicial
      initialRoute: '/login',
    );
  }
}
