// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotesList _$NotesListFromJson(Map<String, dynamic> json) {
  return NotesList(
    (json['notes'] as List)
        ?.map(
            (e) => e == null ? null : Note.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$NotesListToJson(NotesList instance) => <String, dynamic>{
      'notes': instance.notes,
    };

Note _$NoteFromJson(Map<String, dynamic> json) {
  return Note(
    json['id'] as int,
    json['number'] as int,
    json['title'] as String,
    json['date'] as String,
    json['user'] as Map<String, dynamic>,
    json['fast'] as bool,
    json['status'] as String,
    json['user_index'] as int,
    json['users'] as List<dynamic>,
  );
}

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'title': instance.title,
      'date': instance.date,
      'user': instance.user,
      'fast': instance.fast,
      'status': instance.status,
      'user_index': instance.user_index,
      'users': instance.users,
    };
