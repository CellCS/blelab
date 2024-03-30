import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:blelab/services/appservices.dart';
import 'package:blelab/services/appstate.dart';
import 'package:blelab/routes/route_generator.dart';
import 'package:blelab/utils/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AppStateController());
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
    );
  }
}
