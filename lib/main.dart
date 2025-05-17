import 'package:bantay_alertdraft/create_accountpages/resident_getstarted.dart';
import 'package:bantay_alertdraft/firebase_options.dart';
import 'package:bantay_alertdraft/variable/authority_variable.dart';
import 'package:bantay_alertdraft/variable/resident_variable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bantay_alertdraft/login_pages/home_rolepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _checkinternetConnection();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthorityVariable()),
        ChangeNotifierProvider(create: (context) => ResidentVariable()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeRolePage());
  }
}

Future<void> _checkinternetConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    print('No Internet Connection');
  }
}
