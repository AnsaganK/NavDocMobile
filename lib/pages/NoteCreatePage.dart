import 'package:flutter/material.dart';
import 'package:nd/constants.dart';

class NoteCreatePage extends StatelessWidget {
  var dateText = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: secondColor),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: secondColor,
          ),
        ),
        title: Text(
          "Создание СЗ",
          style: TextStyle(color: Colors.black54),
        ),
        centerTitle: true,
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
          Center(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(),
              child: Card(
                elevation: 8,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: ListView(children: [
                    TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(labelText: "Название"),
                    ),
                    RaisedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2022),
                        ).then((DateTime value) {
                          if (value != null) {
                            print(12);
                            String r = value.toString();
                            dateText = r.substring(0, 10);
                          }
                        });
                      },
                      child: Text("${dateText != null ? dateText : 'Дата'}"),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Текст"),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Итого"),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
