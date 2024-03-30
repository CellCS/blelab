import 'package:async/async.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

enum EasyLoadingType { error, info, success, progress, show }

class AppStateController extends GetxController {
  var isBusy = false.obs;
  late RestartableTimer restartableTimer;

  AppStateController() {
    restartableTimer = RestartableTimer(
      const Duration(minutes: 2),
      () {
        setBusy(false, msg: "Timeout");
      },
    );
  }
  bool isAppBusy() {
    return isBusy.value;
  }

  void setBusy(bool busy,
      {bool showToast = true, String msg = "", bool isError = false}) {
    isBusy.value = busy;
    if (busy) {
      restartableTimer.reset();
      if (msg == "") {
        msg = "Loading ...";
      }
      if (showToast) {
        EasyLoading.show(status: msg);
      }
    } else {
      if (msg == "") {
        if (isError) {
          msg = "An error happens, try again later";
        } else {
          msg = "Loaded";
        }
      }
      if (isError) {
        if (showToast) {
          EasyLoading.showError(msg);
        }
      } else {
        if (showToast) {
          EasyLoading.showSuccess(msg, duration: const Duration(seconds: 2));
        }
      }
      EasyLoading.dismiss();
    }
  }

  showProgreeMsg(EasyLoadingType type, String msg,
      {double progress = 0.0, int durationms = 800}) {
    Duration duration = Duration(milliseconds: durationms);
    switch (type) {
      case EasyLoadingType.error:
        EasyLoading.showError(msg, duration: duration);
        break;
      case EasyLoadingType.info:
        EasyLoading.showInfo(msg, duration: duration);
        break;
      case EasyLoadingType.success:
        EasyLoading.showSuccess(msg, duration: duration);
        break;
      case EasyLoadingType.progress:
        EasyLoading.showProgress(progress, status: msg);
        break;
      case EasyLoadingType.show:
        EasyLoading.show(status: msg);
        break;
      default:
        EasyLoading.dismiss();
        break;
    }
  }

  void toastmessage(String v, {bool isError = false, int durationms = 1500}) {
    Duration instanceduration = Duration(milliseconds: durationms);
    if (isError) {
      EasyLoading.showError(v, duration: instanceduration);
    } else {
      EasyLoading.showInfo(v, duration: instanceduration);
    }
  }

  void toastmessageType(
      String v, int msgtype, int durationms, double progress) {
    Duration instanceduration = Duration(milliseconds: durationms);
    if (msgtype == 0) {
      EasyLoading.showInfo(v, duration: instanceduration);
    } else if (msgtype == -1) {
      EasyLoading.showError(v, duration: instanceduration);
    } else if (msgtype == 1) {
      EasyLoading.showSuccess(v, duration: instanceduration);
    } else if (msgtype == 2) {
      EasyLoading.showInfo(v, duration: instanceduration);
    } else if (msgtype == 3) {
      EasyLoading.showProgress(progress, status: v);
    } else if (msgtype == 4) {
      EasyLoading.show(status: v);
    }
  }

  @override
  void onClose() {
    restartableTimer.cancel();
    super.onClose();
  }
}
