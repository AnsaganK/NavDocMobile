import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nd/constants.dart';
import 'package:nd/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//d0074ba6-2a78-4c1c-832c-29e92418fa1c
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

int user_id;
var user;
Future getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  user_id = await prefs.getInt('user_id');
  final url = base_url + '/api/profile/${user_id}';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return await json.decode(utf8.decode(response.bodyBytes));
  }
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Профиль"),
        centerTitle: true,
        backgroundColor: baseColor,
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              })
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/back.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            children: [
              FutureBuilder(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, .15),
                            offset: Offset(0, 2),
                            blurRadius: 3,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, .15),
                                    offset: Offset(0, 2),
                                    blurRadius: 3,
                                    spreadRadius: 1,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: snapshot.data['profile']['picture'] != null
                                  ? Image.network(
                                      base_url +
                                          snapshot.data['profile']['picture'],
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;

                                        return Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: SpinKitDualRing(
                                              color: secondColor,
                                            ),
                                          ),
                                        );
                                        // You can use LinearProgressIndicator or CircularProgressIndicator instead
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Text('Some errors occurred!'),
                                    )
                                  : Image.asset(
                                      'assets/img/back.jpg',
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Фамилия"),
                                Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    "${snapshot.data['last_name']}",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Имя"),
                                Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    "${snapshot.data['first_name']}",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Отчество"),
                                Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    "${snapshot.data['profile']['patronymic']}",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Почта"),
                                Container(
                                  width: 200,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    "${snapshot.data['email']}",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Мобильный"),
                                Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    "${snapshot.data['profile']['mobile']}",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Отдел"),
                                Container(
                                  width: 200,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    "${snapshot.data['profile']['department'] != null ? snapshot.data['profile']['department']['name'] : null}",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Данные не были загружены"),
                    );
                  }
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 130),
                    child: SpinKitDualRing(
                      color: secondColor,
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
