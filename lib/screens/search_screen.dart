import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    String args = ModalRoute.of(context)!.settings.arguments as String;

    String searchArg = args.replaceAll(" ", "+");

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(args),
      ),
      body: WebView(
        initialUrl: 'https://www.google.com/search?q=$searchArg',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
