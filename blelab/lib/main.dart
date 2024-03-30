import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:blelab/services/appservices.dart';
import 'package:blelab/services/appstate.dart';
import 'package:blelab/routes/route_generator.dart';
import 'package:blelab/utils/app_constants.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AppStateController());
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic subscription;
  bool initialized = false;

  @override
  void initState() {
    initialized = false;
    super.initState();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      final appservice = AppService();
      appservice.setScreenSize(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height);
      initialized = true;
    }
    return GetMaterialApp(
      locale: const Locale('en'), //Get.deviceLocale,
      fallbackLocale: const Locale('en'),
      title: AppConstants.appId,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      getPages: RouteGenerator.appRoutes,
      initialRoute: AppConstants.splashpage,
      builder: EasyLoading.init(),
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == AppConstants.homepage) {
      _adapterStateSubscription ??=
          FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          AppService().setBusy(false);
          Get.offAllNamed(AppConstants.loginpage);
          AppService().toastmessage("Can not enable BLE", isError: true);
        }
      });
    }else{
      
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}
