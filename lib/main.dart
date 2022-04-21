import 'dart:io';
import 'package:disdukcapil_mobile/screens/add_role_page.dart';
import 'package:disdukcapil_mobile/screens/login_screen.dart';
import 'package:disdukcapil_mobile/screens/role_page.dart';
import 'package:disdukcapil_mobile/screens/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import './screens/detail_screen.dart';
import 'screens/index_screen.dart';

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;
  }
}

// Future<bool> addSelfSignedCertificate() async{
//   ByteData data = await rootBundle.load("assets/cert/CA.pem");
//   SecurityContext context = SecurityContext.defaultContext;
//   context.setTrustedCertificatesBytes(data.buffer.asUint8List());
//   return true;
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpoverrides();
  // assert(await addSelfSignedCertificate());

  SecurityContext(withTrustedRoots: false);
  ByteData data = await rootBundle.load("assets/cert/CA.pem");
  SecurityContext context = SecurityContext.defaultContext;
  // Trust the certificate
  context.setTrustedCertificatesBytes(data.buffer.asUint8List());

  // Requirement dari package flutter downloader
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => IndexScreen(),
        '/detail-screen': (context) => DetailScreen(),
        '/role': (context) => const RolePage(),
        '/add-role': (context) => const AddRolePage(),
        '/user-profile': (context) => const UserProfile(),
      },
    );
  }
}
