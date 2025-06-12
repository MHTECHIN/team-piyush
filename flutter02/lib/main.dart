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

class _MainPageState extends State<MainPage> {
  late WebViewControllerPlus _controler;

  @override
  void initState() {
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
    super.initState();
  }

  double _height = 600; // Set a default height

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
