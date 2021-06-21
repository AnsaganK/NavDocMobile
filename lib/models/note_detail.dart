import 'dart:typed_data';

import 'package:nd/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:nd/pages/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'note_detail.g.dart';

@JsonSerializable()
class NoteDetail {
  final int id;
  final String title;
  final int number;
  final String text;
  final String summa;
  final bool fast;
  final String date_create;
  final String date_update;
  final String date;
  final String status;
  final Map<String, dynamic> user;
  final List<dynamic> users;
  final List<dynamic> files;
  final Map<String, dynamic> buh;

  NoteDetail(
    this.id,
    this.title,
    this.number,
    this.text,
    this.summa,
    this.fast,
    this.date_create,
    this.date_update,
    this.date,
    this.status,
    this.user,
    this.users,
    this.files,
    this.buh,
  );
  factory NoteDetail.fromJson(Map<String, dynamic> json) =>
      _$NoteDetailFromJson(json);
  Map<String, dynamic> toJson() => _$NoteDetailToJson(this);
}

Future<NoteDetail> getNoteDetail(int id) async {
  final url = base_url + '/api/note/$id';
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //int user_id = await prefs.getInt('user_id');
  //print(user_id);
  //final url = base_url + '/api/user/$user_id/note/$id';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    //var data = json.decode(utf8.decode(response.bodyBytes));
    //var for_signing = false;
    //if (data['note']['user_index'] == data['index'] && data['status'] == null) {
    //  for_signing = true;
    //}
    //data['note']['for_signing'] = for_signing;
    return NoteDetail.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    //data['note'],

  } else {
    throw Exception('error: ${response.reasonPhrase}');
  }
}

Future<Uint8List> getNoteFile(int id) async {
  final url = base_url + '/notes/show/$id';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('error: ${response.reasonPhrase}');
  }
}

Future postEditStatus(int note_id, String comment, String status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int user_id = await prefs.getInt('user_id');
  Map body = {
    "user_id": user_id,
    "note_id": note_id,
    "comment": comment,
    "status": status,
  };
  final url = base_url + '/api/notes/status';
  final response = await http.post(Uri.parse(url),
      body: json.encode(body),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });
  if (response.statusCode == 200) {
    return json.decode(utf8.decode(response.bodyBytes));
  } else {
    throw Exception('error: ${response.reasonPhrase}');
  }
}
