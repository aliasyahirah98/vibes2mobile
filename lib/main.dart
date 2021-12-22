import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myveteran/core/provider/localization_provider.dart';
import 'package:myveteran/shared/config/app_localization.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/environment.dart';
import 'package:myveteran/shared/routes.dart' as router;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: Environment.fileName);

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<LocalizationProvider>(
          create: (_) => LocalizationProvider(),
        )
      ],
      child: const MyApp()
    ));
  });
}
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent, // transparent status bar
//   ));
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
//     runApp(MultiProvider(
//       providers: [
//         ChangeNotifierProvider<LocalizationProvider>(
//           create: (_) => LocalizationProvider(),
//         )
//       ],
//       child: const MyApp()
//     ));
//   });
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    for (var language in languages) {
      _locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      locale: Provider.of<LocalizationProvider>(context).locale,
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: _locals,
      onGenerateRoute: router.generateRoute,
      initialRoute: splash
    );
  }
}