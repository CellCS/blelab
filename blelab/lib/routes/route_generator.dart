import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blelab/utils/app_constants.dart';
import 'package:blelab/screens/login/login_screen.dart';
import 'package:blelab/widgets/splash/splashpage.dart';
import 'package:blelab/widgets/splash/splashcontent.dart';
import 'package:blelab/screens/homepage.dart';
import '../utils/extra.dart';
import 'package:blelab/screens/device_screen.dart';
import 'package:blelab/screens/accounthome.dart';

List<SplashContent> splashes = [
  SplashContent('assets/images/splash2.gif', ''),
];

class RouteGenerator {
  /// The route configuration.
  static List<GetPage> appRoutes = [
    GetPage(
      name: '/error',
      page: () => RouteGenerator().errorPage(),
    ),
    GetPage(
      name: AppConstants.loginpage,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppConstants.splashpage,
      page: () => SplashPage(contents: splashes),
    ),
    GetPage(
      name: AppConstants.homepage,
      page: () => const HomePage(),
    ),
    GetPage(
      name: AppConstants.peripheralpage,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppConstants.connecteddevicepage,
      page: () => DeviceScreen(device: Get.arguments['device']),
    ),
    GetPage(
      name: AppConstants.appaboutpage,
      page: () => const AccounttHomePage(),
    ),
  ];

  Widget errorPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Happens'),
      ),
      body: const Center(
        child: Text('Sorry, an error has occurred. Please try again.'),
      ),
    );
  }
}
