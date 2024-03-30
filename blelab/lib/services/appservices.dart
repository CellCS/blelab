import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:blelab/services/appstate.dart';
import 'package:blelab/utils/app_constants.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class AppService {
  bool isDebugMode = false;
  String appId = AppConstants.appId;
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  bool isSmallScreen = false;

  /// Other service interfaces
  final appState = Get.find<AppStateController>();
  AppService._privateConstructor();
  static final AppService _instance = AppService._privateConstructor();
  factory AppService() {
    return _instance;
  }

  void toastmessage(String v, {bool isError = false, int durationms = 1500}) {
    appState.toastmessage(v, isError: isError);
  }

  void toastmessageType(String v,
      {int msgtype = 0, int durationms = 1500, double progress = 0.0}) {
    appState.toastmessageType(v, msgtype, durationms, progress);
  }

  void setScreenSize(double w, double h) async {
    if (w < 1) {
      await Future.delayed(const Duration(milliseconds: 120), () {});
      w = Get.size.width;
      h = Get.size.height;
    }
    screenWidth = min(w, h);
    screenHeight = max(w, h);
    if (min(w, h) > 600) {
      isSmallScreen = false;
    } else {
      isSmallScreen = true;
    }
  }

  bool get isBusy => appState.isBusy.value;

  void setBusy(bool busy, {bool showToast = false}) {
    appState.setBusy(busy, showToast: showToast);
  }

  void cleanBusy(bool busy, {String msg = "", bool isError = false}) {
    appState.setBusy(busy, msg: msg, isError: isError);
  }

  void cleanBusyWith(bool busy, {String msg = "", bool isError = false}) {
    appState.setBusy(busy, msg: msg, isError: isError);
  }

  Future<void> requestlaunchURL(String urlstr, Uri urlpath) async {
    if (urlstr.isNotEmpty) {
      urlpath = Uri.parse(urlstr);
    }
    if (await canLaunchUrl(urlpath)) {
      await launchUrl(urlpath);
    } else {}
  }

  ///end
}
