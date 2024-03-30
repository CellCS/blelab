import 'package:flutter/material.dart';
import 'dart:async';
import 'splashcontent.dart';
import 'package:blelab/services/appservices.dart';
import 'package:get/get.dart';
import 'package:blelab/utils/app_constants.dart';

class SplashPage extends StatefulWidget {
  final List<SplashContent> contents;

  const SplashPage({super.key, required this.contents});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _currentPage = 0;
  int _totalPages = 0;
  late Timer _timer;
  final appservice = AppService();

  @override
  void initState() {
    initactions();
    _currentPage = 0;
    _totalPages = widget.contents.length - 1;
    super.initState();
    _startTimer();
  }

  @override
  dispose() {
    _timer.cancel();
    super.dispose();
  }

  initactions() async {}

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (_currentPage < _totalPages) {
        setState(() {
          _currentPage++;
        });
      } else {
        _skipToLogin();
      }
    });
  }

  Future<void> _skipToLogin() async {
    _timer.cancel();
    appservice.setBusy(false);
    await appservice.requestPermissions();
    Get.offAllNamed(AppConstants.loginpage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              widget.contents[_currentPage].imagePath,
              height: MediaQuery.of(context).size.height * 0.9,
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              widget.contents[_currentPage].message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
