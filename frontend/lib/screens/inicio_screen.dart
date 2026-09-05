import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart';

class InicioScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  Container _body() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Color(0xFF1A419B)),
      child: Column(
        children: [
          Text('Olá'),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
