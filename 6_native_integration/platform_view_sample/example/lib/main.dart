import 'package:flutter/material.dart';
import 'package:platform_view/platform_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = PlatformWebViewController();
  String initialUrl = 'https://google.com';

  @override
  void initState() {
    super.initState();
  }

  void goForward() {
    controller.goForward();
  }

  void goBack() {
    controller.goBack();
  }

  void onSubmittedUrl(String url) {
    controller.loadUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TextField(
                controller: TextEditingController(
                  text: initialUrl,
                ),
                onSubmitted: onSubmittedUrl,
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
              Expanded(
                child: PlatformWebViewWidget(
                  initialUrl: initialUrl,
                  useHybridComposition: true,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: goBack,
                    icon: Icon(Icons.arrow_back),
                  ),
                  IconButton(
                    onPressed: goForward,
                    icon: Icon(Icons.arrow_forward),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
