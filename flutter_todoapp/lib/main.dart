import 'package:flutter/material.dart';
import 'authentication.dart'; // Importez votre classe MyForm ici

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      // Définir la route initiale
      initialRoute: '/',
      // Définir les routes de votre application
      routes: {
        '/': (context) => MyForm(), // Pointez la route initiale vers MyForm()
        // Ajoutez les autres routes de votre application ici
      },
    );
  }
}
