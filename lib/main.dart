import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nd/pages/LoginPage.dart';
import 'package:nd/pages/NotesListPage.dart';
import 'package:nd/constants.dart';
import 'package:nd/models/Notes.dart';
import 'package:nd/pages/NoteCreatePage.dart';
import 'package:nd/pages/NoteDetailPage.dart';
import 'package:nd/pages/NotesListPage.dart';
import 'package:http/http.dart' as http;
import 'package:nd/pages/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navistar Documents',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Navistar Documents'),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.arguments) {
          case '/notes':
            return MaterialPageRoute(builder: (context) => NoteDetailPage());
          case '/note_detail':
            var data = settings.arguments;
            return MaterialPageRoute(
                builder: (context) => NoteDetailPage(
                      id: data,
                    ));
        }
      },
      routes: <String, WidgetBuilder>{
        "/second": (BuildContext context) => NoteDetailPage(),
        "/third": (BuildContext context) => MyHomePage(),
        "/notes_page": (BuildContext context) => NotesNewPage(),
        "/note_create": (BuildContext context) => NoteCreatePage(),
      },
    );
  }
}

/// The API endpoint here accepts a raw FCM payload for demonstration purposes.

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String data_token;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  @override
  void initState() {
    isUserAuth();
    super.initState();

    _messaging.getToken().then((token) => data_token = token);
    print(data_token);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        FlutterLocalNotificationsPlugin().show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print("I am v");
    });
  }

  isUserAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user_id = await prefs.getInt('user_id');
    if (user_id != null) {
      Navigator.pushNamed(context, '/notes_page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              //gradient: LinearGradient(
              //  begin: Alignment.topCenter,
              //  end: Alignment.bottomCenter,
              //  colors: [
              //    Color(0xFF0f2027),
              //    Color(0xFF2c5364),
              //  ],
              //),
              image: DecorationImage(
                image: AssetImage("assets/img/back3.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            children: [
              SizedBox(
                height: 150,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Логин",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Заполните поле';
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Пароль"),
                        validator: (value) {
                          if (value.isNotEmpty) {
                            return 'Заполните поле';
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: RaisedButton(
                          onPressed: () async {
                            if (data_token == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Container(
                                        child: const Text(
                                          'Не удается получить идентификатор устройства, если проблема сохраняется то перезапустите приложение',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      backgroundColor: Colors.red[500],
                                      duration: const Duration(seconds: 2),
                                      elevation: 10,
                                      margin: EdgeInsets.only(
                                          bottom: 20, left: 30, right: 30),
                                      behavior: SnackBarBehavior.floating));
                            } else {
                              var user = await login(_usernameController.text,
                                  _passwordController.text, data_token);
                              if (user != null) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setInt('user_id', user["user_id"]);
                                Navigator.pushNamed(context, '/notes_page');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Container(
                                        child: const Text(
                                          'Невалидные данные',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      backgroundColor: Colors.red[500],
                                      duration: const Duration(seconds: 1),
                                      elevation: 10,
                                      margin: EdgeInsets.only(
                                          bottom: 20, left: 30, right: 30),
                                      behavior: SnackBarBehavior.floating),
                                );
                              }
                            }
                          },
                          color: baseColor,
                          child: Container(
                            width: 150,
                            height: 40,
                            child: Center(
                              child: Text(
                                "Войти",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScaleTransition1 extends PageRouteBuilder {
  final Widget page;
  ScaleTransition1(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: Duration(milliseconds: 700),
          reverseTransitionDuration: Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                parent: animation,
                reverseCurve: Curves.fastOutSlowIn);
            return ScaleTransition(
              alignment: Alignment.bottomRight,
              scale: animation,
              child: child,
            );
          },
        );
}

Future login(String username, String password, String data_token) async {
  Map body = {"username": username, "password": password, "token": data_token};
  final url = base_url + '/api/login';
  var res = await http.post(Uri.parse(url), body: json.encode(body), headers: {
    "Accept": "application/json",
    "content-type": "application/json"
  });
  print(res.statusCode);
  print(res.body);
  if (res.statusCode == 200) return json.decode(res.body);

  return null;
}
