import 'package:cloud_firestore/cloud_firestore.dart';

String formatTimeElapsed(Timestamp timestamp) {
  DateTime now = DateTime.now();
  DateTime dateTime = timestamp.toDate();

  Duration difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return difference.inSeconds == 1 ? 
      'Há ${difference.inSeconds} segundo' 
    : 'Há ${difference.inSeconds} segundos';
  } else if (difference.inMinutes < 60) {
    return difference.inMinutes == 1 ?
      'Há ${difference.inMinutes} minuto'
    : 'Há ${difference.inMinutes} minutos';
  } else if (difference.inHours < 24) {
    return difference.inHours == 1 ?
      'Há ${difference.inHours} hora'
    : 'Há ${difference.inHours} horas';
  } else {
    int days = difference.inDays;
    if (days == 1) {
      return 'Há 1 dia';
    } else {
      return 'Há $days dias';
    }
  }
}