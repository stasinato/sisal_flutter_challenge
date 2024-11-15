import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShowArticleWebView extends StatefulWidget {
  const ShowArticleWebView({super.key, required this.articleURL});
  final String articleURL;

  @override
  State<ShowArticleWebView> createState() => _ShowArticleWebViewState();
}

class _ShowArticleWebViewState extends State<ShowArticleWebView> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()..loadRequest(Uri.parse(widget.articleURL));
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
