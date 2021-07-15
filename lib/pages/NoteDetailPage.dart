import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nd/constants.dart';
import 'package:nd/models/note_detail.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:nd/pages/NotesListPage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NoteDetailPage extends StatefulWidget {
  final int id;
  final String title;
  final int isMy;
  final bool note_for_signing;
  NoteDetailPage(
      {this.id, this.title, this.isMy, this.note_for_signing = false});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  int note_number;
  String note_title;
  List<dynamic> note_files;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  Future<NoteDetail> note;
  bool _isLoading = true;
  bool preloader = false;
  final List<Tab> tabs = <Tab>[
    Tab(
      icon: Icon(Icons.info),
      text: "Информация",
    ),
    Tab(
      icon: Icon(Icons.picture_as_pdf),
      text: "PDF",
    )
  ];
  var _currentPage = 0;
  var status_name = [
    Padding(
        padding: EdgeInsets.all(3),
        child: Center(
          child: Text(
            "Вы действительно хотите подписать данный документ",
            textAlign: TextAlign.center,
            style: TextStyle(color: successColor),
          ),
        )),
    Padding(
        padding: EdgeInsets.all(3),
        child: Center(
          child: Text(
            "Вы действительно хотите  отправить на редактирование данный документ",
            textAlign: TextAlign.center,
            style: TextStyle(color: editColor),
          ),
        )),
    Padding(
        padding: EdgeInsets.all(3),
        child: Center(
          child: Text(
            "Вы действительно хотите отказать в подписании",
            textAlign: TextAlign.center,
            style: TextStyle(color: errorColor),
          ),
        )),
  ];
  var status_api = [
    'success',
    'edit',
    'error',
  ];
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    data();
    //loadDocument();
  }

  data() async {
    note = getNoteDetail(widget.id);
    note.then((value) {
      note_number = value.number;
      note_title = value.title;
      note_files = value.files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: baseColor,
          title: Text(widget.title),
          centerTitle: true,
          bottom: TabBar(
            tabs: tabs,
          ),
          actions: [
            widget.isMy == 0 && widget.note_for_signing
                ? IconButton(
                icon: SvgPicture.asset("assets/img/checked.svg"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      elevation: 20,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        alignment: Alignment.center,
                        width: 300,
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "Подтвердите действие",
                                style: TextStyle(
                                    fontSize: 19, color: Colors.grey),
                              ),
                              Divider(),
                              Text(
                                "СЗ №${note_number}",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54),
                              ),
                              Text(
                                "${note_title}",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black38),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              status_name[_currentPage],
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 60,
                                child: textController.text != ""
                                    ? Text(
                                  textController.text,
                                  style: TextStyle(),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                )
                                    : Text(
                                  "Без комментариев",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedButton(
                                    color: baseColor,
                                    onPressed: () async {
                                      var status;
                                      var post = postEditStatus(
                                          widget.id,
                                          textController.text,
                                          status_api[_currentPage])
                                          .then((value) {
                                        status = value["status"];
                                        if (status == 'success') {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  NotesNewPage(
                                                    days: 7,
                                                  ),
                                            ),
                                          );
                                        } else {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext context) =>
                                                  Dialog(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(
                                                          28.0),
                                                      child: Center(
                                                        child: Text(
                                                          "Не получилось изенить статус",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey),
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Подтвердить",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
                : Center()
          ],
        ),
        body: TabBarView(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/img/back.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => NoteDetailPage(
                            id: widget.id,
                            title: widget.title,
                            isMy: widget.isMy,
                            note_for_signing: widget.note_for_signing,
                          ),
                        ));
                  },
                  child: ListView(
                    children: [
                      FutureBuilder(
                        future: note,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            print(snapshot.data);
                            if (snapshot.data == null) {
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
                              return Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(top: 5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(28),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                              Color.fromRGBO(0, 0, 0, .25),
                                              offset: Offset(0, 1),
                                              blurRadius: 3,
                                              spreadRadius: 0,
                                            )
                                          ],
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 18.0),
                                            child: Text(
                                              "Служебная записка №${snapshot.data.number}",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Создал",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              Text(
                                                  "${snapshot.data.user['first_name']} ${snapshot.data.user['last_name']}")
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Divider(),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Название",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              Text("${snapshot.data.title}")
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Divider(),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Дата",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              Text("${snapshot.data.date}"),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Divider(),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Дата создания",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              Text(
                                                  "${snapshot.data.date_create.split('T')[0]}"),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Divider(),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Текст",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              Container(
                                                width: 200,
                                                child: Text(
                                                  "${snapshot.data.text}",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Divider(),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Итого",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              Container(
                                                width: 200,
                                                child: Text(
                                                  "${snapshot.data.summa}",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Divider(),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Бухгалтер",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              Container(
                                                width: 200,
                                                child: snapshot.data.buh != null
                                                    ? Text(
                                                  "${snapshot.data.buh["first_name"]} ${snapshot.data.buh["last_name"]}\n(подписано)",
                                                  textAlign:
                                                  TextAlign.right,
                                                  style: TextStyle(
                                                      color:
                                                      successColor),
                                                )
                                                    : Text(
                                                  "В ожидании",
                                                  textAlign:
                                                  TextAlign.right,
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Divider(),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Файлы",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              Container(
                                                width: 150,
                                                child: note_files.length != 0
                                                    ? FlatButton(
                                                    child: Text(
                                                      "Показать файлы",
                                                      style: TextStyle(
                                                          color: baseColor),
                                                    ),
                                                    onPressed: () async {
                                                      List<Widget>
                                                      note_files_src =
                                                      [];
                                                      int zero = 0;
                                                      note_files.forEach(
                                                              (element) {
                                                            String
                                                            element_item =
                                                            element["file"]
                                                                .toString();
                                                            String
                                                            element_type =
                                                            element_item.substring(
                                                                element_item
                                                                    .length -
                                                                    3,
                                                                element_item
                                                                    .length);
                                                            note_files_src.add(
                                                                element_type ==
                                                                    'png' ||
                                                                    element_type ==
                                                                        'jpg'
                                                                    ? Column(
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                      200,
                                                                      height:
                                                                      200,
                                                                      child:
                                                                      Card(
                                                                        elevation: 5,
                                                                        child: Image.network(
                                                                          base_url + element["file"],
                                                                          loadingBuilder: (context, child, loadingProgress) {
                                                                            if (loadingProgress == null) return child;

                                                                            return Container(
                                                                              width: 200,
                                                                              height: 200,
                                                                              decoration: BoxDecoration(color: Colors.white),
                                                                              child: Center(
                                                                                child: SpinKitDualRing(
                                                                                  color: secondColor,
                                                                                ),
                                                                              ),
                                                                            );
                                                                            // You can use LinearProgressIndicator or CircularProgressIndicator instead
                                                                          },
                                                                          errorBuilder: (context, error, stackTrace) => Text('Some errors occurred!'),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        "Файл ${++zero}")
                                                                  ],
                                                                )
                                                                    : Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        if (await canLaunch(base_url + element_item))
                                                                          launch(base_url + element_item);
                                                                        else
                                                                          null;
                                                                      },
                                                                      child:
                                                                      Container(
                                                                        width: 200,
                                                                        height: 200,
                                                                        child: Card(
                                                                          color: baseColor,
                                                                          child: Center(
                                                                              child: Text(
                                                                                "Скачать файл",
                                                                                style: TextStyle(color: Colors.white),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        "Файл ${++zero}")
                                                                  ],
                                                                ));
                                                          });
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder:
                                                              (context) {
                                                            return ComplicatedImage(
                                                                note_files_src);
                                                          });
                                                    })
                                                    : null,
                                              ), /*return GestureDetector(
                                                        onTap: () async {},
                                                        child: Card(
                                                          child: Image.network(
                                                              base_url +
                                                                  '${snapshot.data.files[index]["file"]}'),
                                                        ),
                                                      );*/
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    widget.isMy == 0
                                        ? widget.note_for_signing
                                        ? Column(
                                      children: [
                                        Container(
                                            margin:
                                            const EdgeInsets.only(
                                                bottom: 20.0),
                                            child:
                                            null //status_name[_currentPage],
                                        ),
                                        TextField(
                                          controller: textController,
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            labelText: "Комментарии",
                                            focusedBorder:
                                            OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: secondColor,
                                                  width: 1.0),
                                            ),
                                            enabledBorder:
                                            OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: baseColor,
                                                  width: 1.0),
                                            ),
                                          ),
                                          minLines: 2,
                                          maxLines: 10,
                                        )
                                      ],
                                    )
                                        : Text("")
                                        : Column(
                                      children: List.generate(
                                          snapshot.data.users.length,
                                              (index) {
                                            return Card(
                                              elevation: 3,
                                              child: ListTile(
                                                leading: snapshot.data
                                                    .users[index]
                                                ['status'] ==
                                                    'success'
                                                    ? Icon(
                                                  Icons.check,
                                                  color: successColor,
                                                )
                                                    : snapshot.data.users[index]
                                                ['status'] ==
                                                    'edit'
                                                    ? Icon(
                                                  Icons
                                                      .warning_amber_outlined,
                                                  color: editColor,
                                                )
                                                    : snapshot.data.users[
                                                index]
                                                [
                                                'status'] ==
                                                    'error'
                                                    ? Icon(
                                                  Icons.close,
                                                  color:
                                                  errorColor,
                                                )
                                                    : snapshot.data.users[
                                                index]
                                                ['status'] ==
                                                    null
                                                    ? Icon(
                                                  Icons
                                                      .timer,
                                                  color: Colors
                                                      .grey,
                                                )
                                                    : null,
                                                title: Text(
                                                    "${snapshot.data.users[index]['user']['first_name']} ${snapshot.data.users[index]['user']['last_name']}"
                                                        "\n${snapshot.data.users[index]['date_create'] != null && snapshot.data.users[index]['status'] != null ? snapshot.data.users[index]['date_create'].toString().substring(0, 10) + '    ' + snapshot.data.users[index]['date_create'].toString().substring(11, 19) : ''}"),
                                                //Text(
                                                subtitle: Text(
                                                    "${snapshot.data.users[index]['status'] == null ? '' : '\n' + snapshot.data.users[index]['comment']}"),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              );
                            }
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
                  ),
                ),
              ],
            ),
            PdfView(widget.id),
          ],
        ),
        bottomNavigationBar: widget.isMy == 0 && widget.note_for_signing
            ? BottomNavyBar(
          selectedIndex: _currentPage,
          showElevation: true,
          containerHeight: 80,
          itemCornerRadius: 8,
          curve: Curves.easeIn,
          mainAxisAlignment: MainAxisAlignment.center,
          onItemSelected: (index) => setState(() {
            _currentPage = index;
          }),
          items: [
            BottomNavyBarItem(
                inactiveColor: Colors.grey,
                icon: Icon(Icons.check),
                textAlign: TextAlign.center,
                title: Text("Подписать"),
                activeColor: successColor),
            BottomNavyBarItem(
                inactiveColor: Colors.grey,
                icon: Icon(Icons.warning_amber_outlined),
                title: Text("Возврат"),
                textAlign: TextAlign.center,
                activeColor: editColor),
            BottomNavyBarItem(
                inactiveColor: Colors.grey,
                icon: Icon(Icons.close),
                title: Text("Отказать"),
                textAlign: TextAlign.center,
                activeColor: errorColor),
          ],
        )
            : null,
      ),
    );
  }
}

class ComplicatedImage extends StatelessWidget {
  final List<Widget> imageSliders;
  ComplicatedImage(this.imageSliders);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 2.0,
          enlargeCenterPage: true,
        ),
        items: imageSliders,
      ),
    );
  }
}

class PdfView extends StatelessWidget {
  final int id;

  PdfView(this.id);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SfPdfViewer.network('$base_url/notes/show/isSignature/$id'));
  }
}