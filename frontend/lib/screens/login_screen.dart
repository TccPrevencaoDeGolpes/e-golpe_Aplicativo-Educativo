import 'package:flutter/material.dart';

//statefull widget -> classe abstrata 
// obrigado a criar método createState  
class LoginScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body() ,
    );
  }

  Container _body() {
    return Container(
      //infinity -> usa todo espaço liberado
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF1A419B)
      ),
      child: Center(
        child: Text('Olá'),
      ),
    );
  }
}