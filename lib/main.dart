import 'package:flutter/material.dart';
import 'package:chatrefer/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatrefer/screens/list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // initializing flutter core engine to using other method which is run in async
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatting app',
      theme: ThemeData (
        primarySwatch: Colors.lightGreen
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChatList()),
              );
            }); // transfer to chat screen
          }
          return LoginSignupScreen();
        },
      ),
    );
  }
}
