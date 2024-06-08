import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final DateTime date;
  final String? observation;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.date,
    this.observation,
    this.completed = false,
  });

  factory Task.fromDocument(Map<String, dynamic> doc, String docId) {
    return Task(
      id: docId,
      title: doc['title'],
      date: (doc['date'] as Timestamp).toDate(),
      observation: doc['observation'],
      completed: doc['completed'] ?? false,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'date': date,
      'observation': observation,
      'completed': completed,
    };
  }
}
