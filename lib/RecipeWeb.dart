import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeWeb extends StatefulWidget {
  String Url;
  RecipeWeb(this.Url);

  @override
  State<RecipeWeb> createState() => _RecipeWebState();
}

class _RecipeWebState extends State<RecipeWeb> {
  late final String Url;
  late final WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    if (widget.Url.toString().contains("http://")) {
      Url = widget.Url.toString().replaceAll("http://", "https://");
    } else {
      Url = widget.Url;
    }
    webViewController = WebViewController()
      ..loadRequest(
        Uri.parse(Url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Viewer"),
      ),
      body: Container(
        child: WebViewWidget(
          controller: webViewController,
        ),
      ),
    );
  }
}
