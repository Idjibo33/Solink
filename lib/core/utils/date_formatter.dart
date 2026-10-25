import 'package:cloud_firestore/cloud_firestore.dart';

String formatTimestamp(Timestamp? timestamp) {
  final date = timestamp?.toDate();
  if (date == null) {
    return '';
  }
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
