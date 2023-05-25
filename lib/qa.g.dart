// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Qa _$QaFromJson(Map<String, dynamic> json) => Qa(
      json['id'] as String?,
      json['userId'] as String?,
      Qa._timestampFromJson(json['qaDatetime']),
      (json['questions'] as List<dynamic>?)
          ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QaToJson(Qa instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'qaDatetime': Qa._timestampToJson(instance.qaDatetime),
      'questions': instance.questions,
    };

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      questionId: json['questionId'] as String?,
      question: json['question'] as String?,
      questionOwnerId: json['questionOwnerId'] as String?,
      questionOwnerEmail: json['questionOwnerEmail'] as String?,
      questionVotes: json['questionVotes'] as int?,
      questionDatetime: Question._timestampFromJson(json['questionDatetime']),
      answer: json['answer'] as String?, 
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'questionId': instance.questionId,
      'question': instance.question,
      'questionOwnerId': instance.questionOwnerId,
      'questionOwnerEmail': instance.questionOwnerEmail,
      'questionVotes': instance.questionVotes,
      'questionDatetime': Question._timestampToJson(instance.questionDatetime),
      'answer': instance.answer,
    };
