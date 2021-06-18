import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nd/constants.dart';
import 'package:nd/main.dart';
import 'package:nd/models/Notes.dart';
import 'package:nd/pages/NoteCreatePage.dart';
import 'package:nd/pages/ProfilePage.dart';
import 'package:nd/widgets/NoteCardWidget.dart';
import 'package:nd/widgets/CategoryTitle.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesNewPage extends StatefulWidget {
  final int days;
  int currentPage;
  int selectedIndex;
  NotesNewPage({this.days = 7, this.currentPage = 0, this.selectedIndex = 1});
  @override
  _NotesNewPageState createState() => _NotesNewPageState();
}

class _NotesNewPageState extends State<NotesNewPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  //var _currentPage = 0;
  List notes_list;
  var _pages = [
    Text("First page"),
    Text("Second Page"),
  ];
  //int selectedIndex = 1;
  List categories = [
    'Все',
    'Принятые',
    'Срочные',
    'Одобренные',
    'Редактирование',
    'Отказано'
  ];
  List statuses = [
    'all',
    'my',
    'fast',
    'success',
    'edit',
    'error',
  ];
  int isMessage = 0;
  user_id() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = await prefs.getInt('user_id');
  }

  Future<Null> _refresh;

  int user;
  Future<NotesList> sendNotesList;
  Future<NotesList> myNotesList;
  @override
  void initState() {
    super.initState();
    user_id();
    sendNotesList = getSendNotesList(widget.days);
    myNotesList = getMyNotesList(widget.days);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitDialog,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.format_list_bulleted_sharp),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(
                          "3 дня",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color:
                                  widget.days == 3 ? Colors.red : Colors.black),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotesNewPage(
                                        days: 3,
                                        currentPage: widget.currentPage,
                                        selectedIndex: widget.selectedIndex,
                                      )));
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          "7 дней",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color:
                                  widget.days == 7 ? Colors.red : Colors.black),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotesNewPage(
                                        days: 7,
                                        currentPage: widget.currentPage,
                                        selectedIndex: widget.selectedIndex,
                                      )));
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          "14 дней",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: widget.days == 14
                                  ? Colors.red
                                  : Colors.black),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotesNewPage(
                                        days: 14,
                                        currentPage: widget.currentPage,
                                        selectedIndex: widget.selectedIndex,
                                      )));
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          "30 дней",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: widget.days == 30
                                  ? Colors.red
                                  : Colors.black),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotesNewPage(
                                        days: 30,
                                        currentPage: widget.currentPage,
                                        selectedIndex: widget.selectedIndex,
                                      )));
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: secondColor),
          elevation: 3,
          title: Text(
            "Мои СЗ",
            style: TextStyle(color: Colors.black54),
          ),
          centerTitle: true,
          shadowColor: Colors.black,
          backgroundColor: Colors.white.withOpacity(1),
          actions: [
            Center(
              child: Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.autorenew),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotesNewPage(
                            days: widget.days,
                            currentPage: widget.currentPage,
                            selectedIndex: widget.selectedIndex,
                          ),
                        ),
                      );
                    },
                  ),
                  isMessage > 0
                      ? Positioned(
                          top: 10,
                          right: 10,
                          child: Text(
                            "!",
                            style: TextStyle(color: Colors.red, fontSize: 17),
                          ),
                        )
                      : Text(""),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
            )
          ],
        ),
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/back.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30 / 2),
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.selectedIndex = index;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          left: 10,
                          right: index == categories.length - 1 ? 10 : 0,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: index == widget.selectedIndex
                                ? secondColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 1, color: secondColor)),
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: index == widget.selectedIndex
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                FutureBuilder(
                  future: Future.wait(
                    [
                      myNotesList, // Future<bool> secondFuture() async {...}
                      sendNotesList, // Future<bool> firstFuture() async {...}
                    ],
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data[widget.currentPage].notes;
                      if (widget.currentPage == 1) {
                        if (statuses[widget.selectedIndex] == 'fast') {
                          notes_list = data
                              .where((obj) => obj.fast == true)
                              .where((obj) => obj.status == null)
                              .toList();
                        } else if (statuses[widget.selectedIndex] == 'my') {
                          notes_list =
                              data.where((obj) => obj.status == null).toList();
                        } else if (statuses[widget.selectedIndex] ==
                            'success') {
                          notes_list = data
                              .where((obj) => obj.status == 'success')
                              .toList();
                        } else if (statuses[widget.selectedIndex] == 'edit') {
                          notes_list = data
                              .where((obj) => obj.status == 'edit')
                              .toList();
                        } else if (statuses[widget.selectedIndex] == 'error') {
                          notes_list = data
                              .where((obj) => obj.status == 'error')
                              .toList();
                        } else {
                          notes_list = snapshot.data[widget.currentPage].notes;
                        }
                      } else if (widget.currentPage == 0) {
                        if (statuses[widget.selectedIndex] == 'fast') {
                          notes_list = data
                              .where((obj) => obj.fast == true)
                              .where((obj) =>
                                  obj.status == null &&
                                  obj.users[obj.user_index - 1]['user'] == user)
                              .toList();
                        } else if (statuses[widget.selectedIndex] == 'my') {
                          notes_list = data
                              .where((obj) =>
                                  obj.status == null &&
                                  obj.users[obj.user_index - 1]['user'] == user)
                              .toList();
                        } else if (statuses[widget.selectedIndex] ==
                            'success') {
                          notes_list = [];
                          data.forEach(
                            (obj) => obj.users.forEach(
                              (obj_little) {
                                if (obj_little["status"] == 'success' &&
                                    obj_little['user'] == user) {
                                  notes_list.add(obj);
                                }
                              },
                            ),
                          );
                        } else if (statuses[widget.selectedIndex] == 'edit') {
                          notes_list = [];
                          data.forEach(
                            (obj) => obj.users.forEach(
                              (obj_little) {
                                if (obj_little["status"] == 'edit' &&
                                    obj_little['user'] == user) {
                                  notes_list.add(obj);
                                }
                              },
                            ),
                          );
                        } else if (statuses[widget.selectedIndex] == 'error') {
                          notes_list = [];
                          data.forEach(
                            (obj) => obj.users.forEach(
                              (obj_little) {
                                if (obj_little["status"] == 'error' &&
                                    obj_little['user'] == user) {
                                  notes_list.add(obj);
                                }
                              },
                            ),
                          );
                        } else {
                          notes_list = snapshot.data[widget.currentPage].notes;
                        }
                      }
                      if (snapshot.data[widget.currentPage].notes.length == 0) {
                        return Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 40),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  "404",
                                  style: TextStyle(
                                      color: secondColor, fontSize: 32),
                                ),
                                Text(
                                  "Ничего не найдено",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: RefreshIndicator(
                            key: _refreshIndicatorKey,
                            onRefresh: () async {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotesNewPage(
                                            days: widget.days,
                                            currentPage: widget.currentPage,
                                            selectedIndex: widget.selectedIndex,
                                          )));
                            },
                            child: ListView.builder(
                              itemCount: notes_list.length,
                              itemBuilder: (context, index) {
                                return NoteCardWidget(
                                    notes_list[index].id,
                                    notes_list[index].number,
                                    "${notes_list[index].title}",
                                    "${notes_list[index].date}",
                                    '${notes_list[index].user["last_name"]} ${notes_list[index].user["first_name"]}',
                                    notes_list[index].fast,
                                    notes_list[index].status,
                                    widget.currentPage,
                                    widget.currentPage == 0 &&
                                            notes_list[index].status == null &&
                                            notes_list[index].users[
                                                    notes_list[index]
                                                            .user_index -
                                                        1]['user'] ==
                                                user
                                        ? true
                                        : false);
                              },
                            ),
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 40),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                "400",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 32),
                              ),
                              Text(
                                "Нет связи с сервером",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: SpinKitDualRing(
                        color: secondColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              title: Text("Принятые"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.send),
              title: Text("Отправленные"),
            ),
          ],
          currentIndex: widget.currentPage,
          fixedColor: secondColor,
          onTap: (int index) {
            setState(
              () {
                print(index);
                widget.currentPage = index;
              },
            );
          },
        ),
      ),
    );
  }

  Future<bool> exitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
            height: 120,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Вы уверены что хотите выйти?",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      color: baseColor,
                      onPressed: () {
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      },
                      child: Text(
                        "Да",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Нет",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
