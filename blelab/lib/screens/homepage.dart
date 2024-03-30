import 'package:flutter/material.dart';
import 'package:blelab/services/appservices.dart';
import 'package:get/get.dart';
import 'package:blelab/utils/app_constants.dart';
import 'package:blelab/widgets/mainframe.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appservice = AppService();
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainPageFrame(
      pageindex: 0,
      appbarwidget: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          leadingWidth: 100,
          titleSpacing: 5,
          title: const Text('Scan'),
          leading: IconButton(
            icon: Icon(Icons.account_circle_rounded),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            )
          ]),
      subwidget: SingleChildScrollView(
          child: Column(
              // used to be "Stack"
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SizedBox(
              height: 800,
            )
          ])),
    );
  }
}
