import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:webview_flutter/webview_flutter.dart';

import './cloudipsp_web_view_confirmation.dart';
import './receipt.dart';

abstract class CloudipspWebView extends Widget {
  factory CloudipspWebView({
    required Key key,
    required CloudipspWebViewConfirmation confirmation,
  }) = CloudipspWebViewImpl;
}

class CloudipspWebViewImpl extends StatefulWidget implements CloudipspWebView {
  static const URL_START_PATTERN =
      'http://secure-redirect.cloudipsp.com/submit/#';
  static const ADD_VIEWPORT_METADATA = '''(() => {
  const meta = document.createElement('meta');
  meta.setAttribute('content', 'width=device-width, user-scalable=0,');
  meta.setAttribute('name', 'viewport');
  const elementHead = document.getElementsByTagName('head');
  if (elementHead) {
  elementHead[0].appendChild(meta);
  } else {
  const head = document.createElement('head');
  head.appendChild(meta);
  }
  })();''';

  final PrivateCloudipspWebViewConfirmation _confirmation;

  CloudipspWebViewImpl({
    required Key key,
    required CloudipspWebViewConfirmation confirmation,
  })  : _confirmation = confirmation as PrivateCloudipspWebViewConfirmation,
        super(key: key);

  @override
  State<CloudipspWebViewImpl> createState() => _CloudipspWebViewImplState();
}

class _CloudipspWebViewImplState extends State<CloudipspWebViewImpl> {
  final WebViewController _webViewController = WebViewController();
  String? currentUrl;

  @override
  void initState() {
    initWebView();

    super.initState();
  }

  void initWebView() async {
    await _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _webViewController.setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: _navigationDelegate,
    ));
    _webViewController.enableZoom(true);
    _onWebViewCreated(_webViewController);
  }

  void _onWebViewCreated(WebViewController controller) async {
    await controller.runJavaScript(CloudipspWebViewImpl.ADD_VIEWPORT_METADATA);

    if (Platform.isAndroid) {
      widget._confirmation.response.headers.forEach((key, value) async {
        if (key.toLowerCase() == 'set-cookie') {
          await widget._confirmation.native
              .androidAddCookie(widget._confirmation.baseUrl, value);
        }
      });
    }

    print(
        'widget._confirmation.response.body.toString() ${widget._confirmation.response.body.toString()}');
    print('widget._confirmation.baseUrl ${widget._confirmation.baseUrl}');

    await controller.loadHtmlString(
      widget._confirmation.response.body.toString(),
      baseUrl: widget._confirmation.baseUrl,
    );
  }

  NavigationDecision _navigationDelegate(NavigationRequest request) {
    // _webViewController.
    final url = request.url;
    print('_navigationDelegate url $url');

    if (currentUrl == url) {
      print('_navigationDelegate url == currentUrl');

      // return NavigationDecision.prevent;
    }
    final detectsStartPattern =
        url.startsWith(CloudipspWebViewImpl.URL_START_PATTERN);
    var detectsCallbackUrl = false;
    var detectsApiToken = false;

    if (!detectsStartPattern) {
      detectsCallbackUrl = url.startsWith(widget._confirmation.callbackUrl);
      if (!detectsCallbackUrl) {
        detectsApiToken = url
            .startsWith('${widget._confirmation.apiHost}/api/checkout?token=');
      }
    }

    if (detectsStartPattern || detectsCallbackUrl || detectsApiToken) {
      Receipt? receipt;
      if (detectsStartPattern) {
        final jsonOfConfirmation =
            url.split(CloudipspWebViewImpl.URL_START_PATTERN)[1];
        dynamic response;
        try {
          response = jsonDecode(jsonOfConfirmation);
        } catch (e) {
          response = jsonDecode(Uri.decodeComponent(jsonOfConfirmation));
        }
        receipt = Receipt.fromJson(response['params'], response['url']);
      }
      widget._confirmation.completer.complete(receipt);
      return NavigationDecision.prevent;
    }
    currentUrl = url;
    return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
    print('_CloudipspWebViewImplState build url');

    return WebViewWidget(controller: _webViewController);
  }
}
