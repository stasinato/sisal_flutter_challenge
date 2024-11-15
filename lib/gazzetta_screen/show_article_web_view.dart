import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShowArticleWebView extends StatefulWidget {
  const ShowArticleWebView({super.key, required this.articleURL});
  final String articleURL;

  @override
  State<ShowArticleWebView> createState() => _ShowArticleWebViewState();
}

class _ShowArticleWebViewState extends State<ShowArticleWebView> {
  late WebViewController? controller;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progressValue) {
            /// se torno indietro prima che la pagina sia completamente caricata
            /// rischio memory leak
            if (mounted) {
              setState(() {
                progress = progressValue / 100.0;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.articleURL));
  }

  @override
  void dispose() {
    controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          if (progress < 1.0)
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 150),
              builder: (context, value, child) {
                return LinearProgressIndicator(value: value);
              },
            ),
          Expanded(
            child: WebViewWidget(
              controller: controller!,
            ),
          ),
        ],
      ),
    );
  }
}
