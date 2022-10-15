import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl:
              "https://sites.google.com/view/jajaapplication/terms-and-conditions",
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
