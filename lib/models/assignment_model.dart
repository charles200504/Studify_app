import 'package:flutter/material.dart';

enum AssignmentStatus { pending, done, overdue }

class Assignment {
  String? id;
  final String title;
  final String subject;
  final DateTime dueDate;
  AssignmentStatus status;
  final Color color;

  Assignment({
    this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.status,
    required this.color,
  });
}

// This list is now shared across the whole app
List<Assignment> globalAssignments = [];