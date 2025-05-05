import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class LocationPage extends StatefulWidget {
  final String locationLink;

  const LocationPage({Key? key, required this.locationLink}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('intent://')) {
              final httpsUrl = _intentToHttps(request.url);
              if (httpsUrl != null) {
                controller.loadRequest(Uri.parse(httpsUrl));
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.locationLink));
  }

  String? _intentToHttps(String intentUrl) {
    final fallbackMatch = RegExp(r'S\.browser_fallback_url=([^;]+)').firstMatch(intentUrl);
    if (fallbackMatch != null) {
      final url = Uri.decodeComponent(fallbackMatch.group(1)!);
      if (url.startsWith('https://')) return url;
    }
    if (intentUrl.startsWith('intent://')) {
      return intentUrl.replaceFirst('intent://', 'https://');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.busLocation,
        ),
        backgroundColor: Colors.green[700],


        iconTheme: const IconThemeData(color: Colors.black), // 🔁 Back arrow color
        elevation: 1,
      ),
      body: WebViewWidget(controller: controller),

    );
  }

} 