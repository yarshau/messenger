import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yar_messenger/firebase_api.dart';
import 'package:yar_messenger/login_page.dart';
import 'navigation/page_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseApi>(create: (_) => FirebaseApi()),
      ],
      child: MaterialApp(
        home: LoginPage(),
        onGenerateRoute: (settings){
          return PageRoutes.getPageRoute(settings.name!, settings.arguments);
        },
      ),
    );
  }
}
