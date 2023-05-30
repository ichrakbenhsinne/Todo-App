import 'package:flutter/material.dart';
import 'todoliste.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  bool _isAuthenticated = false;
  double _opacity = 1.0;

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void _authenticate() {
    // Votre logique d'authentification ici
    String username = _controller1.text;
    String password = _controller2.text;
    if (username == 'ichrakbenhsinne2@gmail.com' && password == 'ichrak') {
      setState(() {
        _isAuthenticated = true;
        _opacity = 0.0; // Réduire l'opacité à 0 pour masquer les widgets d'authentification
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TodoList()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Se Connecter'),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('lib/assets/logo.png'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 500), // Durée de l'animation en millisecondes
              child: TextField(
                controller: _controller1,
                decoration: InputDecoration(
                  labelText: 'Login',
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 500), // Durée de l'animation en millisecondes
              child: TextField(
                controller: _controller2,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text('Connexion'),
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                textStyle: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
