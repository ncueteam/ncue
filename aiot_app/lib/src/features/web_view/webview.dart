import 'package:flutter/material.dart';
import '../basic/route_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'services/globals.dart';
import 'drawer.dart';
import 'web_login.dart';

class WebViewTest extends RouteView {
  const WebViewTest({super.key})
      : super(routeName: '/webview', routeIcon: Icons.web);
  //const WebViewTest({Key? key}) : super(key: key);

  @override
  WebViewTestState createState() => WebViewTestState();
}

class WebViewTestState extends State<WebViewTest> {
  late final WebViewController controller;
  bool authenticated = false;
  var currentUrl = "http://frp.4hotel.tw:25580/";
  double _progressValue = 0.0;

  setCookie() async {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _progressValue = 0.1;
            });
          },
          onPageFinished: (String url) {
            _getCurrentUrl();
            debugPrint('URL: $url');
            setState(() {
              _progressValue = 1.0;
            });
          },
          onProgress: (int progress) {
            setState(() {
              _progressValue = progress / 100.0;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(currentUrl));

    debugPrint("cookie token: ${Global.profile.token}");
    final manager = WebViewCookieManager();
    await manager.setCookie(
      WebViewCookie(
        name: "login_token",
        value: Global.profile.token.toString(),
        domain: "frp.4hotel.tw",
      ),
    );
    //manager.clearCookies();
  }

  @override
  void initState() {
    super.initState();
    debugPrint("cookie token: ${Global.profile.token}");
    setCookie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
        //toolbarHeight: 0.0,
      ),
      body: WillPopScope(
        onWillPop: () async {
          var canBack = await controller.canGoBack();
          if (canBack) {
            // 当网页还有历史记录时，返回webview上一页
            await controller.goBack();
            _getCurrentUrl();
          } else {
            // 返回原生页面上一页
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          }
          return false;
        },
        child: Column(children: [
          LinearProgressIndicator(
            value: _progressValue,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          Expanded(
            child: WebViewWidget(controller: controller),
          ),
        ]),
      ),
      drawer: const MyDrawer(), //抽屉菜单
      floatingActionButton: getCookie(),
    );
  }

  void _getCurrentUrl() {
    debugPrint('Current URL3: $currentUrl');
    // ignore: unnecessary_null_comparison
    if (controller != null) {
      controller
          .runJavaScriptReturningResult("window.location.href")
          .then((value) {
        if (value != currentUrl) {
          setState(() {
            currentUrl = value.toString();
          });
          debugPrint('Current URL2: $currentUrl');
          if (currentUrl.toString() == '"http://frp.4hotel.tw:25580/login"') {
            debugPrint('Current URL4: $currentUrl');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginRoute()),
            );
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterTest()),
            );*/
          }
        }
      });
    }
  }

  Widget getCookie() {
    return FloatingActionButton(
      onPressed: () async {
        final cookies = await controller.runJavaScriptReturningResult(
          'document.cookie',
        );
        debugPrint(cookies.toString());
        debugPrint("user: ${Global.profile.user?.email}");
      },
      child: const Icon(Icons.cookie_outlined),
    );
  }
}
