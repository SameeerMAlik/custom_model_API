import 'package:flutter/material.dart';
import 'package:rest_api/home_screen.dart';
import 'package:rest_api/make_custom_model.dart';
import 'package:rest_api/userApi_withoutModel.dart';
import 'package:rest_api/user_model_example.dart';

import 'complex_json_model_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  ComplexJsonModelExample(),
    );
  }
}

