import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ali_auth/flutter_ali_auth.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'pages/debug_page.dart';
import 'pages/release_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _aliAuthVersion = '获取阿里云插件版本中';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    SmartDialog.config.toast = SmartConfigToast(
      alignment: Alignment.center,
      animationType: SmartAnimationType.fade,
    );
  }

  Future<void> initPlatformState() async {
    String aliAuthVersion;
    try {
      aliAuthVersion = (await AliAuthClient.version) as String? ?? '未知阿里云插件版本';
    } on PlatformException {
      aliAuthVersion = 'Failed to get ali auth plugin version.';
    }
    if (!mounted) return;
    setState(() {
      _aliAuthVersion = aliAuthVersion;
    });
  }

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(_aliAuthVersion),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            ReleasePage(),
            DebugPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.verified),
              label: "发布",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bug_report),
              label: "测试",
            ),
          ],
        ),
      ),
      // here
      navigatorObservers: [FlutterSmartDialog.observer],
      // here
      builder: FlutterSmartDialog.init(toastBuilder: (String text) {
        return DecoratedBox(
          decoration: const ShapeDecoration(
            shape: StadiumBorder(),
            color: Colors.black87,
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        );
      }),
    );
  }
}

extension HexColor on Color {
  String toHex() {
    return '#${(0xFFFFFF & value).toRadixString(16).padLeft(6, '0')}';
  }
}
