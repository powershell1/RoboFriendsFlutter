import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:robo_friends/bluetooth/bluetooth.dart';
import 'package:robo_friends/classes/assignmentClass.dart';
import 'package:robo_friends/classes/authentication.dart';
import 'package:robo_friends/pages/inside/navigate/assignmentPage.dart';
import 'package:robo_friends/pages/inside/navigate/profilePage.dart';
import 'package:robo_friends/pages/inside/navigate/testContent.dart';
import 'package:robo_friends/pages/inside/navigator/controlPage.dart';
import 'package:robo_friends/pages/inside/navigator/draftPage.dart';
import 'package:robo_friends/pages/inside/navigator/testPage.dart';
import 'package:robo_friends/pages/outside/register/registerPage.dart';
import 'package:robo_friends/pages/test_bluetooth/bluetoothPage.dart';
import 'package:robo_friends/pages/inside/navigate/codeIDE.dart';

// import 'package:robo_friends/pages/inside/silver_page.dart';
import 'package:robo_friends/pages/outside/loginPage.dart';
import 'package:robo_friends/pages/outside/welcomePage.dart';
import 'package:robo_friends/pages/test_bluetooth/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'firebase_options.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
late final FirebaseFirestore firestore;
late final FirebaseStorage storage;

late final usersRef;

// late final

bool shouldUseFirebaseEmulator = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isWelcomed = prefs.getBool('welcome') ?? false;
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);
  firestore = FirebaseFirestore.instanceFor(app: app);
  storage = FirebaseStorage.instanceFor(app: app);
  if (shouldUseFirebaseEmulator) {
    firestore.useFirestoreEmulator('localhost', 8080);
    await storage.useStorageEmulator('localhost', 9199);
    await auth.useAuthEmulator('localhost', 9099);
  }
  // const isWelcomed = true;
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

  bool isLogged = false;

  Future<void> reloadSVGs(List<String> path) async {
    for (String p in path) {
      final loader = SvgAssetLoader(p);
      await svg.cache
          .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
  }

  @override
  void didChangeDependencies() {
    precacheImage(
        const AssetImage("assets/icons/companies/google.png"), context);
    precacheImage(
        const AssetImage("assets/icons/companies/microsoft.png"), context);
    precacheImage(
        const AssetImage("assets/icons/companies/apple.png"), context);
    reloadSVGs([
      "assets/post_stage.svg",
      "assets/school_stage.svg",
    ]);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
          } else if (split[0] == 'profile') {
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ProfilePage(),
              transitionDuration: const Duration(milliseconds: 150),
              reverseTransitionDuration: const Duration(milliseconds: 150),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = const Offset(1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.easeInOutSine;
                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            );
          } else if (split[0] == 'assignments') {
            Assignment args = settings.arguments as Assignment;
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AssignmentPage(
                assignment: args,
              ),
              transitionDuration: const Duration(milliseconds: 150),
              reverseTransitionDuration: const Duration(milliseconds: 150),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = const Offset(1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.easeInOutSine;
                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            );
          } else if (split[0] == 'control') {
            return PageRouteBuilder(
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                pageBuilder: (context, animation1, animation2) =>
                    const ControlPage());
            return MaterialPageRoute(
              builder: (context) => const BluetoothDevicesList(),
            );
          } else if (split[0] == 'code_ide') {
            Map<String, dynamic> args =
                settings.arguments as Map<String, dynamic>;
            /*
            late TextEditingController controller = TextEditingController(
              text: 'https://powershell1.github.io/RoboWebpack/'// 'http://192.168.1.39:8080/',
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
                                title: args['title'] ?? 'Code IDE Sample',
                                codeJson: args['content'],
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

             */
            return MaterialPageRoute(
              builder: (context) => CodeIDE(
                title: args['title'] ?? 'Code IDE Sample',
                codeJson: args['content'],
                uri: 'https://powershell1.github.io/RoboWebpack/',
              ),
            );
          } else if (split[0] == 'test') {
            Map<String, dynamic>? args =
                settings.arguments as Map<String, dynamic>?;
            if (args != null) {
              return MaterialPageRoute(
                builder: (context) => TestContent(testId: args['id']),
              );
            }
            return PageRouteBuilder(
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                pageBuilder: (context, animation1, animation2) =>
                    const TestPage());
          } else if (split[0] == 'bluetooth_devices') {
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const BluetoothDevicesList(),
              transitionDuration: const Duration(milliseconds: 150),
              reverseTransitionDuration: const Duration(milliseconds: 150),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = const Offset(1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.easeInOutSine;
                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            );
          } else if (split[0] == 'home') {
            return PageRouteBuilder(
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (context, animation1, animation2) =>
                  AuthExternal.homepage,
            );
          }
        }
        if (settings.name == '/login') {
          return PageRouteBuilder(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animation2) => const Login(),
          );
        } else if (settings.name == '/register') {
          return MaterialPageRoute(builder: (context) => const Register());
        }
        if (settings.name == '/') {
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
