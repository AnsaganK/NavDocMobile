import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import 'package:http/http.dart' as http;
import 'package:nd/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';
part 'Notes.g.dart';

@JsonSerializable()
class NotesList {
  List<Note> notes;
  NotesList(this.notes);

  factory NotesList.fromJson(Map<String, dynamic> json) =>
      _$NotesListFromJson(json);
  Map<String, dynamic> toJson() => _$NotesListToJson(this);
}

@JsonSerializable()
class Note {
  final int id;
  final int number;
  final String title;
  final String date;
  final Map<String, dynamic> user;
  final bool fast;
  final String status;
  final int user_index;
  final List<dynamic> users;

  Note(this.id, this.number, this.title, this.date, this.user, this.fast,
      this.status, this.user_index, this.users);

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}

Future<NotesList> getSendNotesList(int days) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int user_id = await prefs.getInt('user_id');

  final url = base_url + '/api/send_notes/${user_id}?days=${days}';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return NotesList.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('error: ${response.reasonPhrase}');
  }
}

Future<NotesList> getMyNotesList(int days) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int user_id = await prefs.getInt('user_id');
  final url = base_url + '/api/my_notes/${user_id}?days=${days}';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return NotesList.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('error: ${response.reasonPhrase}');
  }
}
