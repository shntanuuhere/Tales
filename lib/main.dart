import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'theme/theme_notifier.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/privacy_policy.dart';
import 'screens/terms_conditions.dart';
import 'screens/about_us.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/user_details_screen.dart';
import 'providers/notes_provider.dart';import 'package:sentry_flutter/sentry_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://82055cd60d6a1c7363b24c89af1fd90e@o4509174553444352.ingest.us.sentry.io/4509174554558464';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(SentryWidget(child: MyApp(isLoggedIn: isLoggedIn))),
  );
  // TODO: Remove this line after sending the first sample event to sentry.
  await Sentry.captureException(Exception('This is a sample exception.'));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tales',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/user_details': (context) => UserDetailsScreen(),
        '/home': (context) => HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (isLoggedIn) {
          return MaterialPageRoute(builder: (_) => UserDetailsScreen());
        } else {
          return MaterialPageRoute(builder: (_) => SplashScreen());
        }
      },
    );
  }
}
