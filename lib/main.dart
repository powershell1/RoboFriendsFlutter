import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:robo_friends/bluetooth/bluetooth.dart';
import 'package:robo_friends/pages/inside/draft_page.dart';
import 'package:robo_friends/pages/test_bluetooth/bluetooth_page.dart';
import 'package:robo_friends/external/auth_external.dart';
import 'package:robo_friends/external/theme_external.dart';
import 'package:robo_friends/pages/inside/navigate/code_ide.dart';

// import 'package:robo_friends/pages/inside/silver_page.dart';
import 'package:robo_friends/pages/outside/login_page.dart';
import 'package:robo_friends/pages/outside/welcome_page.dart';
import 'package:robo_friends/pages/test_bluetooth/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // final isWelcomed = prefs.getBool('welcome') ?? false;
  const isWelcomed = true;
  print('Welcome: $isWelcomed');
  if (await Permission.location.status.isDenied) {
    await Permission.location.request();
  }
  if (await Permission.bluetoothConnect.status.isDenied) {
    await Permission.bluetoothConnect.request();
  }
  if (await Permission.bluetooth.status.isDenied) {
    await Permission.bluetooth.request();
  }
  if (await Permission.bluetoothScan.status.isDenied) {
    await Permission.bluetoothScan.request();
  }
  runApp(
    App(welcome: isWelcomed),
  );
}

class App extends StatefulWidget {
  App({super.key, required this.welcome});

  final bool welcome;

  static ThemeTemplate theme = ThemeTemplate();

  @override
  State<StatefulWidget> createState() => _AppState();
}

extension IterableX<T> on Iterable<T> {
  dynamic safeFirstWhere(bool Function(T) test) {
    final sublist = where(test);
    return sublist.isEmpty ? null : sublist.first;
  }
}

class _AppState extends State<App> {
  late ThemeMode themeMode = ThemeMode.system;

  bool isLogged = true;

  @override
  void didChangeDependencies() {
    precacheImage(
        const AssetImage("assets/icons/companies/google.png"), context);
    precacheImage(
        const AssetImage("assets/icons/companies/microsoft.png"), context);
    precacheImage(
        const AssetImage("assets/icons/companies/apple.png"), context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    isLogged = true;
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    App.theme.brightness = brightness;
    BluetoothConnection.startScans();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paw Pals',
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light().copyWith(
          onPrimary: Colors.black,
          primaryContainer: Colors.black54,
          onSecondary: Colors.black,
          secondaryContainer: Colors.black26,
          error: const Color(0xffcf6679),
          onError: Colors.black,
        ),
      ),
      /*
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark().copyWith(
          onPrimary: Colors.white,
          primaryContainer: Colors.white54,
          onSecondary: Colors.white,
          secondaryContainer: Colors.white24,
          error: const Color(0xffcf6679),
          onError: Colors.white,
        ),
      ),

       */
      onGenerateRoute: (settings) {
        /*
        home: Stack(
          children: <Widget>[
            if (!widget.welcome)
              const WelcomePage(
                type: 0,
              )
            else
              isLogged
                  ? AuthExternal.homepage
                  : const Login(),
          ],
        ),
         */
        const bool isExperimental = false;
        if (isExperimental) {
          return MaterialPageRoute(
              builder: (context) => const BluetoothDevicesList());
        }
        bool startWithContext = settings.name!.startsWith('/context');
        if (startWithContext) {
          String context = settings.name!.substring(9);
          List<String> split = context.split('/');
          if (split[0] == "draft") {
            return PageRouteBuilder(
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (context, animation1, animation2) => DraftPage(),
            );
          } else if (split[0] == 'code_ide') {
            late TextEditingController controller = TextEditingController(
              text: 'http://192.168.1.39:8080/',
            );
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'uri',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CodeIDE(
                                title: 'Connect to IDE',
                                codeJson: '',
                                uri: '${controller.text}?app_ide',
                              ),
                            ),
                          );
                        },
                        child: const Text('Bluetooth Devices'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (split[0] == 'bluetooth_devices') {
            return MaterialPageRoute(
              builder: (context) => const BluetoothDevicesList(),
            );
          }
        }
        if (settings.name == '/login') {
          return PageRouteBuilder(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animation2) => const Login(),
          );
        }
        if (settings.name == '/' || settings.name == '/context/home') {
          /*
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return CodeIDE(
                title: 'Code IDE Sample',
                codeJson: '',
              );
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          );
           */
          // return MaterialPageRoute(builder: (context) => TestBluetooth());
          Widget page = isLogged ? AuthExternal.homepage : const Login();
          page = !widget.welcome ? const WelcomePage(type: 0) : page;
          return PageRouteBuilder(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animation2) => page,
          );
        }
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for\n"${settings.name}"'),
            ),
          ),
        );
      },
    );
  }
}
