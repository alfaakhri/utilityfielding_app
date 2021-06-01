import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenIntroWebview extends StatefulWidget {
  final String? url;

  const OpenIntroWebview({Key? key, this.url}) : super(key: key);
  @override
  _OpenIntroWebviewState createState() => _OpenIntroWebviewState();
}

class _OpenIntroWebviewState extends State<OpenIntroWebview> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: WebView(
        initialUrl: widget.url!,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
      ),
    );
  }

  // _loadHtmlFromAssets() async {
  //   String fileText =
  //       await rootBundle.loadString('assets/App_Privacy_Policy_1.html');
  //   _controller.loadUrl(Uri.dataFromString(fileText,
  //           mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //       .toString());
  // }
}
