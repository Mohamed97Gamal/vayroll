import 'dart:async';
import 'dart:isolate';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/providers/approved_requests_tab_index_provider.dart';
import 'package:vayroll/providers/check_in_out_notify_provider.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/utils/notifications.dart';
import 'package:vayroll/views/splash/splash.dart';

Future main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    // force portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);

    try {
      FirebaseCrashlytics.instance.sendUnsentReports();
    } catch (ex) {}

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => HomeTabIndexProvider()),
          ChangeNotifierProvider(create: (_) => EmployeeProvider()),
          ChangeNotifierProvider(create: (_) => HomeCheckInNotifyProvider()),
          ChangeNotifierProvider(create: (_) => HomeCheckOutNotifyProvider()),
          ChangeNotifierProvider(create: (_) => AttendanceCheckInNotifyProvider()),
          ChangeNotifierProvider(create: (_) => AttendanceCheckOutNotifyProvider()),
          ChangeNotifierProvider(create: (_) => FilterRequestsProvider()),
          ChangeNotifierProvider(create: (_) => FilterTeamRequestsProvider()),
          ChangeNotifierProvider(create: (_) => StartEndDateProvider()),
          ChangeNotifierProvider(create: (_) => DashboardWidgetsProvider()),
          Provider(create: (_) => ProfileTabIndexProvider()),
          Provider(create: (_) => ApprovedRequestsTabIndexProvider()),
          Provider(create: (_) => AutoCheckOutProvider()),
          Provider(create: (_) => RequestsKeyProvider()),
          Provider(create: (_) => KeyProvider()),
        ],
        child: MyApp(),
      ),
    );
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VAYROLL',
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeProvider>().theme,
      home: SplashPage(),
      navigatorKey: MyApp.navigatorKey,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    LocalNotification().init(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      context.read<KeyProvider>().homeAttendanceNotifier.refresh();
      context.read<HomeCheckOutNotifyProvider>().refresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
