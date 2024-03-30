import 'package:flutter/material.dart';
import 'package:blelab/services/appservices.dart';
import 'package:get/get.dart';
import 'package:blelab/utils/app_constants.dart';

class MainPageFrame extends StatefulWidget {
  final Widget subwidget;
  final PreferredSizeWidget appbarwidget;
  final int pageindex;
  final Widget? extralayerwidget;
  final double marginpading;
  const MainPageFrame(
      {super.key,
      required this.subwidget,
      required this.pageindex,
      required this.appbarwidget,
      this.extralayerwidget,
      this.marginpading = 16});
  @override
  State<MainPageFrame> createState() => _MainPageFrameState();
}

class _MainPageFrameState extends State<MainPageFrame> {
  final appservice = AppService();
  int _selectedIndex = 0;
  double marginpading = 16;
  double marginpadingdevice = 1;

  @override
  void initState() {
    marginpading = 16;
    super.initState();
    load();
  }

  load() {
    if (widget.marginpading > 0) {
      marginpading = widget.marginpading;
    }
    setState(() {
      _selectedIndex = widget.pageindex;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Get.offNamed(AppConstants.homepage);
    } else if (index == 1) {
      Get.offNamed(AppConstants.peripheralpage);
    } else if (index == 2) {
      Get.offNamed(AppConstants.homepage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appbarwidget,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    marginpadingdevice, 4, marginpadingdevice, 0),
                child: widget.subwidget,
              ),
            ),
            if (widget.pageindex == 0 && widget.extralayerwidget != null)
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: widget.extralayerwidget,
                ),
              ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bluetooth_searching,
              color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
              size: 30.0,
            ),
            label: "", //'Scanner Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_remote,
              color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
              size: 30.0,
            ),
            label: "", //'BlePeripheral',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.device_unknown,
              color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
              size: 30.0,
            ),
            label: "",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
