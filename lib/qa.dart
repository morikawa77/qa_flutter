import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';

part 'qa.g.dart';

@JsonSerializable()
class Qa {
  String? id;
  String? userId;

  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  Timestamp? qaDatetime;

  List<Question>? questions;

  Qa(this.id, this.userId, this.qaDatetime, this.questions);

  factory Qa.fromJson(Map<String, dynamic> json) => _$QaFromJson(json);
  Map<String, dynamic> toJson() => _$QaToJson(this);

  static Timestamp? _timestampFromJson(dynamic json) {
    if (json is int) {
      return Timestamp(json, 0);
    } else if (json is Map<String, dynamic>) {
      return Timestamp(json['_seconds'], json['_nanoseconds']);
    } 
    return null;
  }

  static dynamic _timestampToJson(Timestamp? timestamp) {
    if (timestamp != null) {
      return {
        timestamp
      };
    }
    return null;
  }
}

@JsonSerializable()
class Question {
  String? questionId;
  String? question;
  String? questionOwnerId;
  String? questionOwnerEmail;
  int? questionVotes;
  

  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  Timestamp? questionDatetime;

  String? answer;

  Question({
    required this.questionId,
    required this.question,
    required this.questionOwnerId,
    required this.questionOwnerEmail,
    required this.questionVotes,
    required this.questionDatetime,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  static Timestamp? _timestampFromJson(dynamic json) {
    if (json is int) {
      return Timestamp(json, 0);
    } else if (json is Map<String, dynamic>) {
      return Timestamp(json['_seconds'], json['_nanoseconds']);
    } 
    return json[0];
  }

  static dynamic _timestampToJson(Timestamp? timestamp) {
    if (timestamp != null) {
      return {
        timestamp
      };
    }
    return null;
  }
}

class QuestionWithIndex {
  final int index;
  final Question question;

  QuestionWithIndex({required this.index, required this.question});
}

