// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteDetail _$NoteDetailFromJson(Map<String, dynamic> json) {
  return NoteDetail(
    json['id'] as int,
    json['title'] as String,
    json['number'] as int,
    json['text'] as String,
    json['summa'] as String,
    json['fast'] as bool,
    json['date_create'] as String,
    json['date_update'] as String,
    json['date'] as String,
    json['status'] as String,
    json['user'] as Map<String, dynamic>,
    json['users'] as List<dynamic>,
    json['files'] as List<dynamic>,
    json['buh'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$NoteDetailToJson(NoteDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'number': instance.number,
      'text': instance.text,
      'summa': instance.summa,
      'fast': instance.fast,
      'date_create': instance.date_create,
      'date_update': instance.date_update,
      'date': instance.date,
      'status': instance.status,
      'user': instance.user,
      'users': instance.users,
      'files': instance.files,
      'buh': instance.buh,
    };
