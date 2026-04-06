import 'package:flutter/material.dart';

enum AssignmentStatus { overdue, pending, done }

class Assignment {
  final String title;
  final String subject;
  final String dueDate;
  final AssignmentStatus status;
  final Color color;

  Assignment({required this.title, required this.subject, required this.dueDate, required this.status, required this.color});
}