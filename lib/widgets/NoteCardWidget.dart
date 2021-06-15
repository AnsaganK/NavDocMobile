import 'package:flutter/material.dart';
import 'package:nd/constants.dart';
import 'package:nd/pages/NoteDetailPage.dart';

import 'package:flutter_svg/flutter_svg.dart';

class NoteCardWidget extends StatelessWidget {
  final id;
  final number;
  final title;
  final date;
  final username;
  final fast;
  final status;
  final isMy;
  var note_for_signing = false;
  NoteCardWidget(this.id, this.number, this.title, this.date, this.username,
      this.fast, this.status, this.isMy, this.note_for_signing);

  Color getColor() {
    if (status == 'success') {
      return successColor.withOpacity(.8);
    } else if (status == 'edit') {
      return editColor.withOpacity(.8);
    } else if (status == 'error') {
      return errorColor.withOpacity(.8);
    } else
      return baseColor.withOpacity(.8);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SlideTransition1(
            NoteDetailPage(
              id: this.id,
              title: this.title,
              isMy: this.isMy,
              note_for_signing: note_for_signing,
            ),
          ),
        );
      },
      child: Card(
        shadowColor: Colors.white.withOpacity(0),
        color: getColor(),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(
              '${this.number}',
              style: TextStyle(color: secondColor),
            ),
            backgroundColor: Colors.white,
          ),
          trailing:
              fast ? SvgPicture.asset("assets/img/light_little.svg") : null,
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(username + "   " + date),
        ),
      ),
    );
  }
}

class SlideTransition1 extends PageRouteBuilder {
  final Widget page;

  SlideTransition1(this.page)
      : super(
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: Duration(milliseconds: 1000),
            reverseTransitionDuration: Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  parent: animation,
                  reverseCurve: Curves.fastOutSlowIn);
              return SlideTransition(
                position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(animation),
                child: page,
              );
            });
}
