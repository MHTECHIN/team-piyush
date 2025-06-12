import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

void main() {
  runApp(const WebViewPlusExample());
}

class WebViewPlusExample extends StatelessWidget {
  const WebViewPlusExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver 
{
  late WebViewControllerPlus _controler;
  double _height = 600; // Default height

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("Widget initState called");
    }

    WidgetsBinding.instance.addObserver(this); // Listen to app lifecycle

    _controler = WebViewControllerPlus()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            double height = await _controler.webViewHeight;
            if (height != _height) {
              if (kDebugMode) {
                print("Height is: $height");
              }
              setState(() {
                _height = height;
              });
            }
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('https://farmlancer.mhtechin.com'));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Stop listening
    if (kDebugMode) {
      print("Widget dispose called");
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      print("App lifecycle state changed: $state");
    }

    if (state == AppLifecycleState.paused) {
      print("📴 App moved to background");
    } else if (state == AppLifecycleState.resumed) {
      print("📱 App is back to foreground");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebViewPlus Example'),
      ),
      body: ListView(
        children: [
          Text("Height of WebviewPlus: $_height",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            height: _height,
            child: WebViewWidget(
              controller: _controler,
            ),
          ),
          const Text("End of WebviewPlus",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
