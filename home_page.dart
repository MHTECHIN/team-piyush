import 'dart:async';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WebViewController _controller;
  int loadingPercentage = 0;
  int _currentIndex = 0;
  bool internetDisconnected = false;
  late Text appBarTitleText;
  StreamSubscription? _internetStreamSubscription;

  final List<String> urls = [
    'https://mhtechin.com/appscreen1',
    'https://mhtechin.com/appscreen2',
    'https://mhtechin.com/appscreen3',
    'https://mhtechin.com/appscreen4',
  ];

  final List<String> tabs = ['Home', 'Support', 'Job', 'Mail'];

  @override
  void initState() {
    super.initState();
    appBarTitleText = Text(tabs[_currentIndex]);
    _initializeWebView();
    _subscribeToInternetChanges();
  }

  void _subscribeToInternetChanges() {
    _internetStreamSubscription =
        InternetConnection().onStatusChange.listen((status) {
          setState(() {
            internetDisconnected = (status == InternetStatus.disconnected);
          });
        });
  }

  void _initializeWebView() {
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              setState(() => loadingPercentage = 0);
              FirebaseCrashlytics.instance.log("Page started: $url");
            },
            onProgress: (progress) {
              setState(() => loadingPercentage = progress);
            },
            onPageFinished: (url) {
              setState(() => loadingPercentage = 100);
              FirebaseCrashlytics.instance.log("Page finished: $url");
            },
            onWebResourceError: (error) {
              internetDisconnected = true;
              FirebaseCrashlytics.instance.recordError(
                Exception('WebView Error: ${error.description}'),
                StackTrace.current,
                reason: 'WebResourceError: ${error.errorType}',
              );
              setState(() {});
            },
          ),
        )
        ..loadRequest(Uri.parse(urls[_currentIndex]));
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s,
          reason: 'WebViewController initialization failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appBarTitleText,
      ),
      body: internetDisconnected
          ? _buildNoInternetView()
          : Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
              color: Colors.red,
            ),
        ],
      ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        backgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 400),
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home, size: 30),
            title: const Text('Home', style: TextStyle(fontSize: 16)),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.support_agent, size: 30),
            title: const Text('Support', style: TextStyle(fontSize: 16)),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.work, size: 30),
            title: const Text('Job', style: TextStyle(fontSize: 16)),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.mail, size: 30),
            title: const Text('Mail', style: TextStyle(fontSize: 16)),
          ),
        ],
        onItemSelected: (index) {
          try {
            setState(() {
              _currentIndex = index;
              appBarTitleText = Text(tabs[index]);
              loadingPercentage = 0;
            });
            _controller.loadRequest(Uri.parse(urls[_currentIndex]));
            FirebaseCrashlytics.instance
                .log("Tab changed to: ${tabs[index]}");
          } catch (e, s) {
            FirebaseCrashlytics.instance.recordError(e, s,
                reason: 'Error while switching tabs');
          }
        },
      ),
    );
  }

  Widget _buildNoInternetView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/no_signal.webp",
            width: MediaQuery.sizeOf(context).width / 2,
          ),
          const SizedBox(height: 20),
          const Text(
            "You Are Offline",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Text("Make sure you have an internet connection"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              FirebaseCrashlytics.instance.log("Retry button tapped");
              _initializeWebView();
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _internetStreamSubscription?.cancel();
    super.dispose();
  }
}
