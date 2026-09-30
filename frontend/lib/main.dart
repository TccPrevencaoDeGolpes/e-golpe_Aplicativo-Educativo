import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/cadastro_conta_screen.dart';
import 'package:frontend/screens/inicio_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/menu_screen.dart';
import 'package:frontend/screens/perfil_screen.dart';
import 'package:frontend/screens/realizar_teste_screen.dart';
import 'package:frontend/screens/resultado_teste.dart';
import 'package:frontend/screens/teste_de_conhecimento_screen.dart';
import 'package:frontend/screens/teste_personalizado_screen.dart';

final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();
Future<void> main() async{
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      title: 'TCC',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, //para o cupertinoDaterPicker traduzir pra pt-br
      ],

      supportedLocales: const [
        Locale('pt', 'BR'), // Português do Brasil
      ],

      locale: const Locale('pt', 'BR'), 

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/inicio',
      routes: {
        '/inicio': (context) => const InicioScreen(),
        '/menu': (context) => const MenuScreen(),
        '/login':(context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroContaScreen(),
        '/perfil': (context) => const PerfilScreen(),
        '/testes':(context) =>  const TesteDeConhecimentoScreen(),
        '/criar-teste-personalizado': (context) => const TestePersonalizadoScreen(),
        '/realizar-teste': (context) => const RealizarTesteScreen(),
        '/resultado-teste': (context) => const ResultadoTesteScreen(), 
      },
    );
  }
}

