import 'package:flutter/material.dart';
import 'package:writeblog/HomeScreen.dart';
import 'package:writeblog/create.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:writeblog/constraints.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
   
}


ThemeData _lightTheme =
    ThemeData(primarySwatch: Colors.teal, brightness: Brightness.light);
ThemeData _darkTheme =
    ThemeData(primarySwatch: Colors.teal, brightness: Brightness.dark);
class _MyAppState extends State<MyApp> {
  void updateIconBool(bool value) {
    setState(() {
      iconBool = value;
    });
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Blog',
      theme: iconBool ? _lightTheme:_darkTheme,
      initialRoute: '/',
      routes: {
        '/create': (context) => CreateBlog(),
      },
      home: HomeScreen(updateIconBool: updateIconBool),
    );
  }
}
