import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sleep_tracker/screens/auth.dart';
import 'package:sleep_tracker/screens/sleep_list.dart';
import 'package:sleep_tracker/screens/splash.dart';
import 'package:sleep_tracker/utils/app_theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ja_JP');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'),
        Locale('en'),
      ],
      locale: const Locale('ja'),
      home: StreamBuilder(
        // 認証状態の変更を取得する
        // ①リスナーの登録直後 ②ユーザーがログインした時 ③現在のユーザーがログアウトした時
        // https://firebase.google.com/docs/auth/flutter/start?hl=ja#authstatechanges
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // ローディング中はSplash画面を表示する
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            // snapshotがnullでない=ログイン済みの状態
            // 一覧画面へ遷移する
            return const SleepListScreen();
          }
          // snapshotがnull=未ログイン状態
          // 認証画面へ遷移する
          return const AuthScreen();
        },
      ),
    );
  }
}
