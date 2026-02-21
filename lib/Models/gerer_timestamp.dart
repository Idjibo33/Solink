import 'package:cloud_firestore/cloud_firestore.dart';

String gererTimeStamp(Timestamp time) {
  final day = time.toDate().day.toString();
  final month = time.toDate().month.toString();
  final year = time.toDate().year.toString();
  return "$day/$month/$year";
}
