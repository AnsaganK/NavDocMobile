import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import 'package:http/http.dart' as http;
import 'package:nd/constants.dart';

part 'MyNotes.g.dart';

@JsonSerializable()
class MyNotesList {
  List<MyNote> notes;
  MyNotesList(this.notes);

  factory MyNotesList.fromJson(Map<String, dynamic> json) =>
      _$MyNotesListFromJson(json);
  Map<String, dynamic> toJson() => _$MyNotesListToJson(this);
}

@JsonSerializable()
class MyNote {
  final int id;
  final int number;
  final String title;
  final String date;
  final Map<String, dynamic> user;
  final bool fast;
  final String status;

  MyNote(this.id, this.number, this.title, this.date, this.user, this.fast,
      this.status);

  factory MyNote.fromJson(Map<String, dynamic> json) => _$MyNoteFromJson(json);
  Map<String, dynamic> toJson() => _$MyNoteToJson(this);
}

Future<MyNotesList> getMyNotesList() async {
  final url = base_url + '/api/my_notes/1';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return MyNotesList.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('error: ${response.reasonPhrase}');
  }
}
